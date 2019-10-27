package com.example.monipi;

import android.os.AsyncTask;
import android.util.Log;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.net.URL;

import javax.net.ssl.HttpsURLConnection;

public class MyAsyncTask extends AsyncTask<String, Void, String> {

    // ロガーのタグ
    private static final String TAG = "MyAsyncTask";

    public MyAsyncTask(Runnable context) {
        // 本メソッドは UI スレッドで処理されます。
        super();

    }

    @Override
    protected String doInBackground(String... params) {

        // Java の文字列連結では StringBuilder を利用
        // https://www.qoosky.io/techs/05a157a3e0
        StringBuilder sb = new StringBuilder();

        // finally 内で利用するため try の前に宣言
        InputStream inputStream = null;
        HttpsURLConnection connection = null;

        try {
            // URL 文字列をセットします。
            URL url = new URL(params[0]);
            connection = (HttpsURLConnection)url.openConnection();
            connection.setConnectTimeout(3000); // タイムアウト 3 秒
            connection.setReadTimeout(3000);

            // GET リクエストの実行
//            connection.setRequestMethod("GET");
//            connection.connect();

            // // POST リクエストの実行
             connection.setRequestMethod("POST");
             connection.setRequestProperty("Content-Type", "application/json");
             OutputStream outputStream = connection.getOutputStream();
             BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(outputStream));
             writer.write(params[1]);
             writer.close();
             connection.connect();

            // レスポンスコードの確認します。
            int responseCode = connection.getResponseCode();
            if(responseCode != HttpsURLConnection.HTTP_CREATED) {
                throw new IOException("HTTP responseCode: " + responseCode);
            }

            // 文字列化します。
            inputStream = connection.getInputStream();
            if(inputStream != null) {
                BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream, "UTF-8"));
                String line;
                while ((line = reader.readLine()) != null) {
                    sb.append(line);
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if(inputStream != null) {
                try {
                    inputStream.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            if(connection != null) {
                connection.disconnect();
            }
        }
        return sb.toString();
    }

    @Override
    protected void onPostExecute(String result) {
        // 本メソッドは UI スレッドで処理されるため、ビューを操作できます。
        Log.d(TAG, result);
    }
}
