import 'package:Leenloket/src/views/admin/Categories/admin__categories__index.dart';
import 'package:Leenloket/src/views/admin/items/admin__items__index.dart';
import 'package:Leenloket/src/views/admin/home/admin__home_view.dart';
import 'package:Leenloket/src/views/admin/locations/admin__locations__index.dart';
import 'package:Leenloket/src/views/admin/lockers/admin__lockers__index.dart';
import 'package:Leenloket/src/views/admin/reservations/admin__reservations__index.dart';
import 'package:Leenloket/src/views/admin/users/admin__users__index.dart';
import 'package:Leenloket/src/views/authentication/auth__onboarding_view.dart';
import 'package:Leenloket/src/views/user/credit/user__credit__view.dart';
import 'package:Leenloket/src/views/user/favorites/user__favorites__index.dart';
import 'package:Leenloket/src/views/user/reserving/reserving__item__confirmation_view.dart';
import 'package:Leenloket/src/views/user/reserving/reserving__item__overview_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:Leenloket/src/views/authentication/auth__register_view.dart';
import 'package:Leenloket/src/views/user/home/home_view.dart';
import 'package:Leenloket/src/views/user/reservations/user__reservations__index.dart';
import 'package:Leenloket/src/views/user/reservations/user__reservations__single.dart';
import 'package:Leenloket/src/views/user/shop/shop__item__single_view.dart';
import 'package:Leenloket/src/views/user/shop/shop__index_view.dart';
import 'package:Leenloket/src/views/user/settings/settings_controller.dart';
import 'package:Leenloket/src/views/user/settings/settings_view.dart';
import 'package:Leenloket/src/views/user/locations/user__locations__map.dart';
import 'package:Leenloket/src/models/user_model.dart' as userModel;

/// The Widget that configures your application.
class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var auth = FirebaseAuth.instance;
  var isLogedIn = false;
  String userRole = "r2";

  checkIfLogin() async {
    auth.authStateChanges().listen((User? user) {
      if (user != null && mounted) {
        final uid = user.uid;
        getUser(uid);
        setState(() {
          isLogedIn = true;
        });
      }
    });
  }

  getUser(uid) async {
    final ref = FirebaseDatabase.instance.ref("Users/$uid");
    final snapshot = await ref.get();

    if (snapshot.exists && snapshot.value is Map) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      final user = userModel.User.fromJson(data, uid);
      setState(() {
        userRole = user.roleID;
      });
    }
  }

  @override
  void initState() {
    checkIfLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.settingsController,
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
          themeMode: widget.settingsController.themeMode,
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
                  case AdminReservationsIndex.routeName:
                    return const AdminReservationsIndex();

                  case AdimCategoriesIndex.routeName:
                    return const AdimCategoriesIndex();

                  case AdminLockersIndex.routeName:
                    return const AdminLockersIndex();

                  case AdminUsersIndex.routeName:
                    return const AdminUsersIndex();

                  case AdminLocationsIndex.routeName:
                    return const AdminLocationsIndex();

                  // Authentication routes
                  case OnboardingView.routeName:
                    return const OnboardingView();

                  case AuthRegisterView.routeName:
                    return const AuthRegisterView();

                  // Settings routes
                  case SettingsView.routeName:
                    return SettingsView(controller: widget.settingsController);

                  // Home routes
                  case HomeView.routeName:
                    return HomeView(
                      currentIndex: 0,
                    );

                  case UserFavoriteItems.routeName:
                    return const UserFavoriteItems();

                  case UserLocationsMap.routeName:
                    return const UserLocationsMap();

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

                  case ReservationsSingle.routeName:
                    // Extract itemId from route arguments
                    final Map<String, dynamic>? args =
                        routeSettings.arguments as Map<String, dynamic>?;

                    if (args != null && args.containsKey('reservationId')) {
                      final String reservationId =
                          args['reservationId'] as String;
                      return ReservationsSingle(reservationId: reservationId);
                    } else {
                      // Handle missing or invalid arguments
                      return const SizedBox.shrink();
                    }

                  case ReservingItemConfirmation.routeName:
                    // Extract itemId from route arguments
                    final Map<String, dynamic>? args =
                        routeSettings.arguments as Map<String, dynamic>?;

                    if (args != null && args.containsKey('reservationId')) {
                      final String reservationId =
                          args['reservationId'] as String;
                      return ReservingItemConfirmation(
                          reservationId: reservationId);
                    } else {
                      // Handle missing or invalid arguments
                      return const SizedBox.shrink();
                    }

                  case UserCreditView.routeName:
                    // Extract user model from router args
                    final Map<String, dynamic>? args =
                        routeSettings.arguments as Map<String, dynamic>?;
                    if (args != null && args.containsKey('user')) {
                      final userModel.User user =
                          args['user'] as userModel.User;
                      return UserCreditView(currentUser: user);
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
                    if (isLogedIn) {
                      if (userRole == "r1") {
                        return const AdminHomeView();
                      } else {
                        return HomeView(
                          currentIndex: 0,
                        );
                      }
                    } else {
                      return const OnboardingView();
                    }
                }
              },
            );
          },
        );
      },
    );
  }
}
