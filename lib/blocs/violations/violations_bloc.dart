import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:photocontrolapp/models/models.dart';
import 'package:photocontrolapp/repositories/repositories.dart';

import './bloc.dart';

class ViolationsBloc extends Bloc<ViolationsEvent, ViolationsState> {
  final ViolationsRepository violationsRepository;

  ViolationsBloc({@required this.violationsRepository});

  @override
  ViolationsState get initialState => ViolationsLoadInProgress();

  @override
  Stream<ViolationsState> mapEventToState(ViolationsEvent event) async* {
    if (event is ViolationsLoaded) {
      yield* _mapViolationsLoadedToState(event.type);
    } else if (event is ViolationAdded) {
      yield* _mapViolationAddedToState(event);
    } else if (event is ViolationUpdated) {
      yield* _mapViolationUpdatedToState(event);
    } else if (event is ViolationDeleted) {
      yield* _mapViolationDeletedToState(event);
    }
  }

  Stream<ViolationsState> _mapViolationsLoadedToState(
      ViolationType type) async* {
    try {
      final violations = await this.violationsRepository.loadViolations(type);
      yield ViolationsLoadSuccess(
//        violations.map(Violation.fromEntity).toList(),
        type,
        violations,
      );
    } catch (e, s) {
      print("Exception $e");
      print("Stacktrace $s");
      yield ViolationsLoadFailure();
    }
  }

  Stream<ViolationsState> _mapViolationAddedToState(
      ViolationAdded event) async* {
    if (state is ViolationsLoadSuccess) {
      final List<Violation> updatedViolations =
          List.from((state as ViolationsLoadSuccess).violations)
            ..add(event.violation);
      yield ViolationsLoadSuccess(ViolationType.OPEN, updatedViolations);
      _saveViolations(updatedViolations);
    }
  }

  Stream<ViolationsState> _mapViolationUpdatedToState(
      ViolationUpdated event) async* {
    if (state is ViolationUpdated) {
      final List<Violation> updatedViolations =
          (state as ViolationsLoadSuccess).violations.map((violation) {
        return violation.id == event.violation.id ? event.violation : violation;
      }).toList();
      yield ViolationsLoadSuccess(ViolationType.OPEN, updatedViolations);
      _saveViolations(updatedViolations);
    }
  }

  Stream<ViolationsState> _mapViolationDeletedToState(
      ViolationDeleted event) async* {
    if (state is ViolationsLoadSuccess) {
      final updatedViolations = (state as ViolationsLoadSuccess)
          .violations
          .where((violation) => violation.id != event.violation.id)
          .toList();
      yield ViolationsLoadSuccess(ViolationType.OPEN, updatedViolations);
      _saveViolations(updatedViolations);
    }
  }

  Future _saveViolations(List<Violation> violations) {
    return violationsRepository.saveViolations(
//      violations.map((violation) => violation.toEntity()).toList(),
        violations);
  }
}
