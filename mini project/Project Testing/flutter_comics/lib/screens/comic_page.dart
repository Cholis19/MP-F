// import 'package:carousel_slider/carousel_options.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter_comics/screens/detail_comic.dart';
// import 'package:url_launcher/url_launcher.dart';

// import '../main.dart';

// class Detail_comic extends StatefulWidget {
//   String Name;
//   String Category;
//   String images;
//   String Description;
//   String links;

//   Detail_comic(
//       this.images, this.Name, this.Category, this.Description, this.links,
//       {Key? key})
//       : super(key: key);

//   @override
//   State<Detail_comic> createState() =>
//       _Detail_comicState(images, Name, Category, Description, links);
// }

// class _Detail_comicState extends State<Detail_comic> {
//   launcUrl(String url) async {
//     // ignore: deprecated_member_use
//     launch(url);
//   }

//   String _Name;
//   String _Category;
//   String _images;
//   String _Description;
//   String _links;

//   bool _star = false;

//   _Detail_comicState(
//       this._images, this._Name, this._Category, this._Description, this._links);

//   final CollectionReference _comics =
//       FirebaseFirestore.instance.collection('comics');

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         home: Scaffold(
//             backgroundColor: Colors.teal[100],
//             extendBodyBehindAppBar: true,
//             appBar: AppBar(
//               centerTitle: true,
//               backgroundColor: Colors.transparent,
//               elevation: 0,
//               title: Text(widget.Name),
//             ),
//             body: Column(children: [
//               AspectRatio(
//                 aspectRatio: 1,
//                 child: Container(
//                   width: double.infinity,
//                   child: Image.network(
//                     _images,
//                     height: double.infinity,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               ListView(
//                 padding: const EdgeInsets.only(top: 0),
//                 scrollDirection: Axis.vertical,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(top: 0, left: 15, right: 15),
//                     child: Image.network(
//                       _links,
//                       height: double.infinity,
//                       width: double.infinity,
//                       fit: BoxFit.cover,
//                     ),
//                   )
//                 ],
//               )
//             ])));
//   }
// }
