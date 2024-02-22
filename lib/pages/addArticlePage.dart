import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddArticlePage extends StatelessWidget {
  const AddArticlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    String currentDate = DateTime.now().toString();

    TextEditingController marqueController = TextEditingController();
    TextEditingController modeleController = TextEditingController();
    TextEditingController caracteristiquesController = TextEditingController();
    TextEditingController prixController = TextEditingController();

    String baseUrl = 'http://172.20.10.2';

    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un Article'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Marque',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Entrez la marque',
              ),
              controller: marqueController,
            ),
            SizedBox(height: 16.0),
            Text(
              'Modèle',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Entrez le modèle',
              ),
              controller: modeleController,
            ),
            SizedBox(height: 16.0),
            Text(
              'Caractéristiques',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Entrez les caractéristiques',
              ),
              controller: caracteristiquesController,
            ),
            SizedBox(height: 16.0),
            Text(
              'Prix',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Entrez le prix',
              ),
              controller: prixController,
            ),
            SizedBox(height: 16.0),
            Container(
              height: 0,
              width: 0,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Entrez la date de publication',
                ),
                controller: TextEditingController(text: currentDate),
                readOnly: true,
                enabled: false,
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                // Récupérer les données saisies
                String marque = marqueController.text;
                String modele = modeleController.text;
                String caracteristiques = caracteristiquesController.text;
                double prix = double.parse(prixController.text);
                int quantite = 0; // Remplacez par la quantité réelle
                int idVendeur = 0; // Remplacez par l'ID du vendeur réel

                // Créer l'objet JSON à envoyer
                Map<String, dynamic> data = {
                  'Marque': marque,
                  'Modele': modele,
                  'Caracteristiques': caracteristiques,
                  'Prix': prix,
                  'Quantite': quantite,
                  'ID_Vendeur': idVendeur,
                  // Vous pouvez laisser la date de publication être gérée par le serveur
                };

                // Envoyer les données à votre service
                try {
                  final response = await http.post(
                    Uri.parse('$baseUrl/add'), // Remplacez baseUrl par votre URL de service
                    headers: <String, String>{
                      'Content-Type': 'application/json',
                    },
                    body: jsonEncode(data),
                  );

                  if (response.statusCode == 200) {
                    // Succès : Affichez un message ou effectuez une action supplémentaire si nécessaire
                    print('Article ajouté avec succès !');
                  } else {
                    // Erreur : Affichez un message d'erreur ou gérez l'erreur de manière appropriée
                    print('Erreur lors de l\'ajout de l\'article : ${response.statusCode}');
                  }
                } catch (e) {
                  // Gérer l'exception si la requête échoue
                  print('Erreur lors de la connexion au serveur : $e');
                }
              },
              child: Text('Ajouter l\'article'),
            ),
          ],
        ),
      ),
    );
  }
}
