import 'package:solala/features/register/presentation/views/register_view.dart';
import 'package:solala/features/register/presentation/widgets/verification_success_widget.dart';
import 'package:solala/features/splash/presentation/views/welcome_view.dart';
import 'package:solala/features/splash/presentation/views/splash_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/views/home_page.dart';

import '../../features/login/presentation/views/login_view.dart';
import '../../features/register/presentation/views/choose_role_view.dart';
import '../../features/register/presentation/views/provider_register_view.dart';
import '../../features/register/presentation/views/verfication_view.dart';

import '../../features/settings/views/change_language_view.dart';
import '../../features/account/presentation/views/update_profile_view.dart';
import '../../features/settings/views/about_us_view.dart';
import '../../features/app_info/presentation/views/contact_us_view.dart';
import '../../features/settings/views/privacy_policy_view.dart';
import '../../features/register/presentation/manager/register_cubit.dart';
import '../../features/settings/views/terms_and_conditions_view.dart';

import '../../features/splash/presentation/views/intro_view.dart';
import '../../features/splash/presentation/views/intro_with_button.dart';
import '../../features/app_info/presentation/views/help_and_support_view.dart';
import '../services/service_locator.dart';

abstract class AppRouter {
  static const welcomeView = '/welcomeView';
  static const loginView = '/loginView';
  static const registerView = '/registerView';
  static const introViewWithButton = '/introViewWithButton';
  static const homePage = '/homePage';
  static const categoryDetailsView = '/categoryDetailsView';
  static const serviceDetailsView = '/serviceDetailsView';
  static const updateProfileView = '/updateProfileView';
  static const helpAndSupportView = '/helpAndSupportView';
  static const contactUsView = '/contactUsView';
  static const aboutUsView = '/aboutUsView';
  static const termsAndConditionsView = '/termsAndConditionsView';
  static const privacyPolicyView = '/privacyPolicyView';
  static const changeLanguageView = '/changeLanguageView';
  static const allCategoriesView = '/allCategoriesView';
  static const allRecentShopsView = '/allRecentShopsView';
  static const rating = '/rating';
  static const wishlistView = '/wishlistView';
  static const searchView = '/searchView';

  //////////////////

  //Solala

  static const introView = '/introView';
  static const verificationView = '/verificationView';
  static const verificationSuccessView = '/verificationSuccessView';
  static const chooseRoleView = '/chooseRoleView';
  static const providerRegisterView = '/providerRegisterView';



  static final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashView()),
      GoRoute(path: welcomeView,builder: (context, state) => const WelcomeView()),
      GoRoute(path: introView,builder: (context, state) => const IntroView()),
      GoRoute(path: introViewWithButton,builder: (context, state) => const IntroWithButton()),
      GoRoute(path: loginView, builder: (context, state) => LoginView()),
      GoRoute(path: chooseRoleView, builder: (context, state) => const ChooseRoleView()),
      GoRoute(path: providerRegisterView, builder: (context, state) => BlocProvider(
        create: (context) => getIt<RegisterCubit>(),
        child:  ProviderRegisterView(),
      )),
      GoRoute(path: verificationSuccessView, builder: (context, state) => const VerificationSuccessWidget()),


      GoRoute(path: registerView, builder: (context, state) => BlocProvider(
        create: (context) => getIt<RegisterCubit>(),
        child:  RegisterView(),
      )),
      GoRoute(path: homePage, builder: (context, state) =>  AppLayout()),
      GoRoute(path: contactUsView, builder: (context, state) => const ContactUsView()),
      GoRoute(path: helpAndSupportView, builder: (context, state) => const HelpAndSupportView()),
      GoRoute(path: aboutUsView, builder: (context, state) => const AboutUsView()),
      GoRoute(path: termsAndConditionsView, builder: (context, state) => const TermsAndConditionsView()),
      GoRoute(path: privacyPolicyView, builder: (context, state) => const PrivacyPolicyView()),
      GoRoute(path: changeLanguageView, builder: (context, state) => const ChangeLanguageView()),
      GoRoute(path: updateProfileView, builder: (context, state) => const UpdateProfileView()),
      GoRoute(path: verificationView, builder: (context, state) => BlocProvider(
        create: (context) => getIt<RegisterCubit>(),
        child: const VerificationView(),
      )),

    ],
  );
}
