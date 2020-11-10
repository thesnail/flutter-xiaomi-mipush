package com.flutter.xiaomi.mipush;

import android.app.ActivityManager;
import android.app.Application;
import android.content.Context;
import android.os.Process;
import android.util.Log;
import androidx.annotation.NonNull;
import com.xiaomi.channel.commonutils.logger.LoggerInterface;
import com.xiaomi.mipush.sdk.Logger;
import com.xiaomi.mipush.sdk.MiPushClient;
import java.util.ArrayList;
import java.util.List;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class FlutterXiaomiMipushPlugin implements FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler {

    private static final String PLUGIN_NAME = "com.xiaomi.mipush/flutter";

    public final static String TAG = "XiaomiMipushPlugin";

    public static MethodChannel channel;
    private Application application;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), PLUGIN_NAME);
        application = (Application) flutterPluginBinding.getApplicationContext();
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case "registerPush": {
                String appId = call.argument("appId");
                String appKey = call.argument("appKey");
                boolean isLog = call.argument("isLog");
                boolean status = registerPush(appId, appKey, isLog);
                result.success(status);
                break;
            }
            case "unregisterPush": {
                boolean status = unregisterPush();
                result.success(status);
                break;
            }
            case "enablePush": {
                boolean status = enablePush();
                result.success(status);
                break;
            }
            case "disablePush": {
                boolean status = disablePush();
                result.success(status);
                break;
            }
            case "setAlias": {
                String alias = call.argument("alias");
                String category = call.argument("category");
                boolean status = setAlias(alias, category);
                result.success(status);
                break;
            }
            case "unsetAlias": {
                String alias = call.argument("alias");
                String category = call.argument("category");
                boolean status = unsetAlias(alias, category);
                result.success(status);
                break;
            }
            case "setUserAccount": {
                String userAccount = call.argument("userAccount");
                String category = call.argument("category");
                boolean status = setUserAccount(userAccount, category);
                result.success(status);
                break;
            }
            case "unsetUserAccount": {
                String userAccount = call.argument("userAccount");
                String category = call.argument("category");
                boolean status = unsetUserAccount(userAccount, category);
                result.success(status);
                break;
            }
            case "subscribe": {
                String topic = call.argument("topic");
                String category = call.argument("category");
                boolean status = subscribe(topic, category);
                result.success(status);
                break;
            }
            case "unsubscribe": {
                String topic = call.argument("topic");
                String category = call.argument("category");
                boolean status = unsubscribe(topic, category);
                result.success(status);
                break;
            }
            case "pausePush": {
                String category = call.argument("category");
                boolean status = pausePush(category);
                result.success(status);
                break;
            }
            case "resumePush": {
                String category = call.argument("category");
                boolean status = resumePush(category);
                result.success(status);
                break;
            }
            case "setAcceptTime": {
                String category = call.argument("category");
                Integer startHour = call.argument("startHour");
                Integer startMin = call.argument("startMin");
                Integer endHour = call.argument("endHour");
                Integer endMin = call.argument("endMin");
                boolean status = setAcceptTime(startHour, startMin, endHour, endMin, category);
                result.success(status);
            }
            case "getAllAlias": {
                List<String> list = getAllAlias();
                result.success(list);
                break;
            }
            case "getAllTopic": {
                List<String> list = getAllTopic();
                result.success(list);
                break;
            }
            case "getAllUserAccount": {
                List<String> list = getAllUserAccount();
                result.success(list);
                break;
            }
            case "reportMessageClicked": {
                String msgId = call.argument("msgId");
                boolean status = reportMessageClicked(msgId);
                result.success(status);
                break;
            }
            case "clearNotification": {
                Integer notifyId = call.argument("notifyId");
                boolean status = clearNotification(notifyId);
                result.success(status);
                break;
            }
            case "setLocalNotificationType": {
                Integer notifyType = call.argument("notifyType");
                boolean status = setLocalNotificationType(notifyType);
                result.success(status);
                break;
            }
            case "clearLocalNotificationType": { //清除客户端设置的通知消息提醒类型。
                boolean status = clearLocalNotificationType();
                result.success(status);
                break;
            }
            case "getRegId": { //获取客户端的RegId。
                String regId = getRegId();
                result.success(regId);
                break;
            }
            default: {
                result.notImplemented();
                break;
            }
        }
    }

    private List<String> getAllAlias() {
        try {
            List<String> list = MiPushClient.getAllAlias(application);
            return list;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return new ArrayList<String>();
    }

    private List<String> getAllTopic() {
        try {
            List<String> list = MiPushClient.getAllTopic(application);
            return list;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return new ArrayList<String>();
    }

    private List<String> getAllUserAccount() {
        try {
            List<String> list = MiPushClient.getAllUserAccount(application);
            return list;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return new ArrayList<String>();
    }

    private boolean reportMessageClicked(String msgId) {
        try {
            MiPushClient.reportMessageClicked(application, msgId);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
        return true;
    }

    private boolean clearNotification(int notifyId) {
        try {
            if (notifyId == -1) {
                MiPushClient.clearNotification(application);
            } else {
                MiPushClient.clearNotification(application, notifyId);
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
        return true;
    }

    private boolean setLocalNotificationType(int notifyType) {
        try {
            MiPushClient.setLocalNotificationType(application, notifyType);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
        return true;
    }

    private boolean clearLocalNotificationType() {
        try {
            MiPushClient.clearLocalNotificationType(application);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
        return true;
    }

    private String getRegId() {
        try {
            String regId = MiPushClient.getRegId(application);
            return regId;
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }

    private boolean setAcceptTime(int startHour, int startMin, int endHour, int endMin, String category) {
        try {
            MiPushClient.setAcceptTime(application, startHour, startMin, endHour, endMin, category);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
        return true;
    }

    private boolean resumePush(String category) {
        try {
            MiPushClient.resumePush(application, category);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
        return true;
    }

    private boolean pausePush(String category) {
        try {
            MiPushClient.pausePush(application, category);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
        return true;
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
        channel = null;
    }

    private boolean unsubscribe(String topic, String category) {
        try {
            MiPushClient.unsubscribe(application, topic, category);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
        return true;
    }

    private boolean subscribe(String topic, String category) {
        try {
            MiPushClient.subscribe(application, topic, category);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
        return true;
    }

    private boolean unsetUserAccount(String userAccount, String category) {
        try {
            MiPushClient.unsetUserAccount(application, userAccount, category);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
        return true;
    }

    private boolean setUserAccount(String userAccount, String category) {
        try {
            MiPushClient.setUserAccount(application, userAccount, category);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
        return true;
    }


    private boolean setAlias(String alias, String category) {
        try {
            MiPushClient.setAlias(application, alias, category);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
        return true;
    }

    private boolean unsetAlias(String alias, String category) {
        try {
            MiPushClient.unsetAlias(application, alias, category);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
        return true;
    }


    private boolean disablePush() {
        try {
            MiPushClient.disablePush(application);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
        return true;
    }

    private boolean enablePush() {
        try {
            MiPushClient.enablePush(application);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
        return true;
    }

    private boolean unregisterPush() {
        try {
            MiPushClient.unregisterPush(application);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
        return true;
    }

    private boolean registerPush(String appId, String appKey, boolean isLog) {
        //初始化push推送服务
        try {
            if (shouldInit()) {
                MiPushClient.registerPush(application, appId, appKey);
            }
            if (isLog) {
                LoggerInterface newLogger = new LoggerInterface() {
                    @Override
                    public void setTag(String tag) {
                        // ignore
                    }

                    @Override
                    public void log(String content, Throwable t) {
                        Log.e(TAG, content, t);
                    }

                    @Override
                    public void log(String content) {
                        Log.e(TAG, content);
                    }
                };
                Logger.setLogger(application, newLogger);
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
        return true;
    }


    private boolean shouldInit() {
        ActivityManager am = ((ActivityManager) application.getSystemService(Context.ACTIVITY_SERVICE));
        List<ActivityManager.RunningAppProcessInfo> processInfos = am.getRunningAppProcesses();
        String mainProcessName = application.getApplicationInfo().processName;
        int myPid = Process.myPid();
        for (ActivityManager.RunningAppProcessInfo info : processInfos) {
            if (info.pid == myPid && mainProcessName.equals(info.processName)) {
                return true;
            }
        }
        return false;
    }


    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
    }
    @Override
    public void onCancel(Object arguments) {

    }
}
