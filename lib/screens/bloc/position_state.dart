part of 'position_bloc.dart';

class PositionState extends Equatable {
  final LatLng currentView;
  final Status status;
  final String errorMessage;

  const PositionState({
    this.currentView = const LatLng(0, 0),
    this.status = Status.initial,
    this.errorMessage = '',
  });

  @override
  List<Object> get props => [currentView, status, errorMessage];

  PositionState copyWith({
    LatLng? currentView,
    Status? status,
    String? errorMessage,
  }) {
    return PositionState(
      currentView: currentView ?? this.currentView,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
