import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_comics/screens/comic_page.dart';
import 'package:flutter_comics/screens/detail_comic.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';

class Detail extends StatefulWidget {
  String Name;
  String Category;
  String images;
  String Description;
  String links;

  Detail(this.images, this.Name, this.Category, this.Description, this.links,
      {Key? key})
      : super(key: key);

  @override
  State<Detail> createState() =>
      _DetailState(images, Name, Category, Description, links);
}

class _DetailState extends State<Detail> {
  launcUrl(String url) async {
    // ignore: deprecated_member_use
    launch(url);
  }

  String _Name;
  String _Category;
  String _images;
  String _Description;
  String _links;

  bool _star = false;

  _DetailState(
      this._images, this._Name, this._Category, this._Description, this._links);

  final CollectionReference _comics =
      FirebaseFirestore.instance.collection('comics');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.teal[100],
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(widget.Name),
          ),
          body: Column(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  width: double.infinity,
                  child: Image.network(
                    _images,
                    height: double.infinity,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              ListTile(
                trailing: IconButton(
                    onPressed: () {
                      setState(() {
                        _star = !_star;
                      });
                    },
                    icon: Icon(
                      Icons.star,
                      color: _star ? Colors.yellow : Colors.black,
                    )),
                title: Text(
                  'Name : ${_Name}',
                  style: Theme.of(context).textTheme.titleMedium!.merge(
                      const TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 20)),
                ),
                contentPadding: const EdgeInsets.only(
                    top: 0, left: 15, bottom: 10, right: 15),
                subtitle: Text(
                  'Category : ${_Category}',
                  style: Theme.of(context).textTheme.titleSmall!.merge(
                      const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 129, 127, 127))),
                ),
              ),
              Expanded(
                child: ListView(
                    padding: const EdgeInsets.only(top: 0),
                    scrollDirection: Axis.vertical,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 0, left: 15, right: 15),
                        child: Text(
                          'Description :\n${_Description}',
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Read Comics\n',
                        style: Theme.of(context).textTheme.titleMedium!.merge(
                            const TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 17)),
                      ),
                      CarouselSlider.builder(
                        itemCount: _links.length,
                        options: CarouselOptions(
                            autoPlay: false,
                            enlargeCenterPage: false,
                            // scrollDirection: Axis.vertical,
                            // viewportFraction: 1,
                            initialPage: 0,
                            height: 600),
                        itemBuilder:
                            (BuildContext context, int index, int realIndex) {
                          return Column(children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Stack(
                                  children: [
                                    Image.network(
                                      _links,
                                      height: 600,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ],
                                )),
                          ]);
                        },
                      ),
                    ]),
              ),
            ],
          ),
        ));
  }
}
