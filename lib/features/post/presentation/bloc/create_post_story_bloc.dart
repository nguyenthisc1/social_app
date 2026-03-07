import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

/// Flash Mode Enum
enum StoryFlashMode { auto, on, off }

/// Events for Story BLoC
abstract class StoryEvent {}

class OpenCamera extends StoryEvent {}

class CapturePhoto extends StoryEvent {}

class RecordVideo extends StoryEvent {}

class ToggleFlash extends StoryEvent {}

/// State for Story BLoC
class StoryState extends Equatable {
  final bool loading;
  final bool cameraReady;
  final String? imagePath;
  final String? error;
  final StoryFlashMode flashMode;

  const StoryState({
    this.loading = false,
    this.cameraReady = false,
    this.imagePath,
    this.error,
    this.flashMode = StoryFlashMode.auto,
  });

  StoryState copyWith({
    bool? loading,
    bool? cameraReady,
    String? imagePath,
    String? error,
    StoryFlashMode? flashMode,
  }) {
    return StoryState(
      loading: loading ?? this.loading,
      cameraReady: cameraReady ?? this.cameraReady,
      imagePath: imagePath ?? this.imagePath,
      error: error ?? this.error,
      flashMode: flashMode ?? this.flashMode,
    );
  }

  @override
  List<Object?> get props => [
    loading,
    cameraReady,
    imagePath,
    error,
    flashMode,
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
    // You might want to implement RecordVideo in the future.
  }

  Future<void> _onOpenCamera(OpenCamera event, Emitter<StoryState> emit) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      emit(state.copyWith(loading: false, cameraReady: true));
    } catch (e) {
      emit(
        state.copyWith(loading: false, cameraReady: false, error: e.toString()),
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
            cameraReady: false,
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
}
