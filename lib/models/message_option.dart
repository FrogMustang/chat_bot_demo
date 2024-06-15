import 'package:json_annotation/json_annotation.dart';

part 'message_option.g.dart';

@JsonSerializable()
class MessageOption {
  /// Used to easily create a chain of replies
  final String id;

  /// Stores the id of the next message that should be sent in case this option is selected by the user
  final String? nextMessageId;

  /// The text of the [MessageOption] button
  final String optionText;

  /// Svg icon shown on the left side of the text
  final String? svgIcon;


  MessageOption({
    required this.id,
    required this.nextMessageId,
    required this.optionText,
    this.svgIcon,
  });

  factory MessageOption.fromJson(Map<String, dynamic> json) => _$MessageOptionFromJson(json);

  Map<String, dynamic> toJson() => _$MessageOptionToJson(this);
}
