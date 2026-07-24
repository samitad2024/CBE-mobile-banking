import 'package:cbe_mobile_banking/core/constants/app_constants.dart';
import 'package:cbe_mobile_banking/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Four circular PIN dots (PDF p.1). Ephemeral UI state only.
class PinDotsField extends StatefulWidget {
  const PinDotsField({
    required this.onChanged,
    this.onCompleted,
    this.enabled = true,
    super.key,
  });

  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onCompleted;
  final bool enabled;

  @override
  State<PinDotsField> createState() => _PinDotsFieldState();
}

class _PinDotsFieldState extends State<PinDotsField> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    final clipped = digits.length > AppConstants.pinLength
        ? digits.substring(0, AppConstants.pinLength)
        : digits;
    if (clipped != value) {
      _controller.value = TextEditingValue(
        text: clipped,
        selection: TextSelection.collapsed(offset: clipped.length),
      );
    }
    setState(() {});
    widget.onChanged(clipped);
    if (clipped.length == AppConstants.pinLength) {
      widget.onCompleted?.call(clipped);
    }
  }

  @override
  Widget build(BuildContext context) {
    final length = _controller.text.length.clamp(0, AppConstants.pinLength);

    return GestureDetector(
      onTap: widget.enabled ? _focusNode.requestFocus : null,
      child: Column(
        children: [
          Offstage(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              enabled: widget.enabled,
              autofocus: true,
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: AppConstants.pinLength,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: _onChanged,
              decoration: const InputDecoration(
                counterText: '',
                border: InputBorder.none,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(AppConstants.pinLength, (index) {
              final filled = index < length;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.peach.withValues(alpha: 0.7),
                  ),
                ),
                child: filled
                    ? const Text(
                        '*',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    : null,
              );
            }),
          ),
        ],
      ),
    );
  }
}
