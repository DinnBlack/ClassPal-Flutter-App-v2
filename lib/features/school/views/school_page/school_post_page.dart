import 'package:classpal_flutter_app/core/widgets/custom_app_bar.dart';
import 'package:classpal_flutter_app/core/widgets/custom_loading_dialog.dart';
import 'package:classpal_flutter_app/features/post/views/post_list_screen.dart';
import 'package:classpal_flutter_app/features/school/models/school_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../../core/config/platform/platform_config.dart';
import '../../../../core/config/app_constants.dart';
import '../../../../core/utils/app_text_style.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/custom_feature_dialog.dart';
import '../../../class/bloc/class_bloc.dart';
import '../../../post/bloc/post_bloc.dart';
import '../../bloc/school_bloc.dart';

class SchoolPostPage extends StatefulWidget {
  final SchoolModel school;
  final bool isTeacherView;

  const SchoolPostPage(
      {super.key, required this.school, this.isTeacherView = false});

  @override
  State<SchoolPostPage> createState() => _SchoolPostPageState();
}

class _SchoolPostPageState extends State<SchoolPostPage> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  void _showFeatureDialog(BuildContext context) {
    showCustomFeatureDialog(
      context,
      [
        'Kết thúc trường học',
      ],
      [
        () {
          _showDeleteClassDialog(context);
        },
      ],
    );
  }

  void _showDeleteClassDialog(BuildContext context) {
    final TextEditingController schoolNameController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xóa trường học'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Nhập lại tên trường học để xác nhận xóa:'),
                const SizedBox(height: 10),
                TextFormField(
                  controller: schoolNameController,
                  decoration:
                      const InputDecoration(labelText: 'Tên trường học'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tên trường học không được để trống';
                    }
                    if (value != widget.school.name) {
                      return 'Tên trường học không khớp';
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
                if (formKey.currentState?.validate() ?? false) {
                  context
                      .read<SchoolBloc>()
                      .add(SchoolDeleteStarted(schoolId: widget.school.id));
                  Navigator.pop(context);
                }
              },
              child: const Text('Xóa trường học'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SchoolBloc, SchoolState>(
      listener: (context, state) {
        if (state is SchoolDeleteInProgress) {
          setState(() {
            _isLoading = true;
          });
          CustomLoadingDialog.show(context);
        } else {
          if (_isLoading) {
            setState(() {
              _isLoading = false;
            });
            CustomLoadingDialog.dismiss(context);
          }
        }

        if (state is SchoolDeleteSuccess) {
          showTopSnackBar(
            Overlay.of(context),
            const CustomSnackBar.success(
              message: 'Xóa trường học thành công!',
            ),
          );
          Navigator.pop(context);
        }

        if (state is SchoolDeleteFailure) {
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(
              message: 'Xóa trường học thất bại: ${state.error}',
            ),
          );
        }
      },
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: RefreshIndicator(
          onRefresh: () => _reFetchPosts(context),
          child: Center(
            // Đảm bảo nội dung ở giữa
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 650),
              child: PostListScreen(
                isTeacherView: widget.isTeacherView,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _reFetchPosts(BuildContext context) async {
    context.read<PostBloc>().add(PostFetchStarted());
  }

  CustomAppBar _buildAppBar(BuildContext context) {
    return CustomAppBar(
      height: Responsive.isMobile(context) ? kToolbarHeight : 70,
      backgroundColor: kWhiteColor,
      title: widget.school.name,
      leftWidget: InkWell(
        child: const Icon(FontAwesomeIcons.arrowLeft),
        onTap: () {
          context.read<ClassBloc>().add(ClassPersonalFetchStarted());
          if (kIsWeb) {
            goBack();
          } else {
            Navigator.pop(context);
          }
        },
      ),
      rightWidget: !widget.isTeacherView ? Responsive.isMobile(context)
          ? InkWell(
              child: const Icon(FontAwesomeIcons.ellipsis),
              onTap: () => _showFeatureDialog(context),
            )
          : GestureDetector(
              onTap: () => _showFeatureDialog(context),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Tùy chọn',
                    style: AppTextStyle.semibold(kTextSizeMd),
                  ),
                  const SizedBox(
                    width: kMarginMd,
                  ),
                  const Icon(
                    FontAwesomeIcons.caretDown,
                  )
                ],
              ),
            ) : null,
      bottomWidget:  !Responsive.isMobile(context) ? Container(
        height: 2,
        width: double.infinity,
        color: kGreyMediumColor,
      ) : null,
      additionalHeight: !Responsive.isMobile(context) ? 2: 0,
    );
  }
}
