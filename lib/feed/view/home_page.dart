import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:instagrume/import.dart';
import 'package:timeago/timeago.dart' as timeago;

class HomePage extends StatefulWidget {
  HomePage({super.key});

  static String id = 'home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> _getUserData(DocumentReference userRef) async {
    DocumentSnapshot userDoc = await userRef.get();
    return userDoc.data() as Map<String, dynamic>;
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        surfaceTintColor: Colors.white,
        height: 60,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.home,
              size: 30,
              color: Colors.black,
            ),
            IconButton(
              color: Colors.grey,
              onPressed: () {
                Navigator.pushNamed(context, AddPost.id);
              },
              icon: Icon(
                Icons.add,
                size: 30,
                color: Colors.grey,
              ),
            ),
            IconButton(
              onPressed: signOut,
              icon: Icon(
                Icons.logout,
                size: 25,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          scrolledUnderElevation: 0.0,
          elevation: 0,
          // backgroundColor: Colors.blueGrey,
          leadingWidth: 0,
          centerTitle: false,
          title: Padding(
            padding: EdgeInsets.only(left: 20.0, top: 20, bottom: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Bonjour",
                  style: TextStyle(color: Colors.grey, fontSize: 16.0),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Fil d'actualités",
                  style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            const Padding(
              padding: EdgeInsets.only(right: 30.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://firebasestorage.googleapis.com/v0/b/instagrume-ad695.appspot.com/o/images%2F1718269518502?alt=media&token=8fbb8d8d-3a57-4574-a8fe-71455e684ab0"),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 35, left: 35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(
                  thickness: 1,
                  color: CupertinoColors.systemGrey4,
                ),
                Text(
                  'Récents',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: StreamBuilder(
              stream: _firestore
                  .collection('posts')
                  .orderBy('date', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData) {
                  return Center(child: Text('No posts available'));
                }

                final posts = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    var post = posts[index];

                    print(post['image_url']);
                    print(post['user']);

                    return FutureBuilder<Widget>(
                        future: _buildPostCard(post),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }

                          if (snapshot.hasError) {
                            return Text('Error loading post');
                          }

                          return Column(
                            children: [
                              snapshot.data!,
                              SizedBox(
                                  height:
                                      10), // Ajoute un espace entre les cartes
                            ],
                          );
                        });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<Widget> _buildPostCard(DocumentSnapshot post) async {
    var userRef = post['user'] as DocumentReference;
    var userData = await _getUserData(userRef);
    var timestamp = post['date'] as Timestamp;
    var date = timestamp.toDate();
    var timeAgo = timeago.format(date);

    return GestureDetector(
      onTap: () {
        print('tapped');
        Navigator.pushNamed(context, CardPage.id,
            arguments: {"post": post, "user": userData, "timeAgo": timeAgo});
      },
      child: Card(
        color: Colors.transparent,
        elevation: null,
        shadowColor: Colors.transparent,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
        margin: const EdgeInsets.all(0),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Image.network(
              post['image_url'],
              fit: BoxFit.cover,
              height: 400,
              width: MediaQuery.of(context).size.width,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(userData['picture']),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            userData['first name'],
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            '- $timeAgo',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      Text(
                        post['description'],
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
