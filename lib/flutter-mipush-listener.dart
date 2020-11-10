
import 'package:flutter/services.dart';

class FlutterMipushListener {
  
  /// 监听器列表
  static Set<ListenerValue> listeners = Set();

  
  FlutterMipushListener(MethodChannel channel) {
    ///
    /// 绑定监听器
    /// 
    channel.setMethodCallHandler((call) async {
      ///
      /// 解析监听到的参数
      ///
      Map<dynamic, dynamic> arguments = call.arguments;
      switch (call.method) {
        case 'onReceivePassThroughMessage':{// 方法用来接收服务器向客户端发送的透传消息
          //print('---------> arguments:$arguments');
          break;
        }
        case 'onNotificationMessageClicked':{// 方法用来接收服务器向客户端发送的通知消息 这个回调方法会在用户手动点击通知后触发。
          //print('---------> arguments:$arguments');
          break;
        }
        case 'onNotificationMessageArrived':{ //方法用来接收服务器向客户端发送的通知消息
          //print('---------> arguments:$arguments');
          break;
        }
        case 'onCommandResult':{ //方法用来接收客户端向服务器发送命令后的响应结果。
          //print('---------> arguments:$arguments');
          break;
        }
        case 'onReceiveRegisterResult':{ // 方法用来接收客户端向服务器发送注册命令后的响应结果。
          //print('---------> arguments:$arguments');
          break;
        }
        default:{
          break;
        }
      }
      for (var item in listeners) {
        item(call.method, arguments);
      }
    });
  }

  ///
  /// 添加小米推送的消息监听
  ///
  void addListener(ListenerValue func){
    listeners.add(func);
  }

  ///
  /// 移除小米推送的消息监听
  ///
  void removeListener(ListenerValue func){
    listeners.remove(func);
  } 
}

typedef ListenerValue<P> = void Function(String method, P params);
