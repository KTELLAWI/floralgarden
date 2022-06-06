import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app.dart';
import '../../common/constants.dart';
import '../../common/tools.dart';
import '../../models/index.dart';
import '../../routes/flux_navigate.dart';
import '../../services/index.dart';
import 'banner/banner_animate_items.dart';
import 'banner/banner_group_items.dart';
import 'banner/banner_slider.dart';
import 'blog/blog_grid.dart';
import 'brand/brand_layout.dart';
import 'button/button.dart';
import 'category/category_icon.dart';
import 'category/category_image.dart';
import 'category/category_menu_with_products.dart';
import 'category/category_text.dart';
import 'config/brand_config.dart';
import 'config/index.dart';
import 'divider/divider.dart';
import 'header/header_search.dart';
import 'header/header_text.dart';
import 'instagram_story/instagram_story.dart';
import 'logo/logo.dart';
import 'product/product_list_simple.dart';
import 'product/product_recent_placeholder.dart';
import 'slider_testimonial/index.dart';
import 'spacer/spacer.dart';
import 'story/index.dart';
import 'testimonial/index.dart';
import 'tiktok/index.dart';
import 'video/index.dart';

class DynamicLayout extends StatelessWidget {
  final config;
  final bool cleanCache;

  const DynamicLayout({this.config, this.cleanCache = false});

  @override
  Widget build(BuildContext context) {
    final appModel = Provider.of<AppModel>(context, listen: true);

    switch (config['layout']) {
      case 'logo':
        final themeConfig = appModel.themeConfig;
        return Logo(
          config: LogoConfig.fromJson(config),
          logo: themeConfig.logo,
          totalCart:
              Provider.of<CartModel>(context, listen: true).totalCartQuantity,
          notificationCount:
              Provider.of<NotificationModel>(context).unreadCount,
          onSearch: () {
            FluxNavigate.pushNamed(RouteList.homeSearch);
          },
          onCheckout: () {
            FluxNavigate.pushNamed(RouteList.cart);
          },
          onTapNotifications: () {
            FluxNavigate.pushNamed(RouteList.notify);
          },
          onTapDrawerMenu: () => NavigateTools.onTapOpenDrawerMenu(context),
        );

      case 'header_text':
        return HeaderText(
          config: HeaderConfig.fromJson(config),
          onSearch: () => Navigator.of(context).pushNamed(RouteList.homeSearch),
        );

      case 'header_search':
        return HeaderSearch(
          config: HeaderConfig.fromJson(config),
          onSearch: () {
            Navigator.of(App.floralgardenNavigatorKey.currentContext!)
                .pushNamed(RouteList.homeSearch);
          },
        );
      case 'featuredVendors':
        return Services().widget.renderFeatureVendor(config);
      case 'category':
        if (config['type'] == 'image') {
          return CategoryImages(
            config: CategoryConfig.fromJson(config),
          );
        }
        return Selector<CategoryModel, Map<String?, Category>>(
          selector: (_, model) => model.categoryList,
          builder: (context, categoryList, child) {
            var configValue = CategoryConfig.fromJson(config);
            var listCategoryName =
                categoryList.map((key, value) => MapEntry(key, value.name));
            void _onShowProductList(CategoryItemConfig item) {
              FluxNavigate.pushNamed(
                RouteList.backdrop,
                arguments: BackDropArguments(
                  config: item.toJson(),
                  data: item.data,
                ),
              );
            }

            if (config['type'] == 'menuWithProducts') {
              return CategoryMenuWithProducts(
                config: configValue,
                listCategoryName: listCategoryName,
                onShowProductList: _onShowProductList,
              );
            }

            if (config['type'] == 'text') {
              return CategoryTexts(
                config: configValue,
                listCategoryName: listCategoryName,
                onShowProductList: _onShowProductList,
              );
            }

            return CategoryIcons(
              config: configValue,
              listCategoryName: listCategoryName,
              onShowProductList: _onShowProductList,
            );
          },
        );
      case 'bannerAnimated':
        if (kIsWeb) return const SizedBox();
        return BannerAnimated(config: BannerConfig.fromJson(config));

      case 'bannerImage':
        if (config['isSlider'] == true) {
          return BannerSlider(
            config: BannerConfig.fromJson(config),
            onTap: (itemConfig) {
              NavigateTools.onTapNavigateOptions(
                context: context,
                config: itemConfig,
              );
            },
          );
        }

        return BannerGroupItems(
          config: BannerConfig.fromJson(config),
          onTap: (itemConfig) {
            NavigateTools.onTapNavigateOptions(
              context: context,
              config: itemConfig,
            );
          },
        );

      case 'blog':
        return BlogGrid(config: BlogConfig.fromJson(config));

      case 'video':
        return VideoLayout(config: config);

      case 'story':
        return StoryWidget(
          config: config,
        );
      case 'recentView':
        if (Config().isBuilder) {
          return ProductRecentPlaceholder();
        }
        return Services().widget.renderHorizontalListItem(config);
      case 'fourColumn':
      case 'threeColumn':
      case 'twoColumn':
      case 'staggered':
      case 'saleOff':
      case 'card':
      case 'listTile':
        return Services()
            .widget
            .renderHorizontalListItem(config, cleanCache: cleanCache);

      /// New product layout style.
      case 'largeCardHorizontalListItems':
      case 'largeCard':
        return Services().widget.renderLargeCardHorizontalListItems(config);
      case 'simpleVerticalListItems':
      case 'simpleList':
        return SimpleVerticalProductList(
          config: ProductConfig.fromJson(config),
        );

      case 'brand':
        return BrandLayout(
          config: BrandConfig.fromJson(config),
        );

      /// FluxNews
      case 'sliderList':
        return Services().widget.renderSliderList(config);
      case 'sliderItem':
        return Services().widget.renderSliderItem(config);

      case 'geoSearch':
        return Services().widget.renderGeoSearch(config);
      case 'divider':
        return DividerLayout(config: DividerConfig.fromJson(config));
      case 'spacer':
        return SpacerLayout(config: SpacerConfig.fromJson(config));
      case 'button':
        return ButtonLayout(config: ButtonConfig.fromJson(config));
      case 'testimonial':
        return TestimonialLayout(config: TestimonialConfig.fromJson(config));
      case 'sliderTestimonial':
        return SliderTestimonial(
          config: SliderTestimonialConfig.fromJson(config),
        );
      case 'instagramStory':
        return InstagramStory(
          config: InstagramStoryConfig.fromJson(config),
        );
      case 'tiktokVideos':
        if (Config().isBuilder || !isMobile) {
          return TikTokVideosPlaceholder();
        }
        return TikTokVideos(
          config: TikTokVideosConfig.fromJson(config),
        );
      default:
        return const SizedBox();
    }
  }
}
