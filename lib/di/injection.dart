
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:unites_flutter/di/injection.config.dart';


@injectableInit
void configureInjection(String environment, GetIt getIt) =>
    $initGetIt(getIt, environment: environment);

abstract class Env {
  static const dev = 'dev';
  static const prod = 'prod';
}