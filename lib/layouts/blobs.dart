// ignore_for_file: deprecated_member_use

import 'dart:math';
import 'package:flutter/material.dart';

class BouncingImageBlobs extends StatefulWidget {
  final List<ImageProvider> images;
  final int blobCount;
  final double width;
  final double height;
  final bool showShadow;

  const BouncingImageBlobs({
    super.key,
    required this.images,
    required this.width,
    required this.height,
    this.blobCount = 6,
    this.showShadow = true,
  });

  @override
  State<BouncingImageBlobs> createState() => _BouncingImageBlobsState();
}

class _BouncingImageBlobsState extends State<BouncingImageBlobs>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random _random = Random();
  late List<_BouncingBlob> _blobs;
  static const double blobSpeed = 0.5; // ✅ all blobs move at this speed
  Offset? _hoverPosition;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(days: 1),
    )..repeat();
    _blobs = List.generate(widget.images.length, (i) {
      final angle = _random.nextDouble() * 2 * pi; // ✅ random direction

      return _BouncingBlob(
        image: widget.images[i], // ✅ one image per blob
        x: _random.nextDouble() * widget.width,
        y: _random.nextDouble() * widget.height,
        size: i == 0 ? 160 : 175,

        // ✅ SAME speed for all, only direction changes
        dx: cos(angle) * blobSpeed,
        dy: sin(angle) * blobSpeed,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        for (final blob in _blobs) {
          blob.update(
            widget.width,
            widget.height,
            hoverPosition: _hoverPosition,
          );
        }

        return MouseRegion(
          onHover: (event) {
            _hoverPosition = event.localPosition;
          },
          onExit: (_) {
            _hoverPosition = null;
          },
          child: Stack(
            children:
                _blobs.map((blob) {
                  return Positioned(
                    left: blob.x,
                    top: blob.y,
                    child: GestureDetector(
                      onPanStart: (_) {
                        blob.isDragging = true;
                      },
                      onPanUpdate: (details) {
                        setState(() {
                          blob.x += details.delta.dx;
                          blob.y += details.delta.dy;
                          blob.lastDragDelta = details.delta;
                        });
                      },
                      onPanEnd: (_) {
                        blob.isDragging = false;
                        blob.dx = blob.lastDragDelta.dx * 0.3;
                        blob.dy = blob.lastDragDelta.dy * 0.3;
                      },
                      child: _BlobWidget(
                        image: blob.image,
                        size: blob.size,
                        showShadow: widget.showShadow,
                      ),
                    ),
                  );
                }).toList(),
          ),
        );
      },
    );
  }
}

class _BouncingBlob {
  double x, y, size, dx, dy;
  bool isDragging = false;
  Offset lastDragDelta = Offset.zero;
  ImageProvider image;

  _BouncingBlob({
    required this.image,
    required this.x,
    required this.y,
    required this.size,
    required this.dx,
    required this.dy,
  });

  void update(double width, double height, {Offset? hoverPosition}) {
    if (!isDragging && hoverPosition != null) {
      final center = Offset(x + size / 2, y + size / 2);
      final direction = hoverPosition - center;

      final double distance = direction.distance.clamp(20, 300);
      final normalized = direction / distance;
      const double hoverForce = 0.01; // ✅ how strong hover pulls

      dx += normalized.dx * hoverForce;
      dy += normalized.dy * hoverForce;
    }

    if (isDragging) return;

    x += dx;
    y += dy;

    const double damping = 0.2;

    if (x <= 0) {
      x = 0;
      dx = -dx * damping;
    } else if (x + size >= width) {
      x = width - size;
      dx = -dx * damping;
    }

    if (y <= 0) {
      y = 0;
      dy = -dy * damping;
    } else if (y + size >= height) {
      y = height - size;
      dy = -dy * damping;
    }
  }
}

class _BlobWidget extends StatelessWidget {
  final ImageProvider image;
  final double size;
  final bool showShadow;

  const _BlobWidget({
    required this.image,
    required this.size,
    required this.showShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow:
            showShadow
                ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 30,
                    spreadRadius: 0.2,
                    offset: const Offset(0, 30),
                  ),
                ]
                : [],
      ),
      child: Image(image: image, fit: BoxFit.contain),
    );
  }
}
