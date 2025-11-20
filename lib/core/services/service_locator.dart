import 'package:solala/core/databases/api/dio_consumer.dart';
import 'package:solala/core/databases/cache/app_data_manager.dart';
import 'package:solala/core/databases/cache/cache_helper.dart';
import 'package:solala/core/databases/cache/secure_storage_helper.dart';
import 'package:solala/core/databases/cache/user_data_manager.dart';
import 'package:solala/core/state_management/network_connection_cubit/network_connection_cubit.dart';
import 'package:solala/core/state_management/network_connection_cubit/network_info.dart';
import 'package:solala/features/home/data/repos/banners_repo/banners_repo.dart';
import 'package:solala/features/home/data/repos/banners_repo/banners_repo_impl.dart';
import 'package:solala/features/home/presentation/manager/banners_cubit/banners_cubit.dart';
import 'package:solala/features/login/data/repos/login_repo_impl.dart';
import 'package:solala/features/login/presentation/manager/login_cubit.dart';
import 'package:solala/features/register/data/repos/register_repo_impl.dart';
import 'package:solala/features/register/presentation/manager/register_cubit.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../features/account/data/repos/delete_account_repo/delete_account_repo_impl.dart';
import '../../features/account/data/repos/logout_repo/logout_repo_impl.dart';
import '../../features/account/data/repos/update_profile_repo/update_profile_repo_impl.dart';
import '../../features/account/presentation/manager/delete_account_cubit/delete_account_cubit.dart';
import '../../features/account/presentation/manager/logout_cubit/logout_cubit.dart';
import '../../features/account/presentation/manager/update_profile_cubit/update_profile_cubit.dart';
import '../../features/app_info/data/repos/about_us_repo/about_us_repo.dart';
import '../../features/app_info/data/repos/about_us_repo/about_us_repo_impl.dart';
import '../../features/app_info/data/repos/contact_us_repo/contact_us_repo_impl.dart';
import '../../features/app_info/data/repos/default_page_repo/default_page_repo_impl.dart';
import '../../features/app_info/data/repos/privacy_repo/privacy_repo.dart';
import '../../features/app_info/data/repos/privacy_repo/privacy_repo_impl.dart';
import '../../features/app_info/data/repos/terms_repo/terms_repo.dart';
import '../../features/app_info/data/repos/terms_repo/terms_repo_impl.dart';
import '../../features/app_info/presentation/manager/about_us_cubit/about_us_cubit.dart';
import '../../features/app_info/presentation/manager/contact_us_cubit/contact_us_cubit.dart';
import '../../features/app_info/presentation/manager/default_page_cubit/default_page_cubit.dart';
import '../../features/app_info/presentation/manager/privacy_cubit/privacy_cubit.dart';
import '../../features/app_info/presentation/manager/terms_cubit/terms_cubit.dart';
import '../../features/events/presentation/manager/events_cuibt/events_cubit.dart';
import '../../features/family_tree/data/repos/family_repo.dart';
import '../../features/family_tree/data/repos/family_repo_impl.dart';
import '../../features/events/data/repos/events_repo.dart';
import '../../features/events/data/repos/events_repo_impl.dart';
import '../../features/family_tree/presentation/manager/family_cubit/family_cubit.dart';
import '../../features/home/data/repos/family_info_repos/family_info_repo.dart';
import '../../features/home/data/repos/family_info_repos/family_info_repo_impl.dart';
import '../../features/home/data/repos/numbering_events_repo/numbering_events_repo.dart';
import '../../features/home/data/repos/numbering_events_repo/numbering_events_repo_impl.dart';
import '../../features/home/data/repos/news_repos/news_repo.dart';
import '../../features/home/data/repos/news_repos/news_repo_impl.dart';
import '../../features/home/presentation/manager/family_info_cubit/family_info_cubit.dart';
import '../../features/home/presentation/manager/news_cubit/news_cubit.dart';
import '../../features/home/presentation/manager/numering_events_cubit/numbering_events_cubit.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Core shops
  getIt.registerLazySingleton<CacheHelper>(() => CacheHelper());
  getIt.registerSingleton<AppDataManager>(AppDataManager(getIt<CacheHelper>()));
  getIt.registerSingleton<UserDataManager>(
    UserDataManager(getIt<CacheHelper>()),
  );
  getIt.registerLazySingleton<SecureStorageHelper>(() => SecureStorageHelper());
  getIt.registerLazySingleton<DioConsumer>(() => DioConsumer(dio: Dio()));
  getIt.registerLazySingleton<NetworkInfo>(
        () => NetworkInfoImpl(DataConnectionChecker()),
  );
  getIt.registerLazySingleton<NetworkConnectionCubit>(
        () => NetworkConnectionCubit(getIt<NetworkInfo>()),
  );

  // Banners dependencies
  getIt.registerLazySingleton<BannersRepo>(() => BannersRepoImpl(
      dioConsumer: getIt<DioConsumer>(),
      networkCubit: getIt<NetworkConnectionCubit>()));
  getIt.registerFactory<BannersCubit>(() => BannersCubit(
    bannersRepo: getIt<BannersRepo>(),
  ));



  // Register dependencies
  getIt.registerSingleton<RegisterRepoImpl>(
    RegisterRepoImpl(
      dioConsumer: getIt.get<DioConsumer>(),
      secureStorageHelper: getIt<SecureStorageHelper>(),
      networkCubit: getIt<NetworkConnectionCubit>(),
    ),
  );
  getIt.registerFactory<RegisterCubit>(
          () => RegisterCubit(registerRepo: getIt<RegisterRepoImpl>()));

  // Login dependencies
  getIt.registerSingleton<LoginRepoImpl>(
    LoginRepoImpl(
      dioConsumer: getIt.get<DioConsumer>(),
      secureStorageHelper: getIt<SecureStorageHelper>(),
      networkCubit: getIt<NetworkConnectionCubit>(),
      userDataManager: getIt<UserDataManager>(),

    ),
  );
  getIt.registerFactory<LoginCubit>(
        () => LoginCubit(
      loginRepo: getIt<LoginRepoImpl>(),
    ),
  );




  getIt.registerLazySingleton<AboutUsRepo>(
        () => AboutUsRepoImpl(
      dioConsumer: getIt<DioConsumer>(),
    ),
  );


  getIt.registerFactory<AboutUsCubit>(
        () => AboutUsCubit(
      repo: getIt<AboutUsRepo>(),
    ),
  );
  getIt.registerLazySingleton<TermsRepo>(
        () => TermsRepoImpl(
      dioConsumer: getIt<DioConsumer>(),
    ),
  );


  getIt.registerFactory<TermsCubit>(
        () => TermsCubit(
      repo: getIt<TermsRepo>(),
    ),
  );


  getIt.registerLazySingleton<PrivacyRepo>(
        () => PrivacyRepoImpl(
      dioConsumer: getIt<DioConsumer>(),

    ),
  );


  getIt.registerFactory<PrivacyCubit>(
        () => PrivacyCubit(
      repo: getIt<PrivacyRepo>(),
    ),
  );

  getIt.registerSingleton<LogoutRepoImpl>(
    LogoutRepoImpl(
        networkCubit: getIt(),
        dioConsumer: getIt<DioConsumer>(),
        secureStorageHelper: getIt<SecureStorageHelper>(),
        userDataManager: getIt<UserDataManager>()),
  );
  getIt.registerFactory<LogoutCubit>(
          () => LogoutCubit(logoutRepo: getIt<LogoutRepoImpl>()));


  getIt.registerLazySingleton<DeleteAccountRepoImpl>(
        () =>
        DeleteAccountRepoImpl(
            dioConsumer: getIt(),
            secureStorageHelper: getIt(),
            networkCubit: getIt(),
            userDataManager: getIt()),
  );
  getIt.registerFactory(() => DeleteAccountCubit(deleteAccountRepo: getIt()));



  getIt.registerSingleton<UpdateProfileRepoImpl>(
    UpdateProfileRepoImpl(
      dioConsumer: getIt.get<DioConsumer>(),
      secureStorageHelper: getIt<SecureStorageHelper>(),
      userDataManager: getIt<UserDataManager>(),
      networkCubit: getIt<NetworkConnectionCubit>(),
    ),
  );
  getIt.registerFactory<UpdateProfileCubit>(() =>
      UpdateProfileCubit(updateProfileRepo: getIt<UpdateProfileRepoImpl>()));


  getIt.registerLazySingleton<DefaultPageRepoImpl>(() =>
      DefaultPageRepoImpl(
        dioConsumer: getIt<DioConsumer>(),
        networkCubit: getIt<NetworkConnectionCubit>(),
      ));
  getIt.registerFactory<DefaultPageCubit>(() =>
      DefaultPageCubit(
          repo: getIt<DefaultPageRepoImpl>(),
          cacheHelper: getIt<CacheHelper>()
      ));


  getIt.registerSingleton<ContactUsRepoImpl>(
    ContactUsRepoImpl(
      dioConsumer: getIt.get<DioConsumer>(),
      secureStorageHelper: getIt<SecureStorageHelper>(),
      networkCubit: getIt<NetworkConnectionCubit>(),
    ),
  );
  getIt.registerFactory<ContactUsCubit>(
          () => ContactUsCubit(contactUsRepo: getIt<ContactUsRepoImpl>()));

  // FamilyTree dependencies
  getIt.registerLazySingleton<FamilyTreeRepo>(() => FamilyTreeRepoImpl(
      secureStorageHelper: getIt<SecureStorageHelper>(),
      dioConsumer: getIt<DioConsumer>(),
      networkCubit: getIt<NetworkConnectionCubit>()));
  getIt.registerFactory<FamilyTreeCubit>(() => FamilyTreeCubit(
    familyTreeRepo: getIt<FamilyTreeRepo>(),
  ));

  // Events dependencies
  getIt.registerLazySingleton<EventsRepo>(() => EventsRepoImpl(
      secureStorageHelper: getIt<SecureStorageHelper>(),
      dioConsumer: getIt<DioConsumer>(),
      networkCubit: getIt<NetworkConnectionCubit>()));
  getIt.registerFactory<EventsCubit>(() => EventsCubit(
    eventsRepo: getIt<EventsRepo>(),
  ));

  // Numbering Events dependencies
  getIt.registerLazySingleton<NumberingEventsRepo>(() => NumberingEventsRepoImpl(
      dioConsumer: getIt<DioConsumer>(),
      userDataManager: getIt<UserDataManager>(),
      secureStorageHelper: getIt<SecureStorageHelper>() ));
  getIt.registerFactory<NumberingEventsCubit>(
          () => NumberingEventsCubit(getIt<NumberingEventsRepo>()));

  // FamilyInfo dependencies
  getIt.registerLazySingleton<FamilyInfoRepo>(() => FamilyInfoRepoImpl(
      secureStorageHelper: getIt<SecureStorageHelper>(),
      dioConsumer: getIt<DioConsumer>(),
      networkCubit: getIt<NetworkConnectionCubit>()));
  getIt.registerFactory<FamilyInfoCubit>(() => FamilyInfoCubit(
    familyInfoRepo: getIt<FamilyInfoRepo>(),
  ));

  // News dependencies
  getIt.registerLazySingleton<NewsRepo>(() => NewsRepoImpl(
      secureStorageHelper: getIt<SecureStorageHelper>(),
      dioConsumer: getIt<DioConsumer>(),
      networkCubit: getIt<NetworkConnectionCubit>()));
  getIt.registerFactory<NewsCubit>(() => NewsCubit(
    getIt<NewsRepo>(),
  ));
}
