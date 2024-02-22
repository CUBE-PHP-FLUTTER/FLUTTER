import 'package:flutter/foundation.dart';

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
}
