import 'dart:async';

/// Repository for handling authentication state
class AuthRepository {
  final _ctrl = StreamController<bool>.broadcast();
  bool _isLoggedIn = false;

  /// Stream of authentication state changes
  Stream<bool> authStateChanges() => _ctrl.stream;

  /// Current login status
  bool get isLoggedIn => _isLoggedIn;

  /// Sign in user
  Future<void> signIn() async {
    _isLoggedIn = true;
    _ctrl.add(true);
  }

  /// Sign out user
  Future<void> signOut() async {
    _isLoggedIn = false;
    _ctrl.add(false);
  }

  /// Dispose resources
  void dispose() {
    _ctrl.close();
  }
}
