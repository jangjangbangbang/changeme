/// Route names for navigation
class R {
  static const login = 'login';
  static const home = 'home';
  static const search = 'search';
  static const profile = 'profile';
  static const detail = 'detail';
  static const settings = 'settings';
}

/// Route paths for navigation
class P {
  static const login = '/login';
  static const home = '/home';
  static const search = '/search';
  static const profile = '/profile';
  static const detail = 'detail/:postId'; // nested under /home
  static const settings = 'settings'; // nested under /profile
}
