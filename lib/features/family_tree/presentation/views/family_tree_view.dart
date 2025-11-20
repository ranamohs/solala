import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphview/GraphView.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:solala/core/constants/app_assets.dart';
import 'package:solala/core/constants/app_colors.dart';
import 'package:solala/core/constants/app_strings.dart';
import 'package:solala/core/constants/app_styles.dart';
import 'package:solala/features/family_tree/presentation/widgets/add_member_dialog.dart';

import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/retry_widget.dart';
import '../../data/models/family_model.dart';
import '../manager/family_cubit/family_cubit.dart';
import '../manager/family_cubit/family_state.dart';
import '../widgets/update_menmber_dialog.dart';


class FamilyTreeView extends StatefulWidget {
  const FamilyTreeView({super.key});

  @override
  State<FamilyTreeView> createState() => _FamilyTreeViewState();
}

class _FamilyTreeViewState extends State<FamilyTreeView> {
  @override
  void initState() {
    super.initState();
    context.read<FamilyTreeCubit>().getFamilyTree();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppAssets.homeBackground),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            AppStrings.familyTree.tr(),
            style: AppStyles.styleBold20(context)
                .copyWith(color: AppColors.greenColor),
          ),
        ),
        backgroundColor: Colors.transparent,
        body: BlocListener<FamilyTreeCubit, FamilyTreeState>(
          listener: (context, state) {
            if (state is AddFamilyMemberSuccess ||
                state is UpdateFamilyMemberSuccess ||
                state is DeleteFamilyMemberSuccess) {
              context.read<FamilyTreeCubit>().getFamilyTree();
            }
          },
          child: RefreshIndicator(
            backgroundColor: AppColors.primaryColor,
            color: AppColors.greenColor,
            onRefresh: () async {
              context.read<FamilyTreeCubit>().getFamilyTree();
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: BlocBuilder<FamilyTreeCubit, FamilyTreeState>(
                    buildWhen: (previous, current) {
                      return current is! AddFamilyMemberLoading &&
                          current is! AddFamilyMemberFailure;
                    },
                    builder: (context, state) {
                      if (state is FamilyTreeLoading) {
                        return Center(
                          child: LoadingAnimationWidget.flickr(
                            leftDotColor: AppColors.primaryColor,
                            rightDotColor: AppColors.greenColor,
                            size: 64,
                          ),
                        );
                      } else if (state is FamilyTreeFailure) {
                        return Center(
                          child: RetryWidget(
                            message: state.failure.errMessage,
                            onPressed: () {
                              context.read<FamilyTreeCubit>().getFamilyTree();
                            },
                          ),
                        );
                      } else if (state is FamilyTreeSuccess) {
                        final graph = Graph();
                        final BuchheimWalkerConfiguration builder =
                        BuchheimWalkerConfiguration()
                          ..siblingSeparation = (50)
                          ..levelSeparation = (50)
                          ..subtreeSeparation = (50)
                          ..orientation = (BuchheimWalkerConfiguration
                              .ORIENTATION_TOP_BOTTOM);

                        if (state.familyTreeModel.data == null ||
                            state.familyTreeModel.data!.isEmpty) {
                          return Center(
                            child: Text(
                              AppStrings.noMembersFoundTillNow.tr(),
                              style: AppStyles.styleMedium18(context).copyWith(
                                color: AppColors.secondaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }
                        for (var member in state.familyTreeModel.data!) {
                          _buildGraph(graph, member, null);
                        }

                        return GestureDetector(
                          onHorizontalDragStart: (details) {},
                          child: InteractiveViewer(
                            constrained: false,
                            boundaryMargin: const EdgeInsets.all(100),
                            minScale: 0.01,
                            maxScale: 5.6,
                            child: GraphView(
                              graph: graph,
                              algorithm: BuchheimWalkerAlgorithm(
                                  builder, TreeEdgeRenderer(builder)),
                              paint: Paint()
                                ..color = Colors.green
                                ..strokeWidth = 1
                                ..style = PaintingStyle.stroke,
                              builder: (Node node) {
                                final familyMember =
                                node.key!.value as FamilyMember;
                                return _buildMemberNode(familyMember);
                              },
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _buildGraph(Graph graph, FamilyMember member, FamilyMember? parent) {
    final node = Node.Id(member);
    graph.addNode(node);

    if (parent != null) {
      final parentNode = Node.Id(parent);
      graph.addEdge(parentNode, node);
    }

    if (member.children != null) {
      for (var child in member.children!) {
        _buildGraph(graph, child, member);
      }
    }
  }

  Widget _buildMemberNode(FamilyMember member) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: CachedNetworkImageProvider(
            member.avatar ?? '',
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              member.name ?? '',
              style: AppStyles.styleRegular14(context),
            ),
            const SizedBox(
              width: 5,
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => BlocProvider.value(
                    value: context.read<FamilyTreeCubit>(),
                    child: AddMemberDialog(
                      parentId: member.id!,
                    ),
                  ),
                );
              },
              child: const Icon(
                Icons.add_circle,
                color: AppColors.greenColor,
                size: 20,
              ),
            ),
            SizedBox(
              width: 5.w,
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => BlocProvider.value(
                    value: context.read<FamilyTreeCubit>(),
                    child: UpdateMemberDialog(
                      member: member,
                    ),
                  ),
                );
              },
              child: const Icon(
                Icons.edit,
                color: AppColors.primaryColor,
                size: 20,
              ),
            ),
            SizedBox(
              width: 5.w,
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext dialogContext) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Icon
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.delete_outline,
                                color: Colors.red.shade400,
                                size: 32,
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Title
                            Text(
                              AppStrings.deleteMember.tr(),
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Content
                            Text(
                              AppStrings.deleteMemberTitle.tr(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey.shade600,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Buttons
                            Row(
                              children: [
                                Expanded(
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.of(dialogContext).pop();
                                    },
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        side: BorderSide(color: Colors.grey.shade300),
                                      ),
                                    ),
                                    child: Text(
                                      AppStrings.cancel.tr(),
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child:   PrimaryButton(
                                    onPressed: () {
                                      context
                                          .read<FamilyTreeCubit>()
                                          .deleteFamilyMember(memberId: member.id!);
                                      Navigator.of(dialogContext).pop();
                                    },
                                    text: AppStrings.delete.tr(),
                                  ),
                                ),

                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: Icon(
                Icons.delete,
                color: Colors.red,
                size: 16.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }

}
