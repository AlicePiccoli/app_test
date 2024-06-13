import 'package:flutter/material.dart';

class CardPage extends StatefulWidget {
  const CardPage({super.key});

  static String id = 'card_page';

  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    var post = arguments['post'];
    var user = arguments['user'];
    var timeAgo = arguments['timeAgo'];

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Image.network(
            post['image_url'],
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height,
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
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
            body: Padding(
              padding: EdgeInsets.only(left: 30.0, bottom: 50.0),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        user['picture'],
                      ),
                    ),
                    SizedBox(width: 10),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(user['first name'],
                                style: TextStyle(color: Colors.white)),
                            SizedBox(width: 10),
                            Text(timeAgo,
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                        Text(post['description'],
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
