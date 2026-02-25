# API Integration

[Back to Architecture Index](../index.md)

---

## Service Template

### Azure STT Repository Implementation

```dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Domain layer - abstract interface
abstract class SttRepository {
  Future<String> transcribeAudio(Uint8List audioData);
}

// Data layer - Azure implementation
class AzureSttRepositoryImpl implements SttRepository {
  AzureSttRepositoryImpl(this._dio, this._apiKey, this._region);

  final Dio _dio;
  final String _apiKey;
  final String _region;

  @override
  Future<String> transcribeAudio(Uint8List audioData) async {
    try {
      final response = await _dio.post(
        'https://$_region.stt.speech.microsoft.com/speech/recognition/conversation/cognitiveservices/v1',
        data: audioData,
        queryParameters: {
          'language': 'ar-SA', // Arabic (Saudi Arabia)
          'format': 'simple',
        },
        options: Options(
          headers: {
            'Ocp-Apim-Subscription-Key': _apiKey,
            'Content-Type': 'audio/wav',
          },
          receiveTimeout: const Duration(seconds: 10),
          sendTimeout: const Duration(seconds: 10),
        ),
      );

      final transcription = response.data['DisplayText'] as String?;
      if (transcription == null || transcription.isEmpty) {
        throw SttException(
          message: 'Empty transcription returned',
          type: SttErrorType.emptyResponse,
        );
      }

      return transcription;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw SttException(
        message: 'Unexpected error: $e',
        type: SttErrorType.unknown,
      );
    }
  }

  SttException _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return SttException(
          message: 'Request timeout - check your internet connection',
          type: SttErrorType.timeout,
        );
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 401 || statusCode == 403) {
          return SttException(
            message: 'Authentication failed',
            type: SttErrorType.authenticationFailed,
          );
        }
        return SttException(
          message: 'Server error: ${e.response?.statusCode}',
          type: SttErrorType.serverError,
        );
      case DioExceptionType.cancel:
        return SttException(
          message: 'Request cancelled',
          type: SttErrorType.cancelled,
        );
      default:
        return SttException(
          message: 'Network error: ${e.message}',
          type: SttErrorType.networkError,
        );
    }
  }
}

// Custom exception with typed errors
class SttException implements Exception {
  SttException({required this.message, required this.type});

  final String message;
  final SttErrorType type;

  @override
  String toString() => 'SttException: $message (type: $type)';
}

enum SttErrorType {
  timeout,
  networkError,
  authenticationFailed,
  serverError,
  emptyResponse,
  cancelled,
  unknown,
}

// Provider declaration
final sttRepositoryProvider = Provider<SttRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final apiKey = ref.watch(azureApiKeyProvider);
  final region = ref.watch(azureRegionProvider);

  return AzureSttRepositoryImpl(dio, apiKey, region);
});
```

---

## API Client Configuration

### Dio Setup with Interceptors

```dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
    ),
  );

  // Logging interceptor (only in debug mode)
  if (kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(
        requestBody: false, // Don't log audio data (too large)
        responseBody: true,
        error: true,
        logPrint: (log) => debugPrint('[Dio] $log'),
      ),
    );
  }

  // Error handling interceptor
  dio.interceptors.add(
    InterceptorsWrapper(
      onError: (error, handler) async {
        // Log error to analytics
        final analytics = ref.read(analyticsServiceProvider);
        await analytics.logError(
          error: error.error,
          stackTrace: error.stackTrace,
          context: {
            'endpoint': error.requestOptions.uri.toString(),
            'statusCode': error.response?.statusCode,
          },
        );

        handler.next(error);
      },
    ),
  );

  // Retry interceptor for transient failures
  dio.interceptors.add(
    RetryInterceptor(
      dio: dio,
      retries: 2,
      retryDelays: const [
        Duration(seconds: 1),
        Duration(seconds: 2),
      ],
    ),
  );

  return dio;
});

// Custom retry interceptor
class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    required this.dio,
    required this.retries,
    required this.retryDelays,
  });

  final Dio dio;
  final int retries;
  final List<Duration> retryDelays;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final shouldRetry = err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        (err.response?.statusCode != null && err.response!.statusCode! >= 500);

    if (!shouldRetry) {
      return handler.next(err);
    }

    var retryCount = err.requestOptions.extra['retryCount'] as int? ?? 0;

    if (retryCount >= retries) {
      return handler.next(err);
    }

    retryCount++;
    err.requestOptions.extra['retryCount'] = retryCount;

    final delay = retryDelays[retryCount - 1];
    await Future.delayed(delay);

    try {
      final response = await dio.fetch(err.requestOptions);
      return handler.resolve(response);
    } on DioException catch (e) {
      return handler.next(e);
    }
  }
}
```

---

## Environment Configuration

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Load environment variables from .env files
Future<void> loadEnvironment() async {
  await dotenv.load(
    fileName: kReleaseMode ? '.env.production' : '.env.development',
  );
}

// Providers for environment variables
final azureApiKeyProvider = Provider<String>((ref) {
  return dotenv.env['AZURE_STT_API_KEY'] ?? '';
});

final azureRegionProvider = Provider<String>((ref) {
  return dotenv.env['GOOGLE_CLOUD_STT_REGION'] ?? 'eastus';
});

final firebaseApiKeyProvider = Provider<String>((ref) {
  return dotenv.env['FIREBASE_API_KEY'] ?? '';
});
```

### .env.development

```bash
# Google Cloud Speech-to-Text (Updated: Feb 2026)
GOOGLE_CLOUD_STT_API_KEY=your_development_api_key_here
GOOGLE_CLOUD_STT_REGION=eastus

# Firebase
FIREBASE_API_KEY=your_firebase_api_key_here

# Stripe
STRIPE_PUBLISHABLE_KEY=pk_test_your_test_key_here
```

### .env.production

```bash
# Google Cloud Speech-to-Text (Updated: Feb 2026)
GOOGLE_CLOUD_STT_API_KEY=your_production_api_key_here
GOOGLE_CLOUD_STT_REGION=eastus

# Firebase
FIREBASE_API_KEY=your_firebase_prod_api_key_here

# Stripe
STRIPE_PUBLISHABLE_KEY=pk_live_your_live_key_here
```

### .env.example (commit this to git)

```bash
# Google Cloud Speech-to-Text (Updated: Feb 2026)
GOOGLE_CLOUD_STT_API_KEY=your_api_key_here
GOOGLE_CLOUD_STT_REGION=eastus

# Firebase
FIREBASE_API_KEY=your_firebase_api_key
FIREBASE_PROJECT_ID=lawh-project-id

# Stripe
STRIPE_PUBLISHABLE_KEY=pk_test_or_pk_live_key_here

# App Configuration
APP_ENV=development
API_TIMEOUT_SECONDS=10
ENABLE_DEBUG_LOGGING=true
```

### Loading Environment Variables (main.dart)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(
    fileName: kReleaseMode ? '.env.production' : '.env.development',
  );

  // Initialize Firebase
  // await Firebase.initializeApp();

  runApp(
    const ProviderScope(
      child: LawhApp(),
    ),
  );
}
```

### Accessing Environment Variables

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Access environment variables
final apiKey = dotenv.env['AZURE_STT_API_KEY'] ?? '';
final region = dotenv.env['GOOGLE_CLOUD_STT_REGION'] ?? 'eastus';
final isDebugLoggingEnabled = dotenv.env['ENABLE_DEBUG_LOGGING'] == 'true';
```

---

## Important Notes

- **Never commit .env files to git**: Add to .gitignore
- **Provide .env.example**: Template with dummy values for team
- **Validate on startup**: Fail fast if required variables missing
- **Rotate keys regularly**: Change production keys every 90 days

---

## Key Patterns

- **Repository pattern wraps HTTP client**: Makes Azure STT swappable without changing business logic
- **Custom exceptions with error types**: Type-safe error handling for specific UI responses
- **Retry interceptor**: Automatically retries transient failures (timeouts, 5xx errors)
- **Logging interceptor in debug only**: Enables debugging without leaking sensitive data in production
- **Environment-based configuration**: Separate dev/prod API keys using flutter_dotenv

---

## Related Documentation

- [Tech Stack](./tech-stack.md) - Full technology stack and package versions
- [State Management](./state-management.md) - Riverpod provider patterns
- [Testing](./testing.md) - Mocking API clients in tests
