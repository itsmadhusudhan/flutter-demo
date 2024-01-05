import 'package:logger/logger.dart';

const String greenColor = '\x1B[32m'; // Green

final logger = Logger(
  printer: PrettyPrinter(
    printTime: true,
    colors: true,
  ),
);
