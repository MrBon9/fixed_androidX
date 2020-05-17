package com.example.stable_flutter_gp1;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import androidx.core.content.ContextCompat;
import android.util.Log;
import android.widget.Toast;

import org.json.JSONException;
import org.json.JSONObject;

import java.net.URISyntaxException;
import java.util.HashMap;
import java.util.Map;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.socket.client.IO;
import io.socket.client.Socket;
import io.socket.emitter.Emitter;
import vn.momo.momo_partner.AppMoMoLib;
import vn.momo.momo_partner.MoMoParameterNamePayment;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "flutter.native/AndroidPlatform";
  public static final String MyPREFERENCES = "MyPrefs" ;
  public SharedPreferences sharedpreferences;
  public SharedPreferences.Editor editor;


  String no;
  Integer amount;
  String period;
  MethodChannel.Result resultTemp;
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
            new MethodChannel.MethodCallHandler() {
              @Override
              public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                if (call.method.equals("addUserInfo")){
                  result.success("addUserInfo");
                  UserDetail.id = call.argument("id");
                  UserDetail.email = call.argument("username");
                  UserDetail.username = call.argument("email");
                  sharedpreferences = getSharedPreferences(MyPREFERENCES, Context.MODE_PRIVATE);
                  editor = sharedpreferences.edit();
                  editor.putString("id", call.argument("id"));
                  editor.putString("username", call.argument("username"));
                  editor.putString("email", call.argument("email"));
                  editor.commit();
//                  startService();
                }

                if (call.method.equals("deleteUserInfo")){
                  result.success("deleteUserInfo");
                  UserDetail.id = "";
                  UserDetail.email = "";
                  UserDetail.username = "";
                  SharedPreferences sharedpreferences = getSharedPreferences(MyPREFERENCES, Context.MODE_PRIVATE);
                  SharedPreferences.Editor editor = sharedpreferences.edit();
                  editor.clear();
                  editor.commit();
//                  ForegroundService.mSocket.disconnect();
                }


                if (call.method.equals("getMoMoToken")) {
                  no = call.argument("box_no");
                  amount = call.argument("amount");
                  String periodTemp = call.argument("period");
                  if (periodTemp.equals("1")){
                    period = "1 hour";
                  }else if (periodTemp.equals("2")){
                    period = "1 day";

                  }else if (periodTemp.equals("3")){
                    period = "1 month";
                  }

                  resultTemp = result;
                  requestPayment(no, amount);
                }

                if (call.method.equals("startSocket")){
                    result.success("startSocket");
                    startService();
                }
              }});
  }

  public void startService() {

    Intent serviceIntent = new Intent(this, ForegroundService.class);
    //serviceIntent.putExtra("inputExtra", "Foreground Service Example in Android");
    ContextCompat.startForegroundService(this, serviceIntent);

  }

  private void requestPayment(String no, Integer amount) {
    String merchantName =  "DHD";
    String merchantCode = "MOMOTOAE20200418";

    AppMoMoLib.getInstance().setEnvironment(AppMoMoLib.ENVIRONMENT.DEVELOPMENT);
    AppMoMoLib.getInstance().setAction(AppMoMoLib.ACTION.PAYMENT);
    AppMoMoLib.getInstance().setActionType(AppMoMoLib.ACTION_TYPE.GET_TOKEN);

    Map<String, Object> eventValue = new HashMap<>();
    //client Required
    eventValue.put(MoMoParameterNamePayment.MERCHANT_NAME, merchantName);
    eventValue.put(MoMoParameterNamePayment.MERCHANT_CODE, merchantCode);
    eventValue.put(MoMoParameterNamePayment.AMOUNT, amount);
    eventValue.put(MoMoParameterNamePayment.DESCRIPTION, "Box " + no + " - " + period);

    //Request momo app
    AppMoMoLib.getInstance().requestMoMoCallBack(this, eventValue);
  }

  @Override
  protected void onActivityResult(int requestCode, int resultCode, Intent data) {
    super.onActivityResult(requestCode, resultCode, data);
    if(requestCode == AppMoMoLib.getInstance().REQUEST_CODE_MOMO && resultCode == -1) {
      JSONObject input = new JSONObject();
      try {
        input.put("status", data.getIntExtra("status", -1));
        input.put("message", data.getStringExtra("message"));
        input.put("data", data.getStringExtra("data"));
        input.put("phonenumber", data.getStringExtra("phonenumber"));
      } catch (JSONException e) {
        e.printStackTrace();
      }
      resultTemp.success(String.valueOf(input));
    }
  }
}
