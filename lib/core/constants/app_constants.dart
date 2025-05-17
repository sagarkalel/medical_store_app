class AppConstants {
  // App information
  static const String appName = 'Medical Store';
  static const String appVersion = '1.0.0';

  // Default values
  static const int animationDuration = 300; // milliseconds
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
  static const double defaultElevation = 2.0;

  // Authentication
  static const String adminUsername = 'admin';
  static const String adminPassword = 'admin123';
  static const String userUsername = 'user';
  static const String userPassword = 'user123';

  // Assets paths
  static const String imagePath = 'assets/images/';
  static const String placeholderImage = '${imagePath}placeholder.png';

  // Error messages
  static const String errorInvalidCredentials = 'Invalid username or password';
  static const String errorGeneric = 'Something went wrong. Please try again.';
  static const String errorFieldRequired = 'This field is required';
  static const String errorNotAuthorized =
      'You are not authorized to access this feature';

  // Animations
  // static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration splashDuration = Duration(seconds: 2);

  // Routes
  static const String splashRoute = '/splash';
  static const String loginRoute = '/login';
  static const String userHomeRoute = '/user/home';
  static const String productDetailRoute = '/product/detail';
  static const String adminDashboardRoute = '/admin/dashboard';
  static const String adminProductsRoute = '/admin/products';
  static const String adminAddEditProductRoute = '/admin/product/edit';

  // Product categories
  static const List<String> productCategories = [
    'Pain Relief',
    'Antibiotics',
    'Vitamins & Supplements',
    'Cough & Cold',
    'Skin Care',
    'Diabetes',
    'Blood Pressure',
    'Fever',
    'Digestive Health',
    'Eye Care',
    'Dental Care',
    'First Aid',
    'Baby Care',
    'Women\'s Health',
    'Men\'s Health',
    'Other',
  ];

  // Image placeholders
  static const String placeholderImageUrl = 'assets/images/placeholder.jpg';

  // Error messages
  static const String generalErrorMessage =
      'Something went wrong. Please try again later.';
  static const String networkErrorMessage =
      'Network error. Please check your connection.';
  static const String unauthorizedMessage =
      'You are not authorized to perform this action.';
}

class AppRoutes {
  // Common routes
  static const String splash = '/';
  static const String login = '/login';

  // User routes
  static const String productList = '/products';
  static const String productDetail = '/product-details';

  // Admin routes
  // static const String adminDashboard = '/admin';
  static const String manageProducts = '/admin/products';
  static const String addProduct = '/admin/product/add';
  static const String editProduct = '/admin/product/edit';
}
