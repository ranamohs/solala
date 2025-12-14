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
import 'package:solala/core/databases/cache/user_data_manager.dart';
import 'package:solala/core/services/service_locator.dart';
import 'package:solala/features/family_tree/presentation/views/provider_family_tree_view.dart';
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
  final GlobalKey _graphKey = GlobalKey();
  final TransformationController _transformationController =
  TransformationController();

  @override
  void initState() {
    super.initState();
    context.read<FamilyTreeCubit>().getFamilyTree();
  }

  void _centerGraph(Size? graphSize, Size viewportSize) {
    if (graphSize == null) return;
    final double scale = viewportSize.width / graphSize.width;
    final double xOffset = (viewportSize.width - graphSize.width * scale) / 2;
    final double yOffset = (viewportSize.height - graphSize.height * scale) / 2;
    _transformationController.value = Matrix4.identity()
      ..translate(xOffset, yOffset)
      ..scale(scale);
  }

  @override
  Widget build(BuildContext context) {
    final accountType = getIt<UserDataManager>().getAccountType();

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
                  List<FamilyMember> members =
                  List.from(state.familyTreeModel.data ?? []);

                  if (accountType == 'provider' && members.isEmpty) {
                    return const ProviderFamilyView();
                  }

                  if (members.isEmpty) {
                    final familyName =
                    getIt<UserDataManager>().getUserFamilyName();
                    final familyId =
                    getIt<UserDataManager>().getUserFamilyId();

                    // إذا كانت القائمة فارغة، نعرض عضو افتراضي مع اسم العائلة
                    if (familyName != null && familyName.isNotEmpty) {
                      final familyRoot = FamilyMember(
                        id: 0,
                        name: familyName,
                        avatar: getIt<UserDataManager>().getUserAvatarUrl() ?? '',

                      );

                      members.add(familyRoot);

                      final graph = Graph();
                      final BuchheimWalkerConfiguration builder =
                      BuchheimWalkerConfiguration()
                        ..siblingSeparation = (100)
                        ..levelSeparation = (150)
                        ..subtreeSeparation = (150)
                        ..orientation =
                        (BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM);

                      _buildGraph(graph, familyRoot, null);

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        final RenderBox? graphRenderBox =
                        _graphKey.currentContext?.findRenderObject() as RenderBox?;
                        final RenderBox? viewportRenderBox =
                        context.findRenderObject() as RenderBox?;

                        if (graphRenderBox != null && viewportRenderBox != null) {
                          _centerGraph(graphRenderBox.size, viewportRenderBox.size);
                        }
                      });

                      return GestureDetector(
                        onHorizontalDragStart: (details) {},
                        child: InteractiveViewer(
                          transformationController: _transformationController,
                          constrained: false,
                          boundaryMargin: const EdgeInsets.all(double.infinity),
                          minScale: 0.01,
                          maxScale: 5.6,
                          child: GraphView(
                            key: _graphKey,
                            graph: graph,
                            algorithm: BuchheimWalkerAlgorithm(
                                builder, TreeEdgeRenderer(builder)),
                            paint: Paint()
                              ..color = Colors.green
                              ..strokeWidth = 1
                              ..style = PaintingStyle.stroke,
                            builder: (Node node) {
                              final familyMember = node.key!.value as FamilyMember;
                              return _buildMemberNode(
                                familyMember,
                                isEmptyTree: true,
                                familyId: familyId,
                              );
                            },
                          ),
                        ),
                      );
                    } else {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage:
                              AssetImage(AppAssets.accountIcon),
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              AppStrings.noMembersFoundTillNow.tr(),
                              style: AppStyles.styleMedium18(context).copyWith(
                                color: AppColors.secondaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              "Please add family information".tr(),
                              style: AppStyles.styleRegular14(context).copyWith(
                                color: AppColors.greyColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  }

                  final graph = Graph();
                  final BuchheimWalkerConfiguration builder =
                  BuchheimWalkerConfiguration()
                    ..siblingSeparation = (100)
                    ..levelSeparation = (150)
                    ..subtreeSeparation = (150)
                    ..orientation =
                    (BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM);

                  for (var member in members) {
                    _buildGraph(graph, member, null);
                  }

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    final RenderBox? graphRenderBox =
                    _graphKey.currentContext?.findRenderObject() as RenderBox?;
                    final RenderBox? viewportRenderBox =
                    context.findRenderObject() as RenderBox?;

                    if (graphRenderBox != null && viewportRenderBox != null) {
                      _centerGraph(graphRenderBox.size, viewportRenderBox.size);
                    }
                  });

                  return GestureDetector(
                    onHorizontalDragStart: (details) {},
                    child: InteractiveViewer(
                      transformationController: _transformationController,
                      constrained: false,
                      boundaryMargin: const EdgeInsets.all(double.infinity),
                      minScale: 0.01,
                      maxScale: 5.6,
                      child: GraphView(
                        key: _graphKey,
                        graph: graph,
                        algorithm: BuchheimWalkerAlgorithm(
                            builder, TreeEdgeRenderer(builder)),
                        paint: Paint()
                          ..color = Colors.green
                          ..strokeWidth = 1
                          ..style = PaintingStyle.stroke,
                        builder: (Node node) {
                          final familyMember = node.key!.value as FamilyMember;
                          final familyId =
                          getIt<UserDataManager>().getUserFamilyId();
                          return _buildMemberNode(
                            familyMember,
                            familyId: familyId,
                          );
                        },
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
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

  Widget _buildMemberNode(
      FamilyMember member, {
        bool isEmptyTree = false,
        String? familyId,
      }) {
    ImageProvider backgroundImage;
    if (member.avatar != null && member.avatar!.isNotEmpty) {
      backgroundImage = CachedNetworkImageProvider(member.avatar!);
    } else {
      backgroundImage = AssetImage(AppAssets.accountIcon);
    }
    final familyId =
    getIt<UserDataManager>().getUserFamilyId();
    return Column(
      children: [
        CircleAvatar(
          radius: isEmptyTree ? 40 : 40,
          backgroundImage: backgroundImage,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              member.name ?? '',
              style: isEmptyTree
                  ? AppStyles.styleSemiBold14(context).copyWith(color: AppColors.greenColor)
                  : AppStyles.styleRegular14(context),
            ),
            const SizedBox(width: 5),
            if (isEmptyTree && member.id == 0)

              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (familyId != null) {
                        showDialog(
                          context: context,
                          builder: (_) => BlocProvider.value(
                            value: context.read<FamilyTreeCubit>(),
                            child: AddMemberDialog(
                              parentId:null,
                            ),
                          ),
                        );
                      }
                    },
                    child: Icon(
                      Icons.add_circle,
                      color: AppColors.greenColor,
                      size: 24,
                    ),
                  ),

                ],
              )
            else if (member.id == 0)
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
                child: Icon(
                  Icons.add_circle,
                  color: AppColors.greenColor,
                  size: 20,
                ),
              )
            else
            // للأعضاء العاديين
              Row(
                children: [
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
                    child: Icon(
                      Icons.add_circle,
                      color: AppColors.greenColor,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 5.w),
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
                    child: Icon(
                      Icons.edit,
                      color: AppColors.primaryColor,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 5.w),
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

                                  Text(
                                    AppStrings.deleteMember.tr(),
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                  const SizedBox(height: 12),

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

                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextButton(
                                          onPressed: () {
                                            Navigator.of(dialogContext).pop();
                                          },
                                          style: TextButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 14),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(12),
                                              side: BorderSide(
                                                  color: Colors.grey.shade300),
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
                                        child: PrimaryButton(
                                          onPressed: () {
                                            context
                                                .read<FamilyTreeCubit>()
                                                .deleteFamilyMember(
                                                memberId: member.id!);
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
        ),
      ],
    );
  }
}