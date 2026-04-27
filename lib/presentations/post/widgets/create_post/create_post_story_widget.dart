import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/core/core.dart';
import 'package:social_app/presentations/post/bloc/create_post_story_bloc.dart';

class CreatePostStoryWidget extends StatefulWidget {
  const CreatePostStoryWidget({super.key});

  @override
  State<CreatePostStoryWidget> createState() => _CreatePostStoryWidgetState();
}

class _CreatePostStoryWidgetState extends State<CreatePostStoryWidget>
    with AutomaticKeepAliveClientMixin {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    context.read<StoryBloc>().add(OpenCamera());
  }

  Future<void> _initializeCamera(StoryCameraDirection direction) async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        debugPrint('No cameras found');
        return;
      }

      final CameraLensDirection lensDirection =
          direction == StoryCameraDirection.front
          ? CameraLensDirection.front
          : CameraLensDirection.back;

      final CameraDescription cameraDescription = _cameras.firstWhere(
        (camera) => camera.lensDirection == lensDirection,
        orElse: () => _cameras.first,
      );

      _controller = CameraController(
        cameraDescription,
        ResolutionPreset.high,
        enableAudio: false,
      );
      await _controller!.initialize();
      if (!mounted) return;
      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _onCapture(BuildContext context) async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    try {
      final photo = await _controller!.takePicture();
      if (!mounted) return;
      // Send the photo path to the bloc (uncommented for update)
      // context.read<StoryBloc>().add(PhotoCaptured(photo.path));
    } catch (e) {
      debugPrint('Error capturing photo: $e');
    }
  }

  void _onToggleFlash() async {
    if (_controller != null) {
      final flashMode = _controller!.value.flashMode; // camera FlashMode
      FlashMode next;
      switch (flashMode) {
        case FlashMode.off:
          next = FlashMode.auto;
          break;
        case FlashMode.auto:
          next = FlashMode.always;
          break;
        case FlashMode.always:
          next = FlashMode.off;
          break;
        case FlashMode.torch:
          next = FlashMode.off;
          break;
      }
      await _controller!.setFlashMode(next);
      context.read<StoryBloc>().add(ToggleFlash());
    }
  }

  Future<void> _switchCamera(StoryCameraDirection direction) async {
    if (_cameras.isEmpty) {
      try {
        _cameras = await availableCameras();
      } catch (e) {
        debugPrint('No cameras found during switch: $e');
        return;
      }
    }

    CameraDescription cameraToUse;

    if (direction == StoryCameraDirection.front) {
      cameraToUse = _cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras.first,
      );
    } else {
      cameraToUse = _cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => _cameras.first,
      );
    }

    final oldController = _controller;

    setState(() {
      _isCameraInitialized = false;
      _controller = null;
    });

    await oldController?.dispose();

    final newController = CameraController(
      cameraToUse,
      ResolutionPreset.high,
      enableAudio: false,
    );

    _controller = newController;

    try {
      await newController.initialize();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Error switching camera: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocConsumer<StoryBloc, StoryState>(
      listenWhen: (prev, curr) =>
          prev.cameraDirection != curr.cameraDirection ||
          prev.openCamera != curr.openCamera,
      listener: (context, state) async {
        print("listener openCamera: ${state.openCamera}");

        if (state.openCamera && !_isCameraInitialized) {
          await _initializeCamera(state.cameraDirection);
        } else if (state.openCamera) {
          await _switchCamera(state.cameraDirection);
        }
      },
      builder: (context, state) {
        final screenHeight = MediaQuery.of(context).size.height;
        final bottomMargin = screenHeight * 0.10;
        // Show the image when it's captured
        if (state.imagePath != null) {
          return Stack(
            fit: StackFit.expand,
            children: [
              Image.file(File(state.imagePath!), fit: BoxFit.cover),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _HeaderBar(
                  onClose: () => Navigator.of(context).pop(),
                  flashMode: state.flashMode,
                  onFlashToggle: _onToggleFlash,
                ),
              ),
            ],
          );
        }

        // Show camera if openCamera and initialized
        if (state.openCamera &&
            _controller != null &&
            _isCameraInitialized &&
            _controller!.value.isInitialized) {
          return Container(
            margin: EdgeInsets.only(bottom: bottomMargin),
            child: SafeArea(
              top: false,
              bottom: false,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(AppSize.borderRadiusXLarge),
                      bottomRight: Radius.circular(AppSize.borderRadiusXLarge),
                    ),
                    child: Transform.scale(
                      scaleX: 1.15,
                      child: AspectRatio(
                        aspectRatio: 4 / 3,
                        child: CameraPreview(_controller!),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: _HeaderBar(
                      onClose: () => Navigator.of(context).pop(),
                      flashMode: state.flashMode,
                      onFlashToggle: _onToggleFlash,
                    ),
                  ),
                  Positioned(
                    bottom: AppSize.xl,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: GestureDetector(
                        onTap: () => _onCapture(context),
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey.shade400,
                              width: 4,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.camera,
                              color: Colors.black87,
                              size: 32,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Show loading while not initialized or loading in state
        if (state.loading || !_isCameraInitialized) {
          return const Center(child: CircularProgressIndicator());
        }

        // Default fallback loading
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class _HeaderBar extends StatelessWidget {
  final VoidCallback onClose;
  final VoidCallback onFlashToggle;
  final StoryFlashMode flashMode;

  const _HeaderBar({
    required this.onClose,
    required this.flashMode,
    required this.onFlashToggle,
  });

  IconData getFlashIcon(StoryFlashMode mode) {
    switch (mode) {
      case StoryFlashMode.auto:
        return Icons.flash_auto;
      case StoryFlashMode.on:
        return Icons.flash_on;
      case StoryFlashMode.off:
        return Icons.flash_off;
    }
  }

  String getFlashLabel(StoryFlashMode mode) {
    switch (mode) {
      case StoryFlashMode.auto:
        return "AUTO";
      case StoryFlashMode.on:
        return "ON";
      case StoryFlashMode.off:
        return "OFF";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSize.xl,
          vertical: AppSize.md,
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: onClose,
            ),
            const Spacer(),
            Tooltip(
              message: "Flash: ${getFlashLabel(flashMode)}",
              child: IconButton(
                icon: Icon(getFlashIcon(flashMode), color: Colors.white),
                onPressed: onFlashToggle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
