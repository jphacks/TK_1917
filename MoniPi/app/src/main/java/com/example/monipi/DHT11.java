package com.example.monipi;

import android.util.Log;
import com.google.android.things.pio.PeripheralManager;
import com.google.android.things.pio.UartDevice;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.charset.StandardCharsets;

class DHT11 {
    private ByteBuffer mMessageBuffer = ByteBuffer.allocate(10);
    UartDevice mDevice;

    public DHT11(String uartName, PeripheralManager pManager) throws IOException {
        // initialize the uart device
        mDevice = pManager.getInstance().openUartDevice(uartName);
        mDevice.setBaudrate(115200);
        mDevice.setDataSize(8);
        mDevice.setParity(0);
        mDevice.setStopBits(1);
    }

    public String getTemperature() throws IOException, InterruptedException{
        String response = "";
        byte[] buffer = new byte[5];

        try {
            return this.fillBuffer(buffer, "T");
        } catch (IOException e) {
            Log.e("DHT11", "failed read temperature", e);
        }

        return response;
    }

    public String getHumidity() throws IOException, InterruptedException {
        String response = "";
        byte[] buffer = new byte[5];

        try {
            response = this.fillBuffer(buffer, "H");
        } catch (IOException e) {
            Log.e("DHT11", "failed read temperature", e);
        }

        return response;
    }

    private String fillBuffer(byte[] buffer, String mode) throws InterruptedException, IOException {
        // mode: "T" or "H"
        mDevice.write(mode.getBytes(), mode.length());
        mDevice.read(buffer, buffer.length);
        this.processBuffer(buffer);
        String utf8Buf = new String(this.mMessageBuffer.array(), StandardCharsets.UTF_8.name());
        return utf8Buf.replace("\u0000", "");
    }

    private void processBuffer(byte[] buffer) {
        mMessageBuffer.clear();
        for (int i=0; i<buffer.length; i++) {
            if ((int) buffer[i] != 0) {
                this.mMessageBuffer.put(buffer[i]);
            }
        }
    }

    private void close() {
        try {
            this.mDevice.close();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            this.mDevice = null;
        }
    }


}