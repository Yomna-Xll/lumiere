import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lumiere/core/theme/app_colors.dart';
import 'package:lumiere/core/theme/app_text_style.dart';

class OtpBoxes extends StatefulWidget {
  final int length;
  final ValueChanged<String> onChanged;
  final String? errorText;

  const OtpBoxes({
    super.key,
    this.length = 6,
    required this.onChanged,
    this.errorText,
  });

  @override
  State<OtpBoxes> createState() => OtpBoxesState();
}

class OtpBoxesState extends State<OtpBoxes> {
  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;

  bool get hasError => widget.errorText != null;

  @override
  void initState() {
    super.initState();
    controllers = List.generate(widget.length, (_) => TextEditingController());
    focusNodes = List.generate(
      widget.length,
      (index) => FocusNode(onKeyEvent: (node, event) => onKey(event, index)),
    );
  }

  @override
  void dispose() {
    for (final controller in controllers) {
      controller.dispose();
    }
    for (final node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void notify() {
    widget.onChanged(controllers.map((c) => c.text).join());
  }

  KeyEventResult onKey(KeyEvent event, int index) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        controllers[index].text.isEmpty &&
        index > 0) {
      controllers[index - 1].clear();
      focusNodes[index - 1].requestFocus();
      notify();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  void onChanged(String value, int index) {
    if (value.isNotEmpty && index < widget.length - 1) {
      focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
    notify();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: List.generate(widget.length * 2 - 1, (i) {
            if (i.isOdd) return SizedBox(width: 8);
            final index = i ~/ 2;
            return Expanded(
              child: SizedBox(
                height: 56,
                child: TextFormField(
                  controller: controllers[index],
                  focusNode: focusNodes[index],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.headingMedium,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(1),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (value) => onChanged(value, index),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.inputFill,
                    contentPadding: EdgeInsets.zero,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: hasError
                          ? BorderSide(color: AppColors.error, width: 1.5)
                          : BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: hasError
                            ? AppColors.error
                            : AppColors.textPrimary,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        if (hasError) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.error_outline, color: AppColors.error, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  widget.errorText!,
                  style: AppTextStyle.helper.copyWith(color: AppColors.error),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
