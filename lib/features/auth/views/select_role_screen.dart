import 'package:classpal_flutter_app/features/auth/models/user_model.dart';
import 'package:classpal_flutter_app/features/auth/views/widgets/custom_select_role_item.dart';
import 'package:classpal_flutter_app/shared/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/utils/app_text_style.dart';

class SelectRoleScreen extends StatefulWidget {
  static const route = 'SelectRoleScreen';
  final UserModel user;

  const SelectRoleScreen({super.key, required this.user});

  @override
  State<SelectRoleScreen> createState() => _SelectRoleScreenState();
}

class _SelectRoleScreenState extends State<SelectRoleScreen> {
  @override
  Widget build(BuildContext context) {
    print(widget.user);
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kPaddingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: kMarginXxl,
                ),
                Center(
                  child: Image.asset(
                    'assets/images/classpal_logo.png',
                    width: 150,
                  ),
                ),
                const SizedBox(
                  height: kMarginXxl,
                ),
                Text(
                  'Lựa chọn quyền của bạn',
                  style: AppTextStyle.semibold(kTextSizeMd, kGreyColor),
                ),
                Text(
                  'Bạn là ?',
                  style: AppTextStyle.semibold(kTextSizeXxl),
                ),
                const SizedBox(
                  height: kMarginLg,
                ),
                CustomSelectRoleItem(
                  title: 'Ban giám hiệu',
                  subTitle: 'Quản lý trường học của bạn',
                  image: 'directors_role.png',
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      MainScreen.route,
                      arguments: {'user': widget.user, 'role': 'principal'},
                    );
                  },
                ),
                const SizedBox(
                  height: kMarginLg,
                ),
                CustomSelectRoleItem(
                  title: 'Giáo viên',
                  subTitle: 'Tạo và quản lý lớp học của bạn',
                  image: 'teacher_role.png',
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      MainScreen.route,
                      arguments: {'user': widget.user, 'role': 'teacher'},
                    );
                  },
                ),
                const SizedBox(
                  height: kMarginLg,
                ),
                CustomSelectRoleItem(
                  title: 'Phụ huynh',
                  subTitle: 'Kết nối với các con của bạn',
                  image: 'parent_role.png',
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      MainScreen.route,
                      arguments: {'user': widget.user, 'role': 'parent'},
                    );
                  },
                ),
                const SizedBox(
                  height: kMarginLg,
                ),
                CustomSelectRoleItem(
                  title: 'Học sinh',
                  subTitle: 'Tham gia học tập lớp học của bạn',
                  image: 'student_role.png',
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      MainScreen.route,
                      arguments: {'user': widget.user, 'role': 'student'},
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
