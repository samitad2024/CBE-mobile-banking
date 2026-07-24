import 'package:cbe_mobile_banking/core/theme/app_colors.dart';
import 'package:cbe_mobile_banking/core/widgets/scan_viewfinder.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// Live camera preview clipped to the PDF viewfinder; falls back when unsupported.
class CameraScanPreview extends StatefulWidget {
  const CameraScanPreview({
    required this.onCode,
    required this.onCameraError,
    this.enabled = true,
    super.key,
  });

  final ValueChanged<String> onCode;
  final ValueChanged<String> onCameraError;
  final bool enabled;

  @override
  State<CameraScanPreview> createState() => _CameraScanPreviewState();
}

class _CameraScanPreviewState extends State<CameraScanPreview> {
  MobileScannerController? _controller;
  var _handled = false;
  var _cameraReady = false;

  @override
  void initState() {
    super.initState();
    if (_supportsCamera) {
      _controller = MobileScannerController();
      _cameraReady = true;
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onCameraError('Camera unavailable on this platform');
      });
    }
  }

  bool get _supportsCamera =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CameraScanPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled && !oldWidget.enabled) {
      _handled = false;
      _controller?.start();
    }
    if (!widget.enabled && oldWidget.enabled) {
      _controller?.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_cameraReady || _controller == null) {
      return const ScanViewfinder();
    }

    return ScanViewfinder(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            MobileScanner(
              controller: _controller,
              onDetect: (capture) {
                if (!widget.enabled || _handled) return;
                final raw = capture.barcodes
                    .map((b) => b.rawValue)
                    .whereType<String>()
                    .firstWhere((v) => v.trim().isNotEmpty, orElse: () => '');
                if (raw.isEmpty) return;
                _handled = true;
                widget.onCode(raw);
              },
              errorBuilder: (context, error) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  widget.onCameraError(error.errorDetails?.message ??
                      'Camera permission or hardware error');
                });
                return const ColoredBox(
                  color: AppColors.plumDeep,
                  child: Center(
                    child: Icon(
                      Icons.videocam_off_outlined,
                      color: AppColors.muted,
                      size: 48,
                    ),
                  ),
                );
              },
            ),
            IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.peach.withValues(alpha: 0.35),
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
