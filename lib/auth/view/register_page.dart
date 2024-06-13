import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagrume/import.dart';
import '../../components/widget/action_button.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class RegisterPage extends StatefulWidget {
  final VoidCallback? onTap;

  const RegisterPage({super.key, this.onTap});

  static String id = 'login';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _firstNameController = TextEditingController();
  bool _showPassword = false;

  CollectionReference _reference =
      FirebaseFirestore.instance.collection('images');

  String? imageUrl;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _firstNameController.dispose();
    super.dispose();
  }

  Future signUp() async {
    print(imageUrl);

    if (passwordConfirmed()) {
      // Create user
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // add user details
      addUserDetails(
        _firstNameController.text.trim(),
        _nameController.text.trim(),
        _emailController.text.trim(),
        imageUrl!,
      );
    }
  }

  Future addUserDetails(
      String firstName, String name, String email, String picture) async {
    await FirebaseFirestore.instance.collection('users').add({
      'first name': firstName,
      'name': name,
      'email': email,
      'picture': picture,
    });
  }

  bool passwordConfirmed() {
    if (_passwordController.text.trim() ==
        _confirmPasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.only(right: 25.0, left: 25, bottom: 0, top: 0),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(
                    top: 30.0,
                    right: 10,
                    left: 10,
                  ),
                  child: Text(
                    textAlign: TextAlign.center,
                    'Créez un compte.',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nom',
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
                  hintText: 'Ex. Doe',
                  controller: _nameController,
                  obscureText: false,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Prénom',
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
                  hintText: 'Ex. John',
                  controller: _firstNameController,
                  obscureText: false,
                ),
                const SizedBox(
                  height: 20,
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
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Confirmer le mot de passe',
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
                  hintText: 'Confirmer le mot de passe',
                  controller: _confirmPasswordController,
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
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Photo de profil',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () async {
                    ImagePicker imagePicker = ImagePicker();
                    XFile? file = await imagePicker.pickImage(
                        source: ImageSource.gallery);
                    print('${file?.path}');

                    if (file == null) return;

                    String uniqueFileName =
                        DateTime.now().millisecondsSinceEpoch.toString();

                    Reference referenceRoot = FirebaseStorage.instance.ref();
                    Reference referenceDirImages =
                        referenceRoot.child('images');

                    Reference referenceImageToUpload =
                        referenceDirImages.child(uniqueFileName);

                    try {
                      await referenceImageToUpload.putFile(File(file!.path));
                      imageUrl = await referenceImageToUpload.getDownloadURL();

                      print(imageUrl);
                    } catch (error) {
                      print("Error while uploading $error");
                    }
                  },
                  child: Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: kLightGreyBG,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: imageUrl == null
                        ? const Icon(
                            Icons.cloud_download,
                            color: Colors.grey,
                            size: 35,
                          )
                        : Image.network(
                            imageUrl!,
                            fit: BoxFit.contain,
                          ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                ActionButton(
                  onTap: () {
                    signUp();
                  },
                  text: "S'inscrire",
                ),
                const SizedBox(
                  height: 30,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Vous avez déjà un compte ?'),
                    const SizedBox(
                      height: 5,
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Connectez-vous',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                            fontSize: 15),
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
