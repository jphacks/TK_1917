package com.example.monipi;

import android.app.Activity;
import android.os.Bundle;
import android.os.Handler;
import android.util.Log;
import android.widget.TextView;

import com.google.android.things.pio.Gpio;
import com.google.android.things.pio.PeripheralManager;


import com.google.android.things.pio.I2cDevice;

import java.io.IOException;
import java.util.List;
import java.util.Locale;

/**
 * Skeleton of an Android Things activity.
 * <p>
 * Android Things peripheral APIs are accessible through the class
 * PeripheralManagerService. For example, the snippet below will open a GPIO pin and
 * set it to HIGH:
 *
 * <pre>{@code
 * PeripheralManagerService service = new PeripheralManagerService();
 * mLedGpio = service.openGpio("BCM6");
 * mLedGpio.setDirection(Gpio.DIRECTION_OUT_INITIALLY_LOW);
 * mLedGpio.setValue(true);
 * }</pre>
 * <p>
 * For more complex peripherals, look for an existing user-space driver, or implement one if none
 * is available.
 *
 * @see <a href="https://github.com/androidthings/contrib-drivers#readme">https://github.com/androidthings/contrib-drivers#readme</a>
 */
public class MainActivity extends Activity {


    private static final String TAG = MainActivity.class.getSimpleName();
    private static final int INTERVAL_BETWEEN_BLINKS_MS = 1000;
    private static final int INTERVAL_BETWEEN_MEASURE_PRESS_MS = 5 * 1000;
    private static final int INTERVAL_BETWEEN_DHT11_MS = 5 * 1000;

    private Handler mHandler = new Handler();
    private Gpio mLedGpio;
    private boolean mLedState = false;

    // I2C Device Name
    private static final String I2C_DEVICE_NAME = "I2C1";
    // I2C Slave Address
    private static final int I2C_ADDRESS = 0x5D;
    private I2cDevice mI2c;

    private DHT11 uartDht11;

    String dbUrlString = "https://qolab-api.herokuapp.com/env-data";
    String MONIPIID = "\"5db4a075aef50d5ed4a62dcc\"";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        try {

            // I2Cデバイスオープン
            PeripheralManager manager = PeripheralManager.getInstance();
            // for checking purpose
            // comment out when production
//            BoardDefaults.scanI2CDevides(manager);

            Log.i(TAG, "Opening Uart device...");

            // 温湿度センサ
            uartDht11 = new DHT11("UART0", manager);
            mHandler.post(mDht11Runnable);

            // 圧力センサ
            mI2c = manager.openI2cDevice(I2C_DEVICE_NAME, I2C_ADDRESS);
            mI2c.writeRegByte(0x12, (byte) 0x01); // power on
            Thread.sleep(2);
            mI2c.writeRegByte(0x13, (byte) 0x01); // Reset Release
            mI2c.writeRegByte(0x14, (byte) 0x8a); // average 16,continue
            Thread.sleep(60);
            mHandler.post(mPressureRunnable);


            List<String> deviceList = manager.getI2cBusList();
            if (deviceList.isEmpty()) {
                Log.i(TAG, "No I2C bus available on this device.");
            } else {
                Log.i(TAG, "List of available devices: "+deviceList);
            }

            // LED Blink
            String pinName = BoardDefaults.getGPIOForLED();
            mLedGpio = manager.openGpio(pinName);
            mLedGpio.setDirection(Gpio.DIRECTION_OUT_INITIALLY_LOW);

            Log.i(TAG, "Start blinking LED GPIO pin");

            // Post a Runnable that continuously switch the state of the GPIO, blinking the
            // corresponding LED
            mHandler.post(mBlinkRunnable); // LED Blink


        } catch (IOException e) {
            Log.e(TAG, "Error on PeripheralIO API", e);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        // Remove pending blink Runnable from the handler.
        mHandler.removeCallbacks(mBlinkRunnable);
        // Close the Gpio pin.
        Log.i(TAG, "Closing LED GPIO pin");
        try {
            mLedGpio.close();
        } catch (IOException e) {
            Log.e(TAG, "Error on PeripheralIO API", e);
        } finally {
            mLedGpio = null;
        }

        // close i2c device
        if (mI2c != null) {
            try {
                mI2c.close();
                mI2c = null;
            } catch (IOException e) {
                Log.w(TAG, "Unable to close I2C device", e);
            }
        }

        // close dht11 device
        if (uartDht11 != null) {
            try {
                mI2c.close();
                mI2c = null;
            } catch (IOException e) {
                Log.w(TAG, "Unable to close Dht11 device", e);
            }
        }

    }

    private Runnable mDht11Runnable = new Runnable() {
        int count = 0; //

        @Override
        public void run() {
            count += 1;

            // Exit Runnable if the GPIO is already closed
            double lHumData = 0.0;
            double lTmpData = 0.0;
            String latestHumData = "undefined";
            String latestTempData = "undefined";
            String latestDiData = "undefined";
            if (uartDht11 == null) {
                return;
            }
            try {

                latestHumData = uartDht11.getHumidity();
                latestTempData = uartDht11.getTemperature();

                if (latestHumData.length() > 0) {
                    lHumData = Float.parseFloat(latestHumData);
                }
                if (latestTempData.length() > 0) {
                    lTmpData = Float.parseFloat(latestTempData);
                }

                latestHumData = String.format("%.2f percent", lHumData);
                latestTempData = String.format("%.2f deg", lTmpData);

                latestDiData = String.format("%.2f point", 0.81 * lTmpData + 0.01 * lHumData * (0.99 * lTmpData - 14.3) + 46.3);
                Log.d(TAG, String.format(Locale.JAPAN, latestHumData));
                Log.d(TAG, String.format(Locale.JAPAN, latestTempData));

                if (count % 12 == 0) {
                    String jsonStr = "{\"monipiId\": "+MONIPIID+", \"sensorName\": \"TempHumSensor\", \"data\": { \"temperature\": "+uartDht11.getTemperature()+", \"humidity\": "+uartDht11.getHumidity()+"}}";
                    // 非同期処理の実行
                    MyAsyncTask task = new MyAsyncTask(this);
                    task.execute(dbUrlString, jsonStr); // POST の場合
                    Log.d(TAG, "created");
                    count = 0; // カウンタを初期化
                }

            } catch (IOException e) {
                e.printStackTrace();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }



            // update sensor data displayed on the screeen
            TextView humDataView = findViewById(R.id.humDataText);
            humDataView.setText(latestHumData);

            // update sensor data displayed on the screeen
            TextView tempDataView = findViewById(R.id.tempDataText);
            tempDataView.setText(latestTempData);

            TextView tempDiView = findViewById(R.id.diDataText);
            tempDiView.setText(latestDiData);

            mHandler.postDelayed(mDht11Runnable, INTERVAL_BETWEEN_DHT11_MS);
        }
    };

    private Runnable mPressureRunnable = new Runnable() {
        int count = 0;

        @Override
        public void run() {
            count += 1;

            // Exit Runnable if the GPIO is already closed
            if (mI2c == null) {
                return;
            }
            try {
                // Toggle the GPIO state

                byte d1 = mI2c.readRegByte((byte) 0x1a);
                byte d2 = mI2c.readRegByte((byte) 0x1b);
                byte d3 = mI2c.readRegByte((byte) 0x1c);
                double hPa = (double) (d1*16384 + d2*64 + (d3>>2)) / 2048.0;

                Log.d(TAG, String.format("%fhPa", hPa));

                // update sensor data displayed on the screeen
                TextView pressDataView = findViewById(R.id.pressDataText);
                pressDataView.setText(String.format(Locale.JAPAN, "%.2f hPa", hPa));

                if (count % 12 == 0) {
                    String jsonStr = "{\"monipiId\": "+MONIPIID+", \"sensorName\": \"PressureSensor\", \"data\": { \"pressure\": "+hPa+"}}";
                    // 非同期処理の実行
                    MyAsyncTask task = new MyAsyncTask(this);
                    task.execute(dbUrlString, jsonStr); // POST の場合
                    Log.d(TAG, "created");
                    count = 0; // カウンタを初期化
                }

                // Reschedule the same runnable in {#INTERVAL_BETWEEN_BLINKS_MS} milliseconds
                mHandler.postDelayed(mPressureRunnable, INTERVAL_BETWEEN_MEASURE_PRESS_MS);
            } catch (IOException e) {
                Log.e(TAG, "Error on PeripheralIO API", e);
            }
        }
    };

    private Runnable mBlinkRunnable = new Runnable() {
        @Override
        public void run() {
            // Exit Runnable if the GPIO is already closed
            if (mLedGpio == null) {
                return;
            }
            try {
                // Toggle the GPIO state
                mLedState = !mLedState;
                mLedGpio.setValue(mLedState);
                mHandler.postDelayed(mBlinkRunnable, INTERVAL_BETWEEN_BLINKS_MS);
            } catch (IOException e) {
                Log.e(TAG, "Error on PeripheralIO API", e);
            }
        }
    };
}
