import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'dart:async';
import '../common/config.dart';
import '../common/config/models/index.dart';
import '../common/constants.dart';
import '../common/tools.dart';
import '../generated/l10n.dart';
import '../models/index.dart'
    show AppModel, BackDropArguments, Category, CategoryModel, UserModel;
import '../modules/dynamic_layout/config/app_config.dart';
import '../modules/dynamic_layout/helper/helper.dart';
import '../routes/flux_navigate.dart';
import '../services/index.dart';
import '../widgets/common/index.dart' show FluxImage, WebView;
import '../widgets/general/index.dart';
import 'maintab_delegate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fstore/screens/posts/post_screen.dart';
class SideBarMenu extends StatefulWidget {
  const SideBarMenu();

  @override
  MenuBarState createState() => MenuBarState();
}

class MenuBarState extends State<SideBarMenu> {
  bool get isEcommercePlatform =>
      !Config().isListingType || !Config().isWordPress;

  DrawerMenuConfig get drawer =>
      Provider.of<AppModel>(context, listen: false).appConfig?.drawer ??
      kDefaultDrawer;

  void pushNavigation(String name) {
    eventBus.fire(const EventCloseNativeDrawer());
    MainTabControlDelegate.getInstance().changeTab(name.replaceFirst('/', ''));
  }




  @override
  Widget build(BuildContext context) {
    printLog('[AppState] Load Menu');
      final style = TextStyle(fontSize: 15,color:Theme.of(context).colorScheme.secondary);
      final textStyle = TextStyle(fontSize: 15, );
    var isDarkTheme = Provider.of<AppModel>(context, listen: false).darkTheme;

    //  final cat1 = <String,dynamic> {"id":"44"};
    //   final cat2 = <String,dynamic> {"id":"45"};
    //    final cat3 = <String,dynamic> {"id":"46"};
    //     final cat4 = <String,dynamic> {"id":"47"};
    //      final cat5 = <String,dynamic> {"id":"48"};

    //   final cat6 = Category.fromJson(cat1);
    //    final cat7 = Category.fromJson(cat2);
    //     final cat8 = Category.fromJson(cat3);
    //      final cat9 = Category.fromJson(cat4);
    //       final cat10 = Category.fromJson(cat5);

_launchURL(String url) async {
 // const url = 'https://flutter.io';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}


    return Padding(
      key: drawer.key != null ? Key(drawer.key as String) : UniqueKey(),
       padding: EdgeInsets.only(bottom:5),
        // bottom: injector<AudioService>().isStickyAudioWidgetActive ? 0 : 0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (drawer.logo != null) ...[
              Container(
                color:isDarkTheme ?Colors.transparent : Colors.white,
              width:350,
                height:200,
            //      decoration: const  BoxDecoration(
            //  gradient: LinearGradient(
                
            //     begin: FractionalOffset(0.0,0.0),
            //     end : FractionalOffset(0.0,1.0),
            //     stops:[0.0,1.0],
            //     tileMode:TileMode.clamp,
            //     colors:[
            //       const Color(0xffffbf00),
            //          const Color(0xffffbf00),
            //       // backgroundColor: const Color(0xff05dae5),
                    

            //   ],
            //   ),
            // ),

               // color:Colors.red,
                // color: drawer.logoConfig.backgroundColor != null
                //     ? HexColor(drawer.logoConfig.backgroundColor)
                //     : null,
                // padding: EdgeInsets.only(
                //   bottom: drawer.logoConfig.marginBottom.toDouble(),
                //   top: drawer.logoConfig.marginTop.toDouble(),
                //   left: drawer.logoConfig.marginLeft.toDouble(),
                //   right: drawer.logoConfig.marginRight.toDouble(),
                // ),
                child:Column(
                  //
                  mainAxisAlignment:MainAxisAlignment.center,
                  children:<Widget>[
                    isDarkTheme ? FluxImage(imageUrl: "https://i.imgur.com/99g2nLi.png", height: 60)
                     : FluxImage(imageUrl: "https://i.imgur.com/XhaKMqR.png", height: 60),
                     SizedBox(height:10),
                     Container(
    margin: context.isRtl? const EdgeInsets.only(right: 110.0) : const EdgeInsets.only(left: 110.0) ,
                   // case 'login':
       // {
          child:
           ListenableProvider.value(
            value: Provider.of<UserModel>(context, listen: false),
            child: Consumer<UserModel>(builder: (context, userModel, _) {
              final loggedIn = userModel.loggedIn;
                  return  ElevatedButton(
                       
            style:  ButtonStyle(
              backgroundColor: MaterialStateProperty.all(const Color(0xff91b375),),
             // overlayColor:MaterialStateProperty.all(Colors.orange),
              shadowColor: MaterialStateProperty.all(const Color(0xff91b375),),

          // overlayColor:MaterialStateProperty.all(Color(0x187BCD)) ,//change with your color
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ))),
            onPressed: () {
                  if (loggedIn) {
                    Provider.of<UserModel>(context, listen: false).logout();
                    if (kLoginSetting.isRequiredLogin){
                    // if (kLoginSetting['IsRequiredLogin'] ?? false) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        RouteList.login,
                        (route) => false,
                      );
                    }
                    // else {
                    //   pushNavigation(RouteList.dashboard);
                    // }
                  } else {
                    pushNavigation(RouteList.login);
                  }
                },
            child:
            loggedIn
                    ? Text(S.of(context).logout,style:TextStyle(color:Colors.white))
                    : Text(S.of(context).login,style:TextStyle(color:Colors.white)),
            // Text('تسجيل الدخول',style:TextStyle(color: Colors.black)),
         
        );













              // return ListTile(
              //   leading: Icon(Icons.exit_to_app, size: 20, ),
              //   title: loggedIn
              //       ? Text(S.of(context).logout, )
              //       : Text(S.of(context).login,),
              //   onTap: () {
              //     if (loggedIn) {
              //       Provider.of<UserModel>(context, listen: false).logout();
              //       if (kLoginSetting['IsRequiredLogin'] ?? false) {
              //         Navigator.of(context).pushNamedAndRemoveUntil(
              //           RouteList.login,
              //           (route) => false,
              //         );
              //       }
              //       // else {
              //       //   pushNavigation(RouteList.dashboard);
              //       // }
              //     } else {
              //       pushNavigation(RouteList.login);
              //     }
              //   },
              // );



            }),
          ),
       // }
                     ),        
                   
                   
                   
                   
                   
        //             child:ElevatedButton(
                       
        //     style:  ButtonStyle(
        //       backgroundColor: MaterialStateProperty.all(Colors.white),
        //      // overlayColor:MaterialStateProperty.all(Colors.orange),
        //       shadowColor: MaterialStateProperty.all(Colors.white),

        //   // overlayColor:MaterialStateProperty.all(Color(0x187BCD)) ,//change with your color
        //       shape: MaterialStateProperty.all(RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(5),
        //       ))),
        //     onPressed: () async { },
        //     child: Text('تسجيل الدخول',style:TextStyle(color: Colors.black)),
         
        // ),
        // ),

                  ]
                
                )
                // child: FluxImage(
                //   width: drawer.logoConfig.useMaxWidth
                //       ? MediaQuery.of(context).size.width
                //       : drawer.logoConfig.width?.toDouble(),
                //   fit: Helper.boxFit(drawer.logoConfig.boxFit),
                //   height: drawer.logoConfig.height.toDouble(),
                //   imageUrl: "https://i.imgur.com/1il9HBc.png",//drawer.logo as String,
                // ),
              ),
        
              const Divider(color: const Color(0xff91b375),
                thickness: 1.0,),
        //       ListTile(
        //     // leading: Icon(
        //     //  Icons.cable,
        //     //   size: 20,
        //     //   color: Colors.red,
        //     // ),
        //     title: Text(
        //       "أجهزة تعقب الأسطول",
        //        style: GoogleFonts.almarai(
        //           textStyle: style
        //         ),
        //     ),
        //     onTap: () => navigateToBackDrop(cat6),
        //  // {}
           
        //      ),
        //      ///
        //      ListTile(
        //     // leading: Icon(
        //     //  Icons.cable,
        //     //   size: 20,
        //     //   color: Colors.red,
        //     // ),
        //     title: Text(
        //       "أجهزة تعقب الأصول",
        //        style: GoogleFonts.almarai(
        //           textStyle: style
        //         ),
        //     ),
        //     onTap:() => navigateToBackDrop(cat7),
            
        //      ),
        //       ListTile(
        //     // leading: Icon(
        //     //  Icons.cable,
        //     //   size: 20,
        //     //   color: Colors.red,
        //     // ),
        //     title: Text(
        //       "أجهزة تعقب العناية الشخصية",
        //        style: GoogleFonts.almarai(
        //           textStyle: style
        //         ),
        //     ),
        //     onTap:() => navigateToBackDrop(cat8),
            
        //      ),
        //      ListTile(
        //     // leading: Icon(
        //     //  Icons.cable,
        //     //   size: 20,
        //     //   color: Colors.red,
        //     // ),
        //     title: Text(
        //       "حلول التنقل التشاركي",
        //       style: GoogleFonts.almarai(
        //           textStyle: style
        //         ),
        //     ),
        //     onTap: () => navigateToBackDrop(cat9),
        //      ),
        //     ListTile(
        //     // leading: Icon(
        //     //  Icons.cable,
        //     //   size: 20,
        //     //   color: Colors.red,
        //     // ),
        //     title: Text(
        //       "ملحقات أجهزة التعقب" ,
        //        style: GoogleFonts.almarai(
        //           textStyle: style
        //         ),
        //     ),
        //     onTap:() => navigateToBackDrop(cat10),
        //      ),
            buildListCategory(textStyle: textStyle),
          
               const Divider(color: const Color(0xff91b375),
                thickness: 1.0,),
               ListTile(
            leading: Icon(
             Icons.home_outlined,
              size: 20,
              color:!isDarkTheme ? Color(0xff91b375) : Colors.white,
            ),
            title: Text(S.of(context).home,
              // "الرئيسية",
              style: GoogleFonts.almarai(
                  textStyle: style
                ),
            ),
            onTap: () {
              pushNavigation(RouteList.home);
            },
             ),
             ListTile(
            leading: Icon(
             Icons.settings_outlined,
              size: 20,
              color:!isDarkTheme ? Color(0xff91b375) : Colors.white,
            ),
            title: Text(S.of(context).settings,
              // "الإعدادات",
              style: GoogleFonts.almarai(
                  textStyle: style
                ),
            ),
            onTap: () {
              pushNavigation(RouteList.profile);
            },
             ),
          //         ListTile(
          //   leading: Icon(
          //    Icons.book,
          //     size: 20,
          //     color:!isDarkTheme ? Colors.black : Colors.white,
          //   ),
          //   title: Text(
          //     "الكتالوج",
          //     style: GoogleFonts.almarai(
          //         textStyle: style
          //       ),
          //   ),
          //  onTap: () async => await Tools.launchURL("https://firebasestorage.googleapis.com/v0/b/mwjapp-468fa.appspot.com/o/mwjcatalog.pdf?alt=media&token=6c8163fa-313a-4d17-b7a3-0b1d0122a2bd"),
          //    ),
            //  ListTile(
            // leading: Icon(
            //  Icons.notifications_outlined,
            //   size: 20,
            //   color:!isDarkTheme ? Color(0xff91b375): Colors.white,
            // ),
            // title: Text(S.of(context).notifications,
            //   // "الإشعارات",
            //   style: GoogleFonts.almarai(
            //       textStyle: style
            //     ),
            // ),
            // onTap: () {
            //             Navigator.of(context).pushNamed(RouteList.notify);
            //           },
            // // onTap: () {
            // //   pushNavigation(RouteList.notify );
            // // },
            //  ),
             ListTile(
            leading: Icon(
             Icons.translate,
              size: 20,
              color:!isDarkTheme ?Color(0xff91b375) : Colors.white,
            ),
            title: Text(S.of(context).language,
              // "المفضلة",
              style: GoogleFonts.almarai(
                  textStyle: style
                ),
            ),
            onTap: () {
              Navigator.of(context).pushNamed(RouteList.language);
              //pushNavigation(RouteList.language);
            },
             ),
              ListTile(
            leading: Icon(
             Icons.info_outlined,
              size: 20,
              color:!isDarkTheme ?Color(0xff91b375) : Colors.white,
            ),
            title: Text(S.of(context).aboutUs,
              // "عن التطبيق",
              style: GoogleFonts.almarai(
                  textStyle: style
                ),
            ),
            onTap: () {
               Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostScreen(
                        pageId: 1788,
                        pageTitle: S.of(context).aboutUs),
                  ));
               //Navigator.push( context,MaterialPageRoute( builder: (context) => PrivacyScreen3(), ),);
            },
             ),
              ListTile(
            leading: Icon(
             Icons.description_outlined,
              size: 20,
             color:!isDarkTheme ? Color(0xff91b375) : Colors.white,
            ),
            title: Text(S.of(context).PrivacyAndTerm,
              // "الشروط و الأحكام",
              style: GoogleFonts.almarai(
                  textStyle: style
                ),
            ),
            onTap: () {
               Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostScreen(
                        pageId:1790,//context.isRtl ? 1790 1788 : ,
                        pageTitle: S.of(context).privacyPolicy),
                  ));
              // Navigator.push( context,MaterialPageRoute( builder: (context) => PrivacyScreen4(), ),);
            },
             ),
            //   ListTile(
            // leading: Icon(
            //  Icons.lock_outlined,
            //   size: 20,
            //   color: Colors.red,
            // ),
            // title: Text(
            //   "سياسة الخصوصية",
            //   style: GoogleFonts.almarai(
            //       textStyle: style
            //     ),
            // ),
            // onTap: () {
            //    Navigator.push( context,MaterialPageRoute( builder: (context) => PrivacyScreen5(), ),),
            // },
            //  ),
          const Divider(color: const Color(0xff91b375),
                thickness: 1.0,),
              Row(
                 mainAxisAlignment:MainAxisAlignment.center,
                 children:<Widget>[
                      ! isDarkTheme ?
                     IconButton(
                      onPressed:  () =>_launchURL("/"),//_addToCart(context, enableBottomSheet),
                      icon: const Icon(FontAwesomeIcons.facebook, color:Color(0xff91b375), size: 30.0)
                    ): IconButton(
                      onPressed:  () =>_launchURL("/"),//_addToCart(context, enableBottomSheet),
                      icon: const Icon(FontAwesomeIcons.facebook, color: Colors.white, size: 30.0)
                    ),
                    
                   

                   ! isDarkTheme ?
                    IconButton(
                      onPressed: () =>_launchURL(""), //{},//_addToCart(context, enableBottomSheet),
                      icon: FaIcon(FontAwesomeIcons.instagram, color:Color(0xff91b375), size: 30.0), 
                    
                    ):
                    IconButton(
                      onPressed: () =>_launchURL(""), //{},//_addToCart(context, enableBottomSheet),
                      icon: FaIcon(FontAwesomeIcons.instagram, color: Colors.white, size: 30.0), 
                    
                    ),
                    
                   
                  //  ! isDarkTheme ? 
                  //   IconButton(
                  //     onPressed: () =>_launchURL(""),//_addToCart(context, enableBottomSheet),
                  //    icon: Icon(FontAwesomeIcons.youtube, color: Colors.black, size: 30.0),
                  //   ):
                  //   IconButton(
                  //     onPressed: () =>_launchURL(""),//_addToCart(context, enableBottomSheet),
                  //    icon: Icon(FontAwesomeIcons.youtube, color: Colors.white, size: 30.0),
                  //   ),
                   
                   
                  //  ! isDarkTheme ? 
                  //   IconButton(
                  //     onPressed:  () =>_launchURL(""),//_addToCart(context, enableBottomSheet),
                  //     icon: const Icon(FontAwesomeIcons.twitter, color: Colors.black, size: 30.0)
                  //   ):
                   
                  //   IconButton(
                  //     onPressed:  () =>_launchURL(""),//_addToCart(context, enableBottomSheet),
                  //     icon: const Icon(FontAwesomeIcons.twitter, color: Colors.white, size: 30.0)
                  //   ),
                   
                   
          

                 ]
               )

            ],
            // ...List.generate(
            //   drawer.items?.length ?? 0,
            //   (index) {
            //     return drawerItem(
            //       drawer.items![index],
            //       drawer.subDrawerItem ?? {},
            //       textColor: drawer.textColor != null
            //           ? HexColor(drawer.textColor)
            //           : null,
            //       iconColor: drawer.iconColor != null
            //           ? HexColor(drawer.iconColor)
            //           : null,
            //     );
            //   },
            // ),
            isDisplayDesktop(context)
                ? const SizedBox(height: 300)
                : const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget drawerItem(
    DrawerItemsConfig drawerItemConfig,
    Map<String, GeneralSettingItem> subDrawerItem, {
    Color? iconColor,
    Color? textColor,
  }) {
    // final isTablet = Tools.isTablet(MediaQuery.of(context));

    if (drawerItemConfig.show == false) return const SizedBox();
    var value = drawerItemConfig.type;
    var textStyle = TextStyle(
      color: textColor ?? Theme.of(context).textTheme.bodyText1?.color,
    );

    switch (value) {
      case 'home':
        {
          return ListTile(
            leading: Icon(
              isEcommercePlatform ? Icons.home : Icons.shopping_basket,
              size: 20,
              color: iconColor,
            ),
            title: Text(
              isEcommercePlatform ? S.of(context).home : S.of(context).shop,
              style: textStyle,
            ),
            onTap: () {
              pushNavigation(RouteList.home);
            },
          );
        }
      case 'categories':
        {
          return ListTile(
            leading: Icon(
              Icons.category,
              size: 20,
              color: iconColor,
            ),
            title: Text(
              S.of(context).categories,
              style: textStyle,
            ),
            onTap: () => pushNavigation(
              Provider.of<AppModel>(context, listen: false).vendorType ==
                      VendorType.single
                  ? RouteList.category
                  : RouteList.vendorCategory,
            ),
          );
        }
      case 'cart':
        {
          if (Config().isListingType) {
            return Container();
          }
          return ListTile(
            leading: Icon(
              Icons.shopping_cart,
              size: 20,
              color: iconColor,
            ),
            title: Text(
              S.of(context).cart,
              style: textStyle,
            ),
            onTap: () => pushNavigation(RouteList.cart),
          );
        }
      case 'profile':
        {
          return ListTile(
            leading: Icon(
              Icons.person,
              size: 20,
              color: iconColor,
            ),
            title: Text(
              S.of(context).settings,
              style: textStyle,
            ),
            onTap: () => pushNavigation(RouteList.profile),
          );
        }
      case 'web':
        {
          return ListTile(
            leading: Icon(
              Icons.web,
              size: 20,
              color: iconColor,
            ),
            title: Text(
              S.of(context).webView,
              style: textStyle,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WebView(
                    url: '',
                    title: S.of(context).webView,
                  ),
                ),
              );
            },
          );
        }
      case 'blog':
        {
          return ListTile(
            leading: Icon(
              CupertinoIcons.news_solid,
              size: 20,
              color: iconColor,
            ),
            title: Text(
              S.of(context).blog,
              style: textStyle,
            ),
            onTap: () => pushNavigation(RouteList.listBlog),
          );
        }
      case 'login':
        {
          return ListenableProvider.value(
            value: Provider.of<UserModel>(context, listen: false),
            child: Consumer<UserModel>(builder: (context, userModel, _) {
              final loggedIn = userModel.loggedIn;
              return ListTile(
                leading: Icon(Icons.exit_to_app, size: 20, color: iconColor),
                title: loggedIn
                    ? Text(S.of(context).logout, style: textStyle)
                    : Text(S.of(context).login, style: textStyle),
                onTap: () {
                  if (loggedIn) {
                    Provider.of<UserModel>(context, listen: false).logout();
                    if (kLoginSetting.isRequiredLogin){ 
                    // if (kLoginSetting['IsRequiredLogin'] ?? false) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        RouteList.login,
                        (route) => false,
                      );
                    }
                    // else {
                    //   pushNavigation(RouteList.dashboard);
                    // }
                  } else {
                    pushNavigation(RouteList.login);
                  }
                },
              );
            }),
          );
        }
      case 'category':
        {
          return buildListCategory(textStyle: textStyle);
        }
      default:
        {
          var item = subDrawerItem[value];
          if (value?.contains('web') ?? false) {
            return GeneralWebWidget(
              item: item,
              useTile: true,
              iconColor: iconColor,
              textStyle:TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ), //textStyle,
            );
          }
          if (value?.contains('post') ?? false) {
            return GeneralPostWidget(
              item: item,
              useTile: true,
              iconColor: iconColor,
              textStyle:TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),// textStyle,
            );
          }
          if (value?.contains('title') ?? false) {
            return GeneralTitleWidget(item: item);
          }
          if (value?.contains('button') ?? false) {
            return GeneralButtonWidget(item: item);
          }
        }

        return const SizedBox();
    }
  }

  Widget buildListCategory({TextStyle? textStyle}) {
    final categories = Provider.of<CategoryModel>(context).categories;
    final style = TextStyle(fontSize: 15, fontWeight:FontWeight.w600,color:Theme.of(context).colorScheme.secondary);
    var widgets = <Widget>[];

    if (categories != null) {
      var list = categories.where((item) => item.parent == '0').toList();
      for (var i = 0; i < list.length; i++) {
        final currentCategory = list[i];
        var childCategories =
            categories.where((o) => o.parent == currentCategory.id).toList();
        widgets.add(Container(
         // height:60,
          // color: i.isOdd
          //     ? null
          //     : Theme.of(context).colorScheme.secondary.withOpacity(0.1),

          /// Check to add only parent link category
          child: childCategories.isEmpty
              ? InkWell(
                  onTap: () => navigateToBackDrop(currentCategory),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 20,
                      bottom: 12,
                      left: 16,
                      top: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Text(
                          currentCategory.name!.toUpperCase(),
                          style: GoogleFonts.almarai(
                  textStyle: style
                ), //textStyle,
                        )),
                        const SizedBox(width: 24),
                        // currentCategory.totalProduct == null
                        //     ? const Icon(Icons.chevron_right)
                        //     : Padding(
                        //         padding:
                        //             const EdgeInsets.symmetric(vertical: 10),
                        //         child: Text(
                        //           S
                        //               .of(context)
                        //               .nItems(currentCategory.totalProduct!),
                        //           style: TextStyle(
                        //             color: Theme.of(context).primaryColor,
                        //             fontSize: 12,
                        //           ),
                        //         ),
                        //       ),
                      ],
                    ),
                  ),
                )
              : ExpansionTile(
                  title: Padding(
                    padding: const EdgeInsets.only(left: 0.0, top: 0),
                    child: Text(
                      currentCategory.name!.toUpperCase(),
                      style: textStyle?.copyWith(fontSize: 14,color:Theme.of(context).colorScheme.secondary) ??
                           TextStyle(fontSize: 14,color:Theme.of(context).colorScheme.secondary),
                    ),
                  ),
                  textColor:Theme.of(context).colorScheme.secondary,//Theme.of(context).primaryColor,
                  iconColor:Theme.of(context).colorScheme.secondary,
                  children:
                      getChildren(categories, currentCategory, childCategories)
                          as List<Widget>,
                ),
        ),
       
        );
        SizedBox(height:10);
        
      }
    }

    return Column ( 
    //  ExpansionTile(
    //   initiallyExpanded: true,
    //   expandedCrossAxisAlignment: CrossAxisAlignment.start,
    //   tilePadding: const EdgeInsets.only(left: 16, right: 8),
    //   title: Text("التصنيفات",
    //     //S.of(context).byCategory.toUpperCase(),
    //     style: TextStyle(
    //       fontSize: 15,
    //       fontWeight: FontWeight.w700,
    //       color: textStyle?.color ??
    //           Theme.of(context).colorScheme.secondary.withOpacity(0.5),
    //     ),
    //   ),
      children: widgets,
    );
  }

  List getChildren(
    List<Category> categories,
    Category currentCategory,
    List<Category> childCategories, {
    double paddingOffset = 0.0,
  }) {
    var list = <Widget>[];

    list.add(
      ListTile(
        leading: Padding(
          padding: EdgeInsets.only(left: 20 + paddingOffset),
          child: Text(S.of(context).seeAll),
        ),
        trailing: Text(
          S.of(context).nItems(currentCategory.totalProduct!),
          style: TextStyle(
            color:Theme.of(context).colorScheme.secondary, //Theme.of(context).primaryColor,
            fontSize: 12,
          ),
        ),
        onTap: () => navigateToBackDrop(currentCategory),
      ),
    );
    for (var i in childCategories) {
      var newChildren = categories.where((cat) => cat.parent == i.id).toList();
      if (newChildren.isNotEmpty) {
        list.add(
          ExpansionTile(
            title: Padding(
              padding: EdgeInsets.only(left: 20.0 + paddingOffset),
              child: Text(
                i.name!.toUpperCase(),
                style: const TextStyle(fontSize: 14,),
              ),
            ),
            children: getChildren(
              categories,
              i,
              newChildren,
              paddingOffset: paddingOffset + 10,
            ) as List<Widget>,
          ),
        );
      } else {
        list.add(
          ListTile(
            title: Padding(
              padding: EdgeInsets.only(left: 20 + paddingOffset),
              child: Text(i.name!),
            ),
            trailing: Text(
              S.of(context).nItems(i.totalProduct!),
              style: TextStyle(
                color:Theme.of(context).colorScheme.secondary,//Theme.of(context).primaryColor,
                fontSize: 12,
              ),
            ),
            onTap: () => navigateToBackDrop(i),
          ),
        );
      }
    }
    return list;
  }

  void navigateToBackDrop(Category category) {
    FluxNavigate.pushNamed(
      RouteList.backdrop,
      arguments: BackDropArguments(
        cateId: category.id,
        cateName: category.name,
      ),
    );
  }
}

class PrivacyScreen3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var isDarkTheme = Provider.of<AppModel>(context, listen: false).darkTheme;

    return Scaffold(
         backgroundColor:isDarkTheme ? Theme.of(context).backgroundColor : Colors.white,
      //backgroundColor:Colors.white,
     // backgroundColor:Theme.of(context).backgroundColor,
          appBar: AppBar(
         //backgroundColor:Colors.white,//const Color(0xffffbf00),
          // backgroundColor:Theme.of(context).backgroundColor,
           backgroundColor: isDarkTheme ? Theme.of(context).backgroundColor : Colors.white,
  shape: Border(
    bottom: BorderSide(
      color:const Color(0xffffbf00), //Colors.orange,const Color(0xff05dae5)
      width: 1,
    ),
  ),
  elevation: 3,
   centerTitle: true,
         // systemOverlayStyle: SystemUiOverlayStyle.light,
        //  backgroundColor: Theme.of(context).primaryColorLight,
          title:  Text("عن التطبيق",

            style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(
                                      fontWeight: FontWeight.w600,
                                      color:Theme.of(context).colorScheme.secondary,// Colors.black,
                                      fontSize: 17,
                                    )
            // style: TextStyle(
            //   color:Colors.white, //Theme.of(context).colorScheme.secondary,
            // ),
          ),
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
//       appBar: AppBar(
//        // systemOverlayStyle: SystemUiOverlayStyle.light,
//         title: Text("الأحكام والشروط"
// "          S.of(context).agreeWithPrivacy",         style: const TextStyle(
//             fontSize: 14.0,
//             color: Colors.white,
//           ),
//         ),
//         centerTitle:true,
//         leading: GestureDetector(
//           onTap: () => Navigator.pop(context),
//           child: const Icon(
//             Icons.arrow_back_ios,
//             color: Colors.white,
//           ),
//         ),
//       ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text('''

          ''',
            //S.of(context).privacyTerms,
             style: const TextStyle(fontSize: 16.0, height: 1.4),
            textAlign: TextAlign.right,
            // style: Theme.of(context)
            //                         .textTheme
            //                         .subtitle1!
            //                         .copyWith(
            //                           fontWeight: FontWeight.w600,
            //                           color:Theme.of(context).colorScheme.secondary,// Colors.black,
            //                           fontSize: 17,
            //                         )
            //const TextStyle(fontSize: 16.0, height: 1.4 ,color: isDarkTheme ? Colors.blue : Colors.black),//Theme.of(context).colorScheme.secondary,),
           // textAlign: TextAlign.right,
          ),
        ),
      ),
    );
  }
}

class PrivacyScreen4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
        var isDarkTheme = Provider.of<AppModel>(context, listen: false).darkTheme;

    return Scaffold(
  backgroundColor:isDarkTheme ? Theme.of(context).backgroundColor : Colors.white,       //backgroundColor:Theme.of(context).backgroundColor,
     // backgroundColor:Colors.white,
          appBar: AppBar(
         backgroundColor:isDarkTheme ? Theme.of(context).backgroundColor : Colors.white,
         //  backgroundColor:Theme.of(context).backgroundColor,
         //backgroundColor:Colors.white,//const Color(0xffffbf00),
  shape: Border(
    bottom: BorderSide(
      color:const Color(0xffffbf00), //Colors.orange,const Color(0xff05dae5)
      width: 1,
    ),
  ),
  elevation: 3,
   centerTitle: true,
         // systemOverlayStyle: SystemUiOverlayStyle.light,
        //  backgroundColor: Theme.of(context).primaryColorLight,
          title:  Text("الأحكام والشروط",

            style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context).colorScheme.secondary,
                                      fontSize: 17,
                                    )
            // style: TextStyle(
            //   color:Colors.white, //Theme.of(context).colorScheme.secondary,
            // ),
          ),
       leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
//       appBar: AppBar(
//        // systemOverlayStyle: SystemUiOverlayStyle.light,
//         title: Text("الأحكام والشروط"
// "          S.of(context).agreeWithPrivacy",         style: const TextStyle(
//             fontSize: 14.0,
//             color: Colors.white,
//           ),
//         ),
//         centerTitle:true,
//         leading: GestureDetector(
//           onTap: () => Navigator.pop(context),
//           child: const Icon(
//             Icons.arrow_back_ios,
//             color: Colors.white,
//           ),
//         ),
//       ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text('''
سياسة الخصوصية




         
          ''',
            //S.of(context).privacyTerms,
             style: const TextStyle(fontSize: 16.0, height: 1.4),
            textAlign: TextAlign.right,
            // style: Theme.of(context)
            //                         .textTheme
            //                         .subtitle1!
            //                         .copyWith(
            //                           fontWeight: FontWeight.w600,
            //                           color:Theme.of(context).colorScheme.secondary,// Colors.black,
            //                           fontSize: 17,
            //                         ),//const TextStyle(fontSize: 16.0, height: 1.4),
            // textAlign: TextAlign.right,
          ),
        ),
      ),
    );
  }
}

class PrivacyScreen5 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.white,
          appBar: AppBar(
         backgroundColor:Colors.white,//const Color(0xffffbf00),
  shape: Border(
    bottom: BorderSide(
      color:const Color(0xffffbf00), //Colors.orange,const Color(0xff05dae5)
      width: 1,
    ),
  ),
  elevation: 3,
   centerTitle: true,
         // systemOverlayStyle: SystemUiOverlayStyle.light,
        //  backgroundColor: Theme.of(context).primaryColorLight,
          title:  Text("سياسة الخصوصية",

            style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      fontSize: 17,
                                    )
            // style: TextStyle(
            //   color:Colors.white, //Theme.of(context).colorScheme.secondary,
            // ),
          ),
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,//Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
//       appBar: AppBar(
//        // systemOverlayStyle: SystemUiOverlayStyle.light,
//         title: Text("الأحكام والشروط"
// "          S.of(context).agreeWithPrivacy",         style: const TextStyle(
//             fontSize: 14.0,
//             color: Colors.white,
//           ),
//         ),
//         centerTitle:true,
//         leading: GestureDetector(
//           onTap: () => Navigator.pop(context),
//           child: const Icon(
//             Icons.arrow_back_ios,
//             color: Colors.white,
//           ),
//         ),
//       ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(''' ''',
            //S.of(context).privacyTerms,
            style: const TextStyle(fontSize: 16.0, height: 1.4),
            textAlign: TextAlign.right,
          ),
        ),
      ),
    );
  }
}


// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:google_fonts/google_fonts.dart';
// //import 'dart:async';
// import '../common/config.dart';
// import '../common/config/models/index.dart';
// import '../common/constants.dart';
// import '../common/tools.dart';
// import '../generated/l10n.dart';
// import '../models/index.dart'
//     show AppModel, BackDropArguments, Category, CategoryModel, UserModel;
// import '../modules/dynamic_layout/config/app_config.dart';
// import '../modules/dynamic_layout/helper/helper.dart';
// import '../routes/flux_navigate.dart';
// import '../services/index.dart';
// import '../widgets/common/index.dart' show FluxImage, WebView;
// import '../widgets/general/index.dart';
// import 'maintab_delegate.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:url_launcher/url_launcher.dart';
// class SideBarMenu extends StatefulWidget {
//   const SideBarMenu();

//   @override
//   MenuBarState createState() => MenuBarState();
// }

// class MenuBarState extends State<SideBarMenu> {
//   bool get isEcommercePlatform =>
//       !Config().isListingType || !Config().isWordPress;

//   DrawerMenuConfig get drawer =>
//       Provider.of<AppModel>(context, listen: false).appConfig?.drawer ??
//       kDefaultDrawer;

//   void pushNavigation(String name) {
//     eventBus.fire(const EventCloseNativeDrawer());
//     MainTabControlDelegate.getInstance().changeTab(name.replaceFirst('/', ''));
//   }




//   @override
//   Widget build(BuildContext context) {
//     printLog('[AppState] Load Menu');
//       final style = TextStyle(fontSize: 15, );
//     var isDarkTheme = Provider.of<AppModel>(context, listen: false).darkTheme;

//      final cat1 = <String,dynamic> {"id":"44"};
//       final cat2 = <String,dynamic> {"id":"45"};
//        final cat3 = <String,dynamic> {"id":"46"};
//         final cat4 = <String,dynamic> {"id":"47"};
//          final cat5 = <String,dynamic> {"id":"48"};

//       final cat6 = Category.fromJson(cat1);
//        final cat7 = Category.fromJson(cat2);
//         final cat8 = Category.fromJson(cat3);
//          final cat9 = Category.fromJson(cat4);
//           final cat10 = Category.fromJson(cat5);

// _launchURL(String url) async {
//  // const url = 'https://flutter.io';
//   if (await canLaunch(url)) {
//     await launch(url);
//   } else {
//     throw 'Could not launch $url';
//   }
// }


//     return Padding(
//       key: drawer.key != null ? Key(drawer.key as String) : UniqueKey(),
//       padding: EdgeInsets.only(
//           bottom: injector<AudioService>().isStickyAudioWidgetActive ? 0 : 0),
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if (drawer.logo != null) ...[
//               Container(
//                 color:isDarkTheme ?Colors.transparent : Colors.white,
//               width:350,
//                 height:200,
//             //      decoration: const  BoxDecoration(
//             //  gradient: LinearGradient(
                
//             //     begin: FractionalOffset(0.0,0.0),
//             //     end : FractionalOffset(0.0,1.0),
//             //     stops:[0.0,1.0],
//             //     tileMode:TileMode.clamp,
//             //     colors:[
//             //       const Color(0xffffbf00),
//             //          const Color(0xffffbf00),
//             //       // backgroundColor: const Color(0xff05dae5),
                    

//             //   ],
//             //   ),
//             // ),

//                // color:Colors.red,
//                 // color: drawer.logoConfig.backgroundColor != null
//                 //     ? HexColor(drawer.logoConfig.backgroundColor)
//                 //     : null,
//                 // padding: EdgeInsets.only(
//                 //   bottom: drawer.logoConfig.marginBottom.toDouble(),
//                 //   top: drawer.logoConfig.marginTop.toDouble(),
//                 //   left: drawer.logoConfig.marginLeft.toDouble(),
//                 //   right: drawer.logoConfig.marginRight.toDouble(),
//                 // ),
//                 child:Column(
//                   //
//                   mainAxisAlignment:MainAxisAlignment.center,
//                   children:<Widget>[
//                     isDarkTheme ? FluxImage(imageUrl: "https://i.imgur.com/XhaKMqR.png", height: 60)
//                      : FluxImage(imageUrl: "https://i.imgur.com/XhaKMqR.png", height: 60),
//                      SizedBox(height:10),
//                      Container(
//     margin: context.isRtl? const EdgeInsets.only(right: 110.0) : const EdgeInsets.only(left: 110.0) ,
//                    // case 'login':
//        // {
//           child:
//            ListenableProvider.value(
//             value: Provider.of<UserModel>(context, listen: false),
//             child: Consumer<UserModel>(builder: (context, userModel, _) {
//               final loggedIn = userModel.loggedIn;
//                   return  ElevatedButton(
                       
//             style:  ButtonStyle(
//               backgroundColor: MaterialStateProperty.all(const Color(0xffffbf00),),
//              // overlayColor:MaterialStateProperty.all(Colors.orange),
//               shadowColor: MaterialStateProperty.all(const Color(0xffffbf00),),

//           // overlayColor:MaterialStateProperty.all(Color(0x187BCD)) ,//change with your color
//               shape: MaterialStateProperty.all(RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(5),
//               ))),
//             onPressed: () {
//                   if (loggedIn) {
//                     Provider.of<UserModel>(context, listen: false).logout();
//                     if (kLoginSetting['IsRequiredLogin'] ?? false) {
//                       Navigator.of(context).pushNamedAndRemoveUntil(
//                         RouteList.login,
//                         (route) => false,
//                       );
//                     }
//                     // else {
//                     //   pushNavigation(RouteList.dashboard);
//                     // }
//                   } else {
//                     pushNavigation(RouteList.login);
//                   }
//                 },
//             child:
//             loggedIn
//                     ? Text(S.of(context).logout,style:TextStyle(color: Colors.white))
//                     : Text(S.of(context).login,style:TextStyle(color: Colors.white)),
//             // Text('تسجيل الدخول',style:TextStyle(color: Colors.black)),
         
//         );













//               // return ListTile(
//               //   leading: Icon(Icons.exit_to_app, size: 20, ),
//               //   title: loggedIn
//               //       ? Text(S.of(context).logout, )
//               //       : Text(S.of(context).login,),
//               //   onTap: () {
//               //     if (loggedIn) {
//               //       Provider.of<UserModel>(context, listen: false).logout();
//               //       if (kLoginSetting['IsRequiredLogin'] ?? false) {
//               //         Navigator.of(context).pushNamedAndRemoveUntil(
//               //           RouteList.login,
//               //           (route) => false,
//               //         );
//               //       }
//               //       // else {
//               //       //   pushNavigation(RouteList.dashboard);
//               //       // }
//               //     } else {
//               //       pushNavigation(RouteList.login);
//               //     }
//               //   },
//               // );



//             }),
//           ),
//        // }
//                      ),        
                   
                   
                   
                   
                   
//         //             child:ElevatedButton(
                       
//         //     style:  ButtonStyle(
//         //       backgroundColor: MaterialStateProperty.all(Colors.white),
//         //      // overlayColor:MaterialStateProperty.all(Colors.orange),
//         //       shadowColor: MaterialStateProperty.all(Colors.white),

//         //   // overlayColor:MaterialStateProperty.all(Color(0x187BCD)) ,//change with your color
//         //       shape: MaterialStateProperty.all(RoundedRectangleBorder(
//         //         borderRadius: BorderRadius.circular(5),
//         //       ))),
//         //     onPressed: () async { },
//         //     child: Text('تسجيل الدخول',style:TextStyle(color: Colors.black)),
         
//         // ),
//         // ),

//                   ]
                
//                 )
//                 // child: FluxImage(
//                 //   width: drawer.logoConfig.useMaxWidth
//                 //       ? MediaQuery.of(context).size.width
//                 //       : drawer.logoConfig.width?.toDouble(),
//                 //   fit: Helper.boxFit(drawer.logoConfig.boxFit),
//                 //   height: drawer.logoConfig.height.toDouble(),
//                 //   imageUrl: "https://i.imgur.com/1il9HBc.png",//drawer.logo as String,
//                 // ),
//               ),
        
//               const Divider(color: const Color(0xffffbf00),
//                 thickness: 1.0,),
//               ListTile(
//             // leading: Icon(
//             //  Icons.cable,
//             //   size: 20,
//             //   color: Colors.red,
//             // ),
//             title: Text(
//               "أجهزة تعقب الأسطول",
//                style: GoogleFonts.almarai(
//                   textStyle: style
//                 ),
//             ),
//             onTap: () => navigateToBackDrop(cat6),
//          // {}
           
//              ),
//              ///
//              ListTile(
//             // leading: Icon(
//             //  Icons.cable,
//             //   size: 20,
//             //   color: Colors.red,
//             // ),
//             title: Text(
//               "أجهزة تعقب الأصول",
//                style: GoogleFonts.almarai(
//                   textStyle: style
//                 ),
//             ),
//             onTap:() => navigateToBackDrop(cat7),
            
//              ),
//               ListTile(
//             // leading: Icon(
//             //  Icons.cable,
//             //   size: 20,
//             //   color: Colors.red,
//             // ),
//             title: Text(
//               "أجهزة تعقب العناية الشخصية",
//                style: GoogleFonts.almarai(
//                   textStyle: style
//                 ),
//             ),
//             onTap:() => navigateToBackDrop(cat8),
            
//              ),
//              ListTile(
//             // leading: Icon(
//             //  Icons.cable,
//             //   size: 20,
//             //   color: Colors.red,
//             // ),
//             title: Text(
//               "حلول التنقل التشاركي",
//               style: GoogleFonts.almarai(
//                   textStyle: style
//                 ),
//             ),
//             onTap: () => navigateToBackDrop(cat9),
//              ),
//             ListTile(
//             // leading: Icon(
//             //  Icons.cable,
//             //   size: 20,
//             //   color: Colors.red,
//             // ),
//             title: Text(
//               "ملحقات أجهزة التعقب" ,
//                style: GoogleFonts.almarai(
//                   textStyle: style
//                 ),
//             ),
//             onTap:() => navigateToBackDrop(cat10),
//              ),
            
          
//                const Divider(color: const Color(0xffffbf00),
//                 thickness: 1.0,),
//                ListTile(
//             leading: Icon(
//              Icons.home_outlined,
//               size: 20,
//               color: Colors.black,
//             ),
//             title: Text(
//               "الرئيسية",
//               style: GoogleFonts.almarai(
//                   textStyle: style
//                 ),
//             ),
//             onTap: () {
//               pushNavigation(RouteList.home);
//             },
//              ),
//              ListTile(
//             leading: Icon(
//              Icons.settings_outlined,
//               size: 20,
//               color: Colors.black,
//             ),
//             title: Text(
//               "الإعدادات",
//               style: GoogleFonts.almarai(
//                   textStyle: style
//                 ),
//             ),
//             onTap: () {
//               pushNavigation(RouteList.profile);
//             },
//              ),
//                   ListTile(
//             leading: Icon(
//              Icons.book,
//               size: 20,
//               color: Colors.black,
//             ),
//             title: Text(
//               "الكتالوج",
//               style: GoogleFonts.almarai(
//                   textStyle: style
//                 ),
//             ),
//            onTap: () async => await Tools.launchURL("https://firebasestorage.googleapis.com/v0/b/mwjapp-468fa.appspot.com/o/mwjcatalog.pdf?alt=media&token=6c8163fa-313a-4d17-b7a3-0b1d0122a2bd"),
//              ),
//              ListTile(
//             leading: Icon(
//              Icons.notifications_outlined,
//               size: 20,
//               color: Colors.black,
//             ),
//             title: Text(
//               "الإشعارات",
//               style: GoogleFonts.almarai(
//                   textStyle: style
//                 ),
//             ),
//             onTap: () {
//                         Navigator.of(context).pushNamed(RouteList.notify);
//                       },
//             // onTap: () {
//             //   pushNavigation(RouteList.notify );
//             // },
//              ),
//              ListTile(
//             leading: Icon(
//              Icons.favorite_border,
//               size: 20,
//               color: Colors.black,
//             ),
//             title: Text(
//               "المفضلة",
//               style: GoogleFonts.almarai(
//                   textStyle: style
//                 ),
//             ),
//             onTap: () {
//               pushNavigation(RouteList.wishlist);
//             },
//              ),
//               ListTile(
//             leading: Icon(
//              Icons.info_outlined,
//               size: 20,
//               color: Colors.black,
//             ),
//             title: Text(
//               "عن التطبيق",
//               style: GoogleFonts.almarai(
//                   textStyle: style
//                 ),
//             ),
//             onTap: () {
//                Navigator.push( context,MaterialPageRoute( builder: (context) => PrivacyScreen3(), ),);
//             },
//              ),
//               ListTile(
//             leading: Icon(
//              Icons.description_outlined,
//               size: 20,
//               color: Colors.black,
//             ),
//             title: Text(
//               "الشروط و الأحكام",
//               style: GoogleFonts.almarai(
//                   textStyle: style
//                 ),
//             ),
//             onTap: () {
//                Navigator.push( context,MaterialPageRoute( builder: (context) => PrivacyScreen4(), ),);
//             },
//              ),
//             //   ListTile(
//             // leading: Icon(
//             //  Icons.lock_outlined,
//             //   size: 20,
//             //   color: Colors.red,
//             // ),
//             // title: Text(
//             //   "سياسة الخصوصية",
//             //   style: GoogleFonts.almarai(
//             //       textStyle: style
//             //     ),
//             // ),
//             // onTap: () {
//             //    Navigator.push( context,MaterialPageRoute( builder: (context) => PrivacyScreen5(), ),),
//             // },
//             //  ),
//           const Divider(color: const Color(0xffffbf00),
//                 thickness: 1.0,),
//               Row(
//                  mainAxisAlignment:MainAxisAlignment.center,
//                  children:<Widget>[
//                       ! isDarkTheme ?
//                      IconButton(
//                       onPressed:  () =>_launchURL("https://www.facebook.com/Mawj.GPS/"),//_addToCart(context, enableBottomSheet),
//                       icon: const Icon(FontAwesomeIcons.facebook, color: Colors.black, size: 30.0)
//                     ): IconButton(
//                       onPressed:  () =>_launchURL("https://www.facebook.com/Mawj.GPS/"),//_addToCart(context, enableBottomSheet),
//                       icon: const Icon(FontAwesomeIcons.facebook, color: Colors.white, size: 30.0)
//                     ),
                    
                   

//                    ! isDarkTheme ?
//                     IconButton(
//                       onPressed: () =>_launchURL("https://www.instagram.com/mawj.gps"), //{},//_addToCart(context, enableBottomSheet),
//                       icon: FaIcon(FontAwesomeIcons.instagram, color: Colors.black, size: 30.0), 
                    
//                     ):
//                     IconButton(
//                       onPressed: () =>_launchURL("https://www.instagram.com/mawj.gps"), //{},//_addToCart(context, enableBottomSheet),
//                       icon: FaIcon(FontAwesomeIcons.instagram, color: Colors.white, size: 30.0), 
                    
//                     ),
                    
                   
//                    ! isDarkTheme ? 
//                     IconButton(
//                       onPressed: () =>_launchURL("https://www.youtube.com/channel/UCSF22k26YzC9W-Cfol5rC3g"),//_addToCart(context, enableBottomSheet),
//                      icon: Icon(FontAwesomeIcons.youtube, color: Colors.black, size: 30.0),
//                     ):
//                     IconButton(
//                       onPressed: () =>_launchURL("https://www.youtube.com/channel/UCSF22k26YzC9W-Cfol5rC3g"),//_addToCart(context, enableBottomSheet),
//                      icon: Icon(FontAwesomeIcons.youtube, color: Colors.white, size: 30.0),
//                     ),
                   
                   
//                    ! isDarkTheme ? 
//                     IconButton(
//                       onPressed:  () =>_launchURL("https://twitter.com/Mawj_GPS"),//_addToCart(context, enableBottomSheet),
//                       icon: const Icon(FontAwesomeIcons.twitter, color: Colors.black, size: 30.0)
//                     ):
                   
//                     IconButton(
//                       onPressed:  () =>_launchURL("https://twitter.com/Mawj_GPS"),//_addToCart(context, enableBottomSheet),
//                       icon: const Icon(FontAwesomeIcons.twitter, color: Colors.white, size: 30.0)
//                     ),
                   
                   
          

//                  ]
//                )

//             ],
//             // ...List.generate(
//             //   drawer.items?.length ?? 0,
//             //   (index) {
//             //     return drawerItem(
//             //       drawer.items![index],
//             //       drawer.subDrawerItem ?? {},
//             //       textColor: drawer.textColor != null
//             //           ? HexColor(drawer.textColor)
//             //           : null,
//             //       iconColor: drawer.iconColor != null
//             //           ? HexColor(drawer.iconColor)
//             //           : null,
//             //     );
//             //   },
//             // ),
//             isDisplayDesktop(context)
//                 ? const SizedBox(height: 300)
//                 : const SizedBox(height: 24),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget drawerItem(
//     DrawerItemsConfig drawerItemConfig,
//     Map<String, GeneralSettingItem> subDrawerItem, {
//     Color? iconColor,
//     Color? textColor,
//   }) {
//     // final isTablet = Tools.isTablet(MediaQuery.of(context));

//     if (drawerItemConfig.show == false) return const SizedBox();
//     var value = drawerItemConfig.type;
//     var textStyle = TextStyle(
//       color: textColor ?? Theme.of(context).textTheme.bodyText1?.color,
//     );

//     switch (value) {
//       case 'home':
//         {
//           return ListTile(
//             leading: Icon(
//               isEcommercePlatform ? Icons.home : Icons.shopping_basket,
//               size: 20,
//               color: iconColor,
//             ),
//             title: Text(
//               isEcommercePlatform ? S.of(context).home : S.of(context).shop,
//               style: textStyle,
//             ),
//             onTap: () {
//               pushNavigation(RouteList.home);
//             },
//           );
//         }
//       case 'categories':
//         {
//           return ListTile(
//             leading: Icon(
//               Icons.category,
//               size: 20,
//               color: iconColor,
//             ),
//             title: Text(
//               S.of(context).categories,
//               style: textStyle,
//             ),
//             onTap: () => pushNavigation(
//               Provider.of<AppModel>(context, listen: false).vendorType ==
//                       VendorType.single
//                   ? RouteList.category
//                   : RouteList.vendorCategory,
//             ),
//           );
//         }
//       case 'cart':
//         {
//           if (Config().isListingType) {
//             return Container();
//           }
//           return ListTile(
//             leading: Icon(
//               Icons.shopping_cart,
//               size: 20,
//               color: iconColor,
//             ),
//             title: Text(
//               S.of(context).cart,
//               style: textStyle,
//             ),
//             onTap: () => pushNavigation(RouteList.cart),
//           );
//         }
//       case 'profile':
//         {
//           return ListTile(
//             leading: Icon(
//               Icons.person,
//               size: 20,
//               color: iconColor,
//             ),
//             title: Text(
//               S.of(context).settings,
//               style: textStyle,
//             ),
//             onTap: () => pushNavigation(RouteList.profile),
//           );
//         }
//       case 'web':
//         {
//           return ListTile(
//             leading: Icon(
//               Icons.web,
//               size: 20,
//               color: iconColor,
//             ),
//             title: Text(
//               S.of(context).webView,
//               style: textStyle,
//             ),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => WebView(
//                     url: '',
//                     title: S.of(context).webView,
//                   ),
//                 ),
//               );
//             },
//           );
//         }
//       case 'blog':
//         {
//           return ListTile(
//             leading: Icon(
//               CupertinoIcons.news_solid,
//               size: 20,
//               color: iconColor,
//             ),
//             title: Text(
//               S.of(context).blog,
//               style: textStyle,
//             ),
//             onTap: () => pushNavigation(RouteList.listBlog),
//           );
//         }
//       case 'login':
//         {
//           return ListenableProvider.value(
//             value: Provider.of<UserModel>(context, listen: false),
//             child: Consumer<UserModel>(builder: (context, userModel, _) {
//               final loggedIn = userModel.loggedIn;
//               return ListTile(
//                 leading: Icon(Icons.exit_to_app, size: 20, color: iconColor),
//                 title: loggedIn
//                     ? Text(S.of(context).logout, style: textStyle)
//                     : Text(S.of(context).login, style: textStyle),
//                 onTap: () {
//                   if (loggedIn) {
//                     Provider.of<UserModel>(context, listen: false).logout();
//                     if (kLoginSetting['IsRequiredLogin'] ?? false) {
//                       Navigator.of(context).pushNamedAndRemoveUntil(
//                         RouteList.login,
//                         (route) => false,
//                       );
//                     }
//                     // else {
//                     //   pushNavigation(RouteList.dashboard);
//                     // }
//                   } else {
//                     pushNavigation(RouteList.login);
//                   }
//                 },
//               );
//             }),
//           );
//         }
//       case 'category':
//         {
//           return buildListCategory(textStyle: textStyle);
//         }
//       default:
//         {
//           var item = subDrawerItem[value];
//           if (value?.contains('web') ?? false) {
//             return GeneralWebWidget(
//               item: item,
//               useTile: true,
//               iconColor: iconColor,
//               textStyle:TextStyle(
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.bold,
//                                   ), //textStyle,
//             );
//           }
//           if (value?.contains('post') ?? false) {
//             return GeneralPostWidget(
//               item: item,
//               useTile: true,
//               iconColor: iconColor,
//               textStyle:TextStyle(
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.bold,
//                                   ),// textStyle,
//             );
//           }
//           if (value?.contains('title') ?? false) {
//             return GeneralTitleWidget(item: item);
//           }
//           if (value?.contains('button') ?? false) {
//             return GeneralButtonWidget(item: item);
//           }
//         }

//         return const SizedBox();
//     }
//   }

//   Widget buildListCategory({TextStyle? textStyle}) {
//     final categories = Provider.of<CategoryModel>(context).categories;
//     var widgets = <Widget>[];

//     if (categories != null) {
//       var list = categories.where((item) => item.parent == '0').toList();
//       for (var i = 0; i < list.length; i++) {
//         final currentCategory = list[i];
//         var childCategories =
//             categories.where((o) => o.parent == currentCategory.id).toList();
//         widgets.add(Container(
//           color: i.isOdd
//               ? null
//               : Theme.of(context).colorScheme.secondary.withOpacity(0.1),

//           /// Check to add only parent link category
//           child: childCategories.isEmpty
//               ? InkWell(
//                   onTap: () => navigateToBackDrop(currentCategory),
//                   child: Padding(
//                     padding: const EdgeInsets.only(
//                       right: 20,
//                       bottom: 12,
//                       left: 16,
//                       top: 12,
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                             child: Text(
//                           currentCategory.name!.toUpperCase(),
//                           style: textStyle,
//                         )),
//                         const SizedBox(width: 24),
//                         currentCategory.totalProduct == null
//                             ? const Icon(Icons.chevron_right)
//                             : Padding(
//                                 padding:
//                                     const EdgeInsets.symmetric(vertical: 10),
//                                 child: Text(
//                                   S
//                                       .of(context)
//                                       .nItems(currentCategory.totalProduct!),
//                                   style: TextStyle(
//                                     color: Theme.of(context).primaryColor,
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                               ),
//                       ],
//                     ),
//                   ),
//                 )
//               : ExpansionTile(
//                   title: Padding(
//                     padding: const EdgeInsets.only(left: 0.0, top: 0),
//                     child: Text(
//                       currentCategory.name!.toUpperCase(),
//                       style: textStyle?.copyWith(fontSize: 14) ??
//                           const TextStyle(fontSize: 14),
//                     ),
//                   ),
//                   textColor: Theme.of(context).primaryColor,
//                   iconColor: Theme.of(context).primaryColor,
//                   children:
//                       getChildren(categories, currentCategory, childCategories)
//                           as List<Widget>,
//                 ),
//         ));
//       }
//     }

//     return ExpansionTile(
//       initiallyExpanded: true,
//       expandedCrossAxisAlignment: CrossAxisAlignment.start,
//       tilePadding: const EdgeInsets.only(left: 16, right: 8),
//       title: Text(
//         S.of(context).byCategory.toUpperCase(),
//         style: TextStyle(
//           fontSize: 14,
//           fontWeight: FontWeight.w600,
//           color: textStyle?.color ??
//               Theme.of(context).colorScheme.secondary.withOpacity(0.5),
//         ),
//       ),
//       children: widgets,
//     );
//   }

//   List getChildren(
//     List<Category> categories,
//     Category currentCategory,
//     List<Category> childCategories, {
//     double paddingOffset = 0.0,
//   }) {
//     var list = <Widget>[];

//     list.add(
//       ListTile(
//         leading: Padding(
//           padding: EdgeInsets.only(left: 20 + paddingOffset),
//           child: Text(S.of(context).seeAll),
//         ),
//         trailing: Text(
//           S.of(context).nItems(currentCategory.totalProduct!),
//           style: TextStyle(
//             color: Theme.of(context).primaryColor,
//             fontSize: 12,
//           ),
//         ),
//         onTap: () => navigateToBackDrop(currentCategory),
//       ),
//     );
//     for (var i in childCategories) {
//       var newChildren = categories.where((cat) => cat.parent == i.id).toList();
//       if (newChildren.isNotEmpty) {
//         list.add(
//           ExpansionTile(
//             title: Padding(
//               padding: EdgeInsets.only(left: 20.0 + paddingOffset),
//               child: Text(
//                 i.name!.toUpperCase(),
//                 style: const TextStyle(fontSize: 14),
//               ),
//             ),
//             children: getChildren(
//               categories,
//               i,
//               newChildren,
//               paddingOffset: paddingOffset + 10,
//             ) as List<Widget>,
//           ),
//         );
//       } else {
//         list.add(
//           ListTile(
//             title: Padding(
//               padding: EdgeInsets.only(left: 20 + paddingOffset),
//               child: Text(i.name!),
//             ),
//             trailing: Text(
//               S.of(context).nItems(i.totalProduct!),
//               style: TextStyle(
//                 color: Theme.of(context).primaryColor,
//                 fontSize: 12,
//               ),
//             ),
//             onTap: () => navigateToBackDrop(i),
//           ),
//         );
//       }
//     }
//     return list;
//   }

//   void navigateToBackDrop(Category category) {
//     FluxNavigate.pushNamed(
//       RouteList.backdrop,
//       arguments: BackDropArguments(
//         cateId: category.id,
//         cateName: category.name,
//       ),
//     );
//   }
// }

// class PrivacyScreen3 extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     var isDarkTheme = Provider.of<AppModel>(context, listen: false).darkTheme;

//     return Scaffold(
//       //backgroundColor:Colors.white,
//       backgroundColor:Theme.of(context).backgroundColor,
//           appBar: AppBar(
//          //backgroundColor:Colors.white,//const Color(0xffffbf00),
//            backgroundColor:Theme.of(context).backgroundColor,
//   shape: Border(
//     bottom: BorderSide(
//       color:const Color(0xffffbf00), //Colors.orange,const Color(0xff05dae5)
//       width: 1,
//     ),
//   ),
//   elevation: 3,
//    centerTitle: true,
//          // systemOverlayStyle: SystemUiOverlayStyle.light,
//         //  backgroundColor: Theme.of(context).primaryColorLight,
//           title:  Text("عن التطبيق",

//             style: Theme.of(context)
//                                     .textTheme
//                                     .subtitle1!
//                                     .copyWith(
//                                       fontWeight: FontWeight.w600,
//                                       color:Theme.of(context).colorScheme.secondary,// Colors.black,
//                                       fontSize: 17,
//                                     )
//             // style: TextStyle(
//             //   color:Colors.white, //Theme.of(context).colorScheme.secondary,
//             // ),
//           ),
//           leading: GestureDetector(
//             onTap: () {
//               Navigator.pop(context);
//             },
//             child: Icon(
//               Icons.arrow_back_ios,
//               color: Theme.of(context).colorScheme.secondary,
//             ),
//           ),
//         ),
// //       appBar: AppBar(
// //        // systemOverlayStyle: SystemUiOverlayStyle.light,
// //         title: Text("الأحكام والشروط"
// // "          S.of(context).agreeWithPrivacy",         style: const TextStyle(
// //             fontSize: 14.0,
// //             color: Colors.white,
// //           ),
// //         ),
// //         centerTitle:true,
// //         leading: GestureDetector(
// //           onTap: () => Navigator.pop(context),
// //           child: const Icon(
// //             Icons.arrow_back_ios,
// //             color: Colors.white,
// //           ),
// //         ),
// //       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Text('''
// خدماتي عبارة عن تطبيق خاص لشركة الموج يتيح لزبائن امكانية شراء اجهزة Gps الخاص لشركة عن طريق تطبيق بكل سهولة في جميع انحاء العالم.
//           ''',
//             //S.of(context).privacyTerms,
//             style: Theme.of(context)
//                                     .textTheme
//                                     .subtitle1!
//                                     .copyWith(
//                                       fontWeight: FontWeight.w600,
//                                       color:Theme.of(context).colorScheme.secondary,// Colors.black,
//                                       fontSize: 17,
//                                     )
//             //const TextStyle(fontSize: 16.0, height: 1.4 ,color: isDarkTheme ? Colors.blue : Colors.black),//Theme.of(context).colorScheme.secondary,),
//            // textAlign: TextAlign.right,
//           ),
//         ),
//       ),
//     );
//   }
// }

// class PrivacyScreen4 extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
    
//     return Scaffold(
//        backgroundColor:Theme.of(context).backgroundColor,
//      // backgroundColor:Colors.white,
//           appBar: AppBar(
//            backgroundColor:Theme.of(context).backgroundColor,
//          //backgroundColor:Colors.white,//const Color(0xffffbf00),
//   shape: Border(
//     bottom: BorderSide(
//       color:const Color(0xffffbf00), //Colors.orange,const Color(0xff05dae5)
//       width: 1,
//     ),
//   ),
//   elevation: 3,
//    centerTitle: true,
//          // systemOverlayStyle: SystemUiOverlayStyle.light,
//         //  backgroundColor: Theme.of(context).primaryColorLight,
//           title:  Text("الأحكام والشروط",

//             style: Theme.of(context)
//                                     .textTheme
//                                     .subtitle1!
//                                     .copyWith(
//                                       fontWeight: FontWeight.w600,
//                                       color: Theme.of(context).colorScheme.secondary,
//                                       fontSize: 17,
//                                     )
//             // style: TextStyle(
//             //   color:Colors.white, //Theme.of(context).colorScheme.secondary,
//             // ),
//           ),
//        leading: GestureDetector(
//             onTap: () {
//               Navigator.pop(context);
//             },
//             child: Icon(
//               Icons.arrow_back_ios,
//               color: Theme.of(context).colorScheme.secondary,
//             ),
//           ),
//         ),
// //       appBar: AppBar(
// //        // systemOverlayStyle: SystemUiOverlayStyle.light,
// //         title: Text("الأحكام والشروط"
// // "          S.of(context).agreeWithPrivacy",         style: const TextStyle(
// //             fontSize: 14.0,
// //             color: Colors.white,
// //           ),
// //         ),
// //         centerTitle:true,
// //         leading: GestureDetector(
// //           onTap: () => Navigator.pop(context),
// //           child: const Icon(
// //             Icons.arrow_back_ios,
// //             color: Colors.white,
// //           ),
// //         ),
// //       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Text('''عقد الإشتراك
// أقر وأوافق على جميع الشروط والأحكام المدونة في أدناه وإني ملزم بها تجاه مكتب الموج للإستشارات الهندسية المتخصصة بتجهيز ونصب منظومة(GPS)ومراقبة حركة المركبات الثقيلة والخفيفة 

// الشروط والأحكام :

// مع إلتزام المكتب ببنود ضوابط إستخدام وتداول أجهزة ومنظومات تحديد وتتبع الموقع الجغرافي الصادرة من هيئة الإعلام والإتصالات فإن المكتب غير مسؤول أو ملزم بشكل مباشر أو غير مباشر عن أي مشكلة أو تأخير أو توقف أو تقطع أو تغطية يمكن أن تحصل في أي وقت للشبكة ومهما كان نوع الخدمة وليس مسؤولاً عن أي أضرار أو خسائر تلحق بالمشترك وكذلك ليس مسؤولا ً عن نتيجة سوء إستخدام المشترك للجهاز .

// المكتب غير مسؤول عن أي عطل أو خسارة أو خلل أو ضرر ينتج في ظروف خارجة عن الإرادة كالزلازل والفيضانات والحرائق وأعمال الشغب والحروب والحصار والظروف الأمنية القاهرة والأعمال الإرهابية .

// يحتفظ المكتب بإلغاء الإشتراك وكافة الخدمات وإيقاف عمل الجهاز في حالة عدم قيام المشترك بتسديد قيمة الإشتراك بعد أن يتم الإتصال به هاتفيا ً وإخباره برغبته أو عدمها .

// للمكتب حق إيقاف عمل الجهاز في حالة إستعمال المشترك للجهاز بطريقة مخالفة للقوانين والتعليمات 

// على المشترك الإلتزام بعدم إستعمال الجهاز في تحديد وتتبع الموقع الجغرافي للتجسس أو للتشويش والتداخل .

// في حالة ضياع الجهاز أو سرقته أو سرقة المركبة أو توقف عمل الجهاز يجب إخبار المكتب فوراً بذلك خلال مدة  أقصاها 24 ساعة .

// على المشترك تقديم كافة المستمسكات الشخصية به مع مستمسكات المركبة وفي حالة كون المركبة حكومية أو تابعة لشركة رسمية     أو غير رسمية فعليه إبراز تخويل بقيادة المركبة وكذلك كتاب عدم ممانعة من ربط الجهاز وعليه إبلاغ المكتب في حالة بيعه للمركبة وإحضار المشتري الجديد الى المكتب للتعاقد معه وتقديم مستمسكاته الخاصة به  .

// عند إشتراك الزبون فللمكتب تزويده بالبرنامج الخاص بالتعقب وكذلك الباسوورد واليوزرنيم .

// المكتب غير مسؤول عن إعادة أية مبالغ للزبون في حالة عدم ربطه للجهاز أو أي سبب كان .

// المكتب حريص على الحفاظ على سرية البيانات والمعلومات الخاصة بالتتبع والتعقب وكافة معلومات المشترك وأنه غير مسؤول عن سرقة المركبة ولا تعويض المشترك عن ذلك وأن مسؤولية التتبع والتعقب هي مسؤولية المشترك وفقا ً للبرنامج ( التطبيق ) المعطاة له والمثبت على جهاز موبايل أو حاسوب المشترك .

// عند شراء الزبون للجهاز فإن أجور الإشتراك تحسب عليه من تأريخ شرائه للجهاز وتوقيع العقد وليس من تأريخ ربطه بالمركبة .

// في حالة الإشتراك السنوي إذا لم يقوم المشترك بتجديد الإشتراك خلال مدة شهر واحد من إنتهاء مدته فيصبح قيمة الإشتراك السنوي 100 ألف دينار للسنة القادمة ويحسب عليه ولا يشترط موافقته على ذلك .

// في حالة الإشتراك الشهري إذا رغب المشترك بإعادة الجهاز إلى المكتب فيكون ملزما ً بدفع كافة مبالغ الإشتراك المتراكمة بذمته وتكون الإعادة في يوم 27 أو 28 من كل شهر وإلا سوف يتم حساب إشتراك للشهر القادم  .

// إن المكتب مسؤول عن تصليح وتبديل الجهاز في حالة عطله دون تدخل يد بشرية عمدا لكن المكتب غير مسوؤل في حالة التلف العمد وعليه يتحمل التكاليف المترتبة على الجهاز او ملحقاته  .

// في حالة عدم رغبة المشترك بالتجديد فعليه تسليم الجهاز للمكتب حصراً بعد إعطائه وصل إستلام بذلك .

// في حالة قيام المشترك بالعبث بالجهاز من تلقاء نفسه ودون مراجعة الكهربائي المخول من قبل المكتب أو قيامه بتحويله إلى مركبة أخرى دون علم المكتب فإن المكتب غير مسؤول عن كل ما يحصل بالجهاز والمركبة ولا يحق له مطالبة المكتب بأي شيء كان . 

// إن المكتب يكون مسؤولاً عن تشغيل السيم كارت ( M2M  ) الموجود في الجهاز ولكنه غير مسؤول عن ضياع الجهاز أو السيم كارت أو مفردات وملحقات الجهاز من قبل المشترك فإنه يتحمل مسؤولية وتكاليف ذلك .

// يتحمل المشترك كافة المسؤولية القانونية عن كافة الأوراق والمستمسكات المقدمة من قبله إلى المكتب في حالة عدم صحتها  أو ظهر بأنها مزورة.

// في حالة حصول نزاع تكون محاكم كركوك هي المختصة بنظر هذا النزاع . 



         
//           ''',
//             //S.of(context).privacyTerms,
//             style: Theme.of(context)
//                                     .textTheme
//                                     .subtitle1!
//                                     .copyWith(
//                                       fontWeight: FontWeight.w600,
//                                       color:Theme.of(context).colorScheme.secondary,// Colors.black,
//                                       fontSize: 17,
//                                     ),//const TextStyle(fontSize: 16.0, height: 1.4),
//             textAlign: TextAlign.right,
//           ),
//         ),
//       ),
//     );
//   }
// }

// class PrivacyScreen5 extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor:Colors.white,
//           appBar: AppBar(
//          backgroundColor:Colors.white,//const Color(0xffffbf00),
//   shape: Border(
//     bottom: BorderSide(
//       color:const Color(0xffffbf00), //Colors.orange,const Color(0xff05dae5)
//       width: 1,
//     ),
//   ),
//   elevation: 3,
//    centerTitle: true,
//          // systemOverlayStyle: SystemUiOverlayStyle.light,
//         //  backgroundColor: Theme.of(context).primaryColorLight,
//           title:  Text("سياسة الخصوصية",

//             style: Theme.of(context)
//                                     .textTheme
//                                     .subtitle1!
//                                     .copyWith(
//                                       fontWeight: FontWeight.w600,
//                                       color: Colors.black,
//                                       fontSize: 17,
//                                     )
//             // style: TextStyle(
//             //   color:Colors.white, //Theme.of(context).colorScheme.secondary,
//             // ),
//           ),
//           leading: GestureDetector(
//             onTap: () {
//               Navigator.pop(context);
//             },
//             child: Icon(
//               Icons.arrow_back_ios,
//               color: Colors.black,//Theme.of(context).colorScheme.secondary,
//             ),
//           ),
//         ),
// //       appBar: AppBar(
// //        // systemOverlayStyle: SystemUiOverlayStyle.light,
// //         title: Text("الأحكام والشروط"
// // "          S.of(context).agreeWithPrivacy",         style: const TextStyle(
// //             fontSize: 14.0,
// //             color: Colors.white,
// //           ),
// //         ),
// //         centerTitle:true,
// //         leading: GestureDetector(
// //           onTap: () => Navigator.pop(context),
// //           child: const Icon(
// //             Icons.arrow_back_ios,
// //             color: Colors.white,
// //           ),
// //         ),
// //       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Text(''' ''',
//             //S.of(context).privacyTerms,
//             style: const TextStyle(fontSize: 16.0, height: 1.4),
//             textAlign: TextAlign.right,
//           ),
//         ),
//       ),
//     );
//   }
// }



///new one
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../common/config.dart';
// import '../common/config/models/index.dart';
// import '../common/constants.dart';
// import '../common/tools.dart';
// import '../generated/l10n.dart';
// import '../models/index.dart'
//     show AppModel, BackDropArguments, Category, CategoryModel, UserModel;
// import '../modules/dynamic_layout/config/app_config.dart';
// import '../modules/dynamic_layout/helper/helper.dart';
// import '../routes/flux_navigate.dart';
// import '../services/index.dart';
// import '../widgets/common/index.dart' show FluxImage, WebView;
// import '../widgets/general/index.dart';
// import 'maintab_delegate.dart';

// class SideBarMenu extends StatefulWidget {
//   const SideBarMenu();

//   @override
//   MenuBarState createState() => MenuBarState();
// }

// class MenuBarState extends State<SideBarMenu> {
//   bool get isEcommercePlatform =>
//       !Config().isListingType || !Config().isWordPress;

//   DrawerMenuConfig get drawer =>
//       Provider.of<AppModel>(context, listen: false).appConfig?.drawer ??
//       kDefaultDrawer;

//   void pushNavigation(String name) {
//     eventBus.fire(const EventCloseNativeDrawer());
//     MainTabControlDelegate.getInstance().changeTab(name.replaceFirst('/', ''));
//   }

//   @override
//   Widget build(BuildContext context) {
//     printLog('[AppState] Load Menu');

//     return SafeArea(
//       top: drawer.safeArea,
//       right: false,
//       bottom: false,
//       left: false,
//       child: Padding(
//         key: drawer.key != null ? Key(drawer.key as String) : UniqueKey(),
//         padding: EdgeInsets.only(
//             bottom:
//                 injector<AudioManager>().isStickyAudioWidgetActive ? 46 : 0),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               if (drawer.logo != null) ...[
//                 Container(
//                   color: drawer.logoConfig.backgroundColor != null
//                       ? HexColor(drawer.logoConfig.backgroundColor)
//                       : null,
//                   padding: EdgeInsets.only(
//                     bottom: drawer.logoConfig.marginBottom.toDouble(),
//                     top: drawer.logoConfig.marginTop.toDouble(),
//                     left: drawer.logoConfig.marginLeft.toDouble(),
//                     right: drawer.logoConfig.marginRight.toDouble(),
//                   ),
//                   child: FluxImage(
//                     width: drawer.logoConfig.useMaxWidth
//                         ? MediaQuery.of(context).size.width
//                         : drawer.logoConfig.width?.toDouble(),
//                     fit: Helper.boxFit(drawer.logoConfig.boxFit),
//                     height: drawer.logoConfig.height.toDouble(),
//                     imageUrl: drawer.logo as String,
//                   ),
//                 ),
//                 const Divider(),
//               ],
//               ...List.generate(
//                 drawer.items?.length ?? 0,
//                 (index) {
//                   return drawerItem(
//                     drawer.items![index],
//                     drawer.subDrawerItem ?? {},
//                     textColor: drawer.textColor != null
//                         ? HexColor(drawer.textColor)
//                         : null,
//                     iconColor: drawer.iconColor != null
//                         ? HexColor(drawer.iconColor)
//                         : null,
//                   );
//                 },
//               ),
//               isDisplayDesktop(context)
//                   ? const SizedBox(height: 300)
//                   : const SizedBox(height: 24),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget drawerItem(
//     DrawerItemsConfig drawerItemConfig,
//     Map<String, GeneralSettingItem> subDrawerItem, {
//     Color? iconColor,
//     Color? textColor,
//   }) {
//     // final isTablet = Tools.isTablet(MediaQuery.of(context));

//     if (drawerItemConfig.show == false) return const SizedBox();
//     var value = drawerItemConfig.type;
//     var textStyle = TextStyle(
//       color: textColor ?? Theme.of(context).textTheme.bodyText1?.color,
//     );

//     switch (value) {
//       case 'home':
//         {
//           return ListTile(
//             leading: Icon(
//               isEcommercePlatform ? Icons.home : Icons.shopping_basket,
//               size: 20,
//               color: iconColor,
//             ),
//             title: Text(
//               isEcommercePlatform ? S.of(context).home : S.of(context).shop,
//               style: textStyle,
//             ),
//             onTap: () {
//               pushNavigation(RouteList.home);
//             },
//           );
//         }
//       case 'categories':
//         {
//           return ListTile(
//             leading: Icon(
//               Icons.category,
//               size: 20,
//               color: iconColor,
//             ),
//             title: Text(
//               S.of(context).categories,
//               style: textStyle,
//             ),
//             onTap: () => pushNavigation(
//               Provider.of<AppModel>(context, listen: false).vendorType ==
//                       VendorType.single
//                   ? RouteList.category
//                   : RouteList.vendorCategory,
//             ),
//           );
//         }
//       case 'cart':
//         {
//           if (Config().isListingType) {
//             return Container();
//           }
//           return ListTile(
//             leading: Icon(
//               Icons.shopping_cart,
//               size: 20,
//               color: iconColor,
//             ),
//             title: Text(
//               S.of(context).cart,
//               style: textStyle,
//             ),
//             onTap: () => pushNavigation(RouteList.cart),
//           );
//         }
//       case 'profile':
//         {
//           return ListTile(
//             leading: Icon(
//               Icons.person,
//               size: 20,
//               color: iconColor,
//             ),
//             title: Text(
//               S.of(context).settings,
//               style: textStyle,
//             ),
//             onTap: () => pushNavigation(RouteList.profile),
//           );
//         }
//       case 'web':
//         {
//           return ListTile(
//             leading: Icon(
//               Icons.web,
//               size: 20,
//               color: iconColor,
//             ),
//             title: Text(
//               S.of(context).webView,
//               style: textStyle,
//             ),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => WebView(
//                     url: 'https://inspireui.com',
//                     title: S.of(context).webView,
//                   ),
//                 ),
//               );
//             },
//           );
//         }
//       case 'blog':
//         {
//           return ListTile(
//             leading: Icon(
//               CupertinoIcons.news_solid,
//               size: 20,
//               color: iconColor,
//             ),
//             title: Text(
//               S.of(context).blog,
//               style: textStyle,
//             ),
//             onTap: () => pushNavigation(RouteList.listBlog),
//           );
//         }
//       case 'login':
//         {
//           return ListenableProvider.value(
//             value: Provider.of<UserModel>(context, listen: false),
//             child: Consumer<UserModel>(builder: (context, userModel, _) {
//               final loggedIn = userModel.loggedIn;
//               return ListTile(
//                 leading: Icon(Icons.exit_to_app, size: 20, color: iconColor),
//                 title: loggedIn
//                     ? Text(S.of(context).logout, style: textStyle)
//                     : Text(S.of(context).login, style: textStyle),
//                 onTap: () {
//                   if (loggedIn) {
//                     Provider.of<UserModel>(context, listen: false).logout();
//                     if (Services().widget.isRequiredLogin) {
//                       Navigator.of(context).pushNamedAndRemoveUntil(
//                         RouteList.login,
//                         (route) => false,
//                       );
//                     }
//                     // else {
//                     //   pushNavigation(RouteList.dashboard);
//                     // }
//                   } else {
//                     pushNavigation(RouteList.login);
//                   }
//                 },
//               );
//             }),
//           );
//         }
//       case 'category':
//         {
//           return buildListCategory(textStyle: textStyle);
//         }
//       default:
//         {
//           var item = subDrawerItem[value];
//           if (value?.contains('web') ?? false) {
//             return GeneralWebWidget(
//               item: item,
//               useTile: true,
//               iconColor: iconColor,
//               textStyle: textStyle,
//             );
//           }
//           if (value?.contains('post') ?? false) {
//             return GeneralPostWidget(
//               item: item,
//               useTile: true,
//               iconColor: iconColor,
//               textStyle: textStyle,
//             );
//           }
//           if (value?.contains('title') ?? false) {
//             return GeneralTitleWidget(item: item);
//           }
//           if (value?.contains('button') ?? false) {
//             return GeneralButtonWidget(item: item);
//           }
//         }

//         return const SizedBox();
//     }
//   }

//   Widget buildListCategory({TextStyle? textStyle}) {
//     final categories = Provider.of<CategoryModel>(context).categories;
//     var widgets = <Widget>[];

//     if (categories != null) {
//       var list = categories.where((item) => item.parent == '0').toList();
//       for (var i = 0; i < list.length; i++) {
//         final currentCategory = list[i];
//         var childCategories =
//             categories.where((o) => o.parent == currentCategory.id).toList();
//         widgets.add(Container(
//           color: i.isOdd
//               ? null
//               : Theme.of(context).colorScheme.secondary.withOpacity(0.1),

//           /// Check to add only parent link category
//           child: childCategories.isEmpty
//               ? InkWell(
//                   onTap: () => navigateToBackDrop(currentCategory),
//                   child: Padding(
//                     padding: const EdgeInsets.only(
//                       right: 20,
//                       bottom: 12,
//                       left: 16,
//                       top: 12,
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                             child: Text(
//                           currentCategory.name!.toUpperCase(),
//                           style: textStyle,
//                         )),
//                         const SizedBox(width: 24),
//                         currentCategory.totalProduct == null
//                             ? const Icon(Icons.chevron_right)
//                             : Padding(
//                                 padding:
//                                     const EdgeInsets.symmetric(vertical: 10),
//                                 child: Text(
//                                   S
//                                       .of(context)
//                                       .nItems(currentCategory.totalProduct!),
//                                   style: TextStyle(
//                                     color: Theme.of(context).primaryColor,
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                               ),
//                       ],
//                     ),
//                   ),
//                 )
//               : ExpansionTile(
//                   title: Padding(
//                     padding: const EdgeInsets.only(left: 0.0, top: 0),
//                     child: Text(
//                       currentCategory.name!.toUpperCase(),
//                       style: textStyle?.copyWith(fontSize: 14) ??
//                           const TextStyle(fontSize: 14),
//                     ),
//                   ),
//                   textColor: Theme.of(context).primaryColor,
//                   iconColor: Theme.of(context).primaryColor,
//                   children:
//                       getChildren(categories, currentCategory, childCategories)
//                           as List<Widget>,
//                 ),
//         ));
//       }
//     }

//     return ExpansionTile(
//       initiallyExpanded: true,
//       expandedCrossAxisAlignment: CrossAxisAlignment.start,
//       tilePadding: const EdgeInsets.only(left: 16, right: 8),
//       title: Text(
//         S.of(context).byCategory.toUpperCase(),
//         style: TextStyle(
//           fontSize: 14,
//           fontWeight: FontWeight.w600,
//           color: textStyle?.color ??
//               Theme.of(context).colorScheme.secondary.withOpacity(0.5),
//         ),
//       ),
//       children: widgets,
//     );
//   }

//   List getChildren(
//     List<Category> categories,
//     Category currentCategory,
//     List<Category> childCategories, {
//     double paddingOffset = 0.0,
//   }) {
//     var list = <Widget>[];
//     final totalProduct = currentCategory.totalProduct;
//     list.add(
//       ListTile(
//         leading: Padding(
//           padding: EdgeInsets.only(left: 20 + paddingOffset),
//           child: Text(S.of(context).seeAll),
//         ),
//         trailing: ((totalProduct != null && totalProduct > 0))
//             ? Text(
//                 S.of(context).nItems(totalProduct),
//                 style: TextStyle(
//                   color: Theme.of(context).primaryColor,
//                   fontSize: 12,
//                 ),
//               )
//             : null,
//         onTap: () => navigateToBackDrop(currentCategory),
//       ),
//     );
//     for (var i in childCategories) {
//       var newChildren = categories.where((cat) => cat.parent == i.id).toList();
//       if (newChildren.isNotEmpty) {
//         list.add(
//           ExpansionTile(
//             title: Padding(
//               padding: EdgeInsets.only(left: 20.0 + paddingOffset),
//               child: Text(
//                 i.name!.toUpperCase(),
//                 style: const TextStyle(fontSize: 14),
//               ),
//             ),
//             children: getChildren(
//               categories,
//               i,
//               newChildren,
//               paddingOffset: paddingOffset + 10,
//             ) as List<Widget>,
//           ),
//         );
//       } else {
//         final totalProduct = i.totalProduct;
//         list.add(
//           ListTile(
//             title: Padding(
//               padding: EdgeInsets.only(left: 20 + paddingOffset),
//               child: Text(i.name!),
//             ),
//             trailing: (totalProduct != null && totalProduct > 0)
//                 ? Text(
//                     S.of(context).nItems(i.totalProduct!),
//                     style: TextStyle(
//                       color: Theme.of(context).primaryColor,
//                       fontSize: 12,
//                     ),
//                   )
//                 : null,
//             onTap: () => navigateToBackDrop(i),
//           ),
//         );
//       }
//     }
//     return list;
//   }

//   void navigateToBackDrop(Category category) {
//     FluxNavigate.pushNamed(
//       RouteList.backdrop,
//       arguments: BackDropArguments(
//         cateId: category.id,
//         cateName: category.name,
//       ),
//     );
//   }
// }
