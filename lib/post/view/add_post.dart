import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagrume/import.dart';
import 'dart:io';

import '../../components/widget/action_button.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  static String id = 'add_picture';

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final CollectionReference _postsRef =
      FirebaseFirestore.instance.collection('posts');
  final CollectionReference _usersRef =
      FirebaseFirestore.instance.collection('users');

  final String defaultUser = 'FMuyd7heDA6UtsZNT2WW';

  final _descriptionController = TextEditingController();
  String? imageUrl;
  final _auth = FirebaseAuth.instance;

  Future addPost(Timestamp date, String description, String imageUrl,
      DocumentReference user) async {
    await _postsRef.add({
      'date': Timestamp.now(),
      'description': description,
      'image_url': imageUrl,
      'user': user,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: GestureDetector(
            onTap: () async {
              ImagePicker imagePicker = ImagePicker();
              XFile? file =
                  await imagePicker.pickImage(source: ImageSource.gallery);
              print('${file?.path}');

              if (file == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Veuillez mettre une photo"),
                  ),
                );
                return;
              }

              String uniqueFileName =
                  DateTime.now().millisecondsSinceEpoch.toString();

              Reference referenceRoot = FirebaseStorage.instance.ref();
              Reference referenceDirImages = referenceRoot.child('images');

              Reference referenceImageToUpload =
                  referenceDirImages.child(uniqueFileName);

              try {
                await referenceImageToUpload.putFile(File(file!.path));
                imageUrl = await referenceImageToUpload.getDownloadURL();

                print(imageUrl);
                setState(() {});
              } catch (error) {
                print("Error while uploading $error");
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Column(
                children: [
                  Align(
                    alignment: AlignmentDirectional.topStart,
                    child: Text(
                      'Choisis une image',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      height: 300,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: kLightGreyBG,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: imageUrl == null
                          ? const Icon(
                              Icons.cloud_download,
                              color: Colors.grey,
                              size: 35,
                            )
                          : Image.network(
                              imageUrl!,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: AlignmentDirectional.topStart,
                    child: Text(
                      'Ajoutez une description',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: DescriptionField(
                      hintText: 'Décrivez votre post...',
                      controller: _descriptionController,
                      obscureText: false,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ActionButton(
                    onTap: () {
                      if (imageUrl == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Veuillez mettre une photo"),
                          ),
                        );
                        return;
                      } else {
                        final User? user = _auth.currentUser;
                        if (user != null) {
                          DocumentReference userRef =
                              _usersRef.doc(defaultUser);
                          addPost(
                            Timestamp.now(),
                            _descriptionController.text.trim(),
                            imageUrl!,
                            userRef,
                          );

                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                                title: Text(
                                  "Succès",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                content: Text(
                                  "Post ajouté avec succès",
                                  style: TextStyle(color: Colors.black),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text("OK",
                                        style: TextStyle(color: Colors.blue)),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }
                    },
                    text: 'Publier',
                  ),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
