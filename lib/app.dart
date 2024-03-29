import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import 'app_init.dart';
import 'common/config.dart';
import 'common/constants.dart';
import 'common/theme/index.dart';
import 'common/tools.dart';
import 'generated/l10n.dart';
import 'generated/languages/index.dart';
import 'models/brand_layout_model.dart';
import 'models/index.dart';
import 'models/tera_wallet/wallet_model.dart';
import 'modules/dynamic_layout/config/app_config.dart';
import 'modules/firebase/dynamic_link_service.dart';
import 'routes/route.dart';
import 'screens/blog/models/list_blog_model.dart';
import 'screens/index.dart' show ListBlogModel;
import 'services/index.dart';
import 'widgets/overlay/custom_overlay_state.dart';

class App extends StatefulWidget {
  final String languageCode;

  const App({
    required this.languageCode,
  });

  static final GlobalKey<NavigatorState> floralgardenNavigatorKey = GlobalKey();

  @override
  State<StatefulWidget> createState() {
    return AppState();
  }
}

class AppState extends State<App>
    with WidgetsBindingObserver
    implements NotificationDelegate, UserModelDelegate {
  AppModel? _app;
  final _product = ProductModel();
  final _wishlist = ProductWishListModel();
  final _shippingMethod = ShippingMethodModel();
  final _paymentMethod = PaymentMethodModel();
  final _recent = RecentModel();
  final _user = UserModel();
  final _filterModel = FilterAttributeModel();
  final _filterTagModel = FilterTagModel();
  final _categoryModel = CategoryModel();
  final _tagModel = TagModel();
  final _taxModel = TaxModel();
  final _pointModel = PointModel();
  final _notificationModel = NotificationModel();

  /// ---------- Vendor -------------
  final _storeModel = StoreModel();
  final _vendorShippingMethodModel = VendorShippingMethodModel();

  /// -------- Listing ------------///
  final _listingLocationModel = ListingLocationModel();

  CartInject cartModel = CartInject();
  bool isFirstSeen = false;
  bool isLoggedIn = false;

  // late var firebaseAnalyticsAbs;

  void appInitialModules() {
    var startTime = DateTime.now();

    Future.delayed(
      const Duration(milliseconds: 200),
      () {
        _user.delegate = this;
        _user.getUser();
        final notificationService = injector<NotificationService>();

        notificationService.init(notificationDelegate: this);
        notificationService.requestPermission();
        printLog(
            '[AppState] Register Firebase or OneSignal Modules', startTime);
      },
    );
  }

  /// Build the App Theme
  ThemeData getTheme({
    required AppConfig? appConfig,
    required String langCode,
    required ThemeMode themeMode,
  }) {
    var isDarkTheme = themeMode == ThemeMode.dark;

    if (appConfig == null) {
      /// This case is loaded first time without config file
      return buildLightTheme(langCode);
    }

    var fontFamily = appConfig.settings.fontFamily;
    var fontHeader = appConfig.settings.fontHeader;

    ThemeData themeData;
    if (isDarkTheme) {
      themeData = buildDarkTheme(langCode, fontFamily, fontHeader);
      themeData = themeData.copyWith(
          backgroundColor: darkBackgroundColor,
          primaryColorLight: darkPrimaryColorLight,
          cardColor: darkPrimaryColorLight,
          textTheme: themeData.textTheme.apply(
            displayColor: darkTextColor,
            bodyColor: darkTextColor,
          ),
          colorScheme: themeData.colorScheme.copyWith(
            secondary: darkSecondaryColor,
          ));
    } else {
      themeData = buildLightTheme(langCode, fontFamily, fontHeader);
      themeData = themeData.copyWith(
          backgroundColor: lightBackgroundColor,
          primaryColorLight: lightPrimaryColorLight,
          cardColor: lightPrimaryColorLight,
          textTheme: themeData.textTheme.apply(
            displayColor: lightTextColor,
            bodyColor: lightTextColor,
          ),
          colorScheme: themeData.colorScheme.copyWith(
            secondary: lightSecondaryColor,
          ));
    }

    /// The app will use mainColor from env.dart,
    /// or override it with mainColor from config JSON if found.
    var mainColor = appConfig.settings.mainColor.isNotEmpty
        ? appConfig.settings.mainColor
        : (isDarkTheme ? kDarkConfig : kLightConfig).mainColor;

    var colorScheme = themeData.colorScheme.copyWith(
      primary: HexColor(mainColor),
    );

    return themeData.copyWith(
      primaryColor: HexColor(mainColor),
      colorScheme: colorScheme,
      useMaterial3: appConfig.settings.useMaterial3,
    );
  }

  void updateDeviceToken(User? user) {
    if (GmsCheck().isGmsAvailable) {
      /// only update for login users
      if (user!.username != null) {
        Services().firebase.getMessagingToken().then((token) {
          try {
            printLog('[🔽 updateDeviceToken] user cookie ${user.cookie}');
            Services().api.updateUserInfo({'deviceToken': token}, user.cookie);
          } catch (e) {
            printLog(e);
          }
        });
      }
    }
    final notificationService = injector<NotificationService>();
    notificationService.setExternalId(user?.id);
  }

  @override
  void initState() {
    printLog('[AppState] initState');
    _app = AppModel(widget.languageCode);
    WidgetsBinding.instance.addObserver(this);

    appInitialModules();

    super.initState();
  }

  @override
  Future<void> onLoaded(User? user) async {
    if (!Config().isShopify) {
      updateDeviceToken(user);
    }

    /// init Cart Modal
    cartModel.model.changeCurrencyRates(_app?.currencyRate);

    /// save logged in user
    cartModel.model.setUser(user);
    if (user?.cookie != null && kAdvanceConfig.enableSyncCartFromWebsite) {
      await Services()
          .widget
          .syncCartFromWebsite(user?.cookie, cartModel.model, context);
    }
    if (user?.cookie != null && kAdvanceConfig.enableSyncCartToWebsite) {
      await Services().widget.syncCartToWebsite(cartModel.model);
    }

    if (user?.cookie != null && kAdvanceConfig.enablePointReward) {
      await _pointModel.getMyPoint(user?.cookie);
    }

    /// Preload address.
    await cartModel.model.getAddress();
  }

  @override
  Future<void> onLoggedIn(User user) async => onLoaded(user);

  @override
  Future<void> onLogout(User? user) async {
    cartModel.model.clearCart();
    await _wishlist.clearWishList();
    if (Services().firebase.isEnabled) {
      try {
        await Services().api.updateUserInfo({'deviceToken': ''}, user!.cookie);
      } catch (e) {
        printLog(e);
      }
    }
    final notificationService = injector<NotificationService>();
    notificationService.removeExternalId();
  }

  @override
  void onMessage(FStoreNotificationItem notification) {
    printLog(notification.toJson());
    _notificationModel.saveMessage(notification);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _notificationModel.checkGranted();
    }
  }

  @override
  Widget build(BuildContext context) {
    printLog('[AppState] Build app.dart');
    return ChangeNotifierProvider<AppModel>.value(
      value: _app!,
      child: Selector<AppModel, Tuple3<String, ThemeMode?, AppConfig?>>(
        selector: (_, model) =>
            Tuple3(model.langCode, model.themeMode, model.appConfig),
        builder: (context, value, child) {
          var langCode = value.item1;
          var themeMode = value.item2 ?? ThemeMode.light;
          var appConfig = value.item3;

          var languageCode = langCode.isEmptyOrNull
              ? kAdvanceConfig.defaultLanguage
              : langCode.toString();
          var countryCode = '';

          if (languageCode.contains('_')) {
            countryCode = languageCode.substring(languageCode.indexOf('_') + 1);
            languageCode =
                languageCode.substring(0, languageCode.indexOf(('_')));
          }

          return Directionality(
            textDirection: TextDirection.rtl,
            child: MultiProvider(
              providers: [
                Provider<ProductModel>.value(value: _product),
                ChangeNotifierProvider<ProductWishListModel>.value(
                    value: _wishlist),
                Provider<ShippingMethodModel>.value(value: _shippingMethod),
                Provider<PaymentMethodModel>.value(value: _paymentMethod),
                Provider<RecentModel>.value(value: _recent),
                ChangeNotifierProvider<UserModel>.value(value: _user),
                ChangeNotifierProxyProvider<UserModel, WalletModel>(
                  create: (BuildContext context) =>
                      WalletModel(user: _user.user ?? User()),
                  update: (BuildContext context, UserModel userModel,
                      WalletModel? walletModel) {
                    final currentUserToken = userModel.user?.cookie ?? '';
                    if (walletModel?.token != currentUserToken) {
                      return WalletModel(user: userModel.user ?? User());
                    }
                    return walletModel ?? WalletModel(user: User());
                  },
                ),
                ChangeNotifierProvider<ListBlogModel>(
                    create: (_) => ListBlogModel()),
                ChangeNotifierProvider<FilterAttributeModel>.value(
                    value: _filterModel),
                ChangeNotifierProvider<FilterTagModel>.value(
                    value: _filterTagModel),
                ChangeNotifierProvider<CategoryModel>.value(
                    value: _categoryModel),
                ChangeNotifierProvider(create: (_) => _tagModel),
                ChangeNotifierProvider(
                    create: (_) => cartModel.model, lazy: true),
                Provider<TaxModel>.value(value: _taxModel),
                ChangeNotifierProvider.value(value: _notificationModel),
                if (Config().isVendorType()) ...[
                  ChangeNotifierProvider<StoreModel>(
                      create: (_) => _storeModel),
                  ChangeNotifierProvider<VendorShippingMethodModel>(
                      create: (_) => _vendorShippingMethodModel),
                ],
                Provider<PointModel>.value(value: _pointModel),
                if (Config().isListingType) ...[
                  ChangeNotifierProvider<ListingLocationModel>(
                      create: (_) => _listingLocationModel)
                ],
                ChangeNotifierProvider<BlogModel>(create: (_) => BlogModel()),
                ChangeNotifierProvider<TextStyleModel>(
                    create: (_) => TextStyleModel()),
                ChangeNotifierProvider(create: (_) => BlogWishListModel()),
                ChangeNotifierProvider<BrandModel>(create: (_) => BrandModel()),
                ...Services().widget.getExtraProvidersConfig(),
                ChangeNotifierProvider<BrandLayoutModel>(
                  create: (_) => BrandLayoutModel(),
                ),
              ],
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                locale: Locale(languageCode, countryCode),
                navigatorKey: App.floralgardenNavigatorKey,
                navigatorObservers: [
                  MyRouteObserver(
                      action: (screenName) =>
                          OverlayControlDelegate().emitRoute?.call(screenName)),
                  ...Services().firebase.getMNavigatorObservers(),
                ],
                localizationsDelegates: const [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  DefaultCupertinoLocalizations.delegate,
                  LocalWidgetLocalizations.delegate,
                  SubMaterialLocalizations.delegate,
                  SubCupertinoLocalizations.delegate,
                ],
                supportedLocales: S.delegate.supportedLocales,
                home: const Scaffold(
                  body: AppInit(),
                ),
                routes: Routes.getAll(),
                onGenerateRoute: Routes.getRouteGenerate,
                theme: getTheme(
                  appConfig: appConfig,
                  langCode: langCode,
                  themeMode: themeMode,
                ),
                themeMode: themeMode,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void onMessageOpenedApp(FStoreNotificationItem notification) async {
    if (notification.additionalData?['dynamic_link'] != null) {
      var url = notification.additionalData!['dynamic_link'];
      await DynamicLinkService.handleDynamicLink(
          url, App.floralgardenNavigatorKey.currentContext!);
    }
    _notificationModel.saveMessage(notification);
  }
}
