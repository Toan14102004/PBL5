import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:health_app_ui/models/status.dart';
import 'package:health_app_ui/screens/bloc/position_bloc.dart';

class MapScreen extends StatelessWidget {
  final LatLng initialPosition;
  const MapScreen({super.key, required this.initialPosition});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PositionBloc()..add(UpdatePosition(initialPosition)),
      child: MapView(initialPosition: initialPosition),
    );
  }
}


class MapView extends StatefulWidget {
  final LatLng initialPosition;
  const MapView({super.key, required this.initialPosition});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
    // Đẩy sự kiện cập nhật vị trí khi khởi tạo màn hình
    context.read<PositionBloc>().add(UpdatePosition(widget.initialPosition));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: BlocListener<PositionBloc, PositionState>(
        listenWhen: (previous, current) =>
        previous.currentView != current.currentView &&
            current.status == Status.isSuccess,
        listener: (context, state) {
          moveCamera(state.currentView);
        },
        child: BlocBuilder<PositionBloc, PositionState>(
          builder: (_, positionState) {
            if (positionState.status == Status.isLoading ||
                positionState.status == Status.initial) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (positionState.status == Status.isSuccess) {
                LatLng currentView = positionState.currentView;
                return GoogleMap(
                  onMapCreated: (controller) {
                    _controller.complete(controller);
                  },
                  initialCameraPosition: CameraPosition(
                    target: currentView,
                    zoom: 19,
                  ),
                  myLocationEnabled: true,
                  markers: {
                    Marker(
                      markerId: const MarkerId('currentLocation'),
                      position: currentView,
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueBlue,
                      ),
                    ),
                  },
                );
              } else {
                return Center(child: Text(positionState.errorMessage));
              }
            }
          },
        ),
      ),
    );
  }

  Future<void> moveCamera(LatLng newCameraPosition) async {
    final GoogleMapController controller = await _controller.future;
    controller.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: newCameraPosition, zoom: 19),
      ),
    );
  }
}
