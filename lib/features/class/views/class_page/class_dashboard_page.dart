import 'package:classpal_flutter_app/core/widgets/custom_button.dart';
import 'package:classpal_flutter_app/core/widgets/custom_loading_dialog.dart';
import 'package:classpal_flutter_app/features/class/views/class_information_screen.dart';
import 'package:classpal_flutter_app/features/profile/model/profile_model.dart';
import 'package:classpal_flutter_app/features/student/bloc/student_bloc.dart';
import 'package:classpal_flutter_app/features/student/sub_features/group/bloc/group_bloc.dart';
import 'package:classpal_flutter_app/features/student/views/student_create_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/config/app_constants.dart';
import '../../../../core/utils/app_text_style.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_page_transition.dart';
import '../../../student/sub_features/group/views/group_list_screen.dart';
import '../../../student/views/student_list_screen.dart';
import '../../bloc/class_bloc.dart';
import '../../models/class_model.dart';
import '../../repository/class_service.dart';
import '../../sub_features/roll_call/views/roll_call_report_screen.dart';
import '../../sub_features/subject/views/subject_screen.dart';
import '../class_connect/class_connect_screen.dart';
import '../class_management_screen.dart';
import '../../../../core/widgets/custom_feature_dialog.dart';

class ClassDashboardPage extends StatefulWidget {
  final ClassModel currentClass;

  const ClassDashboardPage({super.key, required this.currentClass});

  @override
  State<ClassDashboardPage> createState() => _ClassDashboardPageState();
}

class _ClassDashboardPageState extends State<ClassDashboardPage> {
  final classService = ClassService();

  void _showFeatureDialog(BuildContext context) {
    showCustomFeatureDialog(
      context,
      [
        'Kết nối gia đình',
        'Kết nối học sinh',
        'Thêm giáo viên',
        'Học sinh',
        'Môn học',
        'Báo cáo',
        'Thông tin lớp học',
        'Kết thúc lớp học'
      ],
      [
        () {
          CustomPageTransition.navigateTo(
            context: context,
            page: const ClassConnectScreen(
              pageIndex: 0,
            ),
            transitionType: PageTransitionType.slideFromBottom,
          );
        },
        () {
          CustomPageTransition.navigateTo(
            context: context,
            page: const ClassConnectScreen(
              pageIndex: 1,
            ),
            transitionType: PageTransitionType.slideFromBottom,
          );
        },
        () {
          CustomPageTransition.navigateTo(
            context: context,
            page: const ClassConnectScreen(
              pageIndex: 2,
            ),
            transitionType: PageTransitionType.slideFromBottom,
          );
        },
        () {
          CustomPageTransition.navigateTo(
            context: context,
            page: const StudentCreateScreen(),
            transitionType: PageTransitionType.slideFromBottom,
          );
        },
        () {
          CustomPageTransition.navigateTo(
            context: context,
            page: const SubjectScreen(),
            transitionType: PageTransitionType.slideFromBottom,
          );
        },
        () {
          CustomPageTransition.navigateTo(
            context: context,
            page: const RollCallReportScreen(),
            transitionType: PageTransitionType.slideFromBottom,
          );
        },
        () {
          CustomPageTransition.navigateTo(
            context: context,
            page: ClassInformationScreen(
              currentClass: widget.currentClass,
            ),
            transitionType: PageTransitionType.slideFromBottom,
          );
        },
        () {
          _showDeleteClassDialog(context);
        },
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<StudentBloc>().add(StudentFetchStarted());
    context.read<GroupBloc>().add(GroupFetchStarted());
  }

  void _showDeleteClassDialog(BuildContext context) {
    final TextEditingController classNameController = TextEditingController();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xóa lớp học'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Nhập lại tên lớp học để xác nhận xóa:'),
                const SizedBox(height: 10),
                TextFormField(
                  controller: classNameController,
                  decoration: const InputDecoration(labelText: 'Tên lớp học'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tên lớp học không được để trống';
                    }
                    if (value != widget.currentClass.name) {
                      return 'Tên lớp học không khớp';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  context.read<ClassBloc>().add(ClassDeleteStarted(
                      classId: widget.currentClass.id));
                  Navigator.pop(context);
                  Navigator.pop(context);
                }
              },
              child: const Text('Xóa lớp học'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<StudentBloc, StudentState>(
        builder: (context, state) {
          List<ProfileModel> students = [];

          if (state is StudentFetchInProgress) {
            return Scaffold(
              appBar: _buildAppBar(context, students),
            );
          } else if (state is StudentFetchSuccess) {
            students = state.students;
          }

          return Scaffold(
            appBar: _buildAppBar(context, students),
            body: students.isEmpty
                ? _buildEmptyStudentView()
                : _buildStudentListView(),
          );
        },
        listener: (context, state) {
          if (state is StudentFetchInProgress) {
            CustomLoadingDialog.show(
                context);
          } else if (state is StudentFetchFailure ||
              state is StudentFetchSuccess) {
            CustomLoadingDialog.dismiss(context);
          }
        },
      ),
    );
  }

  Widget _buildEmptyStudentView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/empty_student.png',
              height: 200,
            ),
            const SizedBox(height: kMarginLg),
            Text(
              'Thêm học sinh của bạn nào!',
              style: AppTextStyle.bold(kTextSizeLg),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: kMarginSm),
            Text(
              'Khiến học sinh thu hút với phản hồi tức thời và bắt đầu xây dựng cộng đồng lớp học của mình nào',
              style: AppTextStyle.medium(kTextSizeXs),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: kMarginLg),
            CustomButton(
              text: 'Thêm học viên',
              onTap: () {
                CustomPageTransition.navigateTo(
                  context: context,
                  page: const StudentCreateScreen(),
                  transitionType: PageTransitionType.slideFromBottom,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentListView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: kMarginMd,
          ),
          const StudentListScreen(),
          const SizedBox(
            height: kMarginLg,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
            child: Text(
              'Nhóm',
              style: AppTextStyle.semibold(kTextSizeMd),
            ),
          ),
          const SizedBox(
            height: kMarginLg,
          ),
          const GroupListScreen(),
          const SizedBox(
            height: kMarginLg,
          ),
        ],
      ),
    );
  }

  CustomAppBar _buildAppBar(BuildContext context, List<ProfileModel> students) {
    return CustomAppBar(
      backgroundColor: kWhiteColor,
      title: widget.currentClass.name,
      leftWidget: InkWell(
        child: const Icon(FontAwesomeIcons.arrowLeft),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      rightWidget: InkWell(
        child: const Icon(FontAwesomeIcons.ellipsis),
        onTap: () => _showFeatureDialog(context),
      ),
      bottomWidget: students.isNotEmpty
          ? ClassManagementScreen(isHorizontal: true)
          : null,
      additionalHeight: students.isNotEmpty ? 55 : 0,
    );
  }
}
