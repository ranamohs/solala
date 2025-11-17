import 'package:solala/core/databases/cache/cache_helper.dart' show CacheHelper;
import 'package:solala/core/services/observer.dart' show MyBlocObserver;
import 'package:solala/core/services/service_locator.dart';
import 'package:easy_localization/easy_localization.dart' show EasyLocalization;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show Bloc;

import 'app/solala_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await CacheHelper().init();
  setupServiceLocator();
  Bloc.observer = MyBlocObserver();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ar'),
      startLocale: const Locale('ar'),
      child: SolalaApp() ,
    ),
  );
}
