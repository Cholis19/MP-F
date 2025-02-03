import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_comics/screens/detail_comic.dart';

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
    );
  }
}

class Search extends StatefulWidget {
  const Search({
    super.key,
  });

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController editingController = TextEditingController();
  final CollectionReference _comics =
      FirebaseFirestore.instance.collection('comics');

  List searchResult = [];

  void seacrhFromFirebase(String query) async {
    final result = await FirebaseFirestore.instance
        .collection('comics')
        .where(
          'Name',
          isEqualTo: query,
        )
        .get();

    setState(() {
      searchResult = result.docs.map((e) => e.data()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        backgroundColor: Colors.teal[600],
        title: const Text('Search Comic'),
      ),
      body: Container(
          child: Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: editingController,
            decoration: const InputDecoration(
                filled: true, //<-- SEE HERE
                fillColor: Colors.white,
                hintText: "Search Comic Name",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                )),
            onChanged: (query) {
              seacrhFromFirebase(query);
            },
          ),
        ),
        Expanded(
            child: Padding(
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
                            itemBuilder: (BuildContext context, int index,
                                int realIndex) {
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
                            }),
                        Expanded(
                          child: ListView.builder(
                              itemCount: streamSnapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                final DocumentSnapshot documentSnapshot =
                                    streamSnapshot.data!.docs[index];
                                return ListTile(
                                  focusColor: Colors.white,
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Detail(
                                                  documentSnapshot["images"],
                                                  documentSnapshot["Name"],
                                                  documentSnapshot["Category"],
                                                  documentSnapshot[
                                                      "Description"],
                                                  documentSnapshot["links"]
                                                      [index],
                                                )));
                                  },
                                  title: Text(
                                    documentSnapshot["Name"],
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  subtitle: Text(
                                    documentSnapshot["Category"],
                                    style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 208, 208, 208)),
                                  ),
                                  leading: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    child: Image.network(
                                      documentSnapshot["images"],
                                      height: double.infinity,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              }),
                        )
                      ]);
                }
                // Expanded(
                //   child: ListView.builder(
                //       itemCount: searchResult.length,
                //       itemBuilder: (context, index) {
                //         // final DocumentSnapshot documentSnapshot =
                //         //     streamSnapshot.data!.docs[index];
                //         return ListTile(
                //           focusColor: Colors.white,
                //           onTap: () {
                //             Navigator.push(
                //                 context,
                //                 MaterialPageRoute(
                //                     builder: (context) => Detail(
                //                           documentSnapshot["images"],
                //                           documentSnapshot["Name"],
                //                           documentSnapshot["Category"],
                //                           documentSnapshot["Description"],
                //                           documentSnapshot["links"][index],
                //                         )));
                //           },
                //           title: Text(
                //             searchResult[index]["Name"],
                //             style: const TextStyle(color: Colors.white),
                //           ),
                //           subtitle: Text(
                //             searchResult[index]["Name"],
                //             style: const TextStyle(
                //                 color: Color.fromARGB(255, 208, 208, 208)),
                //           ),
                //           leading: ClipRRect(
                //             borderRadius:
                //                 const BorderRadius.all(Radius.circular(10)),
                //             child: Image.network(
                //               searchResult[index]["images"],
                //               height: double.infinity,
                //               width: 100,
                //               fit: BoxFit.cover,
                //             ),
                //           ),
                //         );
                //       }),
                // );

                return const Center(
                  child: CircularProgressIndicator(),
                );
              }),
        ))
      ])),
    );
  }
}
