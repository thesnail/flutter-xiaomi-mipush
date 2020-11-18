
import 'package:flutter/services.dart';
import 'package:fluttermipush/model/mipush-command-message.dart';
import 'package:fluttermipush/model/mipush-message.dart';

class FlutterMipushListener {
  
  /// 监听器列表
  static Set<ListenerValue> allListeners = Set();

  /// 透传消息监听器列表
  static Set<MiPushListenerValue<MiPushMessage>> passThroughListeners = Set();

  /// 服务器推送通知消息点击触发监听器列表
  static Set<MiPushListenerValue<MiPushMessage>> messageClickedListeners = Set();

  /// 服务器推送通知消息到达客户端监听器列表
  static Set<MiPushListenerValue<MiPushMessage>> messageArrivedListeners = Set();

  /// 给服务器发送命令的结果监听器列表
  static Set<MiPushListenerValue<MiPushCommandMessage>> commandListeners = Set();

  /// 给服务器发送注册命令的结果监听器列表
  static Set<MiPushListenerValue<MiPushCommandMessage>> receiveRegisterListeners = Set();

  /// 所需要权限未获取回调接口监听器列表
  static Set<MiPushListenerValue<List<dynamic>>> permissionsListeners = Set();

  FlutterMipushListener(MethodChannel channel) {
    ///
    /// 绑定监听器
    /// 
    channel.setMethodCallHandler((MethodCall call) async {
      ///
      /// 解析监听到的参数
      ///
      dynamic arguments = call.arguments;
      print(call.method);
      for (var item in allListeners) {
        item(call.method, arguments);
      }
      switch (call.method) {
        case 'ReceivePassThroughMessage':{
          MiPushMessage message = MiPushMessage.fromJson(Map<dynamic, dynamic>.from(arguments));
          for (var passThrough in passThroughListeners) {
            passThrough(message);
          }
          break;
        }
        case 'NotificationMessageClicked':{
          MiPushMessage message = MiPushMessage.fromJson(Map<dynamic, dynamic>.from(arguments));
          for (var messageClicked in messageClickedListeners) {
            messageClicked(message);
          }
          break;
        }
        case 'NotificationMessageArrived':{
          MiPushMessage message = MiPushMessage.fromJson(Map<dynamic, dynamic>.from(arguments));
          for (var messageArrived in messageArrivedListeners) {
            messageArrived(message);
          }
          break;
        }
        case 'CommandResult':{
          try {
            MiPushCommandMessage message = MiPushCommandMessage.fromJson(Map<dynamic, dynamic>.from(arguments));
            for (var command in commandListeners) {
              command(message);
            }
          } catch (e) {
            print(e);
          }
          break;
        }
        case 'ReceiveRegisterResult':{
          try {
            MiPushCommandMessage message = MiPushCommandMessage.fromJson(Map<dynamic, dynamic>.from(arguments));
            for (var receiveRegister in receiveRegisterListeners) {
              receiveRegister(message);
            }
          } catch (e) {
            print(e);
          }
          break;
        }
        case 'RequirePermissions':{
          for (var permissions in permissionsListeners) {
            permissions(List<dynamic>.from(arguments));
          }
          break;
        }
        default:{
          break;
        }
      }
    });
  }

  ///
  /// 注册接收服务器推送的透传消息监听
  ///
  void addPassThroughListener(MiPushListenerValue<MiPushMessage> func){
    passThroughListeners.add(func);
  }

  ///
  /// 移除接收服务器推送的透传消息监听
  ///
  void removePassThroughListener(MiPushListenerValue<MiPushMessage> func){
    passThroughListeners.remove(func);
  }

  ///
  /// 注册服务器推送通知消息点击触发监听
  ///
  void addMessageClickedListener(MiPushListenerValue<MiPushMessage> func){
    messageClickedListeners.add(func);
  }

  ///
  /// 移除服务器推送通知消息点击触发监听
  ///
  void removeMessageClickedListener(MiPushListenerValue<MiPushMessage> func){
    messageClickedListeners.remove(func);
  }

  ///
  /// 注册服务器推送通知消息到达客户端监听
  ///
  void addMessageArrivedListener(MiPushListenerValue<MiPushMessage> func){
    messageArrivedListeners.add(func);
  }

  ///
  /// 注册服务器推送通知消息到达客户端监听
  ///
  void removeMessageArrivedListener(MiPushListenerValue<MiPushMessage> func){
    messageArrivedListeners.remove(func);
  }

  ///
  /// 注册向服务器发送命令结果的监听
  ///
  void addCommandListener(MiPushListenerValue<MiPushCommandMessage> func){
    commandListeners.add(func);
  }

  ///
  /// 移除向服务器发送命令结果的监听
  ///
  void removeCommandListener(MiPushListenerValue<MiPushCommandMessage> func){
    commandListeners.remove(func);
  }

  ///
  /// 注册向服务器发送注册命令结果的监听
  ///
  void addReceiveRegisterListener(MiPushListenerValue<MiPushCommandMessage> func){
    receiveRegisterListeners.add(func);
  }

  ///
  /// 移除向服务器发送注册命令结果的监听
  ///
  void removeReceiveRegisterListener(MiPushListenerValue<MiPushCommandMessage> func){
    receiveRegisterListeners.remove(func);
  }

  /// 
  /// 注册需要的权限未获取时回调监听
  /// 
  void addPermissionsListener(MiPushListenerValue<List<dynamic>> func){
    permissionsListeners.add(func);
  }

  /// 
  /// 移除需要的权限未获取时回调监听
  /// 
  void removePermissionsListener(MiPushListenerValue<List<dynamic>> func){
    permissionsListeners.remove(func);
  }

  ///
  /// 添加小米推送的消息监听
  ///
  void addListener(ListenerValue func){
    allListeners.add(func);
  }

  ///
  /// 移除小米推送的消息监听
  ///
  void removeListener(ListenerValue func){
    allListeners.remove(func);
  } 
}


typedef MiPushListenerValue<P> = void Function(P params);

typedef ListenerValue<P> = void Function(String method, P params);
