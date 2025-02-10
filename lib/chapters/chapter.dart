import 'dart:convert';

import 'package:manager/collection.dart';

class Chapter extends Model {
  String name = '';
  String description = '';
  String author = '';
  DateTime publicationDate = DateTime.now();
  int pageCount = 0;
  String? _topics;
  String? _keywords;
  List<String> get keywords {
    try {
      final s = jsonDecode(_keywords ?? '') as List;
      return s.cast<String>();
    } catch (e) {
      return [];
    }
  }

  set keywords(List<String> value) {
    _keywords = jsonEncode(value);
  }

  String getSummary() {
    return '$name by $author - $description';
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'author': author,
      'publicationDate': publicationDate.microsecondsSinceEpoch,
      'pageCount': pageCount,
      '_topics': _topics,
      '_keywords': _keywords,
    };
  }

  Chapter();
  Chapter.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    name = json['name'] ?? '';
    description = json['description'] ?? '';
    author = json['author'] ?? '';
    publicationDate = DateTime.fromMicrosecondsSinceEpoch(
      json['publicationDate'] ?? 0,
    );
    pageCount = json['pageCount'] ?? 0;
    _topics = json['_topics'];
    _keywords = json['_keywords'] ?? '';
  }
}
