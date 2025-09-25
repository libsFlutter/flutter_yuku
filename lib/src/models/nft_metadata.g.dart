// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nft_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NFTMetadata _$NFTMetadataFromJson(Map<String, dynamic> json) => NFTMetadata(
  name: json['name'] as String,
  description: json['description'] as String,
  image: json['image'] as String,
  attributes: json['attributes'] as Map<String, dynamic>,
  properties: json['properties'] as Map<String, dynamic>,
  externalUrl: json['externalUrl'] as String?,
  animationUrl: json['animationUrl'] as String?,
  backgroundColor: json['backgroundColor'] as String?,
  youtubeUrl: json['youtubeUrl'] as String?,
);

Map<String, dynamic> _$NFTMetadataToJson(NFTMetadata instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'image': instance.image,
      'attributes': instance.attributes,
      'properties': instance.properties,
      'externalUrl': instance.externalUrl,
      'animationUrl': instance.animationUrl,
      'backgroundColor': instance.backgroundColor,
      'youtubeUrl': instance.youtubeUrl,
    };
