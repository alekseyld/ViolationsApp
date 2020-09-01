import 'package:equatable/equatable.dart';
import 'package:photocontrolapp/models/models.dart';

enum ViolationType {
  OPEN, COMPLETE, DELETED
}

abstract class ViolationsEvent extends Equatable {
  const ViolationsEvent();

  @override
  List<Object> get props => [];
}

class ViolationsLoaded extends ViolationsEvent {
  final ViolationType type;

  const ViolationsLoaded(this.type);

  @override
  List<Object> get props => [type];

  @override
  String toString() => 'ViolationsLoaded { type: $type }';
}

class ViolationAdded extends ViolationsEvent {
  final Violation violation;

  const ViolationAdded(this.violation);

  @override
  List<Object> get props => [violation];

  @override
  String toString() => 'ViolationAdded { violation: $violation }';
}

class ViolationUpdated extends ViolationsEvent {
  final Violation violation;

  const ViolationUpdated(this.violation);

  @override
  List<Object> get props => [violation];

  @override
  String toString() => 'ViolationUpdated { violation: $violation }';
}

class ViolationCompleted extends ViolationsEvent {
  final Violation violation;

  const ViolationCompleted(this.violation);

  @override
  List<Object> get props => [violation];

  @override
  String toString() => 'ViolationCompleted { violation: $violation }';
}

class ViolationDeleted extends ViolationsEvent {
  final Violation violation;

  const ViolationDeleted(this.violation);

  @override
  List<Object> get props => [violation];

  @override
  String toString() => 'ViolationDeleted { violation: $violation }';
}