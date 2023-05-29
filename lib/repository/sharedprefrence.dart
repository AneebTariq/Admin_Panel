import 'package:shared_preferences/shared_preferences.dart';
import '../models/usermodel.dart';

class SharedPrefClient {
  static const userId = 'userId';
  static const email = 'email';

  Future<bool> isUserLoggedIn() async {
    final sharedPref = await SharedPreferences.getInstance();
    final userToken = sharedPref.getString(userId);
    return userToken != null;
  }

  Future<UserModel> getUser() async {
    final sharedPref = await SharedPreferences.getInstance();
    final id = sharedPref.getString(userId);
    final mail = sharedPref.getString(email);
    return UserModel(id!, mail!);
  }

  Future<void> setUser(UserModel user) async {
    final sharedPref = await SharedPreferences.getInstance();
    await sharedPref.setString(userId, user.userId);
    await sharedPref.setString(email, user.email);
  }

  Future<void> clearUser() async {
    final sharedPref = await SharedPreferences.getInstance();
    await sharedPref.remove(userId);
  }
}
