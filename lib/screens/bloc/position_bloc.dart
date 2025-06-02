import 'dart:async';
import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:health_app_ui/models/position.dart';
import 'package:health_app_ui/models/status.dart';
import 'package:health_app_ui/services/location_services.dart';

part 'position_event.dart';
part 'position_state.dart';

class PositionBloc extends Bloc<PositionEvent, PositionState> {
  PositionBloc() : super(const PositionState()) {
    on<GetPosition>(_onGetPosition);
    on<CurrentPositionChanged>(_onCurrentPositionChanged);
    add(GetPosition());
    positionSubscription = LocationServices.positionStream.listen(
      (position) => add(CurrentPositionChanged(position)),
    );
  }
  late StreamSubscription<Position> positionSubscription;

  @override
  Future<void> close() {
    positionSubscription.cancel();
    return super.close();
  }

  Future<void> _onGetPosition(
    GetPosition event,
    Emitter<PositionState> emit,
  ) async {
    emit(state.copyWith(status: Status.isLoading));

    try {
      Position position = await LocationServices.getCurrentLocation();
      log('Current position: ${position.latitude}, ${position.longitude}');

      emit(
        state.copyWith(
          status: Status.isSuccess,
          currentView: LatLng(position.latitude, position.longitude),
        ),
      );
    } catch (e) {
      log('error ${e.toString()}');
      emit(state.copyWith(status: Status.error, errorMessage: e.toString()));
    }
  }

  void _onCurrentPositionChanged(
    CurrentPositionChanged event,
    Emitter<PositionState> emit,
  ) async {
    Position position = await LocationServices.getCurrentLocation();

    emit(
      state.copyWith(
        status: Status.isSuccess,
        currentView: LatLng(position.latitude, position.longitude),
      ),
    );
  }
}
