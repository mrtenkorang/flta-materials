import 'package:flutter/material.dart';
import '../screens/screens.dart';
import '../models/models.dart';

class AppRouter extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  final AppStateManager appStateManager;
  final GroceryManager groceryManager;
  final ProfileManager profileManager;

  AppRouter({
    this.appStateManager,
    this.groceryManager,
    this.profileManager,
  }) : navigatorKey = GlobalKey<NavigatorState>() {
    appStateManager.addListener(notifyListeners);
    groceryManager.addListener(notifyListeners);
    profileManager.addListener(notifyListeners);
  }

  @override
  void dispose() {
    appStateManager.removeListener(notifyListeners);
    groceryManager.removeListener(notifyListeners);
    profileManager.removeListener(notifyListeners);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onPopPage: _handlePopPage,
      pages: [
        if (!appStateManager.isInitialized) ...[
          SplashScreen.page(),
        ] else if (!appStateManager.isLoggedIn) ...[
          LoginScreen.page(),
        ] else if (!appStateManager.isOnboardingComplete) ...[
          OnboardingScreen.page(),
        ] else ...[
          Home.page(appStateManager.getSelectedTab),
          if (groceryManager.isCreatingNewItem)
            GroceryItemScreen.page(onCreate: (item) {
              groceryManager.addItem(item);
            }),
          if (groceryManager.selectedIndex != null)
            GroceryItemScreen.page(
                item: groceryManager.selectedGroceryItem,
                index: groceryManager.selectedIndex,
                onUpdate: (item, index) {
                  groceryManager.updateItem(item, index);
                }),
          if (profileManager.didSelectUser)
            ProfileScreen.page(profileManager.getUser),
          if (profileManager.didTapOnRaywenderlich) WebviewScreen.page(),
        ]
      ],
    );
  }

  bool _handlePopPage(Route<dynamic> route, result) {
    if (!route.didPop(result)) {
      return false;
    }

    if (route.settings.name == FooderlichPages.onboardingPath) {
      appStateManager.logout();
    }

    if (route.settings.name == FooderlichPages.groceryItemDetails) {
      groceryManager.groceryItemTapped(null);
    }

    if (route.settings.name == FooderlichPages.profilePath) {
      profileManager.tapOnUser(false);
    }

    if (route.settings.name == FooderlichPages.raywenderlich) {
      profileManager.tapOnRaywenderlich(false);
    }

    return true;
  }

  // TODO: Convert app state to applink

  // TODO: Apply configuration helper
  
  // TODO: Replace setNewRoutePath
  @override
  Future<void> setNewRoutePath(configuration) async => null;
}
