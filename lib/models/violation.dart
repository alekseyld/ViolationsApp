import 'package:equatable/equatable.dart';
import 'package:photocontrolapp/utils/uuid.dart';

import 'models.dart';

class Violation extends Equatable {
  final String id;
  final String title;
  final String description;
  final List<String> images;
  final bool isComplete;
  final bool isDelete;
  final List<Comment> comments;

  Violation(
      {String id,
      this.title,
      this.description,
      this.images,
      this.isComplete,
      this.isDelete,
      this.comments})
      : this.id = id?.isEmpty == false ? id : Uuid().generateV4();

  @override
  List<Object> get props => [];

  @override
  String toString() {
    return "Violation(title: $title, images=${images.length}, isComplete=$isComplete, isDelete=$isDelete, comments=$comments})";
  }

  Violation.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        description = json['description'],
        images = (json["images"] as List).map((e) => e.toString()).toList(),
        isComplete = json['isComplete'],
        isDelete = json['isDelete'],
        comments = List<Comment>.from((json['comments'] as Iterable)
                .map((model) => Comment.fromJson(model)));

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'images': images,
        'isComplete': isComplete,
        'isDelete': isDelete,
        'comments': comments,
      };
}
