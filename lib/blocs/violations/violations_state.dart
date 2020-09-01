import 'package:equatable/equatable.dart';
import 'package:photocontrolapp/blocs/blocs.dart';
import 'package:photocontrolapp/models/models.dart';

abstract class ViolationsState extends Equatable {
  const ViolationsState();

  @override
  List<Object> get props => [];
}

class ViolationsLoadInProgress extends ViolationsState {}

class ViolationsLoadSuccess extends ViolationsState {
  final List<Violation> violations;
  final ViolationType type;

  const ViolationsLoadSuccess(this.type, [this.violations = const []]);

  @override
  List<Object> get props => [violations];

  @override
  String toString() => 'ViolationsLoadSuccess { violations: $violations }';
}

class ViolationsLoadFailure extends ViolationsState {}