package com.example.flutter_mta;

import android.app.Application;
import android.app.Activity;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import com.tencent.stat.StatService;
import com.tencent.stat.StatConfig;

/** FlutterMtaPlugin */
public class FlutterMtaPlugin implements MethodCallHandler {
  private final Registrar mRegistrar;

  FlutterMtaPlugin(Registrar registrar) {
    mRegistrar = registrar;
  }

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_mta");
    channel.setMethodCallHandler(new FlutterMtaPlugin(registrar));
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("init")) {
      init(call, result);
    } else {
      result.notImplemented();
    }
  }

  private void init(MethodCall call, Result result) {
    try {
      String appKey = call.argument("androidAppKey");
      Boolean debug = call.argument("debug");

      Activity activity = mRegistrar.activity();

      StatConfig.setDebugEnable(debug);
      StatService.startStatService(activity.getApplicationContext(), appKey,
          com.tencent.stat.common.StatConstants.VERSION);

      result.success(true);
    } catch (Exception e) {
      e.printStackTrace();
      result.success(false);
    }

  }
}
