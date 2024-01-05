import 'package:chatterbox/chatterbox.dart';
import 'package:chatterbox/core/logger.dart';
import 'package:chatterbox/core/network/connection_status.dart';
import 'package:chatterbox/features/auth/presentation/provider/auth_provider.dart';
import 'package:chatterbox/injectable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await dotenv.load(fileName: ".env");

  configureDependencies(environment: Environment.dev);

  // logger.i("Gettting connection status");

  await getIt<ConnectionStatusSingleton>().initialize();

  final providerContainer = ProviderContainer();

  await providerContainer.read(authProvider.notifier).initialise();

  // logger.i("Getting cached login data");

  // get initial login data from storage
  // logger.i("Starting ChatterBox");

  runApp(
    UncontrolledProviderScope(
      container: providerContainer,
      child: const ChatterBox(),
    ),
  );
}
