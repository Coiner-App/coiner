import 'package:coiner/app/app.dart';
import 'package:coiner/features/authentication/data/repositories/authentication_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final container = ProviderContainer();
  await container.read(authRepositoryProvider).initialize();
  
  runApp(UncontrolledProviderScope(container: container, child: MainApp()));
}