import 'package:flutter_comics/models/detail_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ComicSelected = StateProvider((ref) => Comic(
    Category: 'Category',
    Name: 'Name',
    images: 'images',
    Description: 'Description',
    links: 'links'));
