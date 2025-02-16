import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/config/app_constants.dart';
import '../../../../../core/utils/app_text_style.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../bloc/post_bloc.dart';

class PostCreateScreen extends StatefulWidget {
  const PostCreateScreen({super.key});

  @override
  State<PostCreateScreen> createState() => _PostCreateScreenState();
}

class _PostCreateScreenState extends State<PostCreateScreen> {
  final TextEditingController _contentController = TextEditingController();
  List<File> selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  void _addImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedImages.add(File(image.path));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      selectedImages.removeAt(index);
    });
  }

  void _createPost() {
    if (_contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập nội dung bài viết')),
      );
      return;
    }

    // Nếu không có ảnh, truyền null
    File? imageFile = selectedImages.isNotEmpty ? selectedImages.first : null;

     context.read<PostBloc>().add(
      PostCreateStarted(
        imageFile: imageFile,
        content: _contentController.text,
        targetRoles: ['Teacher'],
      ),
    );

    context.read<PostBloc>().add(PostFetchStarted());

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _contentController,
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText: 'Bạn đang nghĩ gì?',
                        border: InputBorder.none,
                      ),
                    ),
                    const SizedBox(height: kMarginLg),
                    GestureDetector(
                      onTap: _addImage,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: kPrimaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.camera_alt, color: kPrimaryColor),
                            const SizedBox(width: 8),
                            Text(
                              'Thêm hình ảnh',
                              style: AppTextStyle.semibold(
                                kTextSizeMd,
                                kPrimaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: kMarginMd),
                    if (selectedImages.isNotEmpty)
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: selectedImages.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  selectedImages[index],
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 5,
                                right: 5,
                                child: GestureDetector(
                                  onTap: () => _removeImage(index),
                                  child: const CircleAvatar(
                                    radius: 14,
                                    backgroundColor: Colors.black54,
                                    child: Icon(
                                      Icons.close,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  CustomAppBar _buildAppBar(BuildContext context) {
    return CustomAppBar(
      title: 'Tạo bài đăng',
      leftWidget: InkWell(
        child: const Icon(FontAwesomeIcons.xmark),
        onTap: () => Navigator.pop(context),
      ),
      rightWidget: GestureDetector(
        onTap: _createPost,
        child: Text(
          'Tạo',
          style: AppTextStyle.semibold(kTextSizeMd, kPrimaryColor),
        ),
      ),
    );
  }
}
