import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void customPushReplacement(BuildContext context, String pageName, {Object? extra}) =>
    GoRouter.of(context).pushReplacement(pageName, extra: extra);

void customPush(BuildContext context, String pageName, {Object? extra}) =>
    GoRouter.of(context).push(pageName, extra: extra);

void customGo(BuildContext context, String pageName, {Object? extra}) =>
    GoRouter.of(context).go(pageName);