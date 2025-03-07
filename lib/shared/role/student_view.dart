import 'package:classpal_flutter_app/core/widgets/custom_dialog.dart';
import 'package:classpal_flutter_app/core/widgets/custom_page_transition.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/utils/app_text_style.dart';
import 'package:classpal_flutter_app/features/auth/repository/auth_service.dart';
import 'package:classpal_flutter_app/features/class/views/class_join_screen.dart';
import 'package:classpal_flutter_app/features/class/views/class_list_screen.dart';
import 'package:classpal_flutter_app/features/post/views/post_list_screen.dart';
import 'package:classpal_flutter_app/features/profile/repository/profile_service.dart';
import '../../features/auth/models/user_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StudentView extends StatefulWidget {
  final UserModel user;

  const StudentView({super.key, required this.user});

  @override
  State<StudentView> createState() => _StudentViewState();
}

class _StudentViewState extends State<StudentView> {
  late Future<List<dynamic>> _profilesFuture;
  late Future<UserModel?> _userFuture;

  @override
  void initState() {
    super.initState();
    _profilesFuture = ProfileService().getUserProfiles();
    _userFuture = AuthService().getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _profilesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Lỗi: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: ClassJoinScreen(
              isStudentView: true,
              onJoinSuccess: () {
                setState(() {
                  _profilesFuture = ProfileService().getUserProfiles();
                });
              },
            ),
          );
        } else {
          return FutureBuilder<UserModel?>(
            future: _userFuture,
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (userSnapshot.hasError || userSnapshot.data == null) {
                return const Center(
                    child: Text('Không thể tải thông tin người dùng.'));
              } else {
                final user = userSnapshot.data!;
                return Scaffold(
                  appBar: AppBar(
                    title: Text('Student View'),
                    actions: [
                      IconButton(
                        icon: const Icon(FontAwesomeIcons.qrcode),
                        onPressed: () {
                          if (kIsWeb) {
                            showCustomDialog(context, const ClassJoinScreen(isStudentView: true));
                          } else {
                            CustomPageTransition.navigateTo(context: context, page: const ClassJoinScreen(isStudentView: true), transitionType: PageTransitionType.slideFromBottom);
                          }

                        },
                      ),
                    ],
                  ),
                  body: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: kMarginXl),
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: kPaddingMd),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: kPrimaryColor,
                                backgroundImage: user.avatarUrl.isNotEmpty
                                    ? NetworkImage(user.avatarUrl)
                                    : const AssetImage(
                                    'assets/images/default_avatar.png')
                                as ImageProvider,
                              ),
                              const SizedBox(height: kMarginXl),
                              Text(
                                'Xin chào, ${user.name}',
                                style: AppTextStyle.bold(kTextSizeLg),
                              ),
                              const SizedBox(height: kMarginXl),
                              const ClassListScreen(
                                isStudentView: true,
                              ),
                              const SizedBox(height: kMarginXl),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Bảng tin',
                                  style: AppTextStyle.bold(kTextSizeLg),
                                ),
                              ),
                              const SizedBox(height: kMarginMd),
                            ],
                          ),
                        ),
                        const PostListScreen(
                          isStudentView: true,
                        ),
                        const SizedBox(height: kMarginXl),
                      ],
                    ),
                  ),
                );
              }
            },
          );
        }
      },
    );
  }
}
