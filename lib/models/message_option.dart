class MessageOption {
  /// Used to easily create a chain of replies
  final String id;

  /// Stores the id of the next message that should be sent in case this option is selected by the user
  final String? nextMessageId;

  /// The actual text that the user sees when shown multiple [MessageOption]
  final String text;

  /// Svg icon shown on the left side of the text
  final String? svgIcon;

  MessageOption({
    required this.id,
    required this.nextMessageId,
    required this.text,
    this.svgIcon,
  });

  Map<String, dynamic> toJSON() => <String, dynamic>{
        'id': id,
        'nextMessageId': nextMessageId,
        'text': text,
        'svgIcon': svgIcon,
      };

  factory MessageOption.fromJson(Map<String, dynamic> json) => MessageOption(
        id: json['id'],
        nextMessageId: json['nextMessageId'],
        text: json['text'],
      );
}
