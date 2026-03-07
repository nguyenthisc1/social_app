import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/core/core.dart';
import 'package:social_app/features/post/presentation/bloc/create_post_story_bloc.dart';

class CreatePostStoryWidget extends StatefulWidget {
  const CreatePostStoryWidget({super.key});

  @override
  State<CreatePostStoryWidget> createState() => _CreatePostStoryWidgetState();
}

class _CreatePostStoryWidgetState extends State<CreatePostStoryWidget> {
  CameraController? _controller;
  bool _isCameraInitialized = false;
  List<CameraDescription> _cameras = [];

  @override
  void initState() {
    super.initState();
    // Open camera on widget build
    _initializeCamera();
    context.read<StoryBloc>().add(OpenCamera());
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        debugPrint('No cameras found');
        return;
      }
      _controller = CameraController(
        _cameras[0],
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

  void _onCapture(BuildContext context) async {
    if (!_isCameraInitialized ||
        _controller == null ||
        !_controller!.value.isInitialized)
      return;
    try {
      final photo = await _controller!.takePicture();
      if (!mounted) return;
      // context.read<StoryBloc>().add(PhotoCaptured(photo.path));
    } catch (e) {
      debugPrint('Error capturing photo: $e');
    }
  }

  void _onToggleFlash() {
    if (_controller != null && _isCameraInitialized) {
      final hasFlash = _controller!.value.flashMode != FlashMode.off;
      _controller!.setFlashMode(hasFlash ? FlashMode.off : FlashMode.auto);
      context.read<StoryBloc>().add(ToggleFlash());
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoryBloc, StoryState>(
      builder: (context, state) {
        // Show loading overlay
        if (state.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        // If image is selected, preview it full screen
        if (state.imagePath != null) {
          return Stack(
            fit: StackFit.expand,
            children: [
              Image.file(File(state.imagePath!), fit: BoxFit.cover),
              // Top overlay for actions
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _HeaderBar(
                  onClose: () {
                    Navigator.of(context).pop();
                  },
                  flashMode: state.flashMode,
                  onFlashToggle: _onToggleFlash,
                ),
              ),
            ],
          );
        }

        // Camera view with camera preview when ready
        if (_isCameraInitialized &&
            _controller != null &&
            _controller!.value.isInitialized) {
          final screenHeight = MediaQuery.of(context).size.height;
          final bottomMargin = screenHeight * 0.10;

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

                  // Top header bar
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: _HeaderBar(
                      onClose: () {
                        Navigator.of(context).pop();
                      },
                      flashMode: state.flashMode,
                      onFlashToggle: _onToggleFlash,
                    ),
                  ),
                  // Bottom capture button
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
                          child: const Center(
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

        // Initial loading/awaiting camera
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
