class Telephone {
  final int? id;
  final String marque;
  final String modele;
  final String caracteristiques;
  final double prix;
  final int quantite;
  final int idVendeur;
  final DateTime datePublication;
  final String statut;
  final String? imageFileName;
  final String? imageRepository;
  final String? longitude;
  final String? latitude;

  Telephone({
    this.id,
    required this.marque,
    required this.modele,
    required this.caracteristiques,
    required this.prix,
    required this.quantite,
    required this.idVendeur,
    required this.datePublication,
    required this.statut,
    this.imageFileName,
    this.imageRepository,
    this.longitude,
    this.latitude,
  });

  factory Telephone.fromJson(Map<String, dynamic> json) {
    return Telephone(
      id: json['ID_Telephone'],
      marque: json['Marque'],
      modele: json['Modele'],
      caracteristiques: json['Caracteristiques'],
      prix: (json['Prix'] as num).toDouble(),
      quantite: json['Quantite'],
      idVendeur: json['ID_Vendeur'],
      datePublication: DateTime.parse(json['DatePublication']),
      statut: json['Statut'],
      imageFileName: json['ImageFileName'],
      imageRepository: json['ImageRepository'],
      longitude: json['Longitude'],
      latitude: json['Latitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID_Telephone': id,
      'Marque': marque,
      'Modele': modele,
      'Caracteristiques': caracteristiques,
      'Prix': prix,
      'Quantite': quantite,
      'ID_Vendeur': idVendeur,
      'DatePublication': datePublication.toIso8601String(),
      'Statut': statut,
      'ImageFileName': imageFileName,
      'ImageRepository': imageRepository,
      'Longitude': longitude,
      'Latitude': latitude,
    };
  }}
