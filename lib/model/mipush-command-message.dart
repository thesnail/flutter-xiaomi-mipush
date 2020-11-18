
class MiPushCommandMessage {

  final String command;
  final String reason;
  final int resultCode;
  final String category;
  final List<dynamic> commandArguments;
  
  MiPushCommandMessage({
    this.command,
    this.reason,
    this.resultCode,
    this.category,
    this.commandArguments
  });

  factory MiPushCommandMessage.fromJson(Map<dynamic, dynamic> json) {
    return MiPushCommandMessage(
      command:json['command'] == null ? '':json['command'] as String,
      reason:json['reason'] == null ? '':json['reason'] as String,
      resultCode:json['resultCode'] == null ? 0:json['resultCode'] as int,
      category:json['category'] == null ? '':json['category'] as String,
      commandArguments:json['commandArguments'] == null ? List<dynamic>():json['commandArguments'] as List<dynamic>
    );
  }
  
  Map<dynamic, dynamic> toJson() => {
    'command':command,
    'reason':reason,
    'resultCode':resultCode,
    'category':category,
    'commandArguments':commandArguments
  };
}