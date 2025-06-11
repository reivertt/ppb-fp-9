// Treffle Model

class SpeciesModel {
  final int id;
  final String? commonName;
  final String scientificName;
  final String? familyCommonName;
  final int year;
  final String? observations;
  final String? imgUrl;

  SpeciesModel({
    required this.id,
    this.commonName,
    required this.scientificName,
    this.familyCommonName,
    required this.year,
    this.observations,
    this.imgUrl
  });

  factory SpeciesModel.fromJson(Map<String, dynamic> json) {
    return SpeciesModel(
      id: json['id'] as int,
      commonName: json['common_name'] as String?,
      scientificName: json['scientific_name'] as String,
      familyCommonName: json['family_common_name'] as String?,
      year: json['year'] as int,
      observations: json['observations'] as String?,
      imgUrl: json['image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'common_name': commonName,
      'scientific_name': scientificName,
      'family_common_name': familyCommonName,
      'year': year,
      'observations': observations,
      'img_url': imgUrl,
    };
  }

}

