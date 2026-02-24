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
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  bool _isProgrammaticUpdate = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode()..addListener(_onFocusChanged);

    if (widget.autoFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _focusInput();
      });
    }
  }

  @override
  void didUpdateWidget(covariant AppOtpField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.length == oldWidget.length) return;

    final truncated = _normalizeCode(_controller.text);
    if (truncated == _controller.text) return;

    _setCode(truncated);
    _notifyCodeChanged(truncated);
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_onFocusChanged)
      ..dispose();
    _controller.dispose();
    super.dispose();
  }

  String get _code => _normalizeCode(_controller.text);

  int get _activeIndex {
    final index = _code.length;
    if (index >= widget.length) return widget.length - 1;
    return index;
  }

  void _onFocusChanged() {
    if (!mounted) return;
    setState(() {});
  }

  void _onTextChanged(String rawValue) {
    if (_isProgrammaticUpdate) return;

    final normalized = _normalizeCode(rawValue);
    if (normalized != rawValue) {
      _setCode(normalized);
    }

    _notifyCodeChanged(normalized);
    if (mounted) {
      setState(() {});
    }
  }

  String _normalizeCode(String value) {
    final digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.length <= widget.length) return digitsOnly;
    return digitsOnly.substring(0, widget.length);
  }

  void _setCode(String code) {
    _isProgrammaticUpdate = true;
    _controller.value = TextEditingValue(
      text: code,
      selection: TextSelection.collapsed(offset: code.length),
    );
    _isProgrammaticUpdate = false;
  }

  void _notifyCodeChanged(String code) {
    widget.onChanged?.call(code);
    if (code.length == widget.length) {
      widget.onCompleted(code);
    }
  }

  void _focusInput() {
    if (!_focusNode.hasFocus) {
      FocusScope.of(context).requestFocus(_focusNode);
    } else {
      _controller.selection = TextSelection.collapsed(offset: _code.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final hasError = widget.hasError || widget.errorText != null;
    final code = _code;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 1,
          height: 1,
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            style: const TextStyle(fontSize: 1, color: Colors.transparent),
            cursorColor: Colors.transparent,
            showCursor: false,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(widget.length),
            ],
            decoration: const InputDecoration(
              isCollapsed: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            onChanged: _onTextChanged,
          ),
        ),
        GestureDetector(
          onTap: _focusInput,
          behavior: HitTestBehavior.translucent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.length, (index) {
              final char = index < code.length ? code[index] : '';
              final isActive = _focusNode.hasFocus && index == _activeIndex;

              return Padding(
                padding: EdgeInsets.only(left: index == 0 ? 0 : 8),
                child: InkWell(
                  onTap: _focusInput,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colors.bgSecondary,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: hasError
                            ? colors.error
                            : (isActive ? colors.accent : Colors.transparent),
                      ),
                    ),
                    child: Text(
                      char,
                      style: AppTypography.headingM.copyWith(
                        color: hasError ? colors.error : colors.textPrimary,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
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
