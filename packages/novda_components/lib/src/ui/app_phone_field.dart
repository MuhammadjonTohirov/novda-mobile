import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_theme.dart';

/// Phone number input field with masking and prefix
class AppPhoneField extends StatefulWidget {
  const AppPhoneField({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    this.errorText,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.autofocus = false,
    this.focusNode,
  });

  final TextEditingController controller;
  final String? label;
  final String? hint;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;
  final bool autofocus;
  final FocusNode? focusNode;

  @override
  State<AppPhoneField> createState() => _AppPhoneFieldState();
}

class _AppPhoneFieldState extends State<AppPhoneField> {
  late final FocusNode _focusNode;
  bool _isFocused = false;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _hasText = widget.controller.text.isNotEmpty;
    _focusNode.addListener(_onFocusChange);
    widget.controller.addListener(_onTextChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _focusNode.removeListener(_onFocusChange);
    widget.controller.removeListener(_onTextChange);
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  void _onTextChange() {
    final hasText = widget.controller.text.isNotEmpty;
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
    } else if (_isFocused) {
      borderColor = colors.accent;
    } else {
      borderColor = Colors.transparent;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          enabled: widget.enabled,
          autofocus: widget.autofocus,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.done,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            _PhoneInputFormatter(),
            LengthLimitingTextInputFormatter(14), // (xx) xxx-xx-xx is 14 chars
          ],
          style: AppTypography.bodyLRegular.copyWith(
            color: widget.enabled ? colors.textPrimary : colors.textSecondary,
          ),
          decoration: InputDecoration(
            labelText: _hasText || _isFocused ? widget.label : null,
            hintText: _hasText || _isFocused
                ? null
                : (widget.hint ?? widget.label),
            prefixText: '+998 ',
            prefixStyle: AppTypography.bodyLRegular.copyWith(
              color: widget.enabled ? colors.textPrimary : colors.textSecondary,
            ),
            labelStyle: AppTypography.bodySRegular.copyWith(
              color: colors.textSecondary,
            ),
            hintStyle: AppTypography.bodyLRegular.copyWith(
              color: colors.textSecondary,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: borderColor, width: 2),
            ),
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            suffixIcon: _hasText && widget.enabled && !hasError
                ? IconButton(
                    icon: Icon(
                      Icons.cancel,
                      color: colors.textSecondary,
                      size: 20,
                    ),
                    onPressed: () {
                      widget.controller.clear();
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

class _PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    if (text.isEmpty) return newValue;

    final buffer = StringBuffer();
    final digits = text.replaceAll(RegExp(r'[^\d]'), '');

    // Format: (xx) xxx-xx-xx
    for (int i = 0; i < digits.length; i++) {
      if (i == 0) buffer.write('(');
      if (i == 2) buffer.write(') ');
      if (i == 5) buffer.write('-');
      if (i == 7) buffer.write('-');
      buffer.write(digits[i]);
    }

    final string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}
