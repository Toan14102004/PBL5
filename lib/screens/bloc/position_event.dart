// part of 'position_bloc.dart';
//
// class PositionEvent {}
//
// class GetPosition extends PositionEvent {}
//
// class CurrentPositionChanged extends PositionEvent {
//   final Position position;
//
//   CurrentPositionChanged(this.position);
// }
part of 'position_bloc.dart';

abstract class PositionEvent extends Equatable {
  const PositionEvent();

  @override
  List<Object?> get props => [];
}

class GetPosition extends PositionEvent {}

class CurrentPositionChanged extends PositionEvent {
  final Position position;
  const CurrentPositionChanged(this.position);

  @override
  List<Object?> get props => [position];
}

class UpdatePosition extends PositionEvent {
  final LatLng newPosition;
  const UpdatePosition(this.newPosition);

  @override
  List<Object?> get props => [newPosition];
}
