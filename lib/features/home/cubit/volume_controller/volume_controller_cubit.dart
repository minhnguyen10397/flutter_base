import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../common/bloc_status.dart';
import '../../../../common/constants.dart';

part 'volume_controller_state.dart';

class VolumeControllerCubit extends Cubit<VolumeControllerState> {
  VolumeControllerCubit() : super(VolumeControllerState());

  toggleVolume() {
    emit(state.copyWith(
     isMuted: !state.isMuted,
    ));
  }
}
