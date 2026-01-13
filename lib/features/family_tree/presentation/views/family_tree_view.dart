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
import 'package:solala/features/family_tree/presentation/widgets/add_member_dialog.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/retry_widget.dart';
import '../../data/models/family_model.dart';
import '../manager/family_cubit/family_cubit.dart';
import '../manager/family_cubit/family_state.dart';
import '../widgets/member_details_dialog.dart';
import '../widgets/update_menmber_dialog.dart';
import 'provider_family_tree_view.dart';

class FamilyTreeView extends StatefulWidget {
  const FamilyTreeView({super.key});

  @override
  State<FamilyTreeView> createState() => _FamilyTreeViewState();
}

class _FamilyTreeViewState extends State<FamilyTreeView> {
  final GlobalKey _graphKey = GlobalKey();
  final TransformationController _transformationController =
  TransformationController();
  final Map<int, bool> _expandedNodes = {};
  final TextEditingController _searchController = TextEditingController();
  Map<int, FamilyMember> _memberMap = {};

  @override
  void initState() {
    super.initState();
    context.read<FamilyTreeCubit>().getFamilyTree();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  void _centerGraph(Size? graphSize, Size viewportSize) {
    if (graphSize == null) return;
    final double scale = viewportSize.width / graphSize.width;
    final double xOffset = (viewportSize.width - graphSize.width * scale) / 2;
    final double yOffset =
        (viewportSize.height - graphSize.height * scale) / 2;
    _transformationController.value = Matrix4.identity()
      ..translate(xOffset, yOffset)
      ..scale(scale);
  }

  void _initializeExpansionState(List<FamilyMember> memberList) {
    for (var member in memberList) {
      if (member.children != null && member.children!.isNotEmpty) {
        _expandedNodes.putIfAbsent(member.id!, () => false);
        _initializeExpansionState(member.children!);
      }
    }
  }

  void _buildMemberMap(List<FamilyMember> members) {
    for (var member in members) {
      if (member.id != null) {
        _memberMap[member.id!] = member;
      }
      if (member.children != null) {
        _buildMemberMap(member.children!);
      }
    }
  }

  void _buildParentMap(
      FamilyMember member, FamilyMember? parent, Map<int, FamilyMember> map) {
    if (parent != null && member.id != null) {
      map[member.id!] = parent;
    }
    if (member.children != null) {
      for (var child in member.children!) {
        _buildParentMap(child, member, map);
      }
    }
  }

  Set<int> _getNodesToDisplay(
      List<int> searchResultIds, List<FamilyMember> fullTree) {
    final nodesToDisplay = Set<int>.from(searchResultIds);
    final parentMap = <int, FamilyMember>{};

    for (var member in fullTree) {
      _buildParentMap(member, null, parentMap);
    }

    for (var id in searchResultIds) {
      var current = parentMap[id];
      while (current != null) {
        if (current.id != null) {
          nodesToDisplay.add(current.id!);
        }
        current = parentMap[current.id];
      }
    }
    return nodesToDisplay;
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
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: AppStrings.search.tr(),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      context.read<FamilyTreeCubit>().clearSearch();
                    },
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (query) {
                  if (query.trim().isNotEmpty) {
                    context
                        .read<FamilyTreeCubit>()
                        .searchFamilyTree(query: query);
                  } else {
                    context.read<FamilyTreeCubit>().clearSearch();
                  }
                },
              ),
            ),
            Expanded(
              child: MultiBlocListener(
                listeners: [
                  BlocListener<FamilyTreeCubit, FamilyTreeState>(
                    listener: (context, state) {
                      if (state is AddFamilyMemberSuccess ||
                          state is UpdateFamilyMemberSuccess ||
                          state is DeleteFamilyMemberSuccess) {
                        context.read<FamilyTreeCubit>().getFamilyTree();
                      }
                      if (state is FamilyTreeSuccess) {
                        _initializeExpansionState(
                            state.familyTreeModel.data ?? []);
                        _memberMap.clear();
                        _buildMemberMap(state.familyTreeModel.data ?? []);
                      }
                    },
                  ),
                  BlocListener<FamilyTreeCubit, FamilyTreeState>(
                    listener: (context, state) {
                      if (state is GetFamilyMemberDetailsLoading) {
                        showDialog(
                          context: context,
                          builder: (_) =>
                          const Center(child: CircularProgressIndicator()),
                        );
                      } else if (state is GetFamilyMemberDetailsSuccess) {
                        Navigator.of(context).pop();
                        showDialog(
                          context: context,
                          builder: (_) =>
                              MemberDetailsDialog(member: state.memberDetailsModel),
                        );
                      } else if (state is GetFamilyMemberDetailsFailure) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.failure.errMessage)),
                        );
                      }
                    },
                  ),
                ],
                child: RefreshIndicator(
                  backgroundColor: AppColors.primaryColor,
                  color: AppColors.greenColor,
                  onRefresh: () async {
                    context.read<FamilyTreeCubit>().getFamilyTree();
                    _searchController.clear();
                  },
                  child: BlocBuilder<FamilyTreeCubit, FamilyTreeState>(
                    builder: (context, state) {
                      if (state is FamilyTreeLoading) {
                        return Center(
                          child: LoadingAnimationWidget.flickr(
                            leftDotColor: AppColors.primaryColor,
                            rightDotColor: AppColors.greenColor,
                            size: 64,
                          ),
                        );
                      }
                      if (state is FamilyTreeFailure) {
                        return Center(
                          child: RetryWidget(
                            message: state.failure.errMessage,
                            onPressed: () {
                              context.read<FamilyTreeCubit>().getFamilyTree();
                            },
                          ),
                        );
                      }
                      if (state is FamilyTreeSuccess) {
                        List<FamilyMember> members =
                        List.from(state.familyTreeModel.data ?? []);
                        final searchIds = state.searchResultIds;

                        if (members.isEmpty) {
                          return _buildEmptyState();
                        }

                        final graph = Graph();
                        final builder = BuchheimWalkerConfiguration()
                          ..siblingSeparation = (100)
                          ..levelSeparation = (150)
                          ..subtreeSeparation = (150)
                          ..orientation = (BuchheimWalkerConfiguration
                              .ORIENTATION_TOP_BOTTOM);

                        Set<int>? nodesToDisplay;
                        if (searchIds != null && searchIds.isNotEmpty) {
                          nodesToDisplay = _getNodesToDisplay(searchIds, members);
                          for (var member in members) {
                            _buildFilteredGraph(
                                graph, member, null, nodesToDisplay);
                          }
                        } else {
                          for (var member in members) {
                            _buildGraph(graph, member, null);
                          }
                        }

                        if (graph.nodeCount == 0 && searchIds != null) {
                          return Center(child: Text(AppStrings.noDataFound.tr()));
                        }

                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted) {
                            final RenderBox? graphRenderBox = _graphKey
                                .currentContext
                                ?.findRenderObject() as RenderBox?;
                            final RenderBox? viewportRenderBox =
                            context.findRenderObject() as RenderBox?;
                            if (graphRenderBox != null &&
                                viewportRenderBox != null) {
                              _centerGraph(
                                  graphRenderBox.size, viewportRenderBox.size);
                            }
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
                                final familyMember =
                                node.key!.value as FamilyMember;
                                return _buildMemberNode(
                                  member: familyMember,
                                  familyId:
                                  getIt<UserDataManager>().getUserFamilyId(),
                                  isSearchResult:
                                  searchIds?.contains(familyMember.id) ??
                                      false,
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
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final accountType = getIt<UserDataManager>().getAccountType();
    if (accountType == 'provider') {
      return const ProviderFamilyView();
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(AppAssets.accountIcon),
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

  void _buildFilteredGraph(Graph graph, FamilyMember member,
      FamilyMember? parent, Set<int> nodesToDisplay) {
    if (!nodesToDisplay.contains(member.id)) {
      return;
    }

    final node = Node.Id(member);
    graph.addNode(node);

    if (parent != null && nodesToDisplay.contains(parent.id)) {
      final parentNode = Node.Id(parent);
      graph.addEdge(parentNode, node);
    }

    if (member.children != null) {
      for (var child in member.children!) {
        _buildFilteredGraph(graph, child, member, nodesToDisplay);
      }
    }
  }

  void _buildGraph(Graph graph, FamilyMember member, FamilyMember? parent) {
    final node = Node.Id(member);
    graph.addNode(node);

    if (parent != null) {
      final parentNode = Node.Id(parent);
      graph.addEdge(parentNode, node);
    }

    if ((_expandedNodes[member.id] ?? false) && member.children != null) {
      for (var child in member.children!) {
        _buildGraph(graph, child, member);
      }
    }
  }

  Widget _buildMemberNode({
    required FamilyMember member,
    String? familyId,
    bool isSearchResult = false,
  }) {
    final accountType = getIt<UserDataManager>().getAccountType();
    ImageProvider backgroundImage;
    if (member.avatar != null && member.avatar!.isNotEmpty) {
      backgroundImage = CachedNetworkImageProvider(member.avatar!);
    } else {
      backgroundImage = AssetImage(AppAssets.accountIcon);
    }

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (member.id != null) {
              context
                  .read<FamilyTreeCubit>()
                  .getFamilyMemberDetails(memberId: member.id!);
            }
          },
          child: Container(
            padding: EdgeInsets.all(isSearchResult ? 3 : 0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: isSearchResult
                  ? Border.all(color: AppColors.primaryColor, width: 2)
                  : null,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: backgroundImage,
                ),
                if (member.isLive == 0) ...[
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const Icon(Icons.not_interested, color: Colors.white, size: 40),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              member.name ?? '',
              style: isSearchResult
                  ? AppStyles.styleSemiBold14(context)
                  .copyWith(color: AppColors.primaryColor)
                  : AppStyles.styleRegular14(context),
            ),
            if (member.children != null && member.children!.isNotEmpty)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _expandedNodes[member.id!] =
                    !(_expandedNodes[member.id!] ?? false);
                  });
                },
                child: Icon(
                  (_expandedNodes[member.id!] ?? false)
                      ? Icons.arrow_drop_down
                      : Icons.arrow_right,
                  size: 24,
                  color: AppColors.greenColor,
                ),
              ),
            const SizedBox(width: 5),
            if (member.id != 0)
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => BlocProvider.value(
                          value: context.read<FamilyTreeCubit>(),
                          child: AddMemberDialog(parentId: member.id!),
                        ),
                      );
                    },
                    child: Icon(Icons.add_circle,
                        color: AppColors.greenColor, size: 20),
                  ),
                  SizedBox(width: 5.w),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => BlocProvider.value(
                          value: context.read<FamilyTreeCubit>(),
                          child: UpdateMemberDialog(member: member),
                        ),
                      );
                    },
                    child: Icon(Icons.edit, color: AppColors.primaryColor, size: 20),
                  ),
                  if (accountType == 'provider') ...[
                    SizedBox(width: 5.w),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (BuildContext dialogContext) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
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
                                      child: Icon(Icons.delete_outline,
                                          color: Colors.red.shade400, size: 32),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      AppStrings.deleteMember.tr(),
                                      style: TextStyle(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade800),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      AppStrings.deleteMemberTitle.tr(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Colors.grey.shade600,
                                          height: 1.5),
                                    ),
                                    const SizedBox(height: 24),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextButton(
                                            onPressed: () =>
                                                Navigator.of(dialogContext).pop(),
                                            style: TextButton.styleFrom(
                                              padding: const EdgeInsets.symmetric(
                                                  vertical: 14),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(12),
                                                side: BorderSide(
                                                    color:
                                                    Colors.grey.shade300),
                                              ),
                                            ),
                                            child: Text(
                                              AppStrings.cancel.tr(),
                                              style: TextStyle(
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.grey.shade700),
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
                      child: Icon(Icons.delete, color: Colors.red, size: 16.sp),
                    ),
                  ],
                ],
              ),
          ],
        ),
      ],
    );
  }
}