import 'package:flutter/cupertino.dart'
    show 
        CupertinoAlertDialog,
        CupertinoDialogAction,
        CupertinoIcons,
        showCupertinoDialog;
import 'package:flutter/material.dart';
import 'package:fstore/menu/index.dart' show MainTabControlDelegate;
import 'package:inspireui/icons/icon_picker.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:fstore/routes/flux_navigate.dart';
import '../../app.dart';
import '../../common/config.dart';
import '../../common/config/configuration_utils.dart';
import '../../common/constants.dart';
import '../../common/tools.dart';
import '../../generated/l10n.dart';
import '../../models/index.dart'
    show AppModel, CartModel, ProductWishListModel, User, UserModel;
import '../../models/notification_model.dart';
import '../../routes/flux_navigate.dart';
import '../../services/index.dart';
import '../../widgets/common/index.dart';
import 'package:fstore/widgets/general/index.dart';

import '../../widgets/general/index.dart';
import '../common/app_bar_mixin.dart';
import '../index.dart';
import '../posts/post_screen.dart';
import '../users/user_point_screen.dart';

const itemPadding = 15.0;

class SettingScreen extends StatefulWidget {
  final List<dynamic>? settings;
  final Map? subGeneralSetting;
  final String? background;
  final Map? drawerIcon;
  final VoidCallback? onLogout;
  final bool hideUser;

  const SettingScreen({
    this.onLogout,
    this.settings,
    this.subGeneralSetting,
    this.background,
    this.drawerIcon,
    this.hideUser = false,
  });

  @override
  SettingScreenState createState() {
    return SettingScreenState();
  }
}

class SettingScreenState extends State<SettingScreen>
    with
        TickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<SettingScreen>,
        AppBarMixin {
  @override
  bool get wantKeepAlive => true;

  User? get user => Provider.of<UserModel>(context, listen: false).user;
  bool isAbleToPostManagement = false;

  final bannerHigh = 150.0;
  final RateMyApp _rateMyApp = RateMyApp(
      // rate app on store
      minDays: 7,
      minLaunches: 10,
      remindDays: 7,
      remindLaunches: 10,
      googlePlayIdentifier: kStoreIdentifier['android'],
      appStoreIdentifier: kStoreIdentifier['ios']);

  void showRateMyApp() {
    _rateMyApp.showRateDialog(
      context,
      title: S.of(context).rateTheApp,
      // The dialog title.
      message: S.of(context).rateThisAppDescription,
      // The dialog message.
      rateButton: S.of(context).rate.toUpperCase(),
      // The dialog 'rate' button text.
      noButton: S.of(context).noThanks.toUpperCase(),
      // The dialog 'no' button text.
      laterButton: S.of(context).maybeLater.toUpperCase(),
      // The dialog 'later' button text.
      listener: (button) {
        // The button click listener (useful if you want to cancel the click event).
        switch (button) {
          case RateMyAppDialogButton.rate:
            break;
          case RateMyAppDialogButton.later:
            break;
          case RateMyAppDialogButton.no:
            break;
        }

        return true; // Return false if you want to cancel the click event.
      },
      // Set to false if you want to show the native Apple app rating dialog on iOS.
      dialogStyle: const DialogStyle(),
      // Custom dialog styles.
      // Called when the user dismissed the dialog (either by taping outside or by pressing the 'back' button).
      // actionsBuilder: (_) => [], // This one allows you to use your own buttons.
    );
  }

  void checkAddPostRole() {
    for (var legitRole in addPostAccessibleRoles) {
      if (user!.role == legitRole) {
        setState(() {
          isAbleToPostManagement = true;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (isMobile) {
      if (!kStoreIdentifier['disable']) {
        _rateMyApp.init().then((_) {
          // state of rating the app
          if (_rateMyApp.shouldOpenDialog) {
            showRateMyApp();
          }
        });
      }
    }
  }

  /// Render the Delivery Menu.
  /// Currently support WCFM
  Widget renderDeliveryBoy() {
    var isDelivery = user?.isDeliveryBoy ?? false;

    if (!isDelivery) {
      return const SizedBox();
    }

    return Card(
      color: Theme.of(context).backgroundColor,
      margin: const EdgeInsets.only(bottom: 2.0),
      elevation: 0,
      child: ListTile(
        onTap: () {
          FluxNavigate.push(
            MaterialPageRoute(
              builder: (context) =>
                  Services().widget.getDeliveryScreen(context, user)!,
            ),
            forceRootNavigator: true,
          );
        },
        leading: Icon(
          CupertinoIcons.cube_box,
          size: 24,
          color: Theme.of(context).colorScheme.secondary,
        ),
        title: Text(
          S.of(context).deliveryManagement,
          style: const TextStyle(fontSize: 16),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 18,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }

  /// Render the Admin Vendor Menu.
  /// Currently support WCFM & Dokan. Will support WooCommerce soon.
  Widget renderVendorAdmin() {
    var isVendor = user?.isVender ?? false;

    if (!isVendor || serverConfig['type'] == 'listeo') {
      return const SizedBox();
    }

    return Card(
      color: Theme.of(context).backgroundColor,
      margin: const EdgeInsets.only(bottom: 2.0),
      elevation: 0,
      child: ListTile(
        onTap: () {
          FluxNavigate.pushNamed(
            RouteList.vendorAdmin,
            arguments: user,
            forceRootNavigator: true,
          );
        },
        leading: Icon(
          Icons.dashboard,
          size: 24,
          color: Theme.of(context).colorScheme.secondary,
        ),
        title: Text(
          S.of(context).vendorAdmin,
          style: const TextStyle(fontSize: 16),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 18,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }

  Widget renderVendorVacation() {
    var isVendor = user?.isVender ?? false;

    if ((kfloralgardenMV.contains(serverConfig['type']) && !isVendor) ||
        serverConfig['type'] != 'wcfm' ||
        !kVendorConfig['DisableNativeStoreManagement']) {
      return const SizedBox();
    }

    return Card(
      color: Theme.of(context).backgroundColor,
      margin: const EdgeInsets.only(bottom: 2.0),
      elevation: 0,
      child: ListTile(
        onTap: () {
          FluxNavigate.push(
            MaterialPageRoute(
              builder: (context) => Services().widget.renderVacationVendor(
                  user!.id!, user!.cookie!,
                  isFromMV: true),
            ),
            forceRootNavigator: true,
          );
        },
        leading: Icon(
          Icons.house,
          size: 24,
          color: Theme.of(context).colorScheme.secondary,
        ),
        title: Text(
          S.of(context).storeVacation,
          style: const TextStyle(fontSize: 16),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 18,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }

  /// Render the custom profile link via Webview
  /// Example show some special profile on the woocommerce site: wallet, wishlist...
  Widget renderWebViewProfile() {
    if (user == null) {
      return Container();
    }

    var base64Str = EncodeUtils.encodeCookie(user!.cookie!);
    var profileURL = '${serverConfig['url']}/my-account?cookie=$base64Str';

    return Card(
      color: Theme.of(context).backgroundColor,
      margin: const EdgeInsets.only(bottom: 2.0),
      elevation: 0,
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WebView(
                  url: profileURL, title: S.of(context).updateUserInfor),
            ),
          );
        },
        leading: Icon(
          CupertinoIcons.profile_circled,
          size: 24,
          color: Theme.of(context).colorScheme.secondary,
        ),
        title: Text(
          S.of(context).updateUserInfor,
          style: const TextStyle(fontSize: 16),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Theme.of(context).colorScheme.secondary,
          size: 18,
        ),
      ),
    );
  }

  Widget renderItem(value) {
    IconData icon;
    String title;
    Widget trailing;
    Function() onTap;
    var isMultiVendor = kfloralgardenMV.contains(serverConfig['type']);
    var subGeneralSetting = widget.subGeneralSetting != null
        ? ConfigurationUtils.loadSubGeneralSetting(widget.subGeneralSetting!)
        : kSubGeneralSetting;
    var item = subGeneralSetting[value];

    if (value.contains('web')) {
      return GeneralWebWidget(item: item);
    }

    if (value.contains('post-')) {
      return GeneralPostWidget(item: item);
    }

    if (value.contains('title')) {
      return GeneralTitleWidget(item: item, itemPadding: itemPadding);
    }

    if (value.contains('button')) {
      return GeneralButtonWidget(item: item);

    }

    switch (value) {
      case 'products':
        {
          if (!(user != null ? user!.isVender : false) || !isMultiVendor) {
            return const SizedBox();
          }
          trailing = const Icon(
            Icons.arrow_forward_ios,
            size: 18,
            color: kGrey600,
          );
          title = S.of(context).myProducts;
          icon = CupertinoIcons.cube_box;
          onTap = () => Navigator.pushNamed(context, RouteList.productSell);
          break;
        }

//       case 'chat':
//         {
//           // if (user == null || Config().isListingType || !isMultiVendor) {
//           //   return Container();
//           // }
//           trailing = const Icon(
//             Icons.arrow_forward_ios,
//             size: 18,
//             color: kGrey600,
//           );
//           title = S.of(context).conversations;
//           icon = CupertinoIcons.chat_bubble_2;
//           onTap = (){
//            Navigator.pushNamed(context, RouteList.listChat);
// print("dddd");
//           };//() =>//
//           break;
//         }
//       case 'wallet':
//         {
//           if (user == null || !Config().isWooType) {
//             return Container();
//           }
//           trailing = const Icon(
//             Icons.arrow_forward_ios,
//             size: 18,
//             color: kGrey600,
//           );
//           title = S.of(context).myWallet;
//           icon = CupertinoIcons.square_favorites_alt;
//           onTap = () => FluxNavigate.pushNamed(
//                 RouteList.myWallet,
//                 forceRootNavigator: true,
//               );
//           break;
//         }

      
      case 'notifications':
        {
          return Consumer<NotificationModel>(builder: (context, model, child) {
            return 
            //Column(
                ClipRRect(
              borderRadius: BorderRadius.circular(25.0),
       child: Column (
         children: [
            Card(
        
          margin: const EdgeInsets.only(bottom: 2.0),
          elevation: 1,
            shape: context.isRtl ?   Border(right: BorderSide(color:Color(0xff91b375) , width:20))
          : Border(left: BorderSide(color:Color(0xff91b375) , width:20)),
 
 
          // shape: RoundedRectangleBorder(
          //  borderRadius: BorderRadius.only(
          //   bottomRight: Radius.circular(10),
          //   topRight: Radius.circular(10)),
          //   side: BorderSide(width: 5, color: Colors.green)),
          child: Padding(
            padding:const EdgeInsets.only(left:10,right:10),
          //  child:
             // children: [
                // Card(
                //   margin: const EdgeInsets.only(bottom: 2.0),
                //   elevation: 0,
                  child: SwitchListTile(
                    secondary: Icon(
                      CupertinoIcons.bell,
                      color: Theme.of(context).colorScheme.secondary,
                      size: 24,
                    ),
                    value: model.enable,
                    activeColor: const Color(0xFF0066B4),
                    onChanged: (bool enableNotification) {
                      if (enableNotification) {
                        model.enableNotification();
                      } else {
                        model.disableNotification();
                      }
                    },
                    title: Text(
                      S.of(context).getNotification,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
       ),
                // const Divider(
                //   color: Colors.black12,
                //   height: 1.0,
                //   indent: 75,
                //   //endIndent: 20,
                // ),
              //  if (model.enable) ...[
                  Card(
                      margin: const EdgeInsets.only(bottom: 2.0),
          elevation: 1,
            shape: context.isRtl ?   Border(right: BorderSide(color:Color(0xff91b375) , width:20))
          : Border(left: BorderSide(color:Color(0xff91b375) , width:20)),
                    // margin: const EdgeInsets.only(bottom: 2.0),
                    // elevation: 0,
                    child: Padding(
            padding:const EdgeInsets.only(left:10,right:10),
            child:
            GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(RouteList.notify);
                      },
                      child: ListTile(
                        leading: Icon(
                          CupertinoIcons.list_bullet,
                          size: 24,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        title: Text(S.of(context).listMessages),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                          color: kGrey600,
                        ),
                      ),
                    ),
            ),
                    
                  ),

         ]

       )
      
                  // const Divider(
                  //   color: Colors.black12,
                  //   height: 1.0,
                  //   indent: 75,
                  //   //endIndent: 20,
                  // ),
                //],
             // ],
            );//coloumn
          }
          );
        }
      case 'language':
        {
          icon = CupertinoIcons.globe;
          title = S.of(context).language;
          trailing = const Icon(
            Icons.arrow_forward_ios,
            size: 18,
            color: kGrey600,
          );
          onTap = () => Navigator.of(context).pushNamed(RouteList.language);
          break;
        }
      case 'currencies':
        {
          if (Config().isListingType) {
            return Container();
          }
          icon = CupertinoIcons.money_dollar_circle;
          title = S.of(context).currencies;
          trailing =
              const Icon(Icons.arrow_forward_ios, size: 18, color: kGrey600);
          onTap = () => Navigator.of(context).pushNamed(RouteList.currencies);
          break;
        }

      case 'wishlist':
        {
          
          final wishListCount =
              Provider.of<ProductWishListModel>(context, listen: false)
                  .products
                  .length;
          trailing = 
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (wishListCount > 0)
                Text(
                  '$wishListCount ${S.of(context).items}',
                  style: TextStyle(
                      fontSize: 14, color: Theme.of(context).primaryColor),
                ),
              const SizedBox(width: 5),
              const Icon(Icons.arrow_forward_ios, size: 18, color: kGrey600)
            ],
          );

          title = S.of(context).myWishList;
          icon = CupertinoIcons.heart;
          onTap = () => Navigator.of(context).pushNamed(RouteList.wishlist);
          break;
        }
      case 'darkTheme':
 { 
   
//;

   ////
          return
          Column(
           children: [
             SizedBox(height:30),
               ClipRRect(
              borderRadius: BorderRadius.circular(25.0),
       child: Card(
        
          margin: const EdgeInsets.only(bottom: 2.0),
          elevation: 10,
            shape: context.isRtl ?   Border(right: BorderSide(color:Color(0xff91b375) , width:20))
          : Border(left: BorderSide(color:Color(0xff91b375) , width:20)),
 
              // Card(
              //   margin: const EdgeInsets.only(bottom: 2.0),
              //   elevation: 0,
                child:   Padding(
            padding:const EdgeInsets.only(left:10,right:10),
              child:  SwitchListTile(
                  secondary: Icon(
                    Provider.of<AppModel>(context).darkTheme
                        ? CupertinoIcons.sun_min
                        : CupertinoIcons.moon,
                    color: Theme.of(context).colorScheme.secondary,
                    size: 24,
                  ),
                  value: Provider.of<AppModel>(context).darkTheme,
                  activeColor: const Color(0xFF0066B4),
                  onChanged: (bool value) {
                    if (value) {
                      Provider.of<AppModel>(context, listen: false)
                          .updateTheme(true);
                    } else {
                      Provider.of<AppModel>(context, listen: false)
                          .updateTheme(false);
                    }
                  },
                  title: Text(
                    S.of(context).darkTheme,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                ),
              ),
          ),////clip
              // const Divider(
              //   color: Colors.black12,
              //   height: 1.0,
              //   indent: 75,
              //   //endIndent: 20,
              // ),
           ],
         );
        }
      case 'order':
        {
          final storage = LocalStorage(LocalStorageKey.dataOrder);
          var items = storage.getItem('orders');
          if (user == null && items == null) {
            return Container();
          }
          if (Config().isListingType) {
            return const SizedBox();
          }
       
          icon = CupertinoIcons.time;
          title = S.of(context).orderHistory;//S.of(context).orderHistory;
          trailing =
              const Icon(Icons.arrow_forward_ios, size: 18, color: kGrey600);
          onTap = () {
            final user = Provider.of<UserModel>(context, listen: false).user;
            FluxNavigate.pushNamed(
              RouteList.orders,
              arguments: user,
            );
          };
          break;
        }
      // case 'point':
      //   {
      //     if (!(kAdvanceConfig['EnablePointReward'] == true && user != null)) {
      //       return const SizedBox();
      //     }
      //     if (Config().isListingType) {
      //       return const SizedBox();
      //     }
      //     icon = CupertinoIcons.bag_badge_plus;
      //     title = S.of(context).myPoints;
      //     trailing =
      //         const Icon(Icons.arrow_forward_ios, size: 18, color: kGrey600);
      //     onTap = () => Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) => UserPointScreen(),
      //           ),
      //         );
      //     break;
      //   }
      case 'rating':
        {
          icon = CupertinoIcons.star;
          title = S.of(context).rateTheApp;
          trailing =
              const Icon(Icons.arrow_forward_ios, size: 18, color: kGrey600);
          onTap = showRateMyApp;
          break;
        }
      // case 'privacy':
      //   {
      //     icon = CupertinoIcons.doc_text;
      //     title = S.of(context).agreeWithPrivacy;
      //     trailing =
      //         const Icon(Icons.arrow_forward_ios, size: 18, color: kGrey600);
      //     onTap = () {
      //       final privacy = subGeneralSetting['privacy'];
      //       final pageId =
      //           privacy?.pageId ?? kAdvanceConfig['PrivacyPoliciesPageId'];
      //       String? pageUrl =
      //           privacy?.webUrl ?? kAdvanceConfig['PrivacyPoliciesPageUrl'];
      //       if (pageId != null && (privacy?.webUrl?.isEmpty ?? true)) {
      //         Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //               builder: (context) => PostScreen(
      //                   pageId: pageId,
      //                   pageTitle: S.of(context).agreeWithPrivacy),
      //             ));
      //         return;
      //       }
      //       if (pageUrl?.isNotEmpty ?? false) {
      //         ///Display multiple languages WebView
      //         var locale =
      //             Provider.of<AppModel>(context, listen: false).langCode;
      //         if (pageUrl != null && locale != null) {
      //           pageUrl += '?lang=$locale';
      //         }
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) => WebView(
      //               url: pageUrl,
      //               title: S.of(context).agreeWithPrivacy,
      //             ),
      //           ),
      //         );
      //       }
      //     };
      //     break;
      //   }
      // case 'about':
      //   {
      //     icon = CupertinoIcons.info;
      //     title = S.of(context).aboutUs;
      //     trailing =
      //         const Icon(Icons.arrow_forward_ios, size: 18, color: kGrey600);
      //     onTap = () {
      //       final about = subGeneralSetting['about'];
      //       final aboutUrl = about?.webUrl ?? SettingConstants.aboutUsUrl;

      //       if (kIsWeb) {
      //         return Tools.launchURL(aboutUrl);
      //       }
      //       return FluxNavigate.push(
      //         MaterialPageRoute(
      //           builder: (context) =>
      //               WebView(url: aboutUrl, title: S.of(context).aboutUs),
      //         ),
      //         forceRootNavigator: true,
      //       );
      //     };
      //     break;
      //   }
      // case 'post':
      //   {
      //     if (user != null) {
      //       trailing = const Icon(
      //         Icons.arrow_forward_ios,
      //         size: 18,
      //         color: kGrey600,
      //       );
      //       title = S.of(context).postManagement;
      //       icon = CupertinoIcons.chat_bubble_2;
      //       onTap = () {
      //         Navigator.of(context).pushNamed(RouteList.postManagement);
      //       };
      //     } else {
      //       return const SizedBox();
      //     }

      //     break;
      //   }
      default:
        {
          trailing =
              const Icon(Icons.arrow_forward_ios, size: 18, color: kGrey600);
          icon = Icons.error;
          title = S.of(context).dataEmpty;
          onTap = () {};
        }
    }
    return 
    Column(
      children: [
        SizedBox(height:30),
        ClipRRect(
              borderRadius: BorderRadius.circular(25.0),
       child: Card(
        
          margin: const EdgeInsets.only(bottom: 2.0),
          elevation: 10,
           shape: context.isRtl ?   Border(right: BorderSide(color:Color(0xff91b375) , width:20))
          : Border(left: BorderSide(color:Color(0xff91b375) , width:20)),
 
          // shape: RoundedRectangleBorder(
          //  borderRadius: BorderRadius.only(
          //   bottomRight: Radius.circular(10),
          //   topRight: Radius.circular(10)),
          //   side: BorderSide(width: 5, color: Colors.green)),
          child: Padding(
            padding:const EdgeInsets.only(left:10,right:10),
            child:
          
          ListTile(
          //  padding:const EdgeInsets.all(5),
            leading: Icon(
              icon,
              color: Theme.of(context).colorScheme.secondary,
              size: 24,
            ),
            title: Text(
              title,
              style: const TextStyle(fontSize: 16),
            ),
            trailing: trailing,
            onTap: onTap,
          ),
       ),
        ),
    ),
        // const Divider(
        //   color: Colors.black12,
        //   height: 1.0,
        //   indent: 75,
        //   //endIndent: 20,
        // ),
      ],
    );
  }

  Widget renderDrawerIcon() {
    var icon = Icons.blur_on;
    if (widget.drawerIcon != null) {
      icon = iconPicker(
              widget.drawerIcon!['icon'], widget.drawerIcon!['fontFamily']) ??
          Icons.blur_on;
    }
    return Icon(
      icon,
      color: Colors.white70,
    );
  }

  void pushNavigation(String name) {
    eventBus.fire(const EventCloseNativeDrawer());
    MainTabControlDelegate.getInstance().changeTab(name.replaceFirst('/', ''));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var isDarkTheme = Provider.of<AppModel>(context, listen: false).darkTheme;

    var settings = ["notifications","language","wishlist","darkTheme","order","rating"];//widget.settings ?? kDefaultSettings;
    var background = widget.background ?? kProfileBackground;
    const textStyle = TextStyle(fontSize: 16);

    final appBar = (showAppBar(RouteList.profile))
        ? sliverAppBarWidget
        : SliverAppBar(
            backgroundColor: Theme.of(context).primaryColor,
            // leading: IconButton(
            //   icon: renderDrawerIcon(),
            //   onPressed: () => NavigateTools.onTapOpenDrawerMenu(context),
            // ),
            // expandedHeight: bannerHigh,
            // floating: true,
            // pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                S.of(context).settings,
                style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
              // background: FluxImage(
              //   imageUrl: background,
              //   fit: BoxFit.cover,
              // ),
            ),
            // actions: Navigator.canPop(context)
            //     ? [
            //         Padding(
            //           padding: const EdgeInsets.symmetric(horizontal: 10),
            //           child: GestureDetector(
            //             onTap: () => Navigator.pop(context),
            //             child: const Icon(
            //               Icons.close,
            //               color: Colors.white,
            //             ),
            //           ),
            //         ),
            //       ]
            //     : null,
          );

    return  Stack(
        children: <Widget>[
          Image.asset(
            "assets/images/background.png",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
    
    Scaffold(
      //backgroundColor: Theme.of(context).backgroundColor,
       appBar: AppBar(
         backgroundColor:isDarkTheme ? Theme.of(context).backgroundColor : Colors.white,//Colors.white,
                   flexibleSpace:Container(
                   // color:const Color(0xffff690a),
            // decoration: const  BoxDecoration(
            //  gradient: LinearGradient(
                
            //     begin: FractionalOffset(0.0,0.0),
            //     end : FractionalOffset(1.0,0.0),
            //     stops:[0.0,1.0],
            //     tileMode:TileMode.clamp,
            //     colors:[
            //       const Color(0xffffbf00),
            //        const Color(0xfffeae29),
                    

            //   ],
            //   ),
            // ),
          ), 
 toolbarHeight: 100, // Set this height
  // flexibleSpace: Container(
  //   color: Colors.orange,
  //   child: Column(
  //     children: [
  //       Text('1'),
  //       Text('2'),
  //       Text('3'),
  //       Text('4'),
  //     ],
  //   ),
  // ),
      //          leading: GestureDetector(
      //       onTap:  () =>
      //                 NavigateTools.onTapOpenDrawerMenu(context),
      //       child: const Icon(Icons.menu, color: Colors.white,
      // size: 36.0,),
      //     ),
          //backgroundColor:const Color(0xffffbf00),
               
                    
             title: isDarkTheme ? Image.network(
                             'https://i.imgur.com/99g2nLi.png',
                                 width:165,
                                 height:165,
                                ): Image.network(
                              'https://i.imgur.com/XhaKMqR.png',
                                 width:165,
                                 height:165,
                                ),
                 

                             
                      
             centerTitle: true,
   shape: Border(
    bottom: BorderSide(
      color:const Color(0xff91b375), //Colors.orange,const Color(0xff05dae5)
      width: 1
    )
  ),
  elevation: 3,
   
              bottom: new PreferredSize(
      preferredSize: const Size.fromHeight(30.0),
      child: new Padding(
        padding: new EdgeInsets.only(
          bottom: 10.0,
          left: 10.0,
          right: 10.0,
        ),
        child:isDarkTheme ?
        Text(S.of(context).settings,style:TextStyle(fontSize:25,)):Text(S.of(context).settings,style:TextStyle(fontSize:25,),),
        
        
        
        ), 
        
        
        ), 
       ),
       
// AppBar(
//         flexibleSpace:Container(
//             decoration: const  BoxDecoration(
//              gradient: LinearGradient(
                
//                 begin: FractionalOffset(0.0,0.0),
//                 end : FractionalOffset(0.0,1.0),
//                 stops:[0.0,1.0],
//                 tileMode:TileMode.clamp,
//                 colors:[
//                   const Color(0xffffbf00),
//                    const Color(0xff05dae5),
//                   // backgroundColor: const Color(0xff05dae5),
                    

//               ],
//               ),
//             ),
//           ),  
//  toolbarHeight: 100,
    
// //  leading:
// //   GestureDetector(
   
            
// //             child: const Icon(Icons.arrow_back_ios, color: Colors.white,
// //              size: 36.0,), ) ,
//            backgroundColor:Colors.red,
//                        title:
           
// Image.network('https://i.imgur.com/cNVVbrC.png',
//                                 ),
                             
                      
//              centerTitle: true,
//  bottom: new PreferredSize(
//       preferredSize: const Size.fromHeight(30.0),
//       child: new Padding(
//         padding: new EdgeInsets.only(
//           bottom: 10.0,
//           left: 10.0,
//           right: 10.0,
//         ),
//         child:Text("Settings",style:TextStyle(fontSize:25,color:Colors.white),) ), ),      
//           ),
      backgroundColor:Theme.of(context).backgroundColor,//Colors.transparent,////Colors.transparent,//Colors.green, //const Color(0xff05dae5),
      body: ListenableProvider.value(
        value: Provider.of<UserModel>(context),
        child: Consumer<UserModel>(builder: (context, model, child) {
          final user = model.user;
          final loggedIn = model.loggedIn;
          if (!loggedIn){
          return  
           
          Column(
           mainAxisAlignment:MainAxisAlignment.center,
           crossAxisAlignment:CrossAxisAlignment.center,
            children:<Widget>[
            
            
              Container(
               //  width:MediaQuery.of(context).size.width,
                // height:MediaQuery.of(context).size.height,
                child:Center(
              child:Text(""),
                  // Image.network("https://i.imgur.com/YhgPXD0.png",height: 90),            
            )
              ),
              Container(
                margin:const EdgeInsets.all(20),
                child: isDarkTheme ? Text("",textAlign: TextAlign.center,style:TextStyle(fontSize:25,color:Colors.white,  )):Text("",textAlign: TextAlign.center,style:TextStyle(fontSize:25,color:Colors.black,  )),
                //context.isRtl ? 

               // Text("You have not logged or registred yet ",textAlign: TextAlign.center,style:TextStyle(fontSize:25,color:Colors.black,  )),
                ),
              
              ElevatedButton(
                       
            style:  ButtonStyle(
            // backgroundColor: MaterialStateProperty.all(Colors.white),
              overlayColor:MaterialStateProperty.all(Color(0xff91b375)),
              shadowColor: MaterialStateProperty.all(Colors.white),
              // side: MaterialStateProperty.all(BorderSide(
                       // color: Color(0xffffbf00) ,
                        //width: 2.0,
                       // style: BorderStyle.solid)),

          // overlayColor:MaterialStateProperty.all(Color(0x187BCD)) ,//change with your color
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ))),
            onPressed: () {
                 
                    pushNavigation(RouteList.login);
                 
                },
            child:
            Text(S.of(context).login,style:TextStyle(color: Colors.white,fontSize:20)),
                   
            // Text('تسجيل الدخول',style:TextStyle(color: Colors.black)),
         
        ),
            ]
          
          
       
            
          );

          //return  CustomScrollView(
            

        //  );

         
           
          } else {
            return  SingleChildScrollView(
               child: Container(
                 
                 child:Column(
                   children: <Widget>[
                      // Container(height:10,color:Colors.yellow),
                     Container(
                       width:MediaQuery.of(context).size.width,
                       //margin: const EdgeInsets.all(15),
                     //  mainAxisAlignment:MainAxisAlignment.center,
                      // crossAxisAlignment:CrossAxisAlignment.center,
                       margin: const EdgeInsets.all(25),
                       padding:const EdgeInsets.all(10),
                       
                       decoration: BoxDecoration(
                                          boxShadow: [
                            // to make elevation
                            BoxShadow(
                              color:  Color(0xff91b375),
                              offset: Offset(2, 2),
                              blurRadius: 4,
                            ),
                            // to make the coloured border
                            BoxShadow(
                              color:  Color(0xff91b375),
                              offset: Offset(0, 4),
                            ),
                          ],
                         color:isDarkTheme ? Theme.of(context).backgroundColor : Colors.white,//Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(35.0),
              bottomLeft: Radius.circular(35.0),
               topRight: Radius.circular(35.0),
              bottomRight: Radius.circular(35.0),
              
              ),
          //color: Colors.green,
        ),
     // ),
                       child:Column(
                          mainAxisAlignment:MainAxisAlignment.center,
                          crossAxisAlignment:CrossAxisAlignment.center,
                         children:<Widget>[
                                                     
                            (user!.picture?.isNotEmpty ?? false)
                                  ? CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(user.picture!),
                                    )
                                  : const Icon(Icons.face),
                                  if (user != null && user.name != null)
                                  SizedBox(height:20),
                                  if (user != null && user.email != null && user.email!.isNotEmpty && context.isRtl )
                                   Text(" مرحبا ${user.name!} ", textAlign:TextAlign.center),
                                   if (user != null && user.email != null && user.email!.isNotEmpty && !context.isRtl )
                                  Text(" Wlecome ${user.name!} ", textAlign:TextAlign.center),

                                   
                                 
                                 

                                  SizedBox(height:20),
                                  ElevatedButton(
                                       style:  ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Colors.white),
                                        overlayColor:MaterialStateProperty.all(Color(0xff91b375)),
                                        shadowColor: MaterialStateProperty.all(Colors.white),
                                        side: MaterialStateProperty.all(BorderSide(
                                                  color: Color(0xff91b375) ,
                                                  width: 2.0,
                                                  style: BorderStyle.solid)),

                                    // overlayColor:MaterialStateProperty.all(Color(0x187BCD)) ,//change with your color
                                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ))),
                                      onPressed: () async {
                                      final hasChangePassword = await FluxNavigate.pushNamed( RouteList.updateUser, forceRootNavigator: true, ) as bool?;
                                                            /// If change password with Shopify
                                                            /// need to log out and log in again
                                                            if (Config().isShopify &&
                                                                (hasChangePassword ?? false)) {
                                                              _showDialogLogout(); } },
                                      child:Text( S.of(context).updateUserInfor,style:TextStyle(color: Colors.black,fontSize:20)),  ),
                                 ///
                                  SizedBox(height:20),
                                 if (user != null)
                                  ElevatedButton(
                                       style:  ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Colors.white),
                                        overlayColor:MaterialStateProperty.all(Color(0xff91b375)),
                                        shadowColor: MaterialStateProperty.all(Colors.white),
                                        side: MaterialStateProperty.all(BorderSide(
                                                  color: Color(0xff91b375) ,
                                                  width: 2.0,
                                                  style: BorderStyle.solid)),

                                    // overlayColor:MaterialStateProperty.all(Color(0x187BCD)) ,//change with your color
                                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ))),
                                      onPressed: ()=> _onLogout(),
                
                                      child:Text( S.of(context).logout,style:TextStyle(color: Colors.black,fontSize:20)),  ),
                                 
                                 
                                 
                                 
                                 /// last 

                          

                         ]
                       ),
                     ),
                      //  if (user != null && user.name != null)
                      //       ListTile(
                      //         leading: (user.picture?.isNotEmpty ?? false)
                      //             ? CircleAvatar(
                      //                 backgroundImage:
                      //                     NetworkImage(user.picture!),
                      //               )
                      //             : const Icon(Icons.face),
                      //         title: Text(
                      //           user.name!.replaceAll('floralgarden', ''),
                      //           style: textStyle,
                      //         ),
                      //       ),
                            ////////////
                            // if (user != null &&
                            //   user.email != null &&
                            //   user.email!.isNotEmpty)
                            // ListTile(
                            //   leading: const Icon(Icons.email),
                            //   title: Text(
                            //     user.email!,
                            //     style: const TextStyle(fontSize: 16),
                            //   ),
                            // ),
                            //////
                          // if (user != null && !Config().isWordPress)
                          //   Card(
                          //     color: Theme.of(context).backgroundColor,
                          //     margin: const EdgeInsets.only(bottom: 2.0),
                          //     elevation: 0,
                          //     child: ListTile(
                          //       leading: Icon(
                          //         Icons.portrait,
                          //         color:
                          //             Theme.of(context).colorScheme.secondary,
                          //         size: 25,
                          //       ),
                          //       title: Text(
                          //         S.of(context).updateUserInfor,
                          //         style: const TextStyle(fontSize: 15),
                          //       ),
                          //       trailing: const Icon(
                          //         Icons.arrow_forward_ios,
                          //         size: 18,
                          //         color: kGrey600,
                          //       ),
                          //       onTap: () async {
                          //         final hasChangePassword =
                          //             await FluxNavigate.pushNamed(
                          //           RouteList.updateUser,
                          //           forceRootNavigator: true,
                          //         ) as bool?;

                                  /// If change password with Shopify
                                  /// need to log out and log in again
                            //       if (Config().isShopify &&
                            //           (hasChangePassword ?? false)) {
                            //         _showDialogLogout();
                            //       }
                            //     },
                            //   ),
                            // ),
                            ///////
                            //   if (user == null)
                            // Card(
                            //   color: Theme.of(context).backgroundColor,
                            //   margin: const EdgeInsets.only(bottom: 2.0),
                            //   elevation: 0,
                            //   child: ListTile(
                            //     onTap: () {
                            //       if (!loggedIn) {
                            //         Navigator.of(
                            //           App.floralgardenNavigatorKey.currentContext!,
                            //         ).pushNamed(RouteList.login);
                            //         return;
                            //       }
                            //       Provider.of<UserModel>(context, listen: false)
                            //           .logout();
                            //       if (kLoginSetting['IsRequiredLogin'] ??
                            //           false) {
                            //         Navigator.of(
                            //           App.floralgardenNavigatorKey.currentContext!,
                            //         ).pushNamedAndRemoveUntil(
                            //           RouteList.login,
                            //           (route) => false,
                            //         );
                            //       }
                            //     },
                            //     leading: const Icon(Icons.person),
                            //     title: Text(
                            //       loggedIn
                            //           ? S.of(context).logout
                            //           : S.of(context).login,
                            //       style: const TextStyle(fontSize: 16),
                            //     ),
                            //     trailing: const Icon(Icons.arrow_forward_ios,
                            //         size: 18, color: kGrey600),
                            //   ),
                            // ),
                            //////////
                            //  if (user != null)
                            // Card(
                            //   color: Theme.of(context).backgroundColor,
                            //   margin: const EdgeInsets.only(bottom: 2.0),
                            //   elevation: 0,
                            //   child: ListTile(
                            //     onTap: _onLogout,
                            //     leading: Icon(
                            //       Icons.logout,
                            //       size: 20,
                            //       color:
                            //           Theme.of(context).colorScheme.secondary,
                            //     ),

                                // Image.asset(
                                //   'assets/icons/profile/icon-logout.png',
                                //   width: 24,
                                //   color: Theme.of(context).colorScheme.secondary,
                                // ),
                            //     title: Text(
                            //       S.of(context).logout,
                            //       style: const TextStyle(fontSize: 16),
                            //     ),
                            //     trailing: const Icon(Icons.arrow_forward_ios,
                            //         size: 18, color: kGrey600),
                            //   ),
                            // ),

          ///////////////////////////////////////////////////////

           const SizedBox(height: 30.0),
                          // Text(
                          //   S.of(context).generalSetting,
                          //   style: const TextStyle(
                          //       fontSize: 18, fontWeight: FontWeight.w600),
                          // ),
                          const SizedBox(height: 10.0),
                         // renderVendorAdmin(),

                          /// Render some extra menu for Vendor.
                          /// Currently support WCFM & Dokan. Will support WooCommerce soon.
                          // if (kfloralgardenMV.contains(serverConfig['type']) &&
                          //     (user?.isVender ?? false)) ...[
                          //   Services().widget.renderVendorOrder(context),
                          //   renderVendorVacation(),
                          // ],

                        //  renderDeliveryBoy(),

                          /// Render custom Wallet feature
                          // renderWebViewProfile(),

                          /// render some extra menu for Listing
                          if (user != null && Config().isListingType) ...[
                            Services().widget.renderNewListing(context),
                            Services().widget.renderBookingHistory(context),
                          ],

                          const SizedBox(height: 10.0),
                          if (user != null)
                            // const Divider(
                            //   color: Colors.black12,
                            //   height: 1.0,
                            //   indent: 75,
                            //   //endIndent: 20,
                            // ),
                            
                            ////////////////////////////////////////////
                             /// render list of dynamic menu
          //           /// this could be manage from the Fluxbuilder
                    ...List.generate(
                      settings.length,
                      (index) {
                        var item = settings[index];
                        var isTitle = item.contains('title');
                        return 
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: isTitle ? 0.0 : itemPadding),
                          child: renderItem(item),
                        );
                      },
                    ),
                    const SizedBox(height: 100),

                   ]
                 ),
               ),

         

          //                 
          //               
          //                
          //                
          //               ],
                            
          //             ),//column
          //           ),

          //          
          //         ],
          //       ),
          //     ),
          //   ],
  //         // //);
  //       }),
  //     ),
  //   );
  // }
            

           
         

    );

        }/////else
      // / {icon = CupertinoIcons.bag_badge_plus;
      //     title = S.of(context).myPoints;
      //     trailing =
      //         const Icon(Icons.arrow_forward_ios, size: 18, color: kGrey600);
      //     onTap = () => Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) => UserPointScreen(),
      //           ),
      //         );}

          // const ListTile(
          //   leading: Icon(Icons.arrow_back_ios, size: 40),// CupertinoIcons.bag_badge_plus,
          //   title: Text("طلبياتي", style: TextStyle(color: Colors.black)),
          //  // subtitle: Text('TWICE', style: TextStyle(color: Colors.white)),
           // trailing =
             //  Icon(Icons.arrow_forward_ios, size: 18, color: kGrey600),
         // onTap = () => {}
//              //);
         // ),
          // ButtonTheme.bar(
          //   child: ButtonBar(
          //     children: <Widget>[
          //       FlatButton(
          //         child: const Text('Edit', style: TextStyle(color: Colors.white)),
          //         onPressed: () {},
          //       ),
          //       FlatButton(
          //         child: const Text('Delete', style: TextStyle(color: Colors.white)),
          //         onPressed: () {},
          //       ),
          //     ],
          //   ),
          // ),
      //  ],
    //  ),
  ///  ),

  //  ),
   // height:300,
 
 // ),/////2
    //        Container(
    //            padding: new EdgeInsets.all(5.0),
    // width: MediaQuery.of(context).size.width  ,
    // child:Center(
    //      child: Card(
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(15.0),
    //   ),
    //   color: Colors.white,
    //   elevation:4,
    //   child: Column(
    //     mainAxisSize: MainAxisSize.min,
    //     children: <Widget>[
      // / {icon = CupertinoIcons.bag_badge_plus;
      //     title = S.of(context).myPoints;
      //     trailing =
      //         const Icon(Icons.arrow_forward_ios, size: 18, color: kGrey600);
      //     onTap = () => Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) => UserPointScreen(),
      //           ),
      // //         );}

      //     const ListTile(
      //       leading: Icon(Icons.arrow_back_ios, size: 40),// CupertinoIcons.bag_badge_plus,
      //       title: Text("نقاطي", style: TextStyle(color: Colors.black)),
           // subtitle: Text('TWICE', style: TextStyle(color: Colors.white)),
           // trailing =
             //  Icon(Icons.arrow_forward_ios, size: 18, color: kGrey600),
         // onTa//p = () => {}
               // ),
              //);
         // ),
          // ButtonTheme.bar(
          //   child: ButtonBar(
          //     children: <Widget>[
          //       FlatButton(
          //         child: const Text('Edit', style: TextStyle(color: Colors.white)),
          //         onPressed: () {},
          //       ),
          //       FlatButton(
          //         child: const Text('Delete', style: TextStyle(color: Colors.white)),
          //         onPressed: () {},
                                //       ),
                        //         //     ],
                        //         //   ),
                        //         // ),
                        //       ],
                        //     ),
                        //   ),

                        //   ),
                        //  // height:300,
                      
                        // ),////3
                        //      Container(
                        //              padding: new EdgeInsets.all(5.0),
                        //   width: MediaQuery.of(context).size.width  ,
                        //   child:Center(
                        //        child: Card(
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(15.0),
                        //     ),
                        //     color: Colors.white,
                        //     elevation:4,
                        //     child: Column(
                        //       mainAxisSize: MainAxisSize.min,
                        //       children: <Widget>[
                        //         Container(
                        //           height:MediaQuery.of(context).high,
                        //           Center(
                        //             child:Text("لم تقم بتسجيل الدخول")
                        //           )
                        //         )
                        //     // / {icon = CupertinoIcons.bag_badge_plus;
                        //     //     title = S.of(context).myPoints;
                        //     //     trailing =
                        //     //         const Icon(Icons.arrow_forward_ios, size: 18, color: kGrey600);
                        //     //     onTap = () => Navigator.push(
                        //     //           context,
                        //     //           MaterialPageRoute(
                        //     //             builder: (context) => UserPointScreen(),
                        //     //           ),
                        //     //         );}

                        //         const ListTile(
                        //           leading: Icon(Icons.arrow_back_ios, size: 40),// CupertinoIcons.bag_badge_plus,
                        //           title: Text("من نحن", style: TextStyle(color: Colors.black)),
                        //          // subtitle: Text('TWICE', style: TextStyle(color: Colors.white)),
                        //          // trailing =
                        //            //  Icon(Icons.arrow_forward_ios, size: 18, color: kGrey600),
                        //        // onTap = () => {}
                        //               ),
                        //             //);
                        //        // ),
                        //         // ButtonTheme.bar(
                        //         //   child: ButtonBar(
                        //         //     children: <Widget>[
                        //         //       FlatButton(
                        //         //         child: const Text('Edit', style: TextStyle(color: Colors.white)),
                        //         //         onPressed: () {},
                        //         //       ),
                        //         //       FlatButton(
                        //         //         child: const Text('Delete', style: TextStyle(color: Colors.white)),
                        //         //         onPressed: () {},
                        //         //       ),
                        //         //     ],
                        //         //   ),
                        //         // ),
                        //       ],
                        //     ),
                        //   ),

                        //   ),
                        //  // height:300,
                      
                        // ),////4
                        //      Container(
                        //              padding: new EdgeInsets.all(5.0),
                        //   width: MediaQuery.of(context).size.width  ,
                        //   child:Center(
                        //        child: Card(
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(15.0),
                        //     ),
                        //     color: Colors.white,
                        //     elevation:4,
                        //     child: Column(
                        //       mainAxisSize: MainAxisSize.min,
                        //       children: <Widget>[
                        //     // / {icon = CupertinoIcons.bag_badge_plus;
                        //     //     title = S.of(context).myPoints;
                        //     //     trailing =
                        //     //         const Icon(Icons.arrow_forward_ios, size: 18, color: kGrey600);
                        //     //     onTap = () => Navigator.push(
                        //     //           context,
                        //     //           MaterialPageRoute(
                        //     //             builder: (context) => UserPointScreen(),
                        //     //           ),
                        //     //         );}

                        //         const ListTile(
                        //           leading: Icon(Icons.arrow_back_ios, size: 40),// CupertinoIcons.bag_badge_plus,
                        //           title: Text("نقاطي", style: TextStyle(color: Colors.black)),
                        //          // subtitle: Text('TWICE', style: TextStyle(color: Colors.white)),
                        //          // trailing =
                        //            //  Icon(Icons.arrow_forward_ios, size: 18, color: kGrey600),
                        //        // onTap = () => {}
                        //               ),
                        //             //);
                        //        // ),
                        //         // ButtonTheme.bar(
                        //         //   child: ButtonBar(
                        //         //     children: <Widget>[
                        //         //       FlatButton(
                        //         //         child: const Text('Edit', style: TextStyle(color: Colors.white)),
                        //         //         onPressed: () {},
                        //         //       ),
                        //         //       FlatButton(
                        //         //         child: const Text('Delete', style: TextStyle(color: Colors.white)),
                        //         //         onPressed: () {},
                        //         //       ),
                        //         //     ],
                        //         //   ),
                        //         // ),
                        //       ],
                        //     ),
                        //   ),

                        //   ),
                        //  // height:300,
                      
                        // ),
                              
                                // ],
                                // );
                                
          
                      // return CustomScrollView(
                      //   slivers: <Widget>[
                      //     appBar,
                      //    // Text("hhhhhhh"),
                      //     SliverList(
                      //       delegate: SliverChildListDelegate(
                      //         <Widget>[
                      //           Padding(
                      //             padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      //             child:
                      //             // GridView.count(
                      //             //        crossAxisCount: 2,
                      //             //       children: <Widget>[
                      //             Column(
                      //               crossAxisAlignment: CrossAxisAlignment.start,
                      //               children: <Widget>[
                      //                 const SizedBox(height: 10.0),
                      //                 Padding(
                      //             padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      //             child:
                      //                 Row(
                      //                   children:<Widget>[
                      //                   Container(
                      //                     width: MediaQuery.of(context).size.width / 2,
                      //                     color: Colors.red,
                      //                     child:Text("ddddd"),
                      //                   ),
                      //                    Container(
                      //                     width: MediaQuery.of(context).size.width / 2,
                      //                     color: Colors.blue,
                      //                      child:Text("ddddd"),
                      //                   ),
                      //                   ],
                      //                 ),

                      //                 ),
                                        
                      //                 if (user != null && user.name != null)
                      //                   ListTile(
                      //                     leading: (user.picture?.isNotEmpty ?? false)
                      //                         ? CircleAvatar(
                      //                             backgroundImage:
                      //                                 NetworkImage(user.picture!),
                      //                           )
                      //                         : const Icon(Icons.face),
                      //                     title: Text(
                      //                       user.name!.replaceAll('floralgarden', ''),
                      //                       style: textStyle,
                      //                     ),
                      //                   ),
                      //                 if (user != null &&
                      //                     user.email != null &&
                      //                     user.email!.isNotEmpty)
                      //                   ListTile(
                      //                     leading: const Icon(Icons.email),
                      //                     title: Text(
                      //                       user.email!,
                      //                       style: const TextStyle(fontSize: 16),
                      //                     ),
                      //                   ),
                      //                 if (user != null && !Config().isWordPress)
                      //                   Card(
                      //                     color: Theme.of(context).backgroundColor,
                      //                     margin: const EdgeInsets.only(bottom: 2.0),
                      //                     elevation: 0,
                      //                     child: ListTile(
                      //                       leading: Icon(
                      //                         Icons.portrait,
                      //                         color:
                      //                             Theme.of(context).colorScheme.secondary,
                      //                         size: 25,
                      //                       ),
                      //                       title: Text(
                      //                         S.of(context).updateUserInfor,
                      //                         style: const TextStyle(fontSize: 15),
                      //                       ),
                      //                       trailing: const Icon(
                      //                         Icons.arrow_forward_ios,
                      //                         size: 18,
                      //                         color: kGrey600,
                      //                       ),
                      //                       onTap: () async {
                      //                         final hasChangePassword =
                      //                             await FluxNavigate.pushNamed(
                      //                           RouteList.updateUser,
                      //                           forceRootNavigator: true,
                      //                         ) as bool?;

                      //                         /// If change password with Shopify
                      //                         /// need to log out and log in again
                      //                         if (Config().isShopify &&
                      //                             (hasChangePassword ?? false)) {
                      //                           _showDialogLogout();
                      //                         }
                      //                       },
                      //                     ),
                      //                   ),
                      //                 if (user == null)
                      //                   Card(
                      //                     color: Theme.of(context).backgroundColor,
                      //                     margin: const EdgeInsets.only(bottom: 2.0),
                      //                     elevation: 0,
                      //                     child: ListTile(
                      //                       onTap: () {
                      //                         if (!loggedIn) {
                      //                           Navigator.of(
                      //                             App.floralgardenNavigatorKey.currentContext!,
                      //                           ).pushNamed(RouteList.login);
                      //                           return;
                      //                         }
                      //                         Provider.of<UserModel>(context, listen: false)
                      //                             .logout();
                      //                         if (kLoginSetting['IsRequiredLogin'] ??
                      //                             false) {
                      //                           Navigator.of(
                      //                             App.floralgardenNavigatorKey.currentContext!,
                      //                           ).pushNamedAndRemoveUntil(
                      //                             RouteList.login,
                      //                             (route) => false,
                      //                           );
                      //                         }
                      //                       },
                      //                       leading: const Icon(Icons.person),
                      //                       title: Text(
                      //                         loggedIn
                      //                             ? S.of(context).logout
                      //                             : S.of(context).login,
                      //                         style: const TextStyle(fontSize: 16),
                      //                       ),
                      //                       trailing: const Icon(Icons.arrow_forward_ios,
                      //                           size: 18, color: kGrey600),
                      //                     ),
                      //                   ),
                      //                 if (user != null)
                      //                   Card(
                      //                     color: Theme.of(context).backgroundColor,
                      //                     margin: const EdgeInsets.only(bottom: 2.0),
                      //                     elevation: 0,
                      //                     child: ListTile(
                      //                       onTap: _onLogout,
                      //                       leading: Icon(
                      //                         Icons.logout,
                      //                         size: 20,
                      //                         color:
                      //                             Theme.of(context).colorScheme.secondary,
                      //                       ),

                      //                       // Image.asset(
                      //                       //   'assets/icons/profile/icon-logout.png',
                      //                       //   width: 24,
                      //                       //   color: Theme.of(context).colorScheme.secondary,
                      //                       // ),
                      //                       title: Text(
                      //                         S.of(context).logout,
                      //                         style: const TextStyle(fontSize: 16),
                      //                       ),
                      //                       trailing: const Icon(Icons.arrow_forward_ios,
                      //                           size: 18, color: kGrey600),
                      //                     ),
                      //                   ),
                      //                 const SizedBox(height: 30.0),
                      //                 Text(
                      //                   S.of(context).generalSetting,
                      //                   style: const TextStyle(
                      //                       fontSize: 18, fontWeight: FontWeight.w600),
                      //                 ),
                      //                 const SizedBox(height: 10.0),
                      //                 renderVendorAdmin(),

                      //                 /// Render some extra menu for Vendor.
                      //                 /// Currently support WCFM & Dokan. Will support WooCommerce soon.
                      //                 if (kfloralgardenMV.contains(serverConfig['type']) &&
                      //                     (user?.isVender ?? false)) ...[
                      //                   Services().widget.renderVendorOrder(context),
                      //                   renderVendorVacation(),
                      //                 ],

                      //                 renderDeliveryBoy(),

                      //                 /// Render custom Wallet feature
                      //                 // renderWebViewProfile(),

                      //                 /// render some extra menu for Listing
                      //                 if (user != null && Config().isListingType) ...[
                      //                   Services().widget.renderNewListing(context),
                      //                   Services().widget.renderBookingHistory(context),
                      //                 ],

                      //                 const SizedBox(height: 10.0),
                      //                 if (user != null)
                      //                   const Divider(
                      //                     color: Colors.black12,
                      //                     height: 1.0,
                      //                     indent: 75,
                      //                     //endIndent: 20,
                      //                   ),
                      //               ],
                                        
                      //             ),//column
                      //           ),

                      //           /// render list of dynamic menu
                      //           /// this could be manage from the Fluxbuilder
                      //           ...List.generate(
                      //             settings.length,
                      //             (index) {
                      //               var item = settings[index];
                      //               var isTitle = item.contains('title');
                      //               return Padding(
                      //                 padding: EdgeInsets.symmetric(
                      //                     horizontal: isTitle ? 0.0 : itemPadding),
                      //                 child: renderItem(item),
                      //               );
                      //             },
                      //           ),
                      //           const SizedBox(height: 100),
                      //         ],
                      //       ),
                      //     ),
                      //   ],
                      // //);
        }
        ),
      ),
      

       ),
       ],
    );//scafold
  }

  void _onLogout() {
    Provider.of<CartModel>(context, listen: false).clearAddress();
    Provider.of<UserModel>(context, listen: false).logout();
    
    if (kLoginSetting.isRequiredLogin ) {
      Navigator.of(App.floralgardenNavigatorKey.currentContext!)
          .pushNamedAndRemoveUntil(
        RouteList.login,
        (route) => false,
      );
    }
  }

  void _showDialogLogout() {
    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Notice'),
        content: const Text('You need to login again to effect update.'),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.of(ctx).pop();
              Future.delayed(const Duration(milliseconds: 200), _onLogout);
            },
            child: const Text('OK'),
          )
        ],
      ),
    );
  }
}



// import 'package:flutter/cupertino.dart'
//     show
//         CupertinoAlertDialog,
//         CupertinoDialogAction,
//         CupertinoIcons,
//         showCupertinoDialog;
// import 'package:flutter/material.dart';
// import 'package:inspireui/icons/icon_picker.dart';
// import 'package:localstorage/localstorage.dart';
// import 'package:provider/provider.dart';
// import 'package:rate_my_app/rate_my_app.dart';

// import '../../app.dart';
// import '../../common/config.dart';
// import '../../common/config/configuration_utils.dart';
// import '../../common/constants.dart';
// import '../../common/tools.dart';
// import '../../generated/l10n.dart';
// import '../../models/index.dart'
//     show AppModel, CartModel, ProductWishListModel, User, UserModel;
// import '../../models/notification_model.dart';
// import '../../routes/flux_navigate.dart';
// import '../../services/index.dart';
// import '../../widgets/common/index.dart';
// import '../../widgets/general/index.dart';
// import '../common/app_bar_mixin.dart';
// import '../index.dart';
// import '../posts/post_screen.dart';
// import '../users/user_point_screen.dart';

// const itemPadding = 15.0;

// class SettingScreen extends StatefulWidget {
//   final List<dynamic>? settings;
//   final Map? subGeneralSetting;
//   final String? background;
//   final Map? drawerIcon;
//   final VoidCallback? onLogout;
//   final bool hideUser;

//   const SettingScreen({
//     this.onLogout,
//     this.settings,
//     this.subGeneralSetting,
//     this.background,
//     this.drawerIcon,
//     this.hideUser = false,
//   });

//   @override
//   SettingScreenState createState() {
//     return SettingScreenState();
//   }
// }

// class SettingScreenState extends State<SettingScreen>
//     with
//         TickerProviderStateMixin,
//         AutomaticKeepAliveClientMixin<SettingScreen>,
//         AppBarMixin {
//   @override
//   bool get wantKeepAlive => true;

//   User? get user => Provider.of<UserModel>(context, listen: false).user;
//   bool isAbleToPostManagement = false;

//   final bannerHigh = 150.0;
//   final RateMyApp _rateMyApp = RateMyApp(
//     // rate app on store
//     minDays: 7,
//     minLaunches: 10,
//     remindDays: 7,
//     remindLaunches: 10,
//     googlePlayIdentifier: kStoreIdentifier['android'],
//     appStoreIdentifier: kStoreIdentifier['ios'],
//   );

//   void showRateMyApp() {
//     _rateMyApp.showRateDialog(
//       context,
//       title: S.of(context).rateTheApp,
//       // The dialog title.
//       message: S.of(context).rateThisAppDescription,
//       // The dialog message.
//       rateButton: S.of(context).rate.toUpperCase(),
//       // The dialog 'rate' button text.
//       noButton: S.of(context).noThanks.toUpperCase(),
//       // The dialog 'no' button text.
//       laterButton: S.of(context).maybeLater.toUpperCase(),
//       // The dialog 'later' button text.
//       listener: (button) {
//         // The button click listener (useful if you want to cancel the click event).
//         switch (button) {
//           case RateMyAppDialogButton.rate:
//             break;
//           case RateMyAppDialogButton.later:
//             break;
//           case RateMyAppDialogButton.no:
//             break;
//         }

//         return true; // Return false if you want to cancel the click event.
//       },
//       // Set to false if you want to show the native Apple app rating dialog on iOS.
//       dialogStyle: const DialogStyle(),
//       // Custom dialog styles.
//       // Called when the user dismissed the dialog (either by taping outside or by pressing the 'back' button).
//       // actionsBuilder: (_) => [], // This one allows you to use your own buttons.
//     );
//   }

//   void checkAddPostRole() {
//     for (var legitRole in addPostAccessibleRoles) {
//       if (user!.role == legitRole) {
//         setState(() {
//           isAbleToPostManagement = true;
//         });
//       }
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await _rateMyApp.init();

//       if (isMobile && !kStoreIdentifier['disable']) {
//         // state of rating the app
//         if (_rateMyApp.shouldOpenDialog) {
//           showRateMyApp();
//         }
//       }
//     });
//   }

//   /// Render the Delivery Menu.
//   /// Currently support WCFM
//   Widget renderDeliveryBoy() {
//     var isDelivery = user?.isDeliveryBoy ?? false;

//     if (!isDelivery) {
//       return const SizedBox();
//     }

//     return Card(
//       color: Theme.of(context).backgroundColor,
//       margin: const EdgeInsets.only(bottom: 2.0),
//       elevation: 0,
//       child: ListTile(
//         onTap: () {
//           FluxNavigate.push(
//             MaterialPageRoute(
//               builder: (context) =>
//                   Services().widget.getDeliveryScreen(context, user)!,
//             ),
//             forceRootNavigator: true,
//           );
//         },
//         leading: Icon(
//           CupertinoIcons.cube_box,
//           size: 24,
//           color: Theme.of(context).colorScheme.secondary,
//         ),
//         title: Text(
//           S.of(context).deliveryManagement,
//           style: const TextStyle(fontSize: 16),
//         ),
//         trailing: Icon(
//           Icons.arrow_forward_ios,
//           size: 18,
//           color: Theme.of(context).colorScheme.secondary,
//         ),
//       ),
//     );
//   }

//   /// Render the Admin Vendor Menu.
//   /// Currently support WCFM & Dokan. Will support WooCommerce soon.
//   Widget renderVendorAdmin() {
//     var isVendor = user?.isVender ?? false;

//     if (!isVendor || serverConfig['type'] == 'listeo') {
//       return const SizedBox();
//     }

//     return Card(
//       color: Theme.of(context).backgroundColor,
//       margin: const EdgeInsets.only(bottom: 2.0),
//       elevation: 0,
//       child: ListTile(
//         onTap: () {
//           FluxNavigate.pushNamed(
//             RouteList.vendorAdmin,
//             arguments: user,
//             forceRootNavigator: true,
//           );
//         },
//         leading: Icon(
//           Icons.dashboard,
//           size: 24,
//           color: Theme.of(context).colorScheme.secondary,
//         ),
//         title: Text(
//           S.of(context).vendorAdmin,
//           style: const TextStyle(fontSize: 16),
//         ),
//         trailing: Icon(
//           Icons.arrow_forward_ios,
//           size: 18,
//           color: Theme.of(context).colorScheme.secondary,
//         ),
//       ),
//     );
//   }

//   Widget renderVendorVacation() {
//     var isVendor = user?.isVender ?? false;

//     if ((kfloralgardenMV.contains(serverConfig['type']) && !isVendor) ||
//         serverConfig['type'] != 'wcfm' ||
//         !kVendorConfig['DisableNativeStoreManagement']) {
//       return const SizedBox();
//     }

//     return Card(
//       color: Theme.of(context).backgroundColor,
//       margin: const EdgeInsets.only(bottom: 2.0),
//       elevation: 0,
//       child: ListTile(
//         onTap: () {
//           FluxNavigate.push(
//             MaterialPageRoute(
//               builder: (context) => Services().widget.renderVacationVendor(
//                   user!.id!, user!.cookie!,
//                   isFromMV: true),
//             ),
//             forceRootNavigator: true,
//           );
//         },
//         leading: Icon(
//           Icons.house,
//           size: 24,
//           color: Theme.of(context).colorScheme.secondary,
//         ),
//         title: Text(
//           S.of(context).storeVacation,
//           style: const TextStyle(fontSize: 16),
//         ),
//         trailing: Icon(
//           Icons.arrow_forward_ios,
//           size: 18,
//           color: Theme.of(context).colorScheme.secondary,
//         ),
//       ),
//     );
//   }

//   /// Render the custom profile link via Webview
//   /// Example show some special profile on the woocommerce site: wallet, wishlist...
//   Widget renderWebViewProfile() {
//     if (user == null) {
//       return Container();
//     }

//     return Card(
//       color: Theme.of(context).backgroundColor,
//       margin: const EdgeInsets.only(bottom: 2.0),
//       elevation: 0,
//       child: ListTile(
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => WebView(
//                 auth: true,
//                 url: '${serverConfig['url']}/my-account',
//                 title: S.of(context).updateUserInfor,
//               ),
//             ),
//           );
//         },
//         leading: Icon(
//           CupertinoIcons.profile_circled,
//           size: 24,
//           color: Theme.of(context).colorScheme.secondary,
//         ),
//         title: Text(
//           S.of(context).updateUserInfor,
//           style: const TextStyle(fontSize: 16),
//         ),
//         trailing: Icon(
//           Icons.arrow_forward_ios,
//           color: Theme.of(context).colorScheme.secondary,
//           size: 18,
//         ),
//       ),
//     );
//   }

//   Widget renderItem(value) {
//     IconData icon;
//     String title;
//     Widget trailing;
//     Function() onTap;
//     var isMultiVendor = kfloralgardenMV.contains(serverConfig['type']);
//     var subGeneralSetting = widget.subGeneralSetting != null
//         ? ConfigurationUtils.loadSubGeneralSetting(widget.subGeneralSetting!)
//         : kSubGeneralSetting;
//     var item = subGeneralSetting[value];

//     if (value.contains('web')) {
//       return GeneralWebWidget(item: item);
//     }

//     if (value.contains('post-')) {
//       return GeneralPostWidget(item: item);
//     }

//     if (value.contains('title')) {
//       return GeneralTitleWidget(item: item, itemPadding: itemPadding);
//     }

//     if (value.contains('button')) {
//       return GeneralButtonWidget(item: item);
//     }

//     switch (value) {
//       case 'products':
//         {
//           if (!(user != null ? user!.isVender : false) || !isMultiVendor) {
//             return const SizedBox();
//           }
//           trailing = const Icon(
//             Icons.arrow_forward_ios,
//             size: 18,
//             color: kGrey600,
//           );
//           title = S.of(context).myProducts;
//           icon = CupertinoIcons.cube_box;
//           onTap = () => Navigator.pushNamed(context, RouteList.productSell);
//           break;
//         }

//       case 'chat':
//         {
//           if (user == null || Config().isListingType || !isMultiVendor) {
//             return Container();
//           }
//           trailing = const Icon(
//             Icons.arrow_forward_ios,
//             size: 18,
//             color: kGrey600,
//           );
//           title = S.of(context).conversations;
//           icon = CupertinoIcons.chat_bubble_2;
//           onTap = () => Navigator.pushNamed(context, RouteList.listChat);
//           break;
//         }
//       case 'wallet':
//         {
//           if (user == null || !Config().isWooType) {
//             return Container();
//           }
//           trailing = const Icon(
//             Icons.arrow_forward_ios,
//             size: 18,
//             color: kGrey600,
//           );
//           title = S.of(context).myWallet;
//           icon = CupertinoIcons.square_favorites_alt;
//           onTap = () => FluxNavigate.pushNamed(
//                 RouteList.myWallet,
//                 forceRootNavigator: true,
//               );
//           break;
//         }
//       case 'wishlist':
//         {
//           trailing = Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Consumer<ProductWishListModel>(builder: (context, model, child) {
//                 if (model.products.isNotEmpty) {
//                   return Text(
//                     '${model.products.length} ${S.of(context).items}',
//                     style: TextStyle(
//                         fontSize: 14, color: Theme.of(context).primaryColor),
//                   );
//                 } else {
//                   return const SizedBox();
//                 }
//               }),
//               const SizedBox(width: 5),
//               const Icon(Icons.arrow_forward_ios, size: 18, color: kGrey600)
//             ],
//           );

//           title = S.of(context).myWishList;
//           icon = CupertinoIcons.heart;
//           onTap = () => Navigator.of(context).pushNamed(RouteList.wishlist);
//           break;
//         }
//       case 'notifications':
//         {
//           return Consumer<NotificationModel>(builder: (context, model, child) {
//             return Column(
//               children: [
//                 Card(
//                   margin: const EdgeInsets.only(bottom: 2.0),
//                   elevation: 0,
//                   child: SwitchListTile(
//                     secondary: Icon(
//                       CupertinoIcons.bell,
//                       color: Theme.of(context).colorScheme.secondary,
//                       size: 24,
//                     ),
//                     value: model.enable,
//                     activeColor: const Color(0xFF0066B4),
//                     onChanged: (bool enableNotification) {
//                       if (enableNotification) {
//                         model.enableNotification();
//                       } else {
//                         model.disableNotification();
//                       }
//                     },
//                     title: Text(
//                       S.of(context).getNotification,
//                       style: const TextStyle(fontSize: 16),
//                     ),
//                   ),
//                 ),
//                 const Divider(
//                   color: Colors.black12,
//                   height: 1.0,
//                   indent: 75,
//                   //endIndent: 20,
//                 ),
//                 if (model.enable) ...[
//                   Card(
//                     margin: const EdgeInsets.only(bottom: 2.0),
//                     elevation: 0,
//                     child: GestureDetector(
//                       onTap: () {
//                         Navigator.of(context).pushNamed(RouteList.notify);
//                       },
//                       child: ListTile(
//                         leading: Icon(
//                           CupertinoIcons.list_bullet,
//                           size: 22,
//                           color: Theme.of(context).colorScheme.secondary,
//                         ),
//                         title: Text(S.of(context).listMessages),
//                         trailing: const Icon(
//                           Icons.arrow_forward_ios,
//                           size: 18,
//                           color: kGrey600,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const Divider(
//                     color: Colors.black12,
//                     height: 1.0,
//                     indent: 75,
//                     //endIndent: 20,
//                   ),
//                 ],
//               ],
//             );
//           });
//         }
//       case 'language':
//         {
//           icon = CupertinoIcons.globe;
//           title = S.of(context).language;
//           trailing = const Icon(
//             Icons.arrow_forward_ios,
//             size: 18,
//             color: kGrey600,
//           );
//           onTap = () => Navigator.of(context).pushNamed(RouteList.language);
//           break;
//         }
//       case 'currencies':
//         {
//           if (Config().isListingType) {
//             return Container();
//           }
//           icon = CupertinoIcons.money_dollar_circle;
//           title = S.of(context).currencies;
//           trailing =
//               const Icon(Icons.arrow_forward_ios, size: 18, color: kGrey600);
//           onTap = () => Navigator.of(context).pushNamed(RouteList.currencies);
//           break;
//         }
//       case 'darkTheme':
//         {
//           return Column(
//             children: [
//               Card(
//                 margin: const EdgeInsets.only(bottom: 2.0),
//                 elevation: 0,
//                 child: SwitchListTile(
//                   secondary: Icon(
//                     Provider.of<AppModel>(context).darkTheme
//                         ? CupertinoIcons.sun_min
//                         : CupertinoIcons.moon,
//                     color: Theme.of(context).colorScheme.secondary,
//                     size: 24,
//                   ),
//                   value: Provider.of<AppModel>(context).darkTheme,
//                   activeColor: const Color(0xFF0066B4),
//                   onChanged: (bool value) {
//                     if (value) {
//                       Provider.of<AppModel>(context, listen: false)
//                           .updateTheme(true);
//                     } else {
//                       Provider.of<AppModel>(context, listen: false)
//                           .updateTheme(false);
//                     }
//                   },
//                   title: Text(
//                     S.of(context).darkTheme,
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                 ),
//               ),
//               const Divider(
//                 color: Colors.black12,
//                 height: 1.0,
//                 indent: 75,
//                 //endIndent: 20,
//               ),
//             ],
//           );
//         }
//       case 'order':
//         {
//           final storage = LocalStorage(LocalStorageKey.dataOrder);
//           var items = storage.getItem('orders');
//           if (user == null && items == null) {
//             return Container();
//           }
//           if (Config().isListingType) {
//             return const SizedBox();
//           }
//           icon = CupertinoIcons.time;
//           title = S.of(context).orderHistory;
//           trailing =
//               const Icon(Icons.arrow_forward_ios, size: 18, color: kGrey600);
//           onTap = () {
//             final user = Provider.of<UserModel>(context, listen: false).user;
//             FluxNavigate.pushNamed(
//               RouteList.orders,
//               arguments: user,
//             );
//           };
//           break;
//         }
//       case 'point':
//         {
//           if (!(kAdvanceConfig.enablePointReward && user != null)) {
//             return const SizedBox();
//           }
//           if (Config().isListingType) {
//             return const SizedBox();
//           }
//           icon = CupertinoIcons.bag_badge_plus;
//           title = S.of(context).myPoints;
//           trailing =
//               const Icon(Icons.arrow_forward_ios, size: 18, color: kGrey600);
//           onTap = () => Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => UserPointScreen(),
//                 ),
//               );
//           break;
//         }
//       case 'rating':
//         {
//           icon = CupertinoIcons.star;
//           title = S.of(context).rateTheApp;
//           trailing =
//               const Icon(Icons.arrow_forward_ios, size: 18, color: kGrey600);
//           onTap = showRateMyApp;
//           break;
//         }
//       case 'privacy':
//         {
//           icon = CupertinoIcons.doc_text;
//           title = S.of(context).agreeWithPrivacy;
//           trailing =
//               const Icon(Icons.arrow_forward_ios, size: 18, color: kGrey600);
//           onTap = () {
//             final privacy = subGeneralSetting['privacy'];
//             final pageId = privacy?.pageId ??
//                 (privacy?.webUrl == null
//                     ? kAdvanceConfig.privacyPoliciesPageId
//                     : null);
//             String? pageUrl =
//                 privacy?.webUrl ?? kAdvanceConfig.privacyPoliciesPageUrl;
//             if (pageId != null) {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => PostScreen(
//                         pageId: pageId,
//                         pageTitle: S.of(context).agreeWithPrivacy),
//                   ));
//               return;
//             }
//             if (pageUrl.isNotEmpty) {
//               ///Display multiple languages WebView
//               var locale =
//                   Provider.of<AppModel>(context, listen: false).langCode;
//               pageUrl += '?lang=$locale';
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => WebView(
//                     url: pageUrl,
//                     title: S.of(context).agreeWithPrivacy,
//                   ),
//                 ),
//               );
//             }
//           };
//           break;
//         }
//       case 'about':
//         {
//           icon = CupertinoIcons.info;
//           title = S.of(context).aboutUs;
//           trailing =
//               const Icon(Icons.arrow_forward_ios, size: 18, color: kGrey600);
//           onTap = () {
//             final about = subGeneralSetting['about'];
//             final aboutUrl = about?.webUrl ?? SettingConstants.aboutUsUrl;

//             if (kIsWeb) {
//               return Tools.launchURL(aboutUrl);
//             }
//             return FluxNavigate.push(
//               MaterialPageRoute(
//                 builder: (context) => WebView(
//                   url: aboutUrl,
//                   title: S.of(context).aboutUs,
//                 ),
//               ),
//               forceRootNavigator: true,
//             );
//           };
//           break;
//         }
//       case 'post':
//         {
//           if (user != null) {
//             trailing = const Icon(
//               Icons.arrow_forward_ios,
//               size: 18,
//               color: kGrey600,
//             );
//             title = S.of(context).postManagement;
//             icon = CupertinoIcons.chat_bubble_2;
//             onTap = () {
//               Navigator.of(context).pushNamed(RouteList.postManagement);
//             };
//           } else {
//             return const SizedBox();
//           }

//           break;
//         }
//       default:
//         {
//           trailing =
//               const Icon(Icons.arrow_forward_ios, size: 18, color: kGrey600);
//           icon = Icons.error;
//           title = S.of(context).dataEmpty;
//           onTap = () {};
//         }
//     }
//     return Column(
//       children: [
//         Card(
//           margin: const EdgeInsets.only(bottom: 2.0),
//           elevation: 0,
//           child: ListTile(
//             leading: Icon(
//               icon,
//               color: Theme.of(context).colorScheme.secondary,
//               size: 24,
//             ),
//             title: Text(
//               title,
//               style: const TextStyle(fontSize: 16),
//             ),
//             trailing: trailing,
//             onTap: onTap,
//           ),
//         ),
//         const Divider(
//           color: Colors.black12,
//           height: 1.0,
//           indent: 75,
//           //endIndent: 20,
//         ),
//       ],
//     );
//   }

//   Widget renderDrawerIcon() {
//     var icon = Icons.blur_on;
//     if (widget.drawerIcon != null) {
//       icon = iconPicker(
//               widget.drawerIcon!['icon'], widget.drawerIcon!['fontFamily']) ??
//           Icons.blur_on;
//     }
//     return Icon(
//       icon,
//       color: Colors.white70,
//     );
//   }

//   Widget renderUser() {
//     const textStyle = TextStyle(fontSize: 16);

//     return ListenableProvider.value(
//       value: Provider.of<UserModel>(context),
//       child: Consumer<UserModel>(
//         builder: (context, model, child) {
//           final user = model.user;
//           final loggedIn = model.loggedIn;
//           return Column(children: [
//             const SizedBox(height: 10.0),
//             if (user != null && user.name != null)
//               ListTile(
//                 leading: (user.picture?.isNotEmpty ?? false)
//                     ? CircleAvatar(
//                         backgroundImage: NetworkImage(user.picture!),
//                       )
//                     : const Icon(Icons.face),
//                 title: Text(
//                   user.name!.replaceAll('floralgarden', ''),
//                   style: textStyle,
//                 ),
//               ),
//             if (user != null && user.email != null && user.email!.isNotEmpty)
//               ListTile(
//                 leading: const Icon(Icons.email),
//                 title: Text(
//                   user.email!,
//                   style: const TextStyle(fontSize: 16),
//                 ),
//               ),
//             if (user != null && !Config().isWordPress)
//               Card(
//                 color: Theme.of(context).backgroundColor,
//                 margin: const EdgeInsets.only(bottom: 2.0),
//                 elevation: 0,
//                 child: ListTile(
//                   leading: Icon(
//                     Icons.portrait,
//                     color: Theme.of(context).colorScheme.secondary,
//                     size: 25,
//                   ),
//                   title: Text(
//                     S.of(context).updateUserInfor,
//                     style: const TextStyle(fontSize: 15),
//                   ),
//                   trailing: const Icon(
//                     Icons.arrow_forward_ios,
//                     size: 18,
//                     color: kGrey600,
//                   ),
//                   onTap: () async {
//                     final hasChangePassword = await FluxNavigate.pushNamed(
//                       RouteList.updateUser,
//                       forceRootNavigator: true,
//                     ) as bool?;

//                     /// If change password with Shopify
//                     /// need to log out and log in again
//                     if (Config().isShopify && (hasChangePassword ?? false)) {
//                       _showDialogLogout();
//                     }
//                   },
//                 ),
//               ),
//             if (user == null)
//               Card(
//                 color: Theme.of(context).backgroundColor,
//                 margin: const EdgeInsets.only(bottom: 2.0),
//                 elevation: 0,
//                 child: ListTile(
//                   onTap: () {
//                     if (!loggedIn) {
//                       Navigator.of(
//                         App.floralgardenNavigatorKey.currentContext!,
//                       ).pushNamed(RouteList.login);
//                       return;
//                     }
//                     Provider.of<UserModel>(context, listen: false).logout();
//                     if (kLoginSetting.isRequiredLogin) {
//                       Navigator.of(
//                         App.floralgardenNavigatorKey.currentContext!,
//                       ).pushNamedAndRemoveUntil(
//                         RouteList.login,
//                         (route) => false,
//                       );
//                     }
//                   },
//                   leading: const Icon(Icons.person),
//                   title: Text(
//                     loggedIn ? S.of(context).logout : S.of(context).login,
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                   trailing: const Icon(Icons.arrow_forward_ios,
//                       size: 18, color: kGrey600),
//                 ),
//               ),
//             if (user != null)
//               Card(
//                 color: Theme.of(context).backgroundColor,
//                 margin: const EdgeInsets.only(bottom: 2.0),
//                 elevation: 0,
//                 child: ListTile(
//                   onTap: _onLogout,
//                   leading: Icon(
//                     Icons.logout,
//                     size: 20,
//                     color: Theme.of(context).colorScheme.secondary,
//                   ),

//                   // Image.asset(
//                   //   'assets/icons/profile/icon-logout.png',
//                   //   width: 24,
//                   //   color: Theme.of(context).colorScheme.secondary,
//                   // ),
//                   title: Text(
//                     S.of(context).logout,
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                   trailing: const Icon(Icons.arrow_forward_ios,
//                       size: 18, color: kGrey600),
//                 ),
//               ),
//           ]);
//         },
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);

//     var settings = widget.settings ?? kDefaultSettings;
//     var background = widget.background ?? kProfileBackground;

//     final appBar = (showAppBar(RouteList.profile))
//         ? sliverAppBarWidget
//         : SliverAppBar(
//             backgroundColor: Theme.of(context).primaryColor,
//             leading: IconButton(
//               icon: renderDrawerIcon(),
//               onPressed: () => NavigateTools.onTapOpenDrawerMenu(context),
//             ),
//             expandedHeight: bannerHigh,
//             floating: true,
//             pinned: true,
//             flexibleSpace: FlexibleSpaceBar(
//               title: Text(
//                 S.of(context).settings,
//                 style: const TextStyle(
//                     fontSize: 18,
//                     color: Colors.white,
//                     fontWeight: FontWeight.w600),
//               ),
//               background: FluxImage(
//                 imageUrl: background,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             actions: ModalRoute.of(context)?.canPop ?? false
//                 ? [
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 10),
//                       child: GestureDetector(
//                         onTap: () => Navigator.pop(context),
//                         child: const Icon(
//                           Icons.close,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ]
//                 : null,
//           );

//     return Scaffold(
//       backgroundColor: Theme.of(context).backgroundColor,
//       body: CustomScrollView(
//         slivers: <Widget>[
//           appBar,
//           SliverList(
//             delegate: SliverChildListDelegate(
//               <Widget>[
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 15.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       if (!widget.hideUser) renderUser(),
//                       const SizedBox(height: 30.0),
//                       Text(
//                         S.of(context).generalSetting,
//                         style: const TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.w600),
//                       ),
//                       const SizedBox(height: 10.0),
//                       renderVendorAdmin(),

//                       /// Render some extra menu for Vendor.
//                       /// Currently support WCFM & Dokan. Will support WooCommerce soon.
//                       if (kfloralgardenMV.contains(serverConfig['type']) &&
//                           (user?.isVender ?? false)) ...[
//                         Services().widget.renderVendorOrder(context),
//                         renderVendorVacation(),
//                       ],

//                       renderDeliveryBoy(),

//                       /// Render custom Wallet feature
//                       // renderWebViewProfile(),

//                       /// render some extra menu for Listing
//                       if (user != null && Config().isListingType) ...[
//                         Services().widget.renderNewListing(context),
//                         Services().widget.renderBookingHistory(context),
//                       ],

//                       const SizedBox(height: 10.0),
//                       if (user != null)
//                         const Divider(
//                           color: Colors.black12,
//                           height: 1.0,
//                           indent: 75,
//                           //endIndent: 20,
//                         ),
//                     ],
//                   ),
//                 ),

//                 /// render list of dynamic menu
//                 /// this could be manage from the Fluxbuilder
//                 ...List.generate(
//                   settings.length,
//                   (index) {
//                     var item = settings[index];
//                     var isTitle = item.contains('title');
//                     return Padding(
//                       padding: EdgeInsets.symmetric(
//                           horizontal: isTitle ? 0.0 : itemPadding),
//                       child: renderItem(item),
//                     );
//                   },
//                 ),
//                 const SizedBox(height: 100),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _onLogout() {
//     Provider.of<CartModel>(context, listen: false).clearAddress();
//     Provider.of<UserModel>(context, listen: false).logout();
//     if (Services().widget.isRequiredLogin) {
//       Navigator.of(App.floralgardenNavigatorKey.currentContext!)
//           .pushNamedAndRemoveUntil(
//         RouteList.login,
//         (route) => false,
//       );
//     }
//   }

//   void _showDialogLogout() {
//     showCupertinoDialog(
//       context: context,
//       builder: (ctx) => CupertinoAlertDialog(
//         title: const Text('Notice'),
//         content: const Text('You need to login again to effect update.'),
//         actions: [
//           CupertinoDialogAction(
//             isDefaultAction: true,
//             onPressed: () {
//               Navigator.of(ctx).pop();
//               Future.delayed(const Duration(milliseconds: 200), _onLogout);
//             },
//             child: Text(S.of(context).ok),
//           )
//         ],
//       ),
//     );
//   }
// }
