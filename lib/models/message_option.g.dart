// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_option.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageOption _$MessageOptionFromJson(Map<String, dynamic> json) =>
    MessageOption(
      id: json['id'] as String,
      optionText: json['optionText'] as String,
      svgIcon: json['svgIcon'] as String?,
    );

Map<String, dynamic> _$MessageOptionToJson(MessageOption instance) =>
    <String, dynamic>{
      'id': instance.id,
      'optionText': instance.optionText,
      'svgIcon': instance.svgIcon,
    };
