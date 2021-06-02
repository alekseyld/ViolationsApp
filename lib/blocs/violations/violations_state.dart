import 'package:equatable/equatable.dart';
import 'package:photocontrolapp/blocs/blocs.dart';
import 'package:photocontrolapp/models/models.dart';

abstract class ViolationsState extends Equatable {
  const ViolationsState();

  @override
  List<Object> get props => [];

  ViolationType get type;
}

class ViolationsLoadInProgress extends ViolationsState {
  @override
  final ViolationType type;

  const ViolationsLoadInProgress(this.type);

  @override
  List<Object> get props => [type];
}

class ViolationsLoadSuccess extends ViolationsState {
  final List<Violation> violations;
  @override
  final ViolationType type;

  const ViolationsLoadSuccess(this.type, [this.violations = const []]);

  @override
  List<Object> get props => [violations];

  @override
  String toString() => 'ViolationsLoadSuccess { violations: $violations }';
}

class ViolationsLoadFailure extends ViolationsState {
  @override
  final ViolationType type;

  const ViolationsLoadFailure(this.type);

  @override
  List<Object> get props => [type];
}