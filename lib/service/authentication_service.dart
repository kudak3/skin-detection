import 'package:firebase_auth/firebase_auth.dart';
import 'package:skin_detection/models/api_response.dart';
import 'package:skin_detection/models/user_details.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future currentUser() async {
    final User user = _firebaseAuth.currentUser;

    UserDetails _user = UserDetails.optional(
        uid: user.uid, displayName: user.displayName, email: user.email);

    return _user;
  }

  Future logout() async {
    try {
      return APIResponse<User>(
        error: false,
      );
    } catch (e) {
      return APIResponse<bool>(error: true, errorMessage: e.message);
    }
  }

//signup with email
  Future signUpWithEmail(String email, String password) async {
    try {
      var authResult = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (authResult.user != null) {
        User user = authResult.user;

        return APIResponse<UserDetails>(
          error: false,
          data: UserDetails.optional(
              uid: user.uid, displayName: user.displayName, email: user.email),
        );
      } else {
        return APIResponse<bool>(
            error: true, errorMessage: 'User registration failed');
      }
    } catch (e) {
      return APIResponse<bool>(error: true, errorMessage: e.message);
    }
  }

  //signin with email
  Future signInWithEmail(String email, String password) async {
    try {
      var authResult = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      if (authResult.user != null) {
        return APIResponse<UserDetails>(
          error: false,
          data: UserDetails.optional(
            uid: authResult.user.uid,
            displayName: authResult.user.displayName,
            email: authResult.user.email,
          ),
        );
      } else {
        return APIResponse<bool>(error: true, errorMessage: 'Login failed');
      }
    } catch (e) {
      return APIResponse<bool>(error: true, errorMessage: e.message);
    }
  }
}
