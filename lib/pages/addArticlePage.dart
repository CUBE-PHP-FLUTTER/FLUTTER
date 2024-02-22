import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart';

class AddArticlePage extends StatefulWidget {
  const AddArticlePage({Key? key}) : super(key: key);

  @override
  _AddArticlePageState createState() => _AddArticlePageState();
}

class _AddArticlePageState extends State<AddArticlePage> {
  String currentDateTime = DateTime.now().toString();
  LocationData? _currentLocation;
  TextEditingController marqueController = TextEditingController();
  TextEditingController modeleController = TextEditingController();
  TextEditingController caracteristiquesController = TextEditingController();
  TextEditingController prixController = TextEditingController();
  TextEditingController quantiteController = TextEditingController(text: '1');
  TextEditingController idVendeurController = TextEditingController(text: '0');
  TextEditingController statutController = TextEditingController(text: 'Disponible');

  String baseUrl = 'http://172.20.10.2';

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    Location location = Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    setState(() {
      _currentLocation = _locationData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un Article'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Marque',
              ),
              controller: marqueController,
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Modèle',
              ),
              controller: modeleController,
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Caractéristiques',
              ),
              controller: caracteristiquesController,
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Prix',
              ),
              controller: prixController,
              keyboardType: TextInputType.number,
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Quantité',
              ),
              controller: quantiteController,
              keyboardType: TextInputType.number,
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'ID Vendeur',
              ),
              controller: idVendeurController,
              keyboardType: TextInputType.number,
              enabled: false,
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Latitude',
              ),
              controller: TextEditingController(text: _currentLocation?.latitude.toString()),
              keyboardType: TextInputType.number,
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Longitude',
              ),
              controller: TextEditingController(text: _currentLocation?.longitude.toString()),
              keyboardType: TextInputType.number,
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Statut',
              ),
              controller: statutController,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                // Récupérer les données saisies
                String marque = marqueController.text;
                String modele = modeleController.text;
                String caracteristiques = caracteristiquesController.text;
                double prix = double.tryParse(prixController.text) ?? 0.0;
                int quantite = int.tryParse(quantiteController.text) ?? 1;
                int idVendeur = 0;
                String statut = statutController.text;

                // Créer l'objet JSON à envoyer
                Map<String, dynamic> data = {
                  'Marque': marque,
                  'Modele': modele,
                  'Caracteristiques': caracteristiques,
                  'Prix': prix,
                  'Quantite': quantite,
                  'ID_Vendeur': idVendeur,
                  'DatePublication': currentDateTime,
                  'Latitude': _currentLocation?.latitude,
                  'Longitude': _currentLocation?.longitude,
                  'Statut': statut,
                };

                try {
                  final SharedPreferences prefs = await SharedPreferences.getInstance();
                  final String? token = prefs.getString('token');

                  if (token != null) {
                    final response = await http.post(
                      Uri.parse('$baseUrl/ApiTelephone/add'),
                      headers: <String, String>{
                        'Content-Type': 'application/json',
                        'Authorization': 'Bearer $token',
                      },
                      body: jsonEncode(data),
                    );

                    if (response.statusCode == 200) {
                      print('Article ajouté avec succès !');
                    } else {
                      print('Erreur lors de l\'ajout de l\'article : ${response.statusCode}');
                    }
                  } else {
                    print('Erreur : Aucun token trouvé dans SharedPreferences');
                  }
                } catch (e) {
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
