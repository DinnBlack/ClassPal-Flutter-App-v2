import 'package:classpal_flutter_app/core/widgets/custom_page_transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/config/app_constants.dart';
import '../bloc/group_bloc.dart';
import 'student_group_create_screen.dart';
import 'widgets/custom_student_group_list_item.dart';

class StudentGroupListScreen extends StatefulWidget {
  const StudentGroupListScreen({super.key});

  @override
  State<StudentGroupListScreen> createState() => _StudentGroupListScreenState();
}

class _StudentGroupListScreenState extends State<StudentGroupListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GroupBloc>().add(GroupFetchStarted());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
      child: BlocBuilder<GroupBloc, GroupState>(
        builder: (context, state) {
          if (state is GroupFetchInProgress) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GroupFetchSuccess) {
            final groupData = state.groupsWithStudents;
            return LayoutBuilder(
              builder: (context, constraints) {
                double itemHeight = 105;
                double itemWidth = (constraints.maxWidth - (2 - 1) * 8.0) / 2;

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: kPaddingMd,
                    mainAxisSpacing: kPaddingMd,
                    childAspectRatio: itemWidth / itemHeight,
                  ),
                  itemCount: groupData.length + 1,
                  itemBuilder: (context, index) {
                    if (index < groupData.length) {
                      final group = groupData[index];
                      return CustomStudentGroupListItem(groupWithStudents: group);
                    } else {
                      return CustomStudentGroupListItem(
                        addItem: true,
                        onTap: () {
                          CustomPageTransition.navigateTo(
                            context: context,
                            page: const StudentGroupCreateScreen(),
                            transitionType: PageTransitionType.slideFromRight,
                          );
                        },
                      );
                    }
                  },
                );
              },
            );
          } else if (state is GroupFetchFailure) {
            return const Center(child: Text('Failed to load groups'));
          }
          return Container();
        },
      ),
    );
  }
}
