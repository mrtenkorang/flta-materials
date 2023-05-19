import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/models.dart';
import '../screens/grocery_item_screen.dart';
import '../screens/home.dart';
import '../screens/login_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/webview_screen.dart';

class AppRouter {
  final AppStateManager appStateManager;
  final ProfileManager profileManager;
  final GroceryManager groceryManager;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  AppRouter(this.appStateManager, this.profileManager, this.groceryManager);

  late final router = GoRouter(
      debugLogDiagnostics: true,
      refreshListenable: appStateManager,
      initialLocation: '/login',
      routes: [
        GoRoute(
          name: 'login',
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          name: 'onboarding',
          path: '/onboarding',
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          name: 'home',
          path: '/:tab',
          builder: (context, state) {
            final tab = int.tryParse(state.params['tab'] ?? '') ?? 0;
            return Home(
              key: state.pageKey, currentTab: tab,
            );
          },
          routes: [
              GoRoute(
                name: 'item',
                path: 'item/:id',
                builder: (context, state){
                  final itemId = state.params['id'] ?? '';
                  final item = groceryManager.getGroceryItem(itemId);
                  print(item);
                  return GroceryItemScreen(
                    originalItem: item,
                      onCreate: (item){
                        groceryManager.addItem(item);
                      },
                      onUpdate: (item){
                        groceryManager.updateItem(item);
                      });
                }
              ),
              GoRoute(
                name:'profile',
                  path: 'profile',
                builder: (context, state){
                  final tab = int.tryParse(state.params['tab'] ?? '') ?? 0;

                  return ProfileScreen(
                      user: profileManager.getUser,
                      currentTab: tab,
                  );
                },
                routes: [
                  GoRoute(
                      name: 'rw',
                      path: 'rw',
                  builder: (context, state)=> const WebViewScreen(),
                  )
                ],
              ),
          ],
        ),

      ],

      // Build an error  page if the user enters a url that does not exist in the app routes
      errorPageBuilder: (context, state) {
        return MaterialPage(
            child: Scaffold(
          body: Center(
            child: Text(
              state.error.toString(),
            ),
          ),
        ));
      },


    redirect: (state) {
      //print('hello');

      final loggedIn = appStateManager.isLoggedIn;
      //print('user is logged in: $loggedIn');

      final loggingIn = state.subloc == '/login';
      //print(loggingIn);

      if (!loggedIn) return loggingIn ? null : '/login';

      final isOnboardingComplete = appStateManager.isOnboardingComplete;

      final onboarding = state.subloc == '/onboarding';

        if (!isOnboardingComplete) {
          return onboarding ? null : '/onboarding';
        }

      if (loggingIn || onboarding) return '/${FooderlichTab.explore}';

      return null;
    },
  );
}
