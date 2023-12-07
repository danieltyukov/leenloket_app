import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:leenloket_app/src/admin/Categories/admin__categories__index.dart';
import 'package:leenloket_app/src/admin/admin__items__index.dart';
import 'package:leenloket_app/src/admin/admin__items__overview.dart';
import 'package:leenloket_app/src/admin/admin__items__single.dart';
import 'package:leenloket_app/src/admin/lockers/admin__lockers__index.dart';
import 'package:leenloket_app/src/admin/reservations/admin__reservations__index.dart';
import 'package:leenloket_app/src/authentication/auth__login_view.dart';
import 'package:leenloket_app/src/home/admin__home_view.dart';
import 'package:leenloket_app/src/home/home_view.dart';
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
    // Glue the SettingsController to the MaterialApp.
    //
    // The ListenableBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          restorationScopeId: 'app',

          // Provide the generated AppLocalizations to the MaterialApp. This
          // allows descendant Widgets to display the correct translations
          // depending on the user's locale.
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],

          // Use AppLocalizations to configure the correct application title
          // depending on the user's locale.
          //
          // The appTitle is defined in .arb files found in the localization
          // directory.
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,

          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          themeMode: settingsController.themeMode,

          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  //Admin routes
                  case AdminHomeView.routeName:
                    return const AdminHomeView();
                  case AdminCreateItem.routeName:
                    return const AdminCreateItem();
                  case AdminIndexItems.routeName:
                    return const AdminIndexItems();
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

                  // Role routes
                  case RoleSelectorView.routeName:
                    return const RoleSelectorView();

                  // Settings routes
                  case SettingsView.routeName:
                    return SettingsView(controller: settingsController);

                  // Home routes
                  case HomeView.routeName:
                    return const HomeView();

                  // Reserving routes
                  case ReservingItemOverviewView.routeName:
                    return ReservingItemOverviewView();

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
