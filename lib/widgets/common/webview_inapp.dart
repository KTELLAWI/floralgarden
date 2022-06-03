import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart' hide kIsWeb;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:inspireui/widgets/platform_error/platform_error.dart';

import '../../common/config.dart';
import '../../common/constants.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class WebViewInApp extends StatefulWidget {
  final String url;
  final String? title;
  final String? script;
  final Function(String?)? onUrlChanged;
  final Map<String, String>? headers;
  final Function? onClose;
  final bool enableForward;
  final bool enableBackward;

  const WebViewInApp({
    Key? key,
    required this.url,
    this.title,
    this.script,
    this.onUrlChanged,
    this.onClose,
    this.headers,
    this.enableBackward = true,
    this.enableForward = true,
  }) : super(key: key);

  @override
  State<WebViewInApp> createState() => _WebViewInAppState();
}

class _WebViewInAppState extends State<WebViewInApp> {
  final GlobalKey webViewKey = GlobalKey();
  bool isLoaded = false;
  bool isDone = false;
  String addListingUrl = '';
  late var authUrl;
  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));
  late PullToRefreshController pullToRefreshController;

  @override
  void dispose() {
    if (kAdvanceConfig.alwaysClearWebViewCache) {
      webViewController?.clearCache();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(color: Colors.black45),
      onRefresh: () async {
        // var url = webViewController?.getUrl().toString();
        printLog('[WebView InApp] Pull to Refresh');
        if (isAndroid) {
          await webViewController?.reload();
        } else if (isIos) {
          await webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || isDesktop) {
      return const PlatformError(
        enablePop: false,
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          widget.title ?? '',
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(fontWeight: FontWeight.w600),
        ),
        leadingWidth: 150,
        actions: [
          if (widget.onClose != null)
            IconButton(
              onPressed: () async {
                widget.onClose!();
              },
              icon: const Icon(Icons.close, size: 20),
            ),
          const SizedBox(width: 10),
        ],
        leading: Builder(builder: (buildContext) {
          return Row(
            children: [
              const SizedBox(width: 20),
              if (widget.enableBackward)
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 20),
                  onPressed: () async {
                    final value = await webViewController?.canGoBack();
                    if (value == true) {
                      await webViewController?.goBack();
                    } else if (widget.onClose == null &&
                        Navigator.canPop(context)) {
                      Navigator.of(context).pop();
                    }

                    widget.onClose?.call();
                  },
                ),
              if (webViewController?.canGoForward() != null &&
                  widget.enableForward)
                IconButton(
                  onPressed: () => webViewController?.goForward(),
                  icon: const Icon(Icons.arrow_forward_ios, size: 20),
                ),
            ],
          );
        }),
      ),
      body: InAppWebView(
        key: webViewKey,
        initialUrlRequest: URLRequest(
          url: Uri.parse(widget.url),
          headers: widget.headers,
        ),
        initialUserScripts: UnmodifiableListView<UserScript>([
          /// Demo the Javascript Style override
          UserScript(
            source: widget.script ?? '',
            injectionTime: UserScriptInjectionTime.AT_DOCUMENT_END,
          ),
        ]),
        gestureRecognizers: <Factory<VerticalDragGestureRecognizer>>{}..add(
            const Factory<VerticalDragGestureRecognizer>(
                VerticalDragGestureRecognizer.new),
          ),
        initialOptions: options,
        pullToRefreshController: pullToRefreshController,
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
        androidOnPermissionRequest: (controller, origin, resources) async {
          return PermissionRequestResponse(
              resources: resources,
              action: PermissionRequestResponseAction.GRANT);
        },
        onLoadError: (controller, url, code, message) {
          pullToRefreshController.endRefreshing();
        },
        onLoadStop: (_, __) {
          setState(() {});
        },
        onProgressChanged: (_, progress) {
          if (progress == 100) {
            pullToRefreshController.endRefreshing();
          }
        },
        onUpdateVisitedHistory: (_, uri, androidIsReload) {
          if (widget.onUrlChanged != null) {
            widget.onUrlChanged!(uri?.toString());
          }
        },
      ),
    );
  }
}
