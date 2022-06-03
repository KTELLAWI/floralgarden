import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../generated/l10n.dart';
import '../../menu/maintab_delegate.dart';
import '../../models/index.dart' show BackDropArguments, CartModel, Product;
import '../../modules/dynamic_layout/helper/helper.dart';
import '../../routes/flux_navigate.dart';
import '../../screens/index.dart';
import '../../services/index.dart';
import '../../services/services.dart';
import '../../widgets/blog/banner/blog_list_view.dart';
import '../../widgets/common/webview.dart';
import '../config.dart';
import '../constants.dart';
import '../tools.dart';

class NavigateTools {
  static Future onTapNavigateOptions(
      {BuildContext? context,
      required Map config,
      List<Product>? products}) async {
    /// support to show the product detail
    if (config['product'] != null) {
      /// for pre-load the product detail
      final service = Services();
      var product = await service.api.getProduct(config['product']);

      if (product == null || product.isEmptyProduct()) {
        return;
      }

      return FluxNavigate.pushNamed(
        RouteList.productDetail,
        arguments: product,
        forceRootNavigator: true,
      );
    }
    if (config['tab'] != null) {
      return MainTabControlDelegate.getInstance().changeTab(config['tab']);
    }
    if (config['tab_number'] != null) {
      final index = (Helper.formatInt(config['tab_number'], 1) ?? 1) - 1;
      return MainTabControlDelegate.getInstance().tabAnimateTo(
        index,
      );
    }
    if (config['screen'] != null) {
      return Navigator.of(context!).pushNamed(config['screen']);
    }

    /// Launch the URL from external
    if (config['url_launch'] != null) {
      await Tools.launchURL(config['url_launch']);
    }

    /// support to show blog detail
    if (config['blog'] != null) {
      final id = config['blog'].toString();
      return Navigator.of(context!).pushNamed(
        RouteList.detailBlog,
        arguments: BlogDetailArguments(id: id),
      );
    }

    /// support to show blog category
    if (config['blog_category'] != null) {
      return Navigator.push(
        context!,
        MaterialPageRoute<void>(
          builder: (BuildContext context) =>
              BlogListView(id: config['blog_category'].toString()),
          fullscreenDialog: true,
        ),
      );
    }

    if (config['coupon'] != null) {
      return Navigator.of(context!).push(
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) => CouponList(
            couponCode: config['coupon'].toString(),
            onSelect: (String couponCode) async {
              final sharedPrefs = await SharedPreferences.getInstance();

              await sharedPrefs.setString('saved_coupon', couponCode);
              Provider.of<CartModel>(context, listen: false).loadSavedCoupon();

              Tools.showSnackBar(ScaffoldMessenger.of(context),
                  S.of(context).couponHasBeenSavedSuccessfully);
            },
          ),
        ),
      );
    }

    /// Navigate to vendor store on Banner Image
    if (config['vendor'] != null) {
      await Navigator.of(context!).push(
        MaterialPageRoute(
          builder: (context) =>
              Services().widget.renderVendorScreen(config['vendor']),
        ),
      );
      return;
    }

    /// support to show the post detail
    if (config['url'] != null) {
      return FluxNavigate.push(
        MaterialPageRoute(
          builder: (context) => WebView(
            url: config['url'],
            enableBackward: config['enableBackward'] ?? false,
            enableForward: config['enableForward'] ?? false,
            title: config['title'],
            onClose: (config['enableClose'] ?? true)
                ? () => Navigator.pop(context)
                : null,
          ),
        ),
        forceRootNavigator: true,
      );
    } else {
      /// For static image
      if (config['category'] == null &&
          config['tag'] == null &&
          products == null &&
          config['location'] == null) {
        return;
      }

      final category = config['category'];
      final showSubcategory = config['showSubcategory'] ?? false;

      if (category != null && showSubcategory) {
        unawaited(FluxNavigate.pushNamed(
          RouteList.subCategories,
          arguments: SubcategoryArguments(parentId: category.toString()),
        ));
        return;
      }

      /// Default navigate to show the list products
      await FluxNavigate.pushNamed(
        RouteList.backdrop,
        arguments: BackDropArguments(
          config: config,
          data: products,
        ),
      );
    }
  }

  static void onTapOpenDrawerMenu(BuildContext context) {
    eventBus.fire(const EventDrawerSettings());
    if (isDisplayDesktop(context)) {
      eventBus.fire(const EventSwitchStateCustomDrawer());
    } else {
      eventBus.fire(const EventOpenNativeDrawer());
    }
  }

  static void navigateHome(BuildContext context) {
    navigateToRootTab(context, RouteList.home);
  }

  static void navigateToRootTab(BuildContext context, String name) {
    Navigator.popUntil(context, (route) => route.isFirst);
    MainTabControlDelegate.getInstance().changeTab(name);
  }

  static void navigateAfterLogin(user, context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('${S.of(context).welcome} ${user.name} !'),
    ));

    if (kLoginSetting.isRequiredLogin) {
      Navigator.of(context).pushReplacementNamed(RouteList.dashboard);
      return;
    }

    var routeFound = false;
    var routeNames = [RouteList.dashboard, RouteList.productDetail];
    Navigator.popUntil(context, (route) {
      if (routeNames
          .any((element) => route.settings.name?.contains(element) ?? false)) {
        routeFound = true;
      }
      return routeFound || route.isFirst;
    });

    if (!routeFound) {
      Navigator.of(context).pushReplacementNamed(RouteList.dashboard);
    }
  }

  static void navigateRegister(context) {
    if (kAdvanceConfig.enableMembershipUltimate) {
      Navigator.of(context).pushNamed(RouteList.memberShipUltimatePlans);
    } else if (kAdvanceConfig.enablePaidMembershipPro) {
      Navigator.of(context).pushNamed(RouteList.paidMemberShipProPlans);
    } else if (kAdvanceConfig.enableDigitsMobileLogin) {
      Navigator.of(context).pushNamed(RouteList.digitsMobileLoginSignUp);
    } else {
      Navigator.of(context).pushNamed(RouteList.register);
    }
  }
}
