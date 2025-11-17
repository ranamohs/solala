import 'package:solala/core/databases/api/dio_consumer.dart';
import 'package:solala/core/databases/cache/app_data_manager.dart';
import 'package:solala/core/databases/cache/cache_helper.dart';
import 'package:solala/core/databases/cache/secure_storage_helper.dart';
import 'package:solala/core/databases/cache/user_data_manager.dart';
import 'package:solala/core/state_management/network_connection_cubit/network_connection_cubit.dart';
import 'package:solala/core/state_management/network_connection_cubit/network_info.dart';
import 'package:solala/features/home/data/repos/banners_repo/banners_repo.dart';
import 'package:solala/features/home/data/repos/banners_repo/banners_repo_impl.dart';
import 'package:solala/features/home/data/repos/categories_repo/categories_repo.dart';
import 'package:solala/features/home/data/repos/categories_repo/categories_repo_impl.dart';
import 'package:solala/features/home/presentation/manager/banners_cubit/banners_cubit.dart';
import 'package:solala/features/home/presentation/manager/categories_cubit/categories_cubit.dart';
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
import '../../features/home/data/repos/recent_shops_repo/recent_shops_repo.dart';
import '../../features/home/data/repos/recent_shops_repo/recent_shops_repo_impl.dart';
import '../../features/home/presentation/manager/recent_shops_cubit/recent_shops_cubit.dart';

import '../../features/search/data/repo/search_repo.dart';
import '../../features/search/data/repo/search_repo_impl.dart';

import '../../features/search/presentation/manager/search_cubit.dart';

import '../../features/shops/data/repos/favourite/whishlist_repo.dart';
import '../../features/shops/data/repos/favourite/wishlist_repo_impl.dart';
import '../../features/shops/data/repos/request_service/request_service_repo.dart';
import '../../features/shops/data/repos/request_service/request_service_repo_impl.dart';

import '../../features/shops/data/repos/review/add_review_repo.dart';
import '../../features/shops/data/repos/review/add_review_repo_impl.dart';
import '../../features/shops/data/repos/shops/shops_repo.dart';
import '../../features/shops/data/repos/shops/shops_repo_impl.dart';
import '../../features/shops/presentation/manager/favourite_cubit/wishlist_cubit.dart';
import '../../features/shops/presentation/manager/request_service_cubit/request_service_cubit.dart';

import '../../features/shops/presentation/manager/review_cubit/add_review_cubit.dart';
import '../../features/shops/presentation/manager/shops_cubit/shops_cubit.dart';



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

  // Categories dependencies
  getIt.registerLazySingleton<CategoriesRepo>(() => CategoriesRepoImpl(
      dioConsumer: getIt<DioConsumer>(),
      networkCubit: getIt<NetworkConnectionCubit>()));
  getIt.registerFactory<CategoriesCubit>(() => CategoriesCubit(
    categoriesRepo: getIt<CategoriesRepo>(),
  ));

  // Services dependencies
  getIt.registerLazySingleton<ShopsRepo>(() => ServicesRepoImpl(
      secureStorageHelper: getIt<SecureStorageHelper>(),
      dioConsumer: getIt<DioConsumer>(),
      networkCubit: getIt<NetworkConnectionCubit>()));
  getIt.registerFactory<ShopsCubit>(() => ShopsCubit(
    servicesRepo: getIt<ShopsRepo>(),
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

  // Featured Categories dependencies
  getIt.registerLazySingleton<RcenetShopsRepo>(
          () => RcenetShopsRepoImpl(
        dioConsumer: getIt<DioConsumer>(),
        networkCubit: getIt<NetworkConnectionCubit>(),
      ));
  getIt.registerFactory<RcenetShopsCubit>(() => RcenetShopsCubit(
    rcenetShopsRepo: getIt<RcenetShopsRepo>(),
  ));

  getIt.registerLazySingleton<RequestServiceRepo>(() => SelectedServiceRepoImpl(
    dioConsumer: getIt<DioConsumer>(),
    networkCubit: getIt<NetworkConnectionCubit>(),
    secureStorageHelper: getIt<SecureStorageHelper>(),
  ));

  getIt.registerFactory<RequestServiceCubit>(() => RequestServiceCubit(
    requestServiceRepo: getIt<RequestServiceRepo>(),
  ));

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

  // Wishlist dependencies
  getIt.registerLazySingleton<WishlistRepo>(
        () => WishlistRepoImp(
      secureStorageHelper: getIt<SecureStorageHelper>(),
      dioConsumer: getIt<DioConsumer>(),

    ),
  );
  getIt.registerFactory<WishlistCubit>(
        () => WishlistCubit(
      wishlistRepo: getIt<WishlistRepo>(),
    ),
  );

  // Search dependencies
  getIt.registerLazySingleton<ShopsSearchRepo>(
        () => ShopsSearchRepoImpl(
          dioConsumer: getIt<DioConsumer>(),
          networkInfo: getIt<NetworkInfo>(),

    ),
  );


  getIt.registerFactory<ShopsSearchCubit>(
        () => ShopsSearchCubit(
      shopsSearchRepo: getIt<ShopsSearchRepo>(),
    ),
  );

  getIt.registerLazySingleton<AddReviewRepo>(
        () => AddReviewRepoImpl(
          secureStorageHelper: getIt<SecureStorageHelper>(),
      dioConsumer: getIt<DioConsumer>(),
    ),
  );
  getIt.registerFactory<AddReviewCubit>(
        () => AddReviewCubit(
      addReviewRepo: getIt<AddReviewRepo>(),
    ),
  );

}