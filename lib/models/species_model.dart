// Treffle Model

class SpeciesModel {
  final int id;
  final String? commonName;
  final String scientificName;
  final String? family;
  final String? genus;
  final int year;
  final String? bibliography;
  final String? imgUrl;

  SpeciesModel({
    required this.id,
    this.commonName,
    required this.scientificName,
    this.family,
    this.genus,
    required this.year,
    this.bibliography,
    this.imgUrl,
  });

  factory SpeciesModel.fromJson(Map<String, dynamic> json) {
    return SpeciesModel(
      id: json['id'] as int,
      commonName: json['common_name'] as String?,
      scientificName: json['scientific_name'] as String,
      family:
          json['family_common_name'] as String? ?? json['family'] as String?,
      genus: json['genus'] as String?,
      year: json['year'] as int,
      bibliography: json['bibliography'] as String?,
      imgUrl: json['image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'common_name': commonName,
      'scientific_name': scientificName,
      'family': family,
      'genus': genus,
      'year': year,
      'bibliography': bibliography,
      'img_url': imgUrl,
    };
  }
}
