import 'dart:io';
import 'package:classpal_flutter_app/core/widgets/custom_loading_dialog.dart';
import 'package:classpal_flutter_app/core/widgets/custom_page_transition.dart';
import 'package:classpal_flutter_app/features/class/bloc/class_bloc.dart';
import 'package:classpal_flutter_app/features/teacher/views/teacher_create_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../core/config/app_constants.dart';
import '../../../core/utils/app_text_style.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/custom_avatar.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_button_camera.dart';
import '../../../core/widgets/custom_list_item.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../profile/model/profile_model.dart';
import '../../student/bloc/student_bloc.dart';
import '../../student/views/student_list_screen.dart';
import '../../teacher/bloc/teacher_bloc.dart';
import '../repository/class_service.dart';

class ClassCreateScreen extends StatefulWidget {
  static const route = 'ClassCreateScreen';
  final bool isClassSchoolCreateView;

  const ClassCreateScreen({super.key, this.isClassSchoolCreateView = false});

  @override
  _ClassCreateScreenState createState() => _ClassCreateScreenState();
}

class _ClassCreateScreenState extends State<ClassCreateScreen> {
  late final PageController _pageController;
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  final _classNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _studentNameController = TextEditingController();
  final List<String> _invitedEmails = [];
  bool _isValid = false;
  bool _hasText = false;

  void _updateHasText(String value) {
    setState(() {
      _hasText = value.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _classNameController.addListener(_validateForm);
  }

  void _validateForm() {
    setState(() {
      final isNameValid = Validators.validateRequiredText(
              _classNameController.text, 'Tên lớp không được để trống!') ==
          null;

      _isValid = isNameValid && _classNameController.text.trim().isNotEmpty;
    });
  }

  void _addEmail() {
    String email = _emailController.text.trim();
    if (email.isNotEmpty && !_invitedEmails.contains(email)) {
      setState(() {
        _invitedEmails.add(email);
        _emailController.clear();
      });
    }
  }

  void _removeEmail(String email) {
    setState(() {
      _invitedEmails.remove(email);
    });
  }

  void _navigateStep(int step) {
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        step,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep = step);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: _currentStep == 2
            ? 'Hoàn tất'
            : _currentStep == 1
                ? 'Phân công'
                : 'Tạo lớp học mới',
        leftWidget: _currentStep != 2
            ? GestureDetector(
                child: _currentStep == 0
                    ? const Icon(FontAwesomeIcons.xmark)
                    : _currentStep == 1
                        ? const Icon(FontAwesomeIcons.arrowLeft)
                        : null,
                onTap: () {
                  if (_currentStep == 0) {
                    Navigator.pop(context);
                  } else {
                    _navigateStep(_currentStep - 1);
                  }
                },
              )
            : null,
        rightWidget: _currentStep != 0
            ? GestureDetector(
                onTap: () {
                  if (_currentStep == 2) {
                    return Navigator.pop(context);
                  }
                  _navigateStep(_currentStep + 1);

                },
                child: Text(
                  _currentStep == 1 ? 'Tiếp tục' : 'Hoàn tất',
                  style: AppTextStyle.semibold(kTextSizeSm, kPrimaryColor),
                ),
              )
            : null,
      ),
      backgroundColor: kBackgroundColor,
      body: widget.isClassSchoolCreateView
          ? _buildClassSchoolCreationSteps()
          : _buildClassPersonalCreationSteps(),
    );
  }

  Widget _buildClassPersonalCreationSteps() {
    return SafeArea(
      child: Column(
        children: [
          _buildProgressIndicator(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildStep1(),
                  _buildClassPersonalStep2(),
                  _buildStep3(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassSchoolCreationSteps() {
    return SafeArea(
      child: Column(
        children: [
          _buildProgressIndicator(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildStep1(),
                  ClassSchoolStep2(
                    className: _classNameController.text,
                    callback: () {
                      setState(() {
                        _navigateStep(2);
                      });
                    },
                  ),
                  _buildStep3(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Row(
      children: List.generate(3, (index) => _buildProgressBar(index)),
    );
  }

  Widget _buildProgressBar(int index) {
    return Expanded(
      child: Container(
        height: 5,
        decoration: BoxDecoration(
          color: _currentStep >= index
              ? kPrimaryColor
              : kPrimaryColor.withOpacity(0.3),
        ),
      ),
    );
  }

  Widget _buildStep1() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: kMarginXxl),
          CustomButtonCamera(onImagePicked: (File? value) {}),
          const SizedBox(height: kMarginXxl),
          CustomTextField(
            text: 'Tên lớp học',
            autofocus: true,
            controller: _classNameController,
            onChanged: (_) => _validateForm(),
          ),
          const SizedBox(height: kMarginLg),
          CustomButton(
            text: 'Tiếp tục',
            onTap: _isValid ? () => _navigateStep(1) : null,
            isValid: _isValid,
          ),
        ],
      ),
    );
  }

  Widget _buildClassPersonalStep2() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: kMarginXxl),
          _buildStepTitle('Mời đồng giáo viên!',
              'Hãy mời đồng giáo viên để quản lý lớp học'),
          const SizedBox(height: kMarginXxl),
          CustomTextField(
            text: 'Email hoặc số điện thoại',
            validator: (value) => Validators.validateEmail(value),
            controller: _emailController,
            onChanged: (value) {
              setState(() {
                _hasText = value.isNotEmpty;
              });
            },
            suffixIcon: InkWell(
              onTap: _hasText ? _addEmail : null,
              borderRadius: BorderRadius.circular(kBorderRadiusMd),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: kMarginSm),
                decoration: BoxDecoration(
                  color: _hasText ? kPrimaryColor : kGreyLightColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  FontAwesomeIcons.plus,
                  size: 16,
                  color: _hasText ? Colors.white : kGreyColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: kMarginLg),
          _buildInviteSection(),
          CustomButton(
            text: 'Mời và tạo lớp học',
            isValid: _invitedEmails.isNotEmpty,
            onTap: _invitedEmails.isNotEmpty
                ? () {
                    context.read<ClassBloc>().add(ClassPersonalCreateStarted(
                        name: _classNameController.text));
                    _navigateStep(2);
                  }
                : null,
          ),
          const SizedBox(height: kMarginMd),
          GestureDetector(
            onTap: () async {
              context.read<ClassBloc>().add(
                  ClassPersonalCreateStarted(name: _classNameController.text));
              _navigateStep(2);
            },
            child: Text(
              'Tôi không có đồng giáo viên, Tạo lớp học',
              style: AppTextStyle.semibold(kTextSizeXs, kPrimaryColor),
            ),
          ),
          const SizedBox(height: kMarginLg),
        ],
      ),
    );
  }

  Widget _buildInviteSection() {
    if (_invitedEmails.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Bạn đã mời', style: AppTextStyle.bold(kTextSizeMd)),
        const SizedBox(
          height: kMarginMd,
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _invitedEmails.length,
          itemBuilder: (context, index) =>
              _buildInvitedEmail(_invitedEmails[index]),
          separatorBuilder: (context, index) =>
              const SizedBox(height: kMarginMd),
        ),
        const SizedBox(height: kMarginLg),
      ],
    );
  }

  Widget _buildInvitedEmail(String email) {
    return Container(
      padding: const EdgeInsets.all(kPaddingMd),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kBorderRadiusMd),
        border: Border.all(width: 2, color: kGreyMediumColor),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(kPaddingMd),
                decoration: BoxDecoration(
                    color: kGreyLightColor,
                    shape: BoxShape.circle,
                    border: Border.all(width: 2, color: kGreyMediumColor)),
                child: const Icon(
                  FontAwesomeIcons.solidEnvelope,
                  size: 16,
                  color: kGreyColor,
                ),
              ),
              const SizedBox(
                width: kMarginMd,
              ),
              Expanded(
                  child: Text(
                email,
                style: AppTextStyle.semibold(kTextSizeMd),
              ))
            ],
          ),
          const SizedBox(
            height: kMarginMd,
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: kPaddingSm),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: kPrimaryLightColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(kBorderRadiusLg),
            ),
            child: Text(
              'Chỉnh sửa',
              style: AppTextStyle.semibold(kTextSizeSm, kPrimaryColor),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: kMarginLg,
          ),
          CustomTextField(
            text: 'Họ và tên học sinh',
            controller: _studentNameController,
            onChanged: _updateHasText,
            suffixIcon: InkWell(
              onTap: () {
                context.read<StudentBloc>().add(
                    StudentCreateStarted(name: _studentNameController.text));
              },
              borderRadius: BorderRadius.circular(kBorderRadiusMd),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: kMarginSm),
                decoration: BoxDecoration(
                  color: _hasText ? kPrimaryColor : kGreyLightColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  FontAwesomeIcons.plus,
                  size: 16,
                  color: _hasText ? Colors.white : kGreyColor,
                ),
              ),
            ),
          ),
          const Expanded(
              child: StudentListScreen(
            isCreateView: true,
          )),
        ],
      ),
    );
  }
}

Widget _buildStepTitle(String title, String subtitle) {
  return Column(
    children: [
      Text(title, style: AppTextStyle.bold(kTextSizeXxl)),
      Text(subtitle, style: AppTextStyle.semibold(kTextSizeSm, kGreyColor)),
    ],
  );
}

class ClassSchoolStep2 extends StatefulWidget {
  final String className;
  final VoidCallback callback;

  const ClassSchoolStep2(
      {super.key, required this.className, required this.callback});

  @override
  _ClassSchoolStep2State createState() => _ClassSchoolStep2State();
}

class _ClassSchoolStep2State extends State<ClassSchoolStep2> {
  List<ProfileModel> selectedTeachers = [];
  List<ProfileModel> unselectedTeachers = [];
  final List<String> _selectedTeacherIds = [];

  @override
  void initState() {
    super.initState();
    context.read<TeacherBloc>().add(TeacherFetchStarted());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ClassBloc, ClassState>(
      listener: (context, state) {
        if (state is ClassSchoolCreateInProgress ||
            state is ClassSchoolBindRelInProgress) {
          return CustomLoadingDialog.show(context);
        }
        if (state is ClassSchoolCreateSuccess) {
          final currentClass = state.currentClass;
          ClassService().saveCurrentClass(currentClass);
          context
              .read<ClassBloc>()
              .add(ClassSchoolBindRelStarted(profileIds: _selectedTeacherIds));
        }
        if (state is ClassSchoolBindRelSuccess) {
          CustomLoadingDialog.dismiss(context);
          widget.callback();
          showTopSnackBar(
            Overlay.of(context),
            const CustomSnackBar.success(
              message: 'Tạo lớp học và phân công thành công!',
            ),
          );
        }
      },
      child: BlocBuilder<TeacherBloc, TeacherState>(
        builder: (context, state) {
          if (state is TeacherFetchSuccess) {
            final teachers = state.teachers;
            selectedTeachers = teachers
                .where((teacher) => _selectedTeacherIds.contains(teacher.id))
                .toList();
            unselectedTeachers = teachers
                .where((teacher) => !_selectedTeacherIds.contains(teacher.id))
                .toList();

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: kMarginXxl),
                  Center(
                    child: _buildStepTitle(
                      'Thêm giáo viên phụ trách!',
                      'Hãy phân công giáo viên để quản lý lớp học',
                    ),
                  ),
                  const SizedBox(height: kMarginXxl),
                  Text('Đã chọn', style: AppTextStyle.bold(kTextSizeMd)),
                  const SizedBox(height: kMarginMd),
                  // Danh sách giáo viên đã chọn
                  selectedTeachers.isNotEmpty
                      ? ListView.separated(
                          shrinkWrap: true,
                          padding:
                              const EdgeInsets.symmetric(vertical: kMarginMd),
                          itemCount: selectedTeachers.length,
                          itemBuilder: (context, index) {
                            final teacher = selectedTeachers[index];
                            return CustomListItem(
                              title: teacher.displayName,
                              isAnimation: false,
                              leading: CustomAvatar(profile: teacher),
                              trailing: GestureDetector(
                                onTap: () {
                                  _toggleTeacherSelection(teacher.id, teachers);
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(kPaddingMd),
                                  child: Icon(
                                    FontAwesomeIcons.xmark,
                                    size: 16,
                                    color: kRedColor,
                                  ),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: kMarginMd),
                        )
                      : Row(
                          children: [
                            Image.asset('assets/images/empty_teacher.jpg',
                                height: 70),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Chưa có giáo viên quản lý lớp học!',
                                    style: AppTextStyle.bold(kTextSizeSm),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    'Phân công giáo viên để quản lý lớp học',
                                    style: AppTextStyle.medium(kTextSizeXs),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                  const SizedBox(height: kMarginMd),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Danh sách giáo viên của bạn',
                          style: AppTextStyle.bold(kTextSizeMd)),
                      GestureDetector(
                        onTap: () {
                          CustomPageTransition.navigateTo(
                            context: context,
                            page: const TeacherCreateScreen(),
                            transitionType: PageTransitionType.slideFromBottom,
                          );
                        },
                        child: Text(
                          '+ Giáo viên',
                          style:
                              AppTextStyle.semibold(kTextSizeSm, kPrimaryColor),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: kMarginMd),
                  // Danh sách giáo viên chưa chọn
                  ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(vertical: kMarginMd),
                    itemCount: unselectedTeachers.length,
                    itemBuilder: (context, index) {
                      final teacher = unselectedTeachers[index];
                      return CustomListItem(
                        title: teacher.displayName,
                        isAnimation: false,
                        leading: CustomAvatar(profile: teacher),
                        trailing: GestureDetector(
                          onTap: () {
                            _toggleTeacherSelection(teacher.id, teachers);
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(kPaddingMd),
                            child: Icon(
                              FontAwesomeIcons.plus,
                              size: 16,
                              color: kPrimaryColor,
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: kMarginMd),
                  ),
                  const SizedBox(height: kMarginMd),
                  CustomButton(
                    text: 'Phân công',
                    onTap: () {
                      context.read<ClassBloc>().add(
                          ClassSchoolCreateStarted(name: widget.className));
                    },
                    isValid: selectedTeachers.isNotEmpty,
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  void _toggleTeacherSelection(String teacherId, List<ProfileModel> teachers) {
    setState(() {
      if (_selectedTeacherIds.contains(teacherId)) {
        _selectedTeacherIds.remove(teacherId);
        // Move teacher to unselected list
        unselectedTeachers
            .add(teachers.firstWhere((teacher) => teacher.id == teacherId));
        selectedTeachers.removeWhere((teacher) => teacher.id == teacherId);
      } else {
        _selectedTeacherIds.add(teacherId);
        // Move teacher to selected list
        selectedTeachers
            .add(teachers.firstWhere((teacher) => teacher.id == teacherId));
        unselectedTeachers.removeWhere((teacher) => teacher.id == teacherId);
      }
    });
  }
}
