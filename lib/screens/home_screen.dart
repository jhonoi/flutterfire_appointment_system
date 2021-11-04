import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:web_app_firebase/widgets/appbar.dart';
import 'package:web_app_firebase/widgets/hairstyle_tile.dart';
import 'package:web_app_firebase/widgets/max_container.dart';

class HomeScreen extends StatelessWidget {
  /// The future is part of the state of our widget. We should not call `initializeApp`
  /// directly inside [build].
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        backgroundColor: Color(0xFFF6F7F9),
        body: FutureBuilder(
          // Initialize FlutterFire:
          future: _initialization,
          builder: (context, snapshot) {
            // Otherwise, show something whilst waiting for initialization to complete
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                color: Colors.green,
              );
            }

            // Once complete, show your application
            if (snapshot.connectionState == ConnectionState.done) {
              return Content();
            }

            return Container(
              color: Colors.red,
            );
          },
        ),
        appBar: myAppBar(title: 'AA Hair Studisos', context: context),
      ),
    );
  }
}

class Content extends StatelessWidget {
  final CollectionReference products =
      FirebaseFirestore.instance.collection('products');

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        StreamBuilder(
          stream: products.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator.adaptive());
            }

            return MaxContainer(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                child: Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: 2 / 2.8,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                        ),
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          return HairStyleTile(
                            hairstyle:
                                snapshot.data.docs[index]['name'].length > 12
                                    ? snapshot.data.docs[index]['short_name']
                                    : snapshot.data.docs[index]['name'],
                            price: snapshot.data.docs[index]['price'],
                            imgUrl: snapshot.data.docs[index]['imgUrl'],
                            id: snapshot.data.docs[index].id,
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
        Container(
          color: Colors.blue,
        ),
        Container(
          color: Colors.red,
        ),
        Container(
          color: Colors.yellow,
        ),
        Container(
          color: Colors.green,
        ),
        Container(
          color: Colors.orange,
        ),
      ],
    );
  }
}
