import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

enum StoryFlashMode { auto, on, off }

enum StoryCameraDirection { front, back }

/// Events for Story BLoC
abstract class StoryEvent {}

class OpenCamera extends StoryEvent {}

class CapturePhoto extends StoryEvent {}

class RecordVideo extends StoryEvent {}

class ToggleFlash extends StoryEvent {}

class SwitchCameraDirectionEvent extends StoryEvent {}

/// State for Story BLoC
class StoryState extends Equatable {
  final bool loading;
  final bool openCamera;
  final String? imagePath;
  final String? error;
  final StoryFlashMode flashMode;
  final StoryCameraDirection cameraDirection;

  const StoryState({
    this.loading = false,
    this.openCamera = false,
    this.imagePath,
    this.error,
    this.flashMode = StoryFlashMode.auto,
    this.cameraDirection = StoryCameraDirection.front,
  });

  StoryState copyWith({
    bool? loading,
    bool? openCamera,
    String? imagePath,
    String? error,
    StoryFlashMode? flashMode,
    StoryCameraDirection? cameraDirection,
  }) {
    return StoryState(
      loading: loading ?? this.loading,
      openCamera: openCamera ?? this.openCamera,
      imagePath: imagePath ?? this.imagePath,
      error: error ?? this.error,
      flashMode: flashMode ?? this.flashMode,
      cameraDirection: cameraDirection ?? this.cameraDirection,
    );
  }

  @override
  List<Object?> get props => [
    loading,
    openCamera,
    imagePath,
    error,
    flashMode,
    cameraDirection,
  ];
}

class StoryBloc extends Bloc<StoryEvent, StoryState> {
  final ImagePicker _picker;

  StoryBloc({ImagePicker? picker})
    : _picker = picker ?? ImagePicker(),
      super(const StoryState()) {
    on<OpenCamera>(_onOpenCamera);
    on<CapturePhoto>(_onCapturePhoto);
    on<ToggleFlash>(_onToggleFlash);
    on<SwitchCameraDirectionEvent>(_onSwitchCameraDirectionEvent);
  }

  Future<void> _onOpenCamera(OpenCamera event, Emitter<StoryState> emit) async {
      print("bloc open camera");
    emit(state.copyWith(loading: true, error: null));
    try {
      emit(state.copyWith(loading: false, openCamera: true));
    } catch (e) {
      emit(
        state.copyWith(loading: false, openCamera: false, error: e.toString()),
      );
    }
  }

  Future<void> _onCapturePhoto(
    CapturePhoto event,
    Emitter<StoryState> emit,
  ) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      // Although ImagePicker.pickImage doesn't support flash, we keep the selected flash in state for UI and easier upgrade later
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
      );
      if (pickedFile != null) {
        emit(
          state.copyWith(
            loading: false,
            imagePath: pickedFile.path,
            openCamera: false,
            error: null,
          ),
        );
      } else {
        emit(state.copyWith(loading: false, error: 'No image selected.'));
      }
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  void _onToggleFlash(ToggleFlash event, Emitter<StoryState> emit) {
    final modes = StoryFlashMode.values;
    final currentIndex = modes.indexOf(state.flashMode);
    final nextMode = modes[(currentIndex + 1) % modes.length];
    emit(state.copyWith(flashMode: nextMode));
  }

  void _onSwitchCameraDirectionEvent(
    SwitchCameraDirectionEvent event,
    Emitter<StoryState> emit,
  ) {
    final nextCameraDirection = StoryCameraDirection.values.firstWhere(
      (direction) => direction != state.cameraDirection,
      orElse: () => state.cameraDirection,
    );
    emit(state.copyWith(cameraDirection: nextCameraDirection));
  }
}
