import 'package:equatable/equatable.dart';
import 'package:photocontrolapp/utils/uuid.dart';

class Violation extends Equatable {
  final String id;
  final String title;
  final List<String> images;

  Violation({String id, String title, List<String> images})
      : this.id = id?.isEmpty == false ? id : Uuid().generateV4(),
        this.title = title,
        this.images = images;

  @override
  List<Object> get props => [];
}
