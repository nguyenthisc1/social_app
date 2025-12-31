import 'service_locator.dart' as service_locator;

/// Dependency Injection Container
/// 
/// This class provides a clean interface for dependency injection setup.
/// It wraps the GetIt service locator for easier testing and maintenance.
class InjectionContainer {
  InjectionContainer._();

  static bool _isInitialized = false;

  /// Initialize all dependencies
  /// 
  /// This method should be called once at app startup, before runApp()
  /// 
  /// Example:
  /// ```dart
  /// void main() async {
  ///   WidgetsFlutterBinding.ensureInitialized();
  ///   await InjectionContainer.init();
  ///   runApp(MyApp());
  /// }
  /// ```
  static Future<void> init() async {
    if (_isInitialized) {
      return;
    }

    await service_locator.initializeDependencies();
    _isInitialized = true;
  }

  /// Reset all dependencies
  /// 
  /// Useful for testing or when you need to reinitialize the app
  static Future<void> reset() async {
    await service_locator.resetDependencies();
    _isInitialized = false;
  }

  /// Check if container is initialized
  static bool get isInitialized => _isInitialized;
}

/// Extension to make dependency access more convenient
/// 
/// Usage:
/// ```dart
/// final apiClient = sl<ApiClient>();
/// final themeManager = sl<ThemeManager>();
/// ```
T sl<T extends Object>() => service_locator.sl<T>();

