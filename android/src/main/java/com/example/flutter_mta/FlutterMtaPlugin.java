package com.example.flutter_mta;

import android.app.Application;
import android.app.Activity;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import com.tencent.stat.StatService;

import java.util.Map;
import java.util.Properties;

import com.tencent.stat.StatConfig;

/**
 * FlutterMtaPlugin
 */
public class FlutterMtaPlugin implements MethodCallHandler {
  private final Registrar mRegistrar;

  FlutterMtaPlugin(Registrar registrar) {
    mRegistrar = registrar;
  }

  /**
   * Plugin registration.
   */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_mta");
    channel.setMethodCallHandler(new FlutterMtaPlugin(registrar));
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("init")) {
      init(call, result);
    } else if (call.method.equals("trackCustomKVEvent")) {
      trackCustomKVEvent(call, result);
    } else if (call.method.equals("trackBeginPage")) {
      trackBeginPage(call, result);
    } else if (call.method.equals("trackEndPage")) {
      trackEndPage(call, result);
    } else {
      result.notImplemented();
    }
  }

  private void init(MethodCall call, Result result) {
    try {
      String appKey = call.argument("androidAppKey");
      Boolean debug = call.argument("debug");

      Activity activity = mRegistrar.activity();

      // 使用手动统计
      StatConfig.setAntoActivityLifecycleStat(false);
      StatConfig.setEnableAutoMonitorActivityCycle(false);

      StatConfig.setDebugEnable(debug);
      StatService.startStatService(activity.getApplicationContext(), appKey,
              com.tencent.stat.common.StatConstants.VERSION);

      result.success(true);
    } catch (Exception e) {
      e.printStackTrace();
      result.success(false);
    }
  }

  private void trackCustomKVEvent(MethodCall call, Result result) {
    try {
      String eventId = call.argument("eventId");
      Map<String, String> properties = call.argument("properties");

      Activity activity = mRegistrar.activity();

      Properties props = new Properties();
      if (properties != null) {
        for (Map.Entry<String, String> entry : properties.entrySet()) {
          props.setProperty(entry.getKey(), entry.getValue());
        }
      }
      StatService.trackCustomKVEvent(activity.getApplicationContext(), eventId, props);

      result.success(true);
    } catch (Exception e) {
      e.printStackTrace();
      result.success(false);
    }
  }

  private void trackBeginPage(MethodCall call, Result result) {
    try {
      Activity activity = mRegistrar.activity();
      String pageName = call.argument("pageName");
      StatService.trackBeginPage(activity.getApplicationContext(), pageName);

      result.success(true);
    } catch (Exception e) {
      e.printStackTrace();
      result.success(false);
    }
  }

  private void trackEndPage(MethodCall call, Result result) {
    try {
      Activity activity = mRegistrar.activity();
      String pageName = call.argument("pageName");
      StatService.trackEndPage(activity.getApplicationContext(), pageName);

      result.success(true);
    } catch (Exception e) {
      e.printStackTrace();
      result.success(false);
    }
  }
}
