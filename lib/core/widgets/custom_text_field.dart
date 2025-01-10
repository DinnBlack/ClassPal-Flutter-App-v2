import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../config/app_constants.dart';
import '../utils/app_text_style.dart';
import 'custom_feature_dialog.dart';

class CustomTextField extends StatefulWidget {
  final String? title;
  final String? text;
  final bool isPassword;
  final bool isNumber;
  final List<String>? options;
  final double height;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final bool autofocus;
  final String? defaultValue;
  final bool isDatePicker;
  final bool isTimePicker;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    this.title,
    this.text,
    this.isPassword = false,
    this.isNumber = false,
    this.options,
    this.height = 50.0,
    this.controller,
    this.onChanged,
    this.autofocus = false,
    this.defaultValue,
    this.isDatePicker = false,
    this.isTimePicker = false,
    this.suffixIcon,
    this.validator,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isObscured = true;
  late FocusNode _focusNode;
  String _selectedOption = "";
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {});
    });

    if (widget.autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_focusNode);
      });
    }

    if (widget.defaultValue != null) {
      _selectedOption = widget.defaultValue!;
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _validateInput(String value) {
    if (widget.validator != null) {
      setState(() {
        _errorText = widget.validator!(value);
      });
    }
  }

  void _showOptionsDialog() {
    if (widget.options == null) return;

    showCustomFeatureDialog(
      context,
      widget.options!,
      widget.options!.map((option) {
        return () {
          setState(() {
            _selectedOption = option;
          });
          if (widget.controller != null) {
            widget.controller!.text = option;
          }
          if (widget.onChanged != null) {
            widget.onChanged!(option);
          }
        };
      }).toList(),
    );
  }

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
      widget.controller?.text = formattedDate;

      if (widget.onChanged != null) {
        widget.onChanged!(formattedDate);
      }
    }
  }

  Future<void> _selectTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      final now = DateTime.now();
      final selectedTime = DateTime(
        now.year,
        now.month,
        now.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      String formattedTime = DateFormat('hh:mm a').format(selectedTime);
      widget.controller?.text = formattedTime;

      if (widget.onChanged != null) {
        widget.onChanged!(formattedTime);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isOptionMode = widget.options != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Text(
              widget.title!,
              style: AppTextStyle.medium(kTextSizeSm),
            ),
          ),
        Stack(
          children: [
            Container(
              height: widget.height + 5,
              decoration: BoxDecoration(
                color:
                    _focusNode.hasFocus ? kPrimaryLightColor : kGreyLightColor,
                borderRadius: BorderRadius.circular(kBorderRadiusMd),
              ),
            ),
            Container(
              height: widget.height,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: kWhiteColor,
                border: Border.all(
                  width: 2,
                  color: _focusNode.hasFocus
                      ? kPrimaryColor
                      : (_errorText != null ? Colors.red : kGreyMediumColor),
                ),
                borderRadius: BorderRadius.circular(kBorderRadiusMd),
              ),
              child: TextField(
                controller: widget.controller,
                focusNode: _focusNode,
                autofocus: widget.autofocus,
                textAlignVertical: isOptionMode ||
                    widget.isPassword ||
                    widget.suffixIcon != null
                    ? TextAlignVertical.center
                    : null,
                keyboardType:
                widget.isNumber ? TextInputType.number : TextInputType.text,
                obscureText: widget.isPassword && _isObscured,
                readOnly:
                isOptionMode || widget.isDatePicker || widget.isTimePicker,
                decoration: InputDecoration(
                  hintText: widget.text ?? '',
                  hintStyle: AppTextStyle.medium(kTextSizeSm, _focusNode.hasFocus ? kPrimaryColor : kGreyColor),
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  suffixIcon: widget.suffixIcon ??
                      (isOptionMode
                          ? const Icon(
                        Icons.arrow_drop_down_circle_outlined,
                        color: kGreyColor,
                        size: 20,
                      )
                          : (widget.isPassword
                          ? InkWell(
                        child: Icon(
                          _isObscured
                              ? Icons.visibility
                              : Icons.visibility_off,
                          size: 20,
                          color: kGreyColor,
                        ),
                        onTap: () {
                          setState(() {
                            _isObscured = !_isObscured;
                          });
                        },
                      )
                          : null)),
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: kPaddingMd),
                ),
                style: AppTextStyle.medium(
                    kTextSizeSm, _focusNode.hasFocus ? kPrimaryColor : kGreyColor),
                onTap: widget.isDatePicker
                    ? _selectDate
                    : (widget.isTimePicker
                    ? _selectTime
                    : (isOptionMode ? _showOptionsDialog : null)),
                inputFormatters: widget.isNumber
                    ? [FilteringTextInputFormatter.digitsOnly]
                    : null,
                onChanged: (value) {
                  if (widget.onChanged != null) {
                    widget.onChanged!(value);
                  }
                  _validateInput(value);
                },
              ),
            ),
          ],
        ),
        if (_errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(
              _errorText!,
              style: AppTextStyle.regular(kTextSizeXs, Colors.red),
            ),
          ),
      ],
    );
  }
}
