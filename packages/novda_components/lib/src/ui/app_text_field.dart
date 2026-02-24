import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Text field component with various states
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.initialValue,
    this.label,
    this.hint,
    this.errorText,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.enabled = true,
    this.autofocus = false,
    this.maxLines = 1,
    this.focusNode,
    this.showFocusBorder = true,
    this.showClearButton = true,
  });

  final TextEditingController? controller;
  final String? initialValue;
  final String? label;
  final String? hint;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool enabled;
  final bool autofocus;
  final int maxLines;
  final FocusNode? focusNode;
  final bool showFocusBorder;
  final bool showClearButton;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  bool _isFocused = false;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
    _focusNode = widget.focusNode ?? FocusNode();
    _hasText = _controller.text.isNotEmpty;
    _focusNode.addListener(_onFocusChange);
    _controller.addListener(_onTextChange);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _focusNode.removeListener(_onFocusChange);
    _controller.removeListener(_onTextChange);
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  void _onTextChange() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final hasError = widget.errorText != null;

    Color borderColor;
    if (!widget.enabled) {
      borderColor = Colors.transparent;
    } else if (hasError) {
      borderColor = colors.error;
    } else if (_isFocused && widget.showFocusBorder) {
      borderColor = colors.accent;
    } else {
      borderColor = Colors.transparent;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _controller,
          focusNode: _focusNode,
          enabled: widget.enabled,
          autofocus: widget.autofocus,
          obscureText: widget.obscureText,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          maxLines: widget.maxLines,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
          style: AppTypography.bodyLRegular.copyWith(
            color: widget.enabled ? colors.textPrimary : colors.textSecondary,
          ),
          decoration: InputDecoration(
            labelText: _hasText || _isFocused ? widget.label : null,
            hintText: _hasText || _isFocused
                ? null
                : (widget.hint ?? widget.label),
            labelStyle: AppTypography.bodySRegular.copyWith(
              color: colors.textSecondary,
            ),
            hintStyle: AppTypography.bodyLRegular.copyWith(
              color: colors.textSecondary,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            border: InputBorder.none,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: borderColor, width: 0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: borderColor, width: 1.5),
            ),
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            suffixIcon:
                widget.showClearButton &&
                    _hasText &&
                    widget.enabled &&
                    !hasError
                ? IconButton(
                    icon: Icon(
                      Icons.cancel,
                      color: colors.textSecondary,
                      size: 20,
                    ),
                    onPressed: () {
                      _controller.clear();
                      widget.onChanged?.call('');
                    },
                  )
                : hasError
                ? Icon(Icons.error_outline, color: colors.error, size: 24)
                : null,
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 4),
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
