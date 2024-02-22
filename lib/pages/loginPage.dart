import 'package:flutter/material.dart';
import 'package:phone/Services/AuthService.dart';
import 'package:phone/pages/home_page.dart';
import 'package:phone/pages/loginPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';
  String _email = '' ;
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Connexion d'un utilisateur"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre adresse email';
                          }
                          return null;
                        },
                        onSaved: (newValue) => { _email = newValue! },
                      ),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Mot de passe',
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre mot de passe';
                          }
                          return null;
                        },
                        onSaved: (newValue) => { _password = newValue! },
                      ),
                      ElevatedButton(
                        onPressed: _login,
                        child: Text('Se connecter'),
                      ),
                      if (_errorMessage.isNotEmpty)
                        Text(
                          _errorMessage,
                          style: TextStyle(color: Colors.red),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      var authService = new AuthService();
      if(await authService.login(_email, _password)){
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (BuildContext builder) {
              return const HomePage();
            }), (route) => false);
      }else{

      }
    }
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue),
    ),
    initialRoute: '/login',
    routes: {
      '/login': (context) => LoginPage(),
      // Add more routes here if needed
    },
  ));
}
