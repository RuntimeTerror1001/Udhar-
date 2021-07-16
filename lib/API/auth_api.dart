import 'package:udhar_app/Notifiers/auth_notifier.dart';
import 'package:udhar_app/Models/user.dart' as AUser;
import 'package:firebase_auth/firebase_auth.dart';

login(AUser.User user, AuthNotifier authNotifier) async {
  UserCredential userCredential = await FirebaseAuth.instance
      .signInWithEmailAndPassword(email: user.email, password: user.password)
      // ignore: invalid_return_type_for_catch_error
      .catchError((error) => print(error));

  if (userCredential != null) {
    User? firebaseUser = userCredential.user;

    if (firebaseUser != null) {
      print('Log In : $firebaseUser');
      authNotifier.setUser(firebaseUser);
    }
  }
}

signup(AUser.User user, AuthNotifier authNotifier) async {
  UserCredential userCredential = await FirebaseAuth.instance
      .createUserWithEmailAndPassword(
          email: user.email, password: user.password)
      // ignore: invalid_return_type_for_catch_error
      .catchError((error) => print(error));

  if (userCredential != null) {
    await FirebaseAuth.instance.currentUser!
        .updateDisplayName('displayName:aUser.displayName');
    String displayName =
        FirebaseAuth.instance.currentUser!.displayName.toString();

    User? firebaseUser = userCredential.user;

    if (firebaseUser != null) {
      await firebaseUser.updateDisplayName(displayName);

      await firebaseUser.reload();

      print('Sign up : $firebaseUser');

      User? currentUser = await FirebaseAuth.instance.currentUser;
      authNotifier.setUser(currentUser!);
    }
  }
}

signout(AuthNotifier authNotifier) async {
  await FirebaseAuth.instance
      .signOut()
      .catchError((error) => print(error.code));

  authNotifier.setUser(null);
}

initializeCurrentUser(AuthNotifier authNotifier) async {
  User? firebaseUser = await FirebaseAuth.instance.currentUser;

  if (firebaseUser != null) {
    print(firebaseUser);
    authNotifier.setUser(firebaseUser);
  }
}

resetPass(String email) {
  FirebaseAuth.instance.sendPasswordResetEmail(email: email);
}
