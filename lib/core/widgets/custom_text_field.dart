import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../config/app_constants.dart';
import '../utils/app_text_style.dart';

class CustomTextField extends StatefulWidget {
  final String? text;
  final bool isPassword;
  final bool isNumber;
  final List<String>? options;
  final double height;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final bool autofocus;
  final String? defaultValue;
  final bool isDateTimePicker;
  final Widget? suffixIcon;

  const CustomTextField({
    super.key,
    this.text,
    this.isPassword = false,
    this.isNumber = false,
    this.options,
    this.height = 50.0,
    this.controller,
    this.onChanged,
    this.autofocus = false,
    this.defaultValue,
    this.isDateTimePicker = false,
    this.suffixIcon,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isObscured = true;
  late FocusNode _focusNode;
  String _selectedOption = "";

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

  void _showOptionsDialog() {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.only(bottom: kPaddingXl),
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: kMarginLg),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kBorderRadiusXl),
                  color: kWhiteColor,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.options?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(kPaddingLg),
                        child: Center(
                          child: Text(
                            widget.options![index],
                            style: AppTextStyle.medium(kTextSizeMd),
                          ),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _selectedOption = widget.options![index];
                          widget.controller?.text = _selectedOption;
                        });
                        if (widget.onChanged != null) {
                          widget.onChanged!(_selectedOption);
                        }
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
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

  @override
  Widget build(BuildContext context) {
    final isOptionMode = widget.options != null;

    return Stack(
      children: [
        Container(
          height: widget.height + 5,
          decoration: BoxDecoration(
              color: kGreyLightColor,
              borderRadius: BorderRadius.circular(kBorderRadiusMd)),
        ),
        Container(
          height: widget.height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: kWhiteColor,
            border: Border.all(width: 2, color: kGreyMediumColor),
            borderRadius: BorderRadius.circular(kBorderRadiusMd),
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            autofocus: widget.autofocus,
            textAlignVertical: isOptionMode || widget.isPassword || widget.suffixIcon != null ? TextAlignVertical.center : null,
            keyboardType: widget.isNumber ? TextInputType.number : TextInputType.text,
            obscureText: widget.isPassword && _isObscured,
            readOnly: isOptionMode || widget.isDateTimePicker,
            decoration: InputDecoration(
              hintText: widget.defaultValue ?? (widget.text ?? ''),
              hintStyle: AppTextStyle.medium(kTextSizeSm, kGreyColor),
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              suffixIcon: widget.suffixIcon ??
                  (isOptionMode
                      ? const Icon(
                    Icons.arrow_drop_down_circle_outlined,
                    color: kGreyColor,
                    size: 16,
                  )
                      : (widget.isPassword
                      ? InkWell(
                    child: Icon(
                      _isObscured
                          ? Icons.visibility
                          : Icons.visibility_off,
                      size: 16,
                      color: kGreyColor,
                    ),
                    onTap: () {
                      setState(() {
                        _isObscured = !_isObscured;
                      });
                    },
                  )
                      : null)),
              contentPadding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
            ),
            style: AppTextStyle.medium(kTextSizeSm, kGreyColor),
            onTap: widget.isDateTimePicker ? _selectDate : (isOptionMode ? _showOptionsDialog : null),
            inputFormatters: widget.isNumber ? [FilteringTextInputFormatter.digitsOnly] : null,
          ),
        ),
      ],
    );
  }
}
