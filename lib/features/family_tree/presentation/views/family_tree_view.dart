import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphview/GraphView.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:solala/core/constants/app_assets.dart';
import 'package:solala/core/constants/app_colors.dart';
import 'package:solala/core/constants/app_strings.dart';
import 'package:solala/core/constants/app_styles.dart';
import 'package:shimmer/shimmer.dart';
import 'package:solala/core/widgets/error_container.dart';
import 'package:solala/features/family_tree/presentation/widgets/add_member_dialog.dart';

import '../../../../core/widgets/retry_widget.dart';
import '../../data/models/family_model.dart';
import '../manager/family_cubit/family_cubit.dart';
import '../manager/family_cubit/family_state.dart';


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
            style: AppStyles.styleBold18(context)
                .copyWith(color: AppColors.greenColor),
          ),
        ),
        backgroundColor: Colors.transparent,
        body: BlocListener<FamilyTreeCubit, FamilyTreeState>(
          listener: (context, state) {
            if (state is AddFamilyMemberSuccess) {
              context.read<FamilyTreeCubit>().getFamilyTree();
            }
          },
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
                  ..orientation =
                  (BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM);

                if (state.familyTreeModel.data != null) {
                  for (var member in state.familyTreeModel.data!) {
                    _buildGraph(graph, member, null);
                  }
                }

                return InteractiveViewer(
                  constrained: false,
                  boundaryMargin: const EdgeInsets.all(100),
                  minScale: 0.01,
                  maxScale: 5.6,
                  child: GraphView(
                    graph: graph,
                    algorithm:
                    BuchheimWalkerAlgorithm(builder, TreeEdgeRenderer(builder)),
                    paint: Paint()
                      ..color = Colors.green
                      ..strokeWidth = 1
                      ..style = PaintingStyle.stroke,
                    builder: (Node node) {
                      final familyMember = node.key!.value as FamilyMember;
                      return _buildMemberNode(familyMember);
                    },
                  ),
                );
              }
              return const SizedBox.shrink();
            },
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
          ],
        ),
      ],
    );
  }
}
