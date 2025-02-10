import 'dart:convert';

import 'package:doctor_on_duty/chapters/chapter.dart';
import 'package:manager/collection.dart';

class Topic extends Model {
  String name = '';
  String definition = '';
  String description = '';
  String epidemiology = '';
  String _chapter = '{}';
  Chapter get chapter {
    try {
      return Chapter.fromJson(jsonDecode(_chapter));
    } catch (e) {
      return Chapter()..id = "TROUBLES_AHEAD";
    }
  }

  set chapter(Chapter value) {
    _chapter = jsonEncode(value.toJson());
  }

  DateTime createdAt = DateTime.now();
  Topic();
  Topic.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    name = json['name'] ?? '';
    definition = json['definition'] ?? '';
    description = json['description'] ?? '';
    epidemiology = json['epidemiology'] ?? '';
    _chapter = json['_chapter'] ?? '{}';
    createdAt = DateTime.fromMicrosecondsSinceEpoch(
      json['createdAt'] ?? 0,
    ).toLocal();
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'definition': definition,
      'description': description,
      'epidemiology': epidemiology,
      '_chapter': _chapter,
      'createdAt': createdAt.toUtc().microsecond,
    };
  }
}
