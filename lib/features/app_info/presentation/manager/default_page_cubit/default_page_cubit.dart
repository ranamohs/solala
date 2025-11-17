import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/databases/cache/cache_helper.dart';
import '../../../data/models/default_page_model.dart';
import '../../../data/repos/default_page_repo/default_page_repo.dart';
import 'default_page_state.dart';

class DefaultPageCubit extends Cubit<DefaultPageState> {
  final DefaultPageRepo repo;
  final CacheHelper cacheHelper;

  DefaultPageCubit({
    required this.repo,
    required this.cacheHelper,
  }) : super(DefaultPageInitialState());

  Future<void> fetchPage({required String pageName}) async {

    final cachedJson = cacheHelper.getDataString(key: pageName);
    if (cachedJson != null) {
      try {
        final cachedData = DefaultPageModel.fromJson(jsonDecode(cachedJson));
        emit(DefaultPageSuccessState(cachedData));
        return;
      } catch (e) {
        print('❌ Failed to parse cached data for $pageName: $e');

      }
    }


    emit(DefaultPageLoadingState());


    final result = await repo.getDefaultPage(pageName);
    result.fold(
          (failure) {
        emit(DefaultPageFailureState(failure));
      },
          (data) async {

        try {
          await cacheHelper.saveData(
            key: pageName,
            value: jsonEncode(data.toJson()),
          );
        } catch (e) {
          print('⚠️ Failed to cache data for $pageName: $e');
        }


        emit(DefaultPageSuccessState(data));
      },
    );
  }
}
