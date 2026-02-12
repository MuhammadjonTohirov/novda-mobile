import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_theme.dart';

/// OTP/PIN input field component
class AppOtpField extends StatefulWidget {
  const AppOtpField({
    super.key,
    required this.length,
    required this.onCompleted,
    this.onChanged,
    this.errorText,
    this.hasError = false,
    this.autoFocus = true,
  });

  final int length;
  final ValueChanged<String> onCompleted;
  final ValueChanged<String>? onChanged;
  final String? errorText;
  final bool hasError;
  final bool autoFocus;

  @override
  State<AppOtpField> createState() => _AppOtpFieldState();
}

class _AppOtpFieldState extends State<AppOtpField> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());

    for (var i = 0; i < widget.length; i++) {
      _focusNodes[i].addListener(() {
        if (_focusNodes[i].hasFocus) {
          setState(() {});
        }
      });
    }

    if (widget.autoFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNodes[0].requestFocus();
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  String get _currentCode {
    return _controllers.map((c) => c.text).join();
  }

  void _onChanged(int index, String value) {
    if (value.length > 1) {
      // Handle paste
      final chars = value.split('');
      for (var i = 0; i < chars.length && (index + i) < widget.length; i++) {
        _controllers[index + i].text = chars[i];
      }
      final newIndex = (index + chars.length).clamp(0, widget.length - 1);
      _focusNodes[newIndex].requestFocus();
    } else if (value.isNotEmpty) {
      // Single character entered
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      }
    }

    widget.onChanged?.call(_currentCode);

    if (_currentCode.length == widget.length) {
      widget.onCompleted(_currentCode);
    }
  }

  void _onKeyEvent(int index, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        index > 0) {
      if (_controllers[index].text.isEmpty) {
        // Field is empty, move to previous and clear it
        _focusNodes[index - 1].requestFocus();
        _controllers[index - 1].clear();
        widget.onChanged?.call(_currentCode);
      } else {
        // Field has content - after deletion, move to previous field
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _focusNodes[index - 1].requestFocus();
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final hasError = widget.hasError || widget.errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.length, (index) {
            return Padding(
              padding: EdgeInsets.only(left: index == 0 ? 0 : 8),
              child: SizedBox(
                width: 48,
                height: 48,
                child: Container(
                  decoration: BoxDecoration(
                    color: colors.bgSecondary,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.transparent),
                  ),
                  child: KeyboardListener(
                    focusNode: FocusNode(),
                    onKeyEvent: (event) => _onKeyEvent(index, event),
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: AppTypography.headingM.copyWith(
                        color: hasError ? colors.error : colors.textPrimary,
                      ),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        counterText: '',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onChanged: (value) => _onChanged(index, value),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        if (widget.errorText != null) ...[
          const SizedBox(height: 8),
          Center(
            child: Text(
              widget.errorText!,
              style: AppTypography.bodySRegular.copyWith(color: colors.error),
            ),
          ),
        ],
      ],
    );
  }
}
