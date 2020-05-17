package com.example.stable_flutter_gp1;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Color;
import android.media.RingtoneManager;
import android.net.Uri;
import android.os.Build;
import android.os.IBinder;
import android.provider.Settings;
import androidx.annotation.Nullable;
import androidx.transition.Visibility;
import androidx.core.app.NotificationCompat;
import android.util.Log;
import io.flutter.app.FlutterActivity;

import org.json.JSONException;
import org.json.JSONObject;

import java.net.URISyntaxException;
import java.util.Random;

import io.flutter.plugin.common.MethodChannel;
import io.socket.client.IO;
import io.socket.client.Socket;
import io.socket.emitter.Emitter;
import static xdroid.toaster.Toaster.toast;
public class ForegroundService extends Service  {
    public static final String MyPREFERENCES = "MyPrefs" ;
    public SharedPreferences sharedpreferences;
    public SharedPreferences.Editor editor;
    private static final String CHANNEL = "flutter.native/AndroidPlatform";
    public static Socket mSocket ;
    String connect_state = null;
//    {
//        try {
//            mSocket = IO.socket("https://dhdsmartcabinet.herokuapp.com/");
//            if (!mSocket.connected())
//            {
//                Log.d("hello", "connect");
//                mSocket.connect();
//            }
//
//        } catch (
//        URISyntaxException e) {
//            e.printStackTrace();
//        }
//    }

    @Override
    public void onCreate() {
        super.onCreate();
        try {
            mSocket = IO.socket("https://dhdsmartcabinet.herokuapp.com/");
            if (!mSocket.connected())
            {
                Log.d("hello", "connect");
                mSocket.connect();
                mSocket.on("server", onRetrieData);
                mSocket.on("not_close", onRetrieData1);
            }

        } catch (
                URISyntaxException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
    }

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        //Start background activities
//        try {
//            mSocket = IO.socket("https://dhdsmartcabinet.herokuapp.com/");
//            Log.d("hello",mSocket.io().toString());
//            if (!mSocket.connected())
//            {
//                Log.d("hello", "connect");
//                mSocket.connect();
//
//            }
//
//        } catch (
//                URISyntaxException e) {
//            e.printStackTrace();
//        }


        sharedpreferences = getSharedPreferences(MyPREFERENCES, Context.MODE_PRIVATE);
        String id = sharedpreferences.getString("id", "");

        if (id.length() == 0)
        {
            Log.d("Account","log out");
        }
        else
        {
            Log.d("Account",id);
            UserDetail.id = id;
            UserDetail.username = sharedpreferences.getString("username", "");
            UserDetail.email = sharedpreferences.getString("email", "");
            mSocket.emit("mobile_client",UserDetail.id);
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O){
            String NOTIFICATION_CHANNEL_ID = "com.example.stable_flutter_gp1";
            String channelName = "Background Service";
            NotificationChannel chan = new NotificationChannel(NOTIFICATION_CHANNEL_ID, channelName, NotificationManager.IMPORTANCE_NONE);
            chan.setLightColor(Color.BLUE);
            chan.setLockscreenVisibility(Notification.VISIBILITY_PRIVATE);
            NotificationManager manager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
            assert manager != null;
            manager.createNotificationChannel(chan);
            NotificationCompat.Builder notificationBuilder = new NotificationCompat.Builder(this, NOTIFICATION_CHANNEL_ID);
            Notification notification = notificationBuilder.setOngoing(true)
//                    .setSmallIcon(R.drawable.ic_launcher_background)
                    .setContentTitle("App is running in background")
                    .setPriority(NotificationManager.IMPORTANCE_NONE)
                    .setCategory(Notification.CATEGORY_SERVICE)
                    .build();

            startForeground(1,notification);
        }

        return START_NOT_STICKY;
    }

    //server confirms that station has been connected
    private Emitter.Listener onRetrieData = new Emitter.Listener() {
        @Override
        public void call(final Object... args) {
            JSONObject obj = (JSONObject) args[0];
            try {
                String message = obj.getString("message");
                toast(message);

            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
    };

    //not close box
    private Emitter.Listener onRetrieData1 = new Emitter.Listener() {
        @Override
        public void call(final Object... args) {
            JSONObject obj = (JSONObject) args[0];

            try {
                String message =
                        "Your box no " +
                                String.valueOf(obj.getString("box_no")) +
                                " at station no " +
                                obj.getString("station_no") +
                                " location " +
                                obj.getString("station_location") +
                                " has not been closed yet!";

                if (obj.getString("user_id").equals(UserDetail.id)){
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        Intent intent=new Intent(getApplicationContext(),MainActivity.class);
                        String CHANNEL_ID = "Basic activities";
                        NotificationChannel notificationChannel=new NotificationChannel(CHANNEL_ID,"not_close",NotificationManager.IMPORTANCE_LOW);
                        PendingIntent pendingIntent=PendingIntent.getActivity(getApplicationContext(),1,intent,0);
                        NotificationCompat.Builder builder = new NotificationCompat.Builder(getApplicationContext(), CHANNEL_ID)
                                .setSmallIcon(R.drawable.ic_launcher_background)
                                .setContentTitle("Warning")
                                .setContentText(message)
                                .setStyle(new NotificationCompat.BigTextStyle()
                                        .bigText(message))
                                .setVisibility(Notification.VISIBILITY_PUBLIC)
                                .setDefaults(Notification.DEFAULT_SOUND)
                                .setContentIntent(pendingIntent)
//                                .addAction(android.R.drawable.sym_action_chat,"Title",pendingIntent)
                                .setPriority(NotificationCompat.PRIORITY_DEFAULT);

                        NotificationManager notificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
                        notificationManager.createNotificationChannel(notificationChannel);
                        int random = new Random().nextInt((1000 - 2) + 1) + 2;
                        notificationManager.notify(random,builder.build());
                        Log.d("Notification no:",String.valueOf(random));
                    }
//                    toast(message);
                }

            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
    };
}
