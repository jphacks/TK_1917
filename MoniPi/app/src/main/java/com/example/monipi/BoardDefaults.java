package com.example.monipi;

import android.os.Build;
import android.util.Log;

import com.google.android.things.pio.I2cDevice;
import com.google.android.things.pio.PeripheralManager;

import java.io.IOException;
import java.util.List;
import java.util.Locale;

@SuppressWarnings("WeakerAccess")
public class BoardDefaults {
    private static final String DEVICE_RPI3 = "rpi3";
    private static final String DEVICE_IMX6UL_PICO = "imx6ul_pico";
    private static final String DEVICE_IMX7D_PICO = "imx7d_pico";

    private static final String TAG = BoardDefaults.class.getSimpleName();
    private final static int TEST_REGISTER = 0x0;

    /**
     * Return the GPIO pin that the LED is connected on.
     * For example, on Intel Edison Arduino breakout, pin "IO13" is connected to an onboard LED
     * that turns on when the GPIO pin is HIGH, and off when low.
     */
    public static String getGPIOForLED() {
        switch (Build.DEVICE) {
            case DEVICE_RPI3:
                return "BCM6";
            case DEVICE_IMX6UL_PICO:
                return "GPIO4_IO22";
            case DEVICE_IMX7D_PICO:
                return "GPIO2_IO02";
            default:
                throw new IllegalStateException("Unknown Build.DEVICE " + Build.DEVICE);
        }
    }

    public static void scanI2CDevides(PeripheralManager manager) {

        // only for checking purpose
        List<String> deviceList = manager.getI2cBusList();
        if (deviceList.isEmpty()) {
            Log.i(TAG, "No I2C bus available on this device.");
        } else {
            Log.i(TAG, "List of available devices: "+deviceList);
        }

        for (int address = 0; address < 256; address++) {

            //auto-close the devices
            try (final I2cDevice device = manager.openI2cDevice("I2C1", address)) {

                try {
                    device.readRegByte(TEST_REGISTER);
                    Log.i(TAG, String.format(Locale.US, "Trying: 0x%02X - SUCCESS", address));
                } catch (final IOException e) {
                    Log.i(TAG, String.format(Locale.US, "Trying: 0x%02X - FAIL", address));
                }

            } catch (final IOException e) {
                //in case the openI2cDevice(name, address) fails
            }
        }
    }
}