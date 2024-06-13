import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagrume/import.dart';

import '../../components/widget/action_button.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback? onTap;

  const LoginPage({super.key, this.onTap});

  static String id = 'login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _emailResetController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword = false;

  @override
  void dispose() {
    _emailResetController.dispose();
    super.dispose();
  }

  void passwordReset() async {
    try {
      print('await');
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailResetController.text.trim());
      // TODO modal confirm

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            title: Text(
              "Demande envoyée",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            content: Text(
              "Vous allez recevoir un mail de réinitialisation",
              style: TextStyle(color: Colors.black),
            ),
            actions: <Widget>[
              TextButton(
                child: Text("OK", style: TextStyle(color: Colors.blue)),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message.toString()),
        ),
      );
    }
  }

  void signIn() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(
              color: kGreen,
            ),
          );
        });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("User non trouvé"),
          ),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Mot de passe incorrect"),
          ),
        );
      } else {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Veuillez vérifier vos identifiants"),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    top: 20.0,
                    right: 10,
                    left: 10,
                  ),
                  child: Text(
                    textAlign: TextAlign.center,
                    'Connectez-vous ou créez un compte.',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Adresse email',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                LoginField(
                  hintText: 'john.doe@gmail.com',
                  controller: _emailController,
                  obscureText: false,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mot de passe',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                LoginField(
                  hintText: 'Mot de passe',
                  controller: _passwordController,
                  obscureText: !_showPassword,
                  suffixIcon: IconButton(
                    color: Colors.grey,
                    icon: Icon(
                      _showPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Mot de passe oublié ?',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      // style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      onTap: () {
                        showModalBottomSheet<void>(
                          isScrollControlled: true,
                          backgroundColor: Colors.white,
                          context: context,
                          builder: (BuildContext context) {
                            return Padding(
                              padding: MediaQuery.of(context).viewInsets,
                              child: SizedBox(
                                height: 430,
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(15.0),
                                    child: Column(
                                      // mainAxisAlignment: MainAxisAlignment.center,
                                      // mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        const Text(
                                          'Réinitialiser mot de passe',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 17),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const Text(
                                          textAlign: TextAlign.center,
                                          "Entrez l’adresse email associée à votre compte. Nous vous enverrons un email de réinitialisation sur celle-ci.",
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 40,
                                        ),
                                        const Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Adresse email',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15),
                                              textAlign: TextAlign.left,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        LoginField(
                                          hintText: 'john.doe@gmail.com',
                                          controller: _emailResetController,
                                          obscureText: false,
                                        ),
                                        const SizedBox(
                                          height: 40,
                                        ),
                                        ActionButton(
                                          onTap: passwordReset,
                                          text: 'Réinitialiser',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: const Text(
                        'Réinitialiser',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                ActionButton(
                  onTap: () {
                    signIn();
                  },
                  text: 'Connexion',
                ),
                const SizedBox(
                  height: 30,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 120, right: 120),
                  child: Divider(
                    height: 1,
                    color: kLightGreyBG,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Créer un compte',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                            fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
