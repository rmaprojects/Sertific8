import 'dart:io';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sertific8/states/pixel_selector_provider.dart';
import 'package:sertific8/views/name_input_sheet/name_input_sheet.dart';

class PixelSelectorMenu extends StatelessWidget {
  final XFile imageFile;
  final GlobalKey _imageKey = GlobalKey();

  PixelSelectorMenu({super.key, required this.imageFile});

  void _onImageTap(BuildContext context, TapDownDetails details) {
    final provider = context.read<PixelSelectorProvider>();
    final RenderBox? renderBox =
       _imageKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final localPosition = renderBox.globalToLocal(details.globalPosition);
    provider.toggleLock(localPosition);
  }

  void _onImageHover(BuildContext context, PointerEvent event) {
    final provider = context.read<PixelSelectorProvider>();
    final RenderBox? renderBox =
       _imageKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final localPosition = renderBox.globalToLocal(event.position);
    provider.updateHoverPosition(localPosition);
  }

  void _onImageExit(BuildContext context, PointerEvent event) {
    final provider = context.read<PixelSelectorProvider>();
    provider.clearHover();
  }

  List<Widget> _buildCrosshair(Offset position, Color color, bool isLocked) {
    const double crosshairSize = 40.0;
    const double lineThickness = 2.0;
    const double centerDotSize = 6.0;

    return [
      // Vertical line
      Positioned(
        left: position.dx - lineThickness / 2,
        top: position.dy - crosshairSize / 2,
        child: Container(
          width: lineThickness,
          height: crosshairSize,
          color: color,
        ),
      ),
      // Horizontal line
      Positioned(
        left: position.dx - crosshairSize / 2,
        top: position.dy - lineThickness / 2,
        child: Container(
          width: crosshairSize,
          height: lineThickness,
          color: color,
        ),
      ),
      // Center dot
      Positioned(
        left: position.dx - centerDotSize / 2,
        top: position.dy - centerDotSize / 2,
        child: Container(
          width: centerDotSize,
          height: centerDotSize,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
              color: isLocked
                 ? Colors.white
                 : Colors.white.withValues(alpha: 0.7),
              width: 1,
            ),
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PixelSelectorProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          body: Column(
            children: [
              Expanded(
                child: Center(
                  child: MouseRegion(
                    onHover: (event) => _onImageHover(context, event),
                    onExit: (event) => _onImageExit(context, event),
                    child: GestureDetector(
                      onTapDown: (details) => _onImageTap(context, details),
                      child: Stack(
                        children: [
                          Image.file(
                            File(imageFile.path),
                            key: _imageKey,
                            fit: BoxFit.contain,
                            frameBuilder:
                                (
                                  context,
                                 child,
                                 frame,
                                 wasSynchronouslyLoaded,
                                ) {
                                  if (frame != null) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                          final RenderBox? renderBox =
                                             _imageKey.currentContext
                                                      ?.findRenderObject()
                                                 as RenderBox?;
                                          if (renderBox != null) {
                                            provider.setImageSize(
                                              renderBox.size,
                                            );
                                          }
                                        });
                                  }
                                  return child;
                                },
                          ),
                          // Show crosshair for locked selection
                          if (provider.selectedPixel != null &&
                             provider.imageSize != null &&
                             provider.isLocked)
                            ..._buildCrosshair(
                              provider.selectedPixel!,
                             Colors.red,
                             true,
                            ),
                          // Show crosshair for hover (when not locked)
                          if (provider.hoverPixel != null &&
                             provider.imageSize != null &&
                             !provider.isLocked)
                            ..._buildCrosshair(
                              provider.hoverPixel!,
                             Colors.blue.withValues(alpha: .7),
                             false,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  border: Border(
                    top: BorderSide(
                      color: Theme.of(
                        context,
                      ).colorScheme.outline.withValues(alpha: .2),
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      provider.isLocked
                         ? 'Posisi terkunci - Klik lagi untuk membuka'
                         : 'Pilih posisi pixel pada gambar',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    if (provider.isLocked && provider.selectedPixel != null)
                      Text(
                        'Posisi Pixel: X: ${provider.selectedPixel!.dx.toInt()}, Y: ${provider.selectedPixel!.dy.toInt()}',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    else if (!provider.isLocked && provider.hoverPixel != null)
                      Text(
                        'Posisi: X: ${provider.hoverPixel!.dx.toInt()}, Y: ${provider.hoverPixel!.dy.toInt()} (Klik untuk mengunci)',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      )
                    else
                      Text(
                        'Gerakkan kursor pada gambar untuk melihat koordinat',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Kembali'),
                        ),
                        const SizedBox(width: 8),
                        FilledButton(
                          onPressed:
                              (provider.selectedPixel != null &&
                                 provider.isLocked)
                              ? () {
                                  NameInputSheet.show(context);
                                }
                              : null,
                          child: const Text('Simpan Posisi'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
