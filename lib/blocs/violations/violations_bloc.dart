import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:photocontrolapp/models/models.dart';
import 'package:photocontrolapp/repositories/repositories.dart';

import '../blocs.dart';
import '../blocs.dart';
import './bloc.dart';

class ViolationsBloc extends Bloc<ViolationsEvent, ViolationsState> {
  final ViolationsRepository violationsRepository;

  ViolationsBloc({@required this.violationsRepository});

  @override
  ViolationsState get initialState => ViolationsLoadInProgress(ViolationType.OPEN);

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
    } else if (event is ViolationCompleted) {
      yield* _mapViolationCompleteToState(event);
    }
  }

  Stream<ViolationsState> _mapViolationsLoadedToState(
      ViolationType type) async* {
    yield ViolationsLoadInProgress(type);
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
      yield ViolationsLoadFailure(type);
    }
  }

  Stream<ViolationsState> _mapViolationAddedToState(
      ViolationAdded event) async* {
    if (state is ViolationsLoadSuccess) {
      bool complete = false;

      try {
        complete =
            (state as ViolationsLoadSuccess).violations.first?.isComplete;
      } catch (e) {}

      final allViolatation = await violationsRepository.loadViolations(null);

//      final List<Violation> updatedViolations =
//          List.from((state as ViolationsLoadSuccess).violations)
      allViolatation.add(event.violation);
//      yield ViolationsLoadSuccess(ViolationType.OPEN, updatedViolations);
//      _saveViolations(updatedViolations);

      await _saveViolations(allViolatation);
      add(ViolationsLoaded(
          complete ? ViolationType.COMPLETE : ViolationType.OPEN));
    }
  }

  Stream<ViolationsState> _mapViolationUpdatedToState(
      ViolationUpdated event) async* {
    final List<Violation> updatedViolations =
        (state as ViolationsLoadSuccess).violations.map((violation) {
      return violation.id == event.violation.id ? event.violation : violation;
    }).toList();
    yield ViolationsLoadSuccess(ViolationType.OPEN, updatedViolations);
    await _saveViolations(updatedViolations);
  }

  Stream<ViolationsState> _mapViolationDeletedToState(
      ViolationDeleted event) async* {
    if (state is ViolationsLoadSuccess) {
      final allViolatation = await violationsRepository.loadViolations(null);

      final deletingViolation = allViolatation
          .firstWhere((violation) => violation.id == event.violation.id);

      Violation updatedViolation = Violation(
        id: deletingViolation.id,
        title: deletingViolation.title,
        description: deletingViolation.description,
        images: deletingViolation.images,
        isComplete: deletingViolation.isComplete,
        comments: deletingViolation.comments,
        isDelete: true,
      );

      final updatedViolations = allViolatation
          .where((violation) => violation.id != event.violation.id)
          .toList();

      updatedViolations?.add(updatedViolation);

//      yield ViolationsLoadSuccess(ViolationType.COMPLETE, updatedViolations);
      await _saveViolations(updatedViolations);
      add(ViolationsLoaded(ViolationType.COMPLETE));
    }
  }

  Stream<ViolationsState> _mapViolationCompleteToState(
      ViolationCompleted event) async* {
    if (state is ViolationsLoadSuccess) {
      final allViolatation = await violationsRepository.loadViolations(null);

      final completingViolation = allViolatation
          .firstWhere((violation) => violation.id == event.violation.id);

      Violation updatedViolation = Violation(
        id: completingViolation.id,
        title: completingViolation.title,
        description: completingViolation.description,
        images: completingViolation.images,
        comments: completingViolation.comments,
        isComplete: true,
        isDelete: false,
      );

      final updatedViolations = allViolatation
          .where((violation) => violation.id != event.violation.id)
          .toList();

      updatedViolations?.add(updatedViolation);

//      yield ViolationsLoadSuccess(ViolationType.OPEN, updatedViolations);
      await _saveViolations(updatedViolations);
      add(ViolationsLoaded(ViolationType.OPEN));
    }
  }

  Future _saveViolations(List<Violation> violations) async {
    return await violationsRepository.saveViolations(
//      violations.map((violation) => violation.toEntity()).toList(),
        violations);
  }
}
