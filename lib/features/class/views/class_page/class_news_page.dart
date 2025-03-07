import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/config/app_constants.dart';
import '../../../../core/utils/app_text_style.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../post/bloc/post_bloc.dart';
import '../../../post/views/post_list_screen.dart';
import '../../models/class_model.dart';

class ClassNewsPage extends StatelessWidget {
  final ClassModel currentClass;

  const ClassNewsPage({super.key, required this.currentClass});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Center(
        child: RefreshIndicator(
          onRefresh: () => _onRefresh(context),
          child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: const PostListScreen()),
        ),
      ),
    );
  }

  Future<void> _onRefresh(BuildContext context) async {
    context.read<PostBloc>().add(PostFetchStarted());
    await Future.delayed(const Duration(seconds: 1));
  }

  CustomAppBar _buildAppBar(BuildContext context) {
    return CustomAppBar(
      height: Responsive.isMobile(context) ? kToolbarHeight : 70,
      backgroundColor: kWhiteColor,
      title: 'Bảng tin',
      titleStyle:
      Responsive.isMobile(context) ? null : AppTextStyle.bold(kTextSizeXxl),
      leftWidget: InkWell(
        child: const Icon(FontAwesomeIcons.arrowLeft),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
