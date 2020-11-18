
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttermipush/flutter-mipush-listener.dart';
import 'package:fluttermipush/flutter_xiaomi_mipush.dart';
import 'package:fluttermipush/model/mipush-command-message.dart';

class FlutterMipush {
  static const MethodChannel _channel = const MethodChannel('com.xiaomi.mipush/flutter');

  static FlutterMipushListener listener =  FlutterMipushListener(_channel);

  ///
  /// 检查进程是否运行
  /// processName 进程名称
  ///
  static Future<bool> getProessRunning({@required String processName}) async {
    final bool status = await _channel.invokeMethod('getProessRunning',{'processName':processName});
    return status;
  }
  
  ///
  /// 注册MiPush推送服务，建议在app启动的时候调用。(由开发者决定是否注册推送。)
  /// 
  /// appId 在开发者网站上注册时生成的，MiPush推送服务颁发给app的唯一认证标识
  /// appKey 在开发者网站上注册时生成的，与appID相对应，用于验证appID是否合法
  /// isLog 是否打开Log
  ///
  static Future<bool> registerPush({@required String appId,@required String appKey,bool isLog = false}) async{
    final bool status = await _channel.invokeMethod('registerPush',{'appId':appId,'appKey':appKey,'isLog':isLog});
    return status;
  }

  ///
  /// 关闭MiPush推送服务，当用户希望不再使用MiPush推送服务的时候调用，调用成功之后，app将不会接收到任何MiPush服务推送的数据，直到下一次调用registerPush ()。
  /// 注: 调用unregisterPush()之后，服务器不会向app发送任何消息。
  ///
  static Future<bool> unregisterPush() async {
    final bool status = await _channel.invokeMethod('unregisterPush');
    return status;
  }


  ///
  /// 启用MiPush推送服务。 由开发者决定是否启用推送。调用disablePush和enablePush接口后，不会生成新的regId，regId会和原来的保持一致。
  ///
  static Future<bool> enablePush() async {
    final bool status = await _channel.invokeMethod('enablePush');
    return status;
  }


  ///
  /// 禁用MiPush推送服务。调用disablePush和enablePush接口后，不会生成新的regId，regId会和原来的保持一致。
  ///
  static Future<bool> disablePush() async {
    final bool status = await _channel.invokeMethod('disablePush');
    return status;
  }

  ///
  /// 为指定用户设置alias。详细说明请参见3.4.3。(开发者决定通过alias推送。)
  /// alias 为指定用户设置别名
  /// category 扩展参数，暂时没有用途，可以不填,默认为空
  ///
  static Future<bool> setAlias({@required String alias,String category=''}) async {
    final bool status = await _channel.invokeMethod('setAlias',{'alias':alias,'category':category});
    return status;
  }

  ///
  /// 取消指定用户的alias。详细说明请参见3.4.4。开发者需要取消用户别名。
  ///
  static Future<bool> unsetAlias({@required String alias,String category=''}) async {
    final bool status = await _channel.invokeMethod('unsetAlias',{'alias':alias,'category':category});
    return status;
  }

  ///
  /// 为指定用户设置userAccount。详细说明请参见3.4.5。开发者决定通过userAccount推送。
  ///
  static Future<bool> setUserAccount({@required String userAccount,String category=''}) async {
    final bool status = await _channel.invokeMethod('setUserAccount',{'userAccount':userAccount,'category':category});
    return status;
  }

  ///
  /// 取消指定用户的userAccount。详细说明请参见3.4.6。开发者需要取消用户userAccount。
  ///
  static Future<bool> unsetUserAccount({@required String userAccount,String category=''}) async {
    final bool status = await _channel.invokeMethod('unsetUserAccount',{'userAccount':userAccount,'category':category});
    return status;
  }

  ///
  /// 为某个用户设置订阅topic。详细说明请参见3.4.7。 按照用户的订阅，开发者实现根据订阅分组群发。
  ///
  static Future<bool> subscribe({@required String topic,String category=''}) async {
    final bool status = await _channel.invokeMethod('subscribe',{'topic':topic,'category':category});
    return status;
  }

  ///
  /// 取消某个用户的订阅topic。详细说明请参见3.4.8。用户取消某个订阅topic。
  ///
  static Future<bool> unsubscribe({@required String topic,String category=''}) async {
    final bool status = await _channel.invokeMethod('unsubscribe',{'topic':topic,'category':category});
    return status;
  }

  ///
  /// 暂停接收MiPush服务推送的消息，app在恢复MiPush推送服务之前，不接收任何推送消息 注: 这里使用与RegId相关联的alias和topic推送消息，也是被暂停的
  /// category 扩展参数，暂时没有用途，可以不填,默认为空
  ///
  static Future<bool> pausePush({String category=''}) async {
    final bool status = await _channel.invokeMethod('pausePush',{'category':category});
    return status;
  }

  ///
  /// 恢复接收MiPush服务推送的消息 注: 这里使用与RegId相关联的alias和topic推送消息，也是被恢复的；这时服务器会把暂停时期的推送消息重新推送过来
  /// category 扩展参数，暂时没有用途，可以不填,默认为空
  ///
  static Future<bool> resumePush({String category=''}) async {
    final bool status = await _channel.invokeMethod('resumePush',{'category':category});
    return status;
  }

  ///
  /// 设置接收MiPush服务推送的时段，不在该时段的推送消息会被缓存起来，到了合适的时段再向app推送原先被缓存的消息。
  /// 这里采用24小时制，如果开始时间早于结束时间，则这个时段落在一天内；否则，这个时间将会跨越凌晨0点。
  /// 注: 这里使用与regId相关联的alias和topic推送消息，也会受到限制。 
  /// 如果时间设置为0:00-0:00，就是暂停push推送服务，也可以直接调用pausePush()方法，其本质相同 
  /// 如果时间设置为0:00-23:59，就是恢复push推送服务，即全天接收push推送消息，也可以直接调用resumePush()方法，其本质相同
  /// startHour 接收时段开始时间的小时
  /// startMin 接收时段开始时间的分钟
  /// endHour 接收时段结束时间的小时
  /// endMin 接收时段结束时间的分钟
  /// category 扩展参数，暂时没有用途，可以不填,默认为空
  ///
  static Future<bool> setAcceptTime({@required int startHour,@required int startMin,@required int endHour,@required int endMin,String category=''}) async {
    final bool status = await _channel.invokeMethod('setAcceptTime',{'startHour':startHour,'startMin':startMin,'endHour':endHour,'endMin':endMin,'category':category});
    return status;
  }
  
  ///
  /// 获取客户端所有设置的别名。(开发者需要查询所设置的别名。)
  ///
  static Future<List<dynamic>> getAllAlias()async {
    final List<dynamic> list = await _channel.invokeMethod('getAllAlias');
    return list;
  }

  ///
  /// 获取客户端所有订阅的主题。(开发者需要查询所订阅的主题。)
  ///
  static Future<List<dynamic>> getAllTopic()async {
    final List<dynamic> list = await _channel.invokeMethod('getAllTopic');
    return list;
  }

  ///
  /// 获取客户端所有设置的帐号。(开发者需要查询所设置的账号。)
  ///
  static Future<List<dynamic>> getAllUserAccount()async {
    final List<dynamic> list = await _channel.invokeMethod('getAllUserAccount');
    return list;
  }

  ///
  /// 上报点击的消息。(开发者获取消息的点击率。)
  /// msgId 调用server api推送消息后返回的消息ID。
  ///
  static Future<bool> reportMessageClicked({@required String msgId}) async {
    final bool status = await _channel.invokeMethod('reportMessageClicked',{'msgId':msgId});
    return status;
  }

  ///
  /// 清除小米推送弹出的某一个notifyId通知,若notifyId不填写或者填写为-1则表示清除所有通知
  /// notifyId 调用server api设置通知消息的notifyId。 notifyId为-1时清除所有通知
  ///
  static Future<bool> clearNotification({int notifyId = -1}) async{
    final bool status = await _channel.invokeMethod('clearNotification',{'notifyId':notifyId});
    return status;
  }

  ///
  /// 客户端设置通知消息的提醒类型。 注：当服务端指定了消息的提醒类型，会优选考虑客户端设置的。(客户端设置通知消息的提醒类型。)
  /// notifyType 通知栏消息的提醒类型。
  ///
  static Future<bool> setLocalNotificationType({@required int notifyType}) async{
    final bool status = await _channel.invokeMethod('setLocalNotificationType');
    return status;
  }

  ///
  /// 清除客户端设置的通知消息提醒类型。(清除客户端设置的通知消息提醒类型。)
  ///
  static Future<bool> clearLocalNotificationType() async {
    final bool status = await _channel.invokeMethod('clearLocalNotificationType');
    return status;
  }

  ///
  /// 获取客户端的RegId。(获取客户端的RegId。)
  ///
  static Future<String> getRegId() async {
    final String regId = await _channel.invokeMethod('getRegId');
    return regId;
  }

  ///
  /// (透传消息)注册透传消息监听
  ///
  static void addPassThroughListener(MiPushListenerValue<MiPushMessage> func){
    listener.addPassThroughListener(func);
  }

  ///
  /// (透传消息)移除透传消息监听
  ///
  static void removePassThroughListener(MiPushListenerValue<MiPushMessage> func){
    listener.removePassThroughListener(func);
  }

  ///
  /// (通知消息)注册点击通知栏消息监听
  ///
  static void addMessageClickedListener(MiPushListenerValue<MiPushMessage> func){
    listener.addMessageClickedListener(func);
  }

  ///
  /// (通知消息)移除点击通知栏消息监听
  ///
  static void removeMessageClickedListener(MiPushListenerValue<MiPushMessage> func){
    listener.removeMessageClickedListener(func);
  }

  ///
  /// (通知消息)注册消息到达客户端时监听
  ///
  static void addMessageArrivedListener(MiPushListenerValue<MiPushMessage> func){
    listener.addMessageArrivedListener(func);
  }

  ///
  /// (通知消息)移除消息到达客户端时监听
  ///
  static void removeMessageArrivedListener(MiPushListenerValue<MiPushMessage> func){
    listener.removeMessageArrivedListener(func);
  }

  ///
  /// (发送命令)注册发送命令结果的监听
  ///
  static void addCommandListener(MiPushListenerValue<MiPushCommandMessage> func){
    listener.addCommandListener(func);
  }

  ///
  /// (发送命令)移除发送命令结果的监听
  ///
  static void removeCommandListener(MiPushListenerValue<MiPushCommandMessage> func){
    listener.removeCommandListener(func);
  }

  ///
  /// (发送注册命令) 注册发送注册命令的监听
  ///
  static void addReceiveRegisterListener(MiPushListenerValue<MiPushCommandMessage> func){
    listener.addReceiveRegisterListener(func);
  }

  ///
  /// (发送注册命令) 移除发送注册命令的监听
  ///
  static void removeReceiveRegisterListener(MiPushListenerValue<MiPushCommandMessage> func){
    listener.removeReceiveRegisterListener(func);
  }

  ///
  /// (权限获取) 注册权限未获取时回调接口监听
  ///
  static void addPermissionsListener(MiPushListenerValue<List<dynamic>> func){
    listener.addPermissionsListener(func);
  }

  ///
  /// (权限获取) 移除权限未获取时回调接口监听
  ///
  static void removePermissionsListener(MiPushListenerValue<List<dynamic>> func){
    listener.removePermissionsListener(func);
  }


  ///
  /// 添加小米推送消息监听,此方法返回的数据需要自己解析
  ///
  static void addListener(ListenerValue func){
    listener.addListener(func);
  }

  ///
  /// 移除小米推送消息的监听
  ///
  static void removeListener(ListenerValue func){
    listener.removeListener(func);
  }

}
