import 'package:coiner/core/logging/app_logger.dart';
import 'package:coiner/core/network/dio/dio_client.dart';
import 'package:coiner/core/widgets/fluid_app_bar.dart';
import 'package:coiner/app/ctheme.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
        body: FluidAppBar(
          title: Text.rich(TextSpan(
              style: TextTheme.of(context).headlineLarge!.copyWith(fontWeight: FontWeight.bold),
              children: [
                TextSpan(text: 'Coiner', style: TextStyle(color: CTheme.primary)),
                TextSpan(text: 'Dash'),
              ],
            ),
          ),
          body: Center(child: TextButton(onPressed: () async {
            final res = await ref.read(dioClientProvider).getRaw("/api/user/me");
            if (res.isSuccess) {
              AppLogger.debug(res.data?.data);
            } else {
              AppLogger.debug(res.failure?.message ?? res.failure!.type.toString());
            }
          }, child: Text("Test")),),
        ),
      );
  }
}