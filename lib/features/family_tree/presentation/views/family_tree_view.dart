import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
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

  Map<int, FamilyMember>? _cachedParentMap;
  List<FamilyMember>? _lastTreeData;
  Set<int>? _cachedNodesToDisplay;
  List<int>? _lastSearchResultIds;

  Graph? _cachedGraph;
  Map<int, bool>? _lastExpandedNodes;
  bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();
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
    final double yOffset = (viewportSize.height - graphSize.height * scale) / 2;
    _transformationController.value = Matrix4.identity()
      ..translate(xOffset, yOffset)
      ..scale(scale);
  }


  void _buildParentMap(
      FamilyMember member,
      FamilyMember? parent,
      Map<int, FamilyMember> map,
      ) {
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
      List<int> searchResultIds,
      List<FamilyMember> fullTree,
      ) {
    if (_cachedNodesToDisplay != null &&
        _lastSearchResultIds == searchResultIds &&
        _lastTreeData == fullTree) {
      return _cachedNodesToDisplay!;
    }

    final nodesToDisplay = Set<int>.from(searchResultIds);
    final parentMap = _getParentMap(fullTree);

    for (var id in searchResultIds) {
      var current = parentMap[id];
      while (current != null) {
        if (current.id != null) {
          nodesToDisplay.add(current.id!);
        }
        current = parentMap[current.id];
      }
    }

    _cachedNodesToDisplay = nodesToDisplay;
    _lastSearchResultIds = searchResultIds;
    _lastTreeData = fullTree;

    return nodesToDisplay;
  }

  Map<int, FamilyMember> _getParentMap(List<FamilyMember> fullTree) {
    if (_cachedParentMap != null && _lastTreeData == fullTree) {
      return _cachedParentMap!;
    }

    final parentMap = <int, FamilyMember>{};
    for (var member in fullTree) {
      _buildParentMap(member, null, parentMap);
    }

    _cachedParentMap = parentMap;
    _lastTreeData = fullTree;

    return parentMap;
  }

  @override
  Widget build(BuildContext context) {
    final String? accountType = getIt<UserDataManager>().getAccountType();
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
            style: AppStyles.styleBold20(
              context,
            ).copyWith(color: AppColors.greenColor),
          ),
        ),
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Column(
              children: [
                // if (accountType != 'provider')
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
                        context.read<FamilyTreeCubit>().searchFamilyTree(
                          query: query,
                        );
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
                        },
                      ),
                      BlocListener<FamilyTreeCubit, FamilyTreeState>(
                        listener: (context, state) {
                          if (state is GetFamilyMemberDetailsLoading) {
                            showDialog(
                              context: context,
                              builder: (_) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          } else if (state is GetFamilyMemberDetailsSuccess) {
                            Navigator.of(context).pop();
                            showDialog(
                              context: context,
                              builder: (_) => MemberDetailsDialog(
                                member: state.memberDetailsModel,
                              ),
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
                                  context
                                      .read<FamilyTreeCubit>()
                                      .getFamilyTree();
                                },
                              ),
                            );
                          }
                          if (state is FamilyTreeSuccess) {
                            final members = state.familyTreeModel.data ?? [];
                            final searchIds = state.searchResultIds;

                            final displayMembers = List<FamilyMember>.from(members);
                            if (displayMembers.isEmpty) {
                              final familyName = getIt<UserDataManager>()
                                  .getUserFamilyName();
                              final familyId = getIt<UserDataManager>()
                                  .getUserFamilyId();
                              if (familyId != null &&
                                  familyId.isNotEmpty &&
                                  familyName != null &&
                                  familyName.isNotEmpty &&
                                  searchIds == null) {
                                displayMembers.add(
                                  FamilyMember(id: 0, name: familyName),
                                );
                              } else {
                                return _buildEmptyState();
                              }
                            }

                            // Memoize Graph construction
                            final bool expandedChanged = _lastExpandedNodes == null ||
                                !mapEquals(_lastExpandedNodes, _expandedNodes);
                            final bool dataChanged = _lastTreeData != displayMembers ||
                                _lastSearchResultIds != searchIds;

                            if (_cachedGraph == null || expandedChanged || dataChanged) {
                              _cachedGraph = Graph();
                              if (searchIds != null && searchIds.isNotEmpty) {
                                final nodesToDisplay = _getNodesToDisplay(
                                  searchIds,
                                  displayMembers,
                                );
                                for (var member in displayMembers) {
                                  _buildFilteredGraph(
                                    _cachedGraph!,
                                    member,
                                    null,
                                    nodesToDisplay,
                                  );
                                }
                              } else {
                                for (var member in displayMembers) {
                                  _buildGraph(_cachedGraph!, member, null);
                                }
                              }
                              _lastExpandedNodes = Map.from(_expandedNodes);
                              _lastTreeData = displayMembers;
                              _lastSearchResultIds = searchIds;
                            }

                            final graph = _cachedGraph!;

                            final builder = BuchheimWalkerConfiguration()
                              ..siblingSeparation = (100)
                              ..levelSeparation = (150)
                              ..subtreeSeparation = (150)
                              ..orientation = (BuchheimWalkerConfiguration
                                  .ORIENTATION_TOP_BOTTOM);

                            if (graph.nodeCount() == 0 && searchIds != null) {
                              return Center(
                                child: Text(AppStrings.noDataFound.tr()),
                              );
                            }

                            if (_isFirstLoad) {
                              _isFirstLoad = false;
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (mounted) {
                                  final RenderBox? graphRenderBox =
                                  _graphKey.currentContext
                                      ?.findRenderObject() as RenderBox?;
                                  final RenderBox? viewportRenderBox =
                                  context.findRenderObject() as RenderBox?;
                                  if (graphRenderBox != null &&
                                      viewportRenderBox != null) {
                                    _centerGraph(
                                      graphRenderBox.size,
                                      viewportRenderBox.size,
                                    );
                                  }
                                }
                              });
                            }

                            return Stack(
                              children: [
                                GestureDetector(
                                  onHorizontalDragStart: (details) {},
                                  child: InteractiveViewer(
                                    transformationController:
                                    _transformationController,
                                    constrained: false,
                                    boundaryMargin: const EdgeInsets.all(
                                      double.infinity,
                                    ),
                                    minScale: 0.01,
                                    maxScale: 5.6,
                                    child: RepaintBoundary(
                                      child: GraphView(
                                        key: _graphKey,
                                        graph: graph,
                                        algorithm: BuchheimWalkerAlgorithm(
                                          builder,
                                          TreeEdgeRenderer(builder),
                                        ),
                                        paint: Paint()
                                          ..color = Colors.green
                                          ..strokeWidth = 1
                                          ..style = PaintingStyle.stroke,
                                        builder: (Node node) {
                                          final familyMember =
                                          node.key!.value as FamilyMember;
                                          return _buildMemberNode(
                                            member: familyMember,
                                            familyId: getIt<UserDataManager>()
                                                .getUserFamilyId(),
                                            isSearchResult:
                                            searchIds?.contains(
                                              familyMember.id,
                                            ) ??
                                                false,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                if (state.isPaginationLoading)
                                  Positioned(
                                    bottom: 20,
                                    left: 20,
                                    child: LoadingAnimationWidget.flickr(
                                      leftDotColor: AppColors.primaryColor,
                                      rightDotColor: AppColors.greenColor,
                                      size: 32,
                                    ),
                                  ),
                                if (!state.isPaginationLoading &&
                                    state.familyTreeModel.meta?.currentPage !=
                                        state.familyTreeModel.meta?.lastPage)
                                  Positioned(
                                    bottom: 20,
                                    left: 20,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        context
                                            .read<FamilyTreeCubit>()
                                            .getFamilyTree(isPagination: true);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primaryColor,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(20),
                                        ),
                                      ),
                                      child: Text(AppStrings.viewAll.tr()),
                                    ),
                                  ),
                              ],
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
            _buildLegendWidget(context),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final accountType = getIt<UserDataManager>().getAccountType();
    final familyId = getIt<UserDataManager>().getUserFamilyId();

    if (accountType == 'provider' && (familyId == null || familyId.isEmpty)) {
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
              style: AppStyles.styleRegular14(
                context,
              ).copyWith(color: AppColors.greyColor),
            ),
            if (accountType == 'provider' ||
                (familyId != null && familyId.isNotEmpty))
              Padding(
                padding: EdgeInsets.only(top: 24.h),
                child: PrimaryButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => BlocProvider.value(
                        value: context.read<FamilyTreeCubit>(),
                        child: const AddMemberDialog(),
                      ),
                    );
                  },
                  text: AppStrings.addMember.tr(),
                ),
              ),
          ],
        ),
      );
    }
  }

  void _buildFilteredGraph(
      Graph graph,
      FamilyMember member,
      FamilyMember? parent,
      Set<int> nodesToDisplay,
      ) {
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
            if (member.id != null && member.id != 0) {
              context.read<FamilyTreeCubit>().getFamilyMemberDetails(
                memberId: member.id!,
              );
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
                CircleAvatar(radius: 40, backgroundImage: backgroundImage),
                if (member.isLive == 0) ...[
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const Icon(
                    Icons.not_interested,
                    color: Colors.white,
                    size: 40,
                  ),
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
                  ? AppStyles.styleSemiBold14(
                context,
              ).copyWith(color: AppColors.primaryColor)
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
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => BlocProvider.value(
                        value: context.read<FamilyTreeCubit>(),
                        child: AddMemberDialog(
                          parentId: member.id == 0 ? null : member.id,
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
                if (member.id != 0) ...[
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
                    child: Icon(
                      Icons.edit,
                      color: AppColors.primaryColor,
                      size: 20,
                    ),
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
                                            onPressed: () => Navigator.of(
                                              dialogContext,
                                            ).pop(),
                                            style: TextButton.styleFrom(
                                              padding:
                                              const EdgeInsets.symmetric(
                                                vertical: 14,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(12),
                                                side: BorderSide(
                                                  color: Colors.grey.shade300,
                                                ),
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
                                                memberId: member.id!,
                                              );
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
              ],
            ),
          ],
        ),
      ],
    );
  }
}

Widget _buildLegendWidget(BuildContext context) {
  return Positioned(
    bottom: 20,
    right: 20,
    child: SizedBox(
      width: 130.w,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppStrings.legend.tr(),
                style: AppStyles.styleSemiBold14(
                  context,
                ).copyWith(color: AppColors.primaryColor),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.not_interested,
                    color: Colors.black54,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    AppStrings.deceasedStatus.tr(),
                    style: AppStyles.styleRegular12(
                      context,
                    ).copyWith(color: AppColors.secondaryColor),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  const Icon(Icons.edit, color: Colors.black54, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    AppStrings.edit.tr(),
                    style: AppStyles.styleRegular12(
                      context,
                    ).copyWith(color: AppColors.secondaryColor),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  const Icon(
                    Icons.add_circle_outlined,
                    color: Colors.black54,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    AppStrings.addMember.tr(),
                    style: AppStyles.styleRegular12(
                      context,
                    ).copyWith(color: AppColors.secondaryColor),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
