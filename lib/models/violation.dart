import 'package:equatable/equatable.dart';
import 'package:photocontrolapp/utils/uuid.dart';

class Violation extends Equatable {
  final String id;
  final String title;
  final String description;
  final List<String> images;

  Violation({String id, String title, String description, List<String> images})
      : this.id = id?.isEmpty == false ? id : Uuid().generateV4(),
        this.title = title,
        this.description = description,
        this.images = images;

  @override
  List<Object> get props => [];

  @override
  String toString() {
    return "Violation(title: $title, images=${images.length})";
  }

  Violation.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        description = json['description'],
        images = (json["images"] as List).map((e) => e.toString()).toList();

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'title': title,
        'description': description,
        'images': images,
      };

}
