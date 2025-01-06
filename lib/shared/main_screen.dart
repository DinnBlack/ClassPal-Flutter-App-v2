import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/widgets/custom_avatar.dart';
import 'package:classpal_flutter_app/features/class/views/class_join_screen.dart';
import 'package:classpal_flutter_app/features/school/views/school_join_screen.dart';
import 'package:classpal_flutter_app/features/school/views/school_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../core/utils/app_text_style.dart';
import '../core/widgets/custom_app_bar.dart';
import '../core/widgets/custom_list_item.dart';
import '../features/class/views/class_create_screen.dart';
import '../features/class/views/class_screen.dart';

class MainScreen extends StatelessWidget {
  static const route = 'MainScreen';

  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: const CustomAppBar(
        backgroundColor: kWhiteColor,
        title: 'CLASSPAL',
        titleStyle: TextStyle(
            fontFamily: 'ZenDots',
            color: kPrimaryColor,
            fontSize: 16,
            fontWeight: FontWeight.bold),
        leftWidget: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomAvatar(
              text: 'Đinh Hoàng Phúc',
              size: 30,
            ),
            SizedBox(
              width: kMarginSm,
            ),
            Icon(FontAwesomeIcons.chevronDown, size: 16,)
          ],
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: kMarginLg,
            ),
            Text(
              'Trường học',
              style: AppTextStyle.semibold(kTextSizeMd),
            ),
            const SizedBox(
              height: kMarginLg,
            ),
            CustomListItem(
              title: 'Trường tiểu học A Long Bình',
              subtitle: 'Giáo viên',
              leading: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: kGreenColor,
                  shape: BoxShape.circle,
                ),
              ),
              onTap: () => Navigator.pushNamed(context, SchoolScreen.route),
            ),
            const SizedBox(
              height: kMarginLg,
            ),
            CustomListItem(
              title: 'Tham gia trường của bạn',
              subtitle: 'Nhận quyền truy cập các tính năng trường',
              leading: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: kOrangeColor,
                  shape: BoxShape.circle,
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, SchoolJoinScreen.route);
              },
            ),
            const SizedBox(
              height: kMarginXl,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Lớp học cá nhân',
                  style: AppTextStyle.semibold(kTextSizeMd),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      ClassCreateScreen.route,
                    );
                  },
                  child: Text(
                    '+ Thêm lớp học',
                    style: AppTextStyle.semibold(kTextSizeSm, kPrimaryColor),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: kMarginLg,
            ),
            CustomListItem(
              title: 'Lớp toán nâng cao',
              subtitle: 'Giáo viên chính',
              leading: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: kRedColor,
                  shape: BoxShape.circle,
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, ClassScreen.route);
              },
            ),
            const SizedBox(
              height: kMarginLg,
            ),
            CustomListItem(
              title: 'Lớp hóa cơ bản',
              subtitle: 'Đồng giáo viên',
              leading: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: kPrimaryLightColor,
                  shape: BoxShape.circle,
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, ClassScreen.route);
              },
            ),
            const SizedBox(
              height: kMarginLg,
            ),
            CustomListItem(
              title: 'Tham gia lớp học',
              subtitle: 'Nhận quyền truy cập các tính năng lớp học',
              leading: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: kGreyColor,
                  shape: BoxShape.circle,
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, ClassJoinScreen.route);
              },
            ),
          ],
        ),
      )),
    );
  }
}
