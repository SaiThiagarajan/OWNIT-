import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// A row of single-digit boxes for OTP entry. Auto-advances focus as each
/// digit is typed and moves back on backspace. Calls [onCompleted] once
/// every box is filled; callers own what "verifying" that code means.
class OtpInput extends StatefulWidget {
  const OtpInput({
    super.key,
    this.length = 6,
    this.errorText,
    this.onCompleted,
    this.onChanged,
  });

  final int length;
  final String? errorText;
  final ValueChanged<String>? onCompleted;
  final ValueChanged<String>? onChanged;

  @override
  State<OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  /// Ambient focus node that wraps the whole row purely to intercept
  /// backspace key events as they bubble up from whichever box currently
  /// has focus. It never requests focus itself — sharing a FocusNode
  /// between this and a box's TextField would make the focus tree try to
  /// parent a node under itself and crash.
  final FocusNode _rowFocusNode = FocusNode(
    skipTraversal: true,
    canRequestFocus: false,
    debugLabel: 'OtpInput backspace listener',
  );

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    _rowFocusNode.dispose();
    super.dispose();
  }

  String get _code => _controllers.map((c) => c.text).join();

  void _handleChanged(int index, String value) {
    if (value.isNotEmpty && index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }
    widget.onChanged?.call(_code);
    if (_code.length == widget.length) {
      widget.onCompleted?.call(_code);
    }
  }

  void _handleBackspace() {
    final index = _focusNodes.indexWhere((node) => node.hasFocus);
    if (index > 0 && _controllers[index].text.isEmpty) {
      _focusNodes[index - 1].requestFocus();
      _controllers[index - 1].clear();
      widget.onChanged?.call(_code);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          label: 'One-time passcode, ${widget.length} digits',
          child: KeyboardListener(
            focusNode: _rowFocusNode,
            onKeyEvent: (event) {
              if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.backspace) {
                _handleBackspace();
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(widget.length, (index) {
                return Semantics(
                  label: 'Digit ${index + 1} of ${widget.length}',
                  textField: true,
                  child: SizedBox(
                    width: AppSpacing.otpHeight,
                    height: AppSpacing.otpHeight,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: AppTypography.numeral(fontSize: 20),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        counterText: '',
                        contentPadding: EdgeInsets.zero,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
                          borderSide: BorderSide(
                            color: hasError ? AppColors.error : AppColors.border,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
                          borderSide: BorderSide(
                            color: hasError ? AppColors.error : AppColors.orange,
                            width: 1.5,
                          ),
                        ),
                      ),
                      onChanged: (value) => _handleChanged(index, value),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: AppSpacing.s8),
          Row(
            children: [
              const Icon(Icons.error_outline, size: 16, color: AppColors.error),
              const SizedBox(width: AppSpacing.s4),
              Expanded(
                child: Text(
                  widget.errorText!,
                  style: textTheme.bodySmall?.copyWith(color: AppColors.error),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
