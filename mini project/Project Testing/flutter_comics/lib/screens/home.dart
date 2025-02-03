import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_comics/screens/detail_comic.dart';
import 'package:flutter_comics/screens/search.dart';

import '../main.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const Beranda());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final CollectionReference _comics =
      FirebaseFirestore.instance.collection('comics');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.teal,
        appBar: AppBar(
          backgroundColor: Colors.teal[600],
          title: const Text('Comic App'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Search()),
                  );
                },
                icon: const Icon(Icons.search)),
            const Padding(padding: EdgeInsets.only(right: 20))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: StreamBuilder(
            stream: _comics.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (streamSnapshot.hasData) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CarouselSlider.builder(
                      itemCount: streamSnapshot.data!.docs.length,
                      options: CarouselOptions(
                          autoPlay: true,
                          enlargeCenterPage: true,
                          viewportFraction: 1,
                          initialPage: 0,
                          height: 230),
                      itemBuilder:
                          (BuildContext context, int index, int realindex) {
                        final DocumentSnapshot documentSnapshot =
                            streamSnapshot.data!.docs[index];
                        return Column(children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Stack(
                                children: [
                                  Image.network(
                                    documentSnapshot["images"],
                                    height: 200,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ],
                              )),
                        ]);
                      },
                    ),
                    Expanded(
                      child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                  mainAxisExtent: 255,
                                  maxCrossAxisExtent: 150,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12),
                          scrollDirection: Axis.vertical,
                          itemCount: streamSnapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final DocumentSnapshot documentSnapshot =
                                streamSnapshot.data!.docs[index];

                            return Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.teal[100]),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10.0),
                                      topRight: Radius.circular(10.0),
                                    ),
                                    child: Image.network(
                                      documentSnapshot["images"],
                                      height: 170,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ListTile(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Detail(
                                                            documentSnapshot[
                                                                "images"],
                                                            documentSnapshot[
                                                                "Name"],
                                                            documentSnapshot[
                                                                "Category"],
                                                            documentSnapshot[
                                                                "Description"],
                                                            documentSnapshot[
                                                                    'links']
                                                                [index])));
                                          },
                                          title: Text(
                                            documentSnapshot["Name"],
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .merge(const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w800)),
                                          ),
                                          contentPadding: const EdgeInsets.only(
                                              top: 0, left: 5, bottom: 10),
                                          subtitle: Text(
                                            documentSnapshot["Category"],
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall!
                                                .merge(const TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Color.fromARGB(
                                                        255, 129, 127, 127))),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          }),
                    )
                  ],
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ));
  }
}
