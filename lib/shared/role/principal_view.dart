import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/widgets/custom_page_transition.dart';
import 'package:classpal_flutter_app/features/auth/models/user_model.dart';
import 'package:classpal_flutter_app/features/class/repository/class_service.dart';
import 'package:classpal_flutter_app/features/class/views/class_create_screen.dart';
import 'package:classpal_flutter_app/features/class/views/class_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/utils/app_text_style.dart';
import '../../features/class/bloc/class_bloc.dart';
import '../../features/school/bloc/school_bloc.dart';
import '../../features/school/views/school_list_screen.dart';

class PrincipalView extends StatefulWidget {
  static const route = 'PrincipalView';
  final UserModel user;

  const PrincipalView({
    super.key,
    required this.user,
  });

  @override
  State<PrincipalView> createState() => _PrincipalViewState();
}

class _PrincipalViewState extends State<PrincipalView> {
  final classService = ClassService();

  Future<void> _prefetchData() async {
    try {
      context.read<SchoolBloc>().add(SchoolFetchStarted());
      context.read<ClassBloc>().add(ClassPersonalFetchStarted());
      setState(() {});
    } catch (e) {
      print("Prefetch error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
      child: RefreshIndicator(
        onRefresh: _prefetchData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(), // Để có thể kéo xuống ngay cả khi nội dung ít
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: kMarginLg),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Trường học', style: AppTextStyle.semibold(kTextSizeMd)),
                  GestureDetector(
                    onTap: () {
                      context.push('/school/create');
                    },
                    child: Text('+ Thêm trường học', style: AppTextStyle.semibold(kTextSizeSm, kPrimaryColor)),
                  ),
                ],
              ),
              const SizedBox(height: kMarginLg),
              const SchoolListScreen(),
              const SizedBox(height: kMarginLg),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Lớp học cá nhân', style: AppTextStyle.semibold(kTextSizeMd)),
                  GestureDetector(
                    onTap: () {
                      CustomPageTransition.navigateTo(
                        context: context,
                        page: const ClassCreateScreen(),
                        transitionType: PageTransitionType.slideFromBottom,
                      );
                    },
                    child: Text('+ Thêm lớp học', style: AppTextStyle.semibold(kTextSizeSm, kPrimaryColor)),
                  ),
                ],
              ),
              const SizedBox(height: kMarginLg),
              const ClassListScreen(),
              const SizedBox(height: kMarginLg),
            ],
          ),
        ),
      ),
    );
  }
}
