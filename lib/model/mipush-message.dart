class MiPushMessage{
  final String messageId;
  final int messageType;
  final String content;
  final String alias;
  final String topic;
  final String userAccount;
  final int passThrough;
  final int notifyType;
  final int notifyId;
  final bool notified;
  final String description;
  final String title;
  final String category;
  final bool arrivedMessage;
  final MiPushMessageExtra extra;

  MiPushMessage({
    this.messageId,
    this.messageType,
    this.content,
    this.alias,
    this.topic,
    this.userAccount,
    this.passThrough,
    this.notifyType,
    this.notifyId,
    this.notified,
    this.description,
    this.title,
    this.category,
    this.arrivedMessage,
    this.extra
  });

  factory MiPushMessage.fromJson(Map<dynamic, dynamic> json) {
    return MiPushMessage(
      messageId:json['messageId'],
      messageType:json['messageType'],
      content:json['content'],
      alias:json['alias'],
      topic:json['topic'],
      userAccount:json['userAccount'],
      passThrough:json['passThrough'],
      notifyType:json['notifyType'],
      notifyId:json['notifyId'],
      notified:json['notified'],
      description:json['description'],
      title:json['title'],
      category:json['category'],
      arrivedMessage:json['arrivedMessage'],
      extra:json['extra'] == null ? null : (json['extra'] is Map<dynamic, dynamic>)?MiPushMessageExtra.fromJson(json['extra'] as Map<dynamic, dynamic>):null
    );
  }

  Map<dynamic, dynamic> toJson() => {
    'messageId': messageId,
    'messageType': messageType,
    'content': content,
    'alias': alias,
    'topic': topic,
    'userAccount': userAccount,
    'passThrough': passThrough,
    'notifyType': notifyType,
    'notifyId': notifyId,
    'notified': notified,
    'description': description,
    'title': title,
    'category': category,
    'arrivedMessage': arrivedMessage,
    'extra': extra == null?null:extra.toJson()
  };

}

class MiPushMessageExtra {
  
  final String highPriorityEvent;
  final String feTs;
  final String planId;
  final String source;
  final String notifyForeground;
  final String mTs;

  MiPushMessageExtra({
    this.highPriorityEvent,
    this.feTs,
    this.planId,
    this.source,
    this.notifyForeground,
    this.mTs,
  });

  factory MiPushMessageExtra.fromJson(Map<dynamic, dynamic> json) {
    return MiPushMessageExtra(
      highPriorityEvent: json['high_priority_event'],
      feTs: json['fe_ts'],
      planId: json['__planId__'],
      source: json['source'],
      notifyForeground: json['notify_foreground'],
      mTs: json['__m_ts'],
    );
  }

  Map<String, dynamic> toJson() => {
        'high_priority_event': highPriorityEvent,
        'fe_ts': feTs,
        '__planId__': planId,
        'source': source,
        'notify_foreground': notifyForeground,
        '__m_ts': mTs,
      };
}