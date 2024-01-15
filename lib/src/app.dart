import 'package:Leenloket/src/models/item_model.dart';
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
import 'package:Leenloket/src/views/user/reserving/reserving__item__step_1__credentials.dart';
import 'package:Leenloket/src/views/user/reserving/reserving__item__step_2__payment.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  var isLoggedIn = false;
  late userModel.User currentUser;
  String userRole = "r2";
  //Get current time, rounded to the nearest hour
  DateTime now = DateTime.now();
  late DateTime roundedNow;

  Future<userModel.User> getUser() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final ref = FirebaseDatabase.instance.ref("Users/$uid");
    final snapshot = await ref.get();

    if (snapshot.exists && snapshot.value is Map) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      final user = userModel.User.fromJson(data, uid);
      currentUser = user;
      isLoggedIn = true;
      return user;
    } else {
      throw Exception('User not found');
    }
  }

  @override
  void initState() {
    getInitialDateTime();
    super.initState();
  }

  //Generate initial DateTime, rounded to the nearest hour, only if the current time is between 06:00 and 22:00, otherwise return the next day at 06:00
  void getInitialDateTime() {
    roundedNow = DateTime(now.year, now.month, now.day, now.hour);
    print(roundedNow.hour >= 6 && roundedNow.hour < 22);
    if (roundedNow.hour >= 6 && roundedNow.hour < 22) {
      roundedNow = DateTime(now.year, now.month, now.day, now.hour + 1);
    } else {
      roundedNow = DateTime(now.year, now.month, now.day + 1, 06);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.settingsController,
      builder: (BuildContext context, Widget? child) {
        //Get current user
        return FutureBuilder<userModel.User>(
            future: getUser(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                currentUser = snapshot.data;
              }

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
                  primaryColor: Colors.red,
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
                          final Map<String, dynamic>? args =
                              routeSettings.arguments as Map<String, dynamic>?;
                          if (args != null && args.containsKey('user')) {
                            return SettingsView(
                                currentUser: args['user'] as userModel.User,
                                controller: widget.settingsController);
                          } else {
                            // Handle missing or invalid arguments
                            return const SizedBox.shrink();
                          }

                        // Home routes
                        case HomeView.routeName:
                          return HomeView(
                            currentUser: currentUser,
                            startDate: roundedNow,
                            endDate: roundedNow.add(const Duration(days: 1)),
                            currentIndex: 0,
                          );

                        case UserFavoriteItems.routeName:
                          return const UserFavoriteItems();

                        case UserLocationsMap.routeName:
                          return const UserLocationsMap();

                        case UserReservationsIndex.routeName:
                          final Map<String, dynamic>? args =
                              routeSettings.arguments as Map<String, dynamic>?;

                          if (args != null && args.containsKey('user')) {
                            final userModel.User user =
                                args['user'] as userModel.User;
                            return UserReservationsIndex(currentUser: user);
                          } else {
                            // Handle missing or invalid arguments
                            return const SizedBox.shrink();
                          }

                        case ReservingItemStep1.routeName:
                          // Extract itemId from route arguments
                          final Map<String, dynamic>? args =
                              routeSettings.arguments as Map<String, dynamic>?;

                          if (args != null &&
                              args.containsKey('item') &&
                              args.containsKey('user') &&
                              args.containsKey('startDate') &&
                              args.containsKey('endDate')) {
                            final Item item = args['item'] as Item;
                            final userModel.User user =
                                args['user'] as userModel.User;
                            final DateTime startDate =
                                args['startDate'] as DateTime;
                            final DateTime endDate =
                                args['endDate'] as DateTime;

                            return ReservingItemStep1(
                              startDate: startDate,
                              endDate: endDate,
                              user: user,
                              item: item,
                            );
                          } else {
                            // Handle missing or invalid arguments
                            return const SizedBox.shrink();
                          }

                        case ReservingItemStep2.routeName:
                          // Extract itemId from route arguments
                          final Map<String, dynamic>? args =
                              routeSettings.arguments as Map<String, dynamic>?;

                          if (args != null &&
                              args.containsKey('item') &&
                              args.containsKey('user') &&
                              args.containsKey('startDateTime') &&
                              args.containsKey('endDateTime')) {
                            final Item item = args['item'] as Item;
                            final userModel.User user =
                                args['user'] as userModel.User;
                            final DateTime start =
                                args['startDateTime'] as DateTime;
                            final DateTime end =
                                args['endDateTime'] as DateTime;
                            return ReservingItemStep2(
                              user: user,
                              item: item,
                              startDateTime: start,
                              endDateTime: end,
                            );
                          } else {
                            // Handle missing or invalid arguments
                            return const SizedBox.shrink();
                          }

                        case ReservationsSingle.routeName:
                          // Extract itemId from route arguments
                          final Map<String, dynamic>? args =
                              routeSettings.arguments as Map<String, dynamic>?;

                          if (args != null &&
                              args.containsKey('reservationId')) {
                            final String reservationId =
                                args['reservationId'] as String;
                            return ReservationsSingle(
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
                            final DateTime selectedStartDate =
                                args['selectedStartDate'] as DateTime;
                            final DateTime selectedEndDate = args[
                                    'selectedEndDate']
                                as DateTime; // Initialize selectedDay with the first day.
                            final currentUser =
                                args['currentUser'] as userModel.User;
                            return ShopItemSingleView(
                                currentUser: currentUser,
                                selectedEndDate: selectedEndDate,
                                selectedStartDate: selectedStartDate,
                                itemId: itemId);
                          } else {
                            // Handle missing or invalid arguments
                            return const SizedBox.shrink();
                          }

                        // Default route
                        default:
                          if (isLoggedIn) {
                            if (currentUser.roleID == "r1") {
                              return const AdminHomeView();
                            } else {
                              return HomeView(
                                currentUser: currentUser,
                                startDate: roundedNow,
                                endDate:
                                    roundedNow.add(const Duration(days: 1)),
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
            });
      },
    );
  }
}
