package com.flutter.xiaomi.receiver;

import android.content.Context;
import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.TypeReference;
import com.flutter.xiaomi.mipush.FlutterXiaomiMipushPlugin;
import com.flutter.xiaomi.util.CommonUtil;
import com.xiaomi.mipush.sdk.MiPushCommandMessage;
import com.xiaomi.mipush.sdk.MiPushMessage;
import com.xiaomi.mipush.sdk.PushMessageReceiver;
import java.util.Map;
import io.flutter.plugin.common.MethodChannel;


/**
 * 1、PushMessageReceiver 是个抽象类，该类继承了 BroadcastReceiver。<br/>
 * 2、需要将自定义的 DemoMessageReceiver 注册在 AndroidManifest.xml 文件中：
 * <pre>
 * {@code
 *  <receiver
 *      android:name="com.xiaomi.mipushdemo.DemoMessageReceiver"
 *      android:exported="true">
 *      <intent-filter>
 *          <action android:name="com.xiaomi.mipush.RECEIVE_MESSAGE" />
 *      </intent-filter>
 *      <intent-filter>
 *          <action android:name="com.xiaomi.mipush.MESSAGE_ARRIVED" />
 *      </intent-filter>
 *      <intent-filter>
 *          <action android:name="com.xiaomi.mipush.ERROR" />
 *      </intent-filter>
 *  </receiver>
 *  }</pre>
 * 3、DemoMessageReceiver 的 onReceivePassThroughMessage 方法用来接收服务器向客户端发送的透传消息。<br/>
 * 4、DemoMessageReceiver 的 onNotificationMessageClicked 方法用来接收服务器向客户端发送的通知消息，
 * 这个回调方法会在用户手动点击通知后触发。<br/>
 * 5、DemoMessageReceiver 的 onNotificationMessageArrived 方法用来接收服务器向客户端发送的通知消息，
 * 这个回调方法是在通知消息到达客户端时触发。另外应用在前台时不弹出通知的通知消息到达客户端也会触发这个回调函数。<br/>
 * 6、DemoMessageReceiver 的 onCommandResult 方法用来接收客户端向服务器发送命令后的响应结果。<br/>
 * 7、DemoMessageReceiver 的 onReceiveRegisterResult 方法用来接收客户端向服务器发送注册命令后的响应结果。<br/>
 * 8、以上这些方法运行在非 UI 线程中。
 *
 * @author mayixiang
 */

public class MiPushBroadcastReceiver extends PushMessageReceiver {

    @Override
    public void onReceivePassThroughMessage(Context context, MiPushMessage message) {
        this.invokeListener(MessageType.ReceivePassThroughMessage,JSON.parseObject(JSON.toJSONString(message), new TypeReference<Map<String, Object>>(){}));
    }

    @Override
    public void onNotificationMessageClicked(Context context, MiPushMessage message) {
        this.invokeListener(MessageType.NotificationMessageClicked,JSON.parseObject(JSON.toJSONString(message), new TypeReference<Map<String, Object>>(){}));

    }
    @Override
    public void onNotificationMessageArrived(Context context, MiPushMessage message) {
        this.invokeListener(MessageType.NotificationMessageArrived,JSON.parseObject(JSON.toJSONString(message), new TypeReference<Map<String, Object>>(){}));
    }
    @Override
    public void onCommandResult(Context context, MiPushCommandMessage message) {
        this.invokeListener(MessageType.CommandResult,JSON.parseObject(JSON.toJSONString(message), new TypeReference<Map<String, Object>>(){}));
    }
    @Override
    public void onReceiveRegisterResult(Context context, MiPushCommandMessage message) {
        this.invokeListener(MessageType.ReceiveRegisterResult,JSON.parseObject(JSON.toJSONString(message), new TypeReference<Map<String, Object>>(){}));
    }

    @Override
    public void onRequirePermissions(Context context, String[] strings) {
        super.onRequirePermissions(context, strings);
        this.invokeListener(MessageType.RequirePermissions,JSON.parseObject(JSON.toJSONString(strings)));
    }

    private void invokeListener(final MessageType method, final Object params){
        final MethodChannel channel = FlutterXiaomiMipushPlugin.channel;
        if(channel != null){
            CommonUtil.runMainThread(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod(method.name(),params);
                }
            });
        }
    }
}

enum MessageType
{
    ReceivePassThroughMessage, NotificationMessageClicked, NotificationMessageArrived,CommandResult,ReceiveRegisterResult,RequirePermissions
}
