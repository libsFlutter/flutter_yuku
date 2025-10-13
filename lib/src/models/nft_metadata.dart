import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'nft_metadata.g.dart';

/// Standardized NFT metadata format
@JsonSerializable()
class NFTMetadata extends Equatable {
  /// Name of the NFT
  final String name;

  /// Description of the NFT
  final String description;

  /// Image URL of the NFT
  final String image;

  /// Attributes of the NFT
  final Map<String, dynamic> attributes;

  /// Additional properties
  final Map<String, dynamic> properties;

  /// External URL
  final String? externalUrl;

  /// Animation URL
  final String? animationUrl;

  /// Background color
  final String? backgroundColor;

  /// YouTube URL
  final String? youtubeUrl;

  const NFTMetadata({
    required this.name,
    required this.description,
    required this.image,
    required this.attributes,
    required this.properties,
    this.externalUrl,
    this.animationUrl,
    this.backgroundColor,
    this.youtubeUrl,
  });

  /// Create NFTMetadata from JSON
  factory NFTMetadata.fromJson(Map<String, dynamic> json) =>
      _$NFTMetadataFromJson(json);

  /// Convert NFTMetadata to JSON
  Map<String, dynamic> toJson() => _$NFTMetadataToJson(this);

  /// Create a copy with updated fields
  NFTMetadata copyWith({
    String? name,
    String? description,
    String? image,
    Map<String, dynamic>? attributes,
    Map<String, dynamic>? properties,
    String? externalUrl,
    String? animationUrl,
    String? backgroundColor,
    String? youtubeUrl,
  }) {
    return NFTMetadata(
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      attributes: attributes ?? this.attributes,
      properties: properties ?? this.properties,
      externalUrl: externalUrl ?? this.externalUrl,
      animationUrl: animationUrl ?? this.animationUrl,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      youtubeUrl: youtubeUrl ?? this.youtubeUrl,
    );
  }

  /// Get attribute value
  dynamic getAttribute(String key) => attributes[key];

  /// Set attribute value
  NFTMetadata setAttribute(String key, dynamic value) {
    final newAttributes = Map<String, dynamic>.from(attributes);
    newAttributes[key] = value;
    return copyWith(attributes: newAttributes);
  }

  /// Remove attribute
  NFTMetadata removeAttribute(String key) {
    final newAttributes = Map<String, dynamic>.from(attributes);
    newAttributes.remove(key);
    return copyWith(attributes: newAttributes);
  }

  /// Get property value
  dynamic getProperty(String key) => properties[key];

  /// Set property value
  NFTMetadata setProperty(String key, dynamic value) {
    final newProperties = Map<String, dynamic>.from(properties);
    newProperties[key] = value;
    return copyWith(properties: newProperties);
  }

  /// Remove property
  NFTMetadata removeProperty(String key) {
    final newProperties = Map<String, dynamic>.from(properties);
    newProperties.remove(key);
    return copyWith(properties: newProperties);
  }

  /// Check if metadata is valid
  bool get isValid {
    return name.isNotEmpty && description.isNotEmpty && image.isNotEmpty;
  }

  /// Get formatted attributes for display
  Map<String, String> get formattedAttributes {
    final formatted = <String, String>{};
    for (final entry in attributes.entries) {
      formatted[entry.key] = entry.value.toString();
    }
    return formatted;
  }

  /// Get rarity from attributes
  String? get rarity {
    return attributes['Rarity']?.toString() ??
        attributes['rarity']?.toString() ??
        properties['rarity']?.toString();
  }

  /// Get collection from attributes
  String? get collection {
    return attributes['Collection']?.toString() ??
        attributes['collection']?.toString() ??
        properties['collection']?.toString();
  }

  @override
  List<Object?> get props => [
    name,
    description,
    image,
    attributes,
    properties,
    externalUrl,
    animationUrl,
    backgroundColor,
    youtubeUrl,
  ];
}

