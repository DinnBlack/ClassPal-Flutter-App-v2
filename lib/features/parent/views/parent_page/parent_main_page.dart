import 'package:flutter/material.dart';
import '../../../post/views/post_list_screen.dart';

class ParentMainPage extends StatefulWidget {
  const ParentMainPage({super.key});

  @override
  State<ParentMainPage> createState() => _ParentMainPageState();
}

class _ParentMainPageState extends State<ParentMainPage> {
  @override
  Widget build(BuildContext context) {
    return const PostListScreen(isParentView: true);
  }
}
