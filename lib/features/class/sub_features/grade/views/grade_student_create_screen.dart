import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/widgets/custom_button.dart';
import 'package:classpal_flutter_app/core/widgets/custom_text_field.dart';
import 'package:classpal_flutter_app/features/class/sub_features/subject/models/subject_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/custom_loading_dialog.dart';
import '../bloc/grade_bloc.dart';
import '../models/grade_type_model.dart';

class GradeStudentCreateScreen extends StatefulWidget {
  final SubjectModel subject;
  final String? studentId;

  const GradeStudentCreateScreen({
    super.key,
    required this.subject,
    this.studentId,
  });

  @override
  _GradeStudentCreateScreenState createState() =>
      _GradeStudentCreateScreenState();
}

class _GradeStudentCreateScreenState extends State<GradeStudentCreateScreen> {
  final TextEditingController _scoreController = TextEditingController();
  final TextEditingController _gradeTypeController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  GradeTypeModel? selectedGradeType;
  bool _valid = false;

  @override
  void initState() {
    super.initState();
    _scoreController.addListener(_updateValid);
    _gradeTypeController.addListener(_updateValid);
  }

  void _updateValid() {
    setState(() {
      _valid = _scoreController.text.isNotEmpty && selectedGradeType != null;
    });
  }

  @override
  void dispose() {
    _scoreController.removeListener(_updateValid);
    _gradeTypeController.removeListener(_updateValid);
    _scoreController.dispose();
    _gradeTypeController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    if (_scoreController.text.isNotEmpty ||
        selectedGradeType != null ||
        _commentController.text.isNotEmpty) {
      return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Xác nhận'),
          content: const Text('Bạn có chắc chắn muốn thoát không?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Không'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Có'),
            ),
          ],
        ),
      ) ??
          false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: BlocListener<GradeBloc, GradeState>(
        listener: (context, state) {
          if (state is GradeCreateInProgress) {
            CustomLoadingDialog.show(context);
          } else {
            CustomLoadingDialog.dismiss(context);
          }

          if (state is GradeCreateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Thêm điểm thành công')),
            );
            Navigator.pop(context);
          } else if (state is GradeCreateFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Thêm điểm thất bại')),
            );
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: kBackgroundColor,
            borderRadius: BorderRadius.circular(kBorderRadiusLg),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildAppBar(context),
              const SizedBox(height: kMarginMd),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _scoreController,
                      text: 'Điểm',
                      isNumber: true,
                    ),
                    const SizedBox(height: kMarginMd),
                    CustomTextField(
                      controller: _gradeTypeController,
                      text: 'Loại điểm',
                      options:
                      widget.subject.gradeTypes.map((e) => e.name).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedGradeType = widget.subject.gradeTypes
                              .firstWhere((e) => e.name == value);
                          _gradeTypeController.text = selectedGradeType!.name;
                        });
                        _updateValid();
                      },
                    ),
                    const SizedBox(height: kMarginMd),
                    CustomTextField(
                      controller: _commentController,
                      text: 'Nhận xét',
                    ),
                    const SizedBox(height: kMarginLg),
                    CustomButton(
                      isValid: _valid,
                      text: 'Thêm mới',
                      onTap: () {
                        final double? score =
                        double.tryParse(_scoreController.text);
                        if (score == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Điểm không hợp lệ')),
                          );
                          return;
                        }

                        if (selectedGradeType == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Vui lòng chọn loại điểm')),
                          );
                          return;
                        }

                        if (widget.studentId == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Mã sinh viên không hợp lệ')),
                          );
                          return;
                        }

                        context.read<GradeBloc>().add(
                          GradeCreateInStarted(
                            subjectId: widget.subject.id,
                            studentId: widget.studentId!,
                            gradeTypeId: selectedGradeType!.id,
                            value: score,
                            comment: _commentController.text,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: kMarginLg),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  CustomAppBar _buildAppBar(BuildContext context) {
    return CustomAppBar(
      isSafeArea: false,
      title: widget.subject.name,
      leftWidget: InkWell(
        child: const Icon(FontAwesomeIcons.xmark),
        onTap: () async {
          bool shouldPop = await _onWillPop();
          if (shouldPop) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}

