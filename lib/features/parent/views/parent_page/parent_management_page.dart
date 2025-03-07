import 'package:classpal_flutter_app/features/parent/repository/parent_service.dart';
import 'package:flutter/material.dart';

import '../chidren_list_screen.dart';

class ParentManagementPage extends StatefulWidget {
  const ParentManagementPage({super.key});

  @override
  State<ParentManagementPage> createState() => _ParentManagementPageState();
}

class _ParentManagementPageState extends State<ParentManagementPage> {
  @override
  void initState() {
    super.initState();
    ParentService().getChildren();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 600),
        child: const ChildrenListScreen(),
      ),
    );
  }
}
