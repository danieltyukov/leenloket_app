import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:leenloket_app/src/admin/Categories/admin__categories__index.dart';
import 'package:leenloket_app/src/admin/admin__items__create.dart';
import 'package:leenloket_app/src/admin/admin__items__index.dart';
import 'package:leenloket_app/src/admin/admin__items__single.dart';
import 'package:leenloket_app/src/admin/lockers/admin__lockers__index.dart';
import 'package:leenloket_app/src/admin/reservations/admin__reservations__index.dart';
import 'package:leenloket_app/src/authentication/auth__login_view.dart';
import 'package:leenloket_app/src/authentication/auth__register_view.dart';
import 'package:leenloket_app/src/home/admin__home_view.dart';
import 'package:leenloket_app/src/home/home_view.dart';
import 'package:leenloket_app/src/reservations/user__reservations__index.dart';
import 'package:leenloket_app/src/reserving/reserving__item__overview_view.dart';
import 'package:leenloket_app/src/roles/role__selector_view.dart';

import 'shop/shop__item__single_view.dart';
import 'shop/shop__index_view.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          restorationScopeId: 'app',
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''),
          ],
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,
          theme: ThemeData(
            primaryColor: Colors.blue,
          ),
          darkTheme: ThemeData.dark(),
          themeMode: settingsController.themeMode,
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  //Admin routes
                  case AdminHomeView.routeName:
                    return const AdminHomeView();
                  case AdminIndexItems.routeName:
                    return const AdminIndexItems();
                  case AdminItemCreate.routeName:
                    return const AdminItemCreate();
                  case AdminItemSingleView.routeName:
                    // Extract itemId from route arguments
                    final Map<String, dynamic>? args =
                        routeSettings.arguments as Map<String, dynamic>?;

                    if (args != null && args.containsKey('itemId')) {
                      final String itemId = args['itemId'] as String;
                      return AdminItemSingleView(itemId: itemId);
                    } else {
                      // Handle missing or invalid arguments
                      return const SizedBox.shrink();
                    }

                  case AdminReservationsIndex.routeName:
                    return const AdminReservationsIndex();

                  case AdimCategoriesIndex.routeName:
                    return const AdimCategoriesIndex();

                  case AdminLockersIndex.routeName:
                    return const AdminLockersIndex();

                  // Authentication routes
                  case AuthLoginView.routeName:
                    return const AuthLoginView();

                  case AuthRegisterView.routeName:
                    return const AuthRegisterView();

                  // Role routes
                  case RoleSelectorView.routeName:
                    return const RoleSelectorView();

                  // Settings routes
                  case SettingsView.routeName:
                    return SettingsView(controller: settingsController);

                  // Home routes
                  case HomeView.routeName:
                    return const HomeView();

                  case UserReservationsIndex.routeName:
                    return const UserReservationsIndex();

                  // Reserving routes
                  case ReservingItemOverviewView.routeName:
                    // Extract itemId from route arguments
                    final Map<String, dynamic>? args =
                        routeSettings.arguments as Map<String, dynamic>?;

                    if (args != null && args.containsKey('itemId')) {
                      final String itemId = args['itemId'] as String;
                      return ReservingItemOverviewView(itemId: itemId);
                    } else {
                      // Handle missing or invalid arguments
                      return const SizedBox.shrink();
                    }

                  // Shop routes
                  case SampleItemListView.routeName:
                  case ShopItemSingleView.routeName:
                    // Extract itemId from route arguments
                    final Map<String, dynamic>? args =
                        routeSettings.arguments as Map<String, dynamic>?;

                    if (args != null && args.containsKey('itemId')) {
                      final String itemId = args['itemId'] as String;
                      return ShopItemSingleView(itemId: itemId);
                    } else {
                      // Handle missing or invalid arguments
                      return const SizedBox.shrink();
                    }

                  // Default route
                  default:
                    return const AuthLoginView();
                }
              },
            );
          },
        );
      },
    );
  }
}
