import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:sinflix/components/components.dart';
import 'package:sinflix/core/utils/secureStorage/secure_storage_exception.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:sinflix/data/data.dart';
import '../view/view.dart';
import 'constants/api_error_types.dart';
import 'constants/route_names.dart';
import 'constants/app_strings.dart';

//Utils
part 'utils/content_extension.dart';

part 'utils/validation_utils.dart';

part 'utils/auth_helper.dart';

part 'utils/secureStorage/secure_storage_service.dart';

//Init
part 'init/localization/app_localization.dart';

part 'init/theme/text_theme.dart';

part 'init/theme/colors.dart';

part 'init/theme/theme.dart';

part 'init/network/api_service.dart';

part 'init/network/api_error.dart';

part 'init/network/api_response.dart';

part 'init/dependency_injection/injection.dart';

part 'init/navigation/app_router.dart';

part 'init/logger/logger_service.dart';

//Base
part 'base/base_view.dart';
