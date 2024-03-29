import 'package:provider/provider.dart';

import '../../app.dart';
import '../../services/service_config.dart';
import '../app_model.dart';

mixin LanguageMixin {
  String? get langCode => Config().isBuilder
      ? 'en'
      : Provider.of<AppModel>(App.floralgardenNavigatorKey.currentContext!,
              listen: false)
          .langCode;
}
