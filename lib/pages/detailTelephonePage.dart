import 'package:flutter/material.dart';
import 'package:phone/Model/Telephone.dart';

class DetailTelephonePage extends StatelessWidget {
  final Telephone telephone;
  final String baseUrl = 'http://172.20.10.2'; // Lien de base

  DetailTelephonePage({required this.telephone});

  @override
  Widget build(BuildContext context) {
    String? latitude = telephone.latitude;
    String? longitude = telephone.longitude;

    double? latitudeDouble = double.tryParse(latitude ?? '');
    double? longitudeDouble = double.tryParse(longitude ?? '');

    return Scaffold(
      appBar: AppBar(
        title: Text('Détails du Téléphone'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Marque: ${telephone.marque}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Modèle: ${telephone.modele}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Caractéristiques: ${telephone.caracteristiques}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Prix: ${telephone.prix} €',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Quantité: ${telephone.quantite}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Date de Publication: ${telephone.datePublication.day}/${telephone.datePublication.month}/${telephone.datePublication.year}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Statut: ${telephone.statut}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            // Afficher l'image du téléphone
            Container(
              height: 200, // Hauteur souhaitée
              width: double.infinity,
              child: telephone.imageFileName != null && telephone.imageRepository != null
                  ? Image.network(
                '$baseUrl/uploads/images/${telephone.imageRepository}/${telephone.imageFileName}',
                fit: BoxFit.fitHeight,
              )
                  : null, // Retourne null si aucune image n'est détectée
            ),
          ],
        ),
      ),
    );
  }
}
