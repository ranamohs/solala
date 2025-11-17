import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void customPushReplacement(BuildContext context, String pageName) =>
    GoRouter.of(context).pushReplacement(pageName);

void customPush(BuildContext context, String pageName) =>
    GoRouter.of(context).push(pageName);

void customGo(BuildContext context, String pageName) =>
    GoRouter.of(context).go(pageName);