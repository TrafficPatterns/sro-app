import 'package:shared_preferences/shared_preferences.dart';
import 'package:sro/services/global_functions.dart';
import 'package:sro/services/globals/global_user_variables.dart';

class UserModel {
  String? userID;
  String? roleID;
  String? cityID;
  String? schoolID;
  String? cityName;
  String? role;
  String? email;
  String? token;
  String? phoneNumber;
  String? firstName;
  String? lastName;

  UserModel(
      {this.userID,
      this.token,
      this.phoneNumber,
      this.firstName,
      this.lastName,
      this.email,
      this.cityID,
      this.cityName,
      this.role,
      this.roleID,
      this.schoolID});

  Future<UserModel> get getUserFromSharedPreferences async {
    UserModel user;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString('token') != null &&
        sharedPreferences.getString('token') != '') {
      user = UserModel(
          token: sharedPreferences.getString('token'),
          userID: sharedPreferences.getString('userID'),
          firstName: sharedPreferences.getString('firstName'),
          lastName: sharedPreferences.getString('lastName'),
          email: sharedPreferences.getString('email'),
          phoneNumber: sharedPreferences.getString('phoneNumber'),
          cityID: sharedPreferences.getString('cityID'),
          cityName: sharedPreferences.getString('cityName'),
          role: sharedPreferences.getString('role'),
          roleID: sharedPreferences.getString('roleID'),
          schoolID: sharedPreferences.getString('schoolID'));
    } else {
      user = UserModel();
    }
    return user;
  }

  Future<void> setUser(
      {UserModel? model, dynamic map, bool? isSignUp = false}) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString('userID', map['userID']);
      sharedPreferences.setString('roleID', map['roleID']);
      sharedPreferences.setString('email', map['email']);
      sharedPreferences.setString('firstName', map['firstName']);
      sharedPreferences.setString('lastName', map['lastName']);
      sharedPreferences.setString('phoneNumber', map['phoneNumber'] ?? '');
      sharedPreferences.setString('cityID', map['cityID'] ?? '');
      sharedPreferences.setString('schoolID', map['schoolID'] ?? '');
      sharedPreferences.setString('cityName', map['cityName'] ?? '');
      sharedPreferences.setString('role', map['role']);
      sharedPreferences.setString('token', map['token']);
    } catch (e) {
      showToas(e.toString());
    }
  }

  Future<void> setUserFromEdit({dynamic map}) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString('email', map['email']);
      sharedPreferences.setString('firstName', map['firstName']);
      sharedPreferences.setString('lastName', map['lastName']);
      sharedPreferences.setString('phoneNumber', map['phoneNumber'] ?? '');
      user = await getUserFromSharedPreferences;
    } catch (e) {
      showToas(e.toString());
    }
  }

  String getFullName() {
    return capitilize('$firstName $lastName');
  }

  bool get isStudent {
    if (role == 'student') return true;
    return false;
  }
}
