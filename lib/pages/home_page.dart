import 'package:flutter/material.dart';
import 'package:phone/Model/Telephone.dart';
import 'package:phone/Services/TelephoneService.dart';
import 'package:phone/pages/addArticlePage.dart';
import 'package:phone/pages/detailTelephonePage.dart';
import 'package:phone/pages/loginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String baseUrl = 'http://172.20.10.2'; // Lien de base

  final TelephoneService _telephoneService = new TelephoneService();
  late Future<List<Telephone>> futureTelephones;
  late List<Telephone> _telephones;
  List<Widget> _actions = [];

  @override
  void initState() {
    super.initState();
    getActionsAppBar();
    futureTelephones = _telephoneService.getAllTelephones();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Téléphones en Vente'),
        actions: _actions,
      ),
      body: FutureBuilder<List<Telephone>>(
        future: futureTelephones,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur de chargement'));
          } else if (snapshot.hasData) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
                childAspectRatio: 0.7,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return _buildTelephoneCard(snapshot.data![index]);
              },
            );
          } else {
            return Center(child: Text('Aucun téléphone disponible'));
          }
        },
      ),
    );
  }

  // Construction de la carte pour chaque téléphone
  Widget _buildTelephoneCard(Telephone telephone) {
    return GestureDetector(
      onTap: () {
        // Rediriger vers la page de détail du téléphone en passant les données du téléphone
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailTelephonePage(telephone: telephone)),
        );
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: (telephone.imageRepository != null) ? Center(
                child: Image.network(
                  "$baseUrl/uploads/images/${telephone.imageRepository}/${telephone.imageFileName}",
                  fit: BoxFit.cover,
                ),
              ) : Center(child: Text("Aucune Image"),)
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    telephone.marque,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(telephone.modele),
                  Text(telephone.caracteristiques),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${telephone.prix} €',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Publié le ${telephone.datePublication.day}/${telephone.datePublication.month}/${telephone.datePublication.year}', // Utilisez les données réelles du téléphone
                    style: TextStyle(fontSize: 12.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Telephone>> getTelephones() async{
    try{
      var telephoneDatas = await _telephoneService.getAllTelephones();
      setState(() {
        _telephones = telephoneDatas;
      });
      return telephoneDatas;
    }catch(e){
      throw Exception(e);
    }
  }

  void getActionsAppBar() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Widget> actions = [];
    String? token = prefs.getString('token');

    if(token == null){
      actions.add(IconButton(onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
              return const LoginPage();
            }));
      }, icon: const Icon(Icons.login)));
    }else{
      actions.add(IconButton(onPressed: () {
        prefs.remove('token');
        setState(() {
          getActionsAppBar();
        });
      }, icon: const Icon(Icons.logout)));
      actions.add(IconButton(onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
              return const AddArticlePage();
            }));
      }, icon: const Icon(Icons.add)));

    }

    setState(() {
      _actions = actions;
    });
  }
}
