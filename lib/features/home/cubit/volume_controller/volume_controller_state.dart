part of 'volume_controller_cubit.dart';

class VolumeControllerState {
  final bool isMuted;

  VolumeControllerState({
    this.isMuted = false,
  });

  VolumeControllerState copyWith({
    bool? isMuted,
  }) {
    return VolumeControllerState(
      isMuted: isMuted ?? this.isMuted,
    );
  }
}
