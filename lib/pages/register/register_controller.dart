import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sro/models/city_model.dart';
import 'package:sro/models/school_model.dart';
import 'package:sro/pages/loading/loading_overlay.dart';
import 'package:sro/pages/login/login_controller.dart';
import 'package:sro/services/global_functions.dart';
import 'package:sro/services/validation.dart';

import '../../services/remote.dart';

class RegisterController extends GetxController {
  final String title = 'Login Page';
  var passwordController = TextEditingController().obs;
  var emailController = TextEditingController().obs;
  var nameController = TextEditingController().obs;
  var lastNameController = TextEditingController().obs;
  var phoneController = TextEditingController().obs;

  //focus nodes
  var nameFocus = FocusNode();
  var lastNameFocus = FocusNode();
  var emailFocus = FocusNode();
  var passwordFocus = FocusNode();
  var confirmFocus = FocusNode();
  var phoneFocus = FocusNode();

  // for inviting coparent
  var coparentEmail = TextEditingController().obs;
  var coparentEmailError = Rx<String?>(null);
  var coparentName = TextEditingController().obs;
  var coparentNameError = Rx<String?>(null);
  var hasWrittenCoEmail = false.obs;
  var hasWrittenCoName = false.obs;

  // for student addition
  var studentNameController = TextEditingController().obs;
  var studentCity = Rx<String?>(null);
  var studentSchool = Rx<String?>(null);
  var studentType = Rx<String?>(null);
  var studentCounter = 1.obs;

  // for student registration
  var cityController = Rx<String?>(null);
  var typeController = Rx<String?>(null);
  var schoolController = Rx<String?>(null);
  var schoolError = Rx<String?>(null);
  var schoolID = ''.obs;
  var cityID = ''.obs;

  var students = [].obs;
  var student = false.obs;
  var errorName = Rx<String?>(null);
  var errorPass = Rx<String?>(null);
  var errorEmail = Rx<String?>(null);
  var errorPhone = Rx<String?>(null);
  var errorLastName = Rx<String?>(null);
  var errorConfirm = Rx<String?>(null);
  var errorStudentName = Rx<String?>(null);
  String? email;
  String? password;
  String? name;
  String? lastName;
  String? phone;
  String? confirm;

  var cities = <CityModel>[].obs;
  var schools = <SchoolModel>[].obs;

  @override
  void onInit() async {
    super.onInit();
    await getCities();
    await getSchool();
  }

  Future<dynamic> checkEmail() async {
    showDialog(
        context: Get.context!,
        builder: (_) {
          return const LoadingOverlay();
        });
    try {
      var params = <String, dynamic>{};
      params['email'] = email!;
      var data = json.encode(params);
      var encodedData = Uri.encodeComponent(data);
      var response =
          await RemoteServices.getAPI("user/isEmailUsed.php", encodedData);
      var parsedRes = json.decode(response);
      if (parsedRes['status'] == 'success' && parsedRes['message'] == false) {
        Get.back();

        return false;
      } else if (parsedRes['status'] == 'success' &&
          parsedRes['message'] == true) {
        Get.back();

        showToas('Email Already Used');
        return true;
      } else {
        Get.back();

        showToas('Something went wrong, please try again');
        return true;
      }
    } catch (e) {
      Get.back();
      log('$e from check email');
      showToas('Something went wrong, please try again');
      return true;
    }
  }

  Future<void> submitFunction({
    bool hasLoading = true,
  }) async {
    showDialog(
        context: Get.context!,
        builder: (_) {
          return const LoadingOverlay();
        });
    var params = <String, dynamic>{};
    params['email'] = email;
    params['password'] = password!;
    params['type'] = student.value ? 'student' : 'parent';
    params['firstName'] = name!;
    params['lastName'] = lastName!;
    params['phoneNumber'] = phone ?? '';
    if (hasWrittenCoparent() && validateCoparentFields()) {
      params['coparent'] = {
        'fullName': coparentName.value.text,
        'email': coparentEmail.value.text
      };
    }
    if (!student.value) {
      var temp = students.map((element) {
        return {'name': element['name'], 'schoolID': element['schoolId']};
      }).toList();
      params['students'] = temp;
    } else {
      params['schoolID'] = schoolID.value;
      params['cityID'] = cityID.value;
    }
    try {
      var data = json.encode(params);
      var encodedData = Uri.encodeComponent(data);
      var response =
          await RemoteServices.getAPI("user/register.php", encodedData);
      var parsedRes = json.decode(response);
      if (parsedRes['status'] == 'success') {
        var loginController = Get.put(LoginCOntroller());
        await loginController.login(email!, password!, fromRegister: true);
      } else {
        showToas(parsedRes['message']);
      }
    } catch (e) {
      log(e.toString());
    }
    Get.back();
  }

  void shiftFocus() {
    if (errorName.value != null || nameController.value.text.isEmpty) {
      nameFocus.requestFocus();
    } else if (errorLastName.value != null ||
        lastNameController.value.text.isEmpty) {
      lastNameFocus.requestFocus();
    } else if (!student.value &&
        (errorPhone.value != null || phoneController.value.text.isEmpty)) {
      phoneFocus.requestFocus();
    } else if (errorEmail.value != null || emailController.value.text.isEmpty) {
      emailFocus.requestFocus();
    } else if (student.value &&
        (schoolController.value == null || schoolController.value!.isEmpty)) {
      schoolError.value = 'Please select a school';
    } else if (errorPass.value != null ||
        passwordController.value.text.isEmpty) {
      passwordFocus.requestFocus();
    } else if (errorConfirm.value != null ||
        confirm == null ||
        confirm!.isEmpty) {
      confirmFocus.requestFocus();
    }
  }

  bool get checkValidationOfFields {
    bool studentSpecial = true;
    if (student.value) {
      if (schoolController.value != null &&
          schoolController.value!.isNotEmpty) {
        studentSpecial = true;
      } else {
        studentSpecial = false;
      }
    }
    String? error = (ValidateAddItem.validateEmail(email) ?? '') +
        (ValidateAddItem.validateName(name) ?? '') +
        (ValidateAddItem.validatePassword(password) ?? '') +
        (ValidateAddItem.validateName(lastName) ?? '') +
        (ValidateAddItem.validateMobileWithFormatting(phone,
                required: !student.value) ??
            '');
    log(error);
    if (error.isNotEmpty ||
        confirm == null ||
        confirm != password ||
        !studentSpecial) {
      return false;
    }
    return true;
  }

  void onChnagedPass(String password) {
    this.password = password;
    if (confirm == null || confirm == password || confirm!.isEmpty) {
      errorConfirm.value = null;
    } else {
      errorConfirm.value = 'Passwords do not match';
    }
    errorPass.value = ValidateAddItem.validatePassword(password);
  }

  void onChnagedConfirm(String password) {
    confirm = password;
    if (confirm == this.password || confirm!.isEmpty) {
      errorConfirm.value = null;
    } else {
      errorConfirm.value = 'Passwords do not match';
    }
  }

  void onChnagedEmail(String email) {
    this.email = email.trim();
    errorEmail.value = ValidateAddItem.validateEmail(email);
  }

  void onChnagedName(String name) {
    this.name = name.trim();
    errorName.value = ValidateAddItem.validateName(name, required: true);
  }

  void onChnagedStudentName(String name) {
    errorStudentName.value = ValidateAddItem.validateName(name.trim());
  }

  void onChnagedLastName(String lastName) {
    this.lastName = lastName.trim();
    errorLastName.value =
        ValidateAddItem.validateName(lastName, required: true);
  }

  void onChnagedPhone(String phone) {
    this.phone = phone.trim();
    errorPhone.value =
        ValidateAddItem.validateMobileWithFormatting(this.phone!);
  }

  void onChnagedCity(dynamic value) async {
    schoolError.value = null;
    value = value.toString();
    cityController.value = value;
    typeController.value = null;
    schoolController.value = null;
    CityModel? city = cities.firstWhereOrNull((element) {
      if (element.name == value) {
        return true;
      }
      return false;
    });
    String id;
    if (city == null) {
      id = '';
    } else {
      id = city.cityID ?? '';
    }
    await getSchool(cityID: id);
    update();
  }

  void onChnagedType(dynamic value) async {
    schoolError.value = null;
    value = value.toString();
    typeController.value = value;
    schoolController.value = null;
    CityModel? city = cities.firstWhereOrNull((element) {
      if (element.name == cityController.value) {
        return true;
      }
      return false;
    });
    String id;
    if (city == null) {
      id = '';
    } else {
      id = city.cityID ?? '';
    }
    await getSchool(cityID: id, type: value);
    update();
  }

  void onChnagedSchool(dynamic value) {
    value = value.toString();
    schoolError.value = null;
    schoolController.value = value;
    SchoolModel? school = schools.firstWhereOrNull((element) {
      if (element.name == value) {
        return true;
      }
      return false;
    });
    String sID, cID;
    if (school == null) {
      sID = '';
      cID = '';
    } else {
      sID = school.id ?? '';
      cID = school.cityId ?? '';
    }
    schoolID.value = sID;
    cityID.value = cID;
  }

  void onChnagedStudentSchool(dynamic name) {
    name = name.toString();
    studentSchool.value = name;
  }

  Future<void> onChangedStudentType(dynamic value) async {
    value = value.toString();
    studentType.value = value;
    studentSchool.value = null;
    CityModel? city = cities.firstWhereOrNull((element) {
      if (element.name == studentCity.value) {
        return true;
      }
      return false;
    });
    String id;
    if (city == null) {
      id = '';
    } else {
      id = city.cityID ?? '';
    }
    await getSchool(cityID: id, type: value);
    update();
  }

  Future<void> onChnagedStudentCity(dynamic name) async {
    name = name.toString();
    studentCity.value = name;
    CityModel? city = cities.firstWhereOrNull((element) {
      if (element.name == name) {
        return true;
      }
      return false;
    });
    studentSchool.value = null;
    studentType.value = null;
    String id;
    if (city == null) {
      id = '';
    } else {
      id = city.cityID ?? '';
    }
    await getSchool(cityID: id);
    update();
  }

  String? get getErrorPass {
    return errorPass.value;
  }

  String? get getErrorName {
    return errorName.value;
  }

  String? get getErrorLastName {
    return errorLastName.value;
  }

  String? get getErrorEmail {
    return errorEmail.value;
  }

  String? get getErrorConfirm {
    return errorConfirm.value;
  }

  String? get getErrorStudentName {
    return errorStudentName.value;
  }

  void addStudent(String name, String schoolName) {
    if (name.isEmpty) {
      name = 'Student $studentCounter';
    }
    for (var x in students) {
      if (x['name'] == name && x['school'] == schoolName) {
        showToas('Cannot add two students with the same name');
        return;
      }
    }
    SchoolModel? school = schools.firstWhereOrNull((element) {
      if (element.name == schoolName) {
        return true;
      }
      return false;
    });
    var id = '';
    if (school != null) {
      id = school.id ?? '';
    }
    students.add({'name': name, 'schoolId': id, 'school': schoolName});
  }

  void removeStudent(int index) {
    students.removeAt(index);
  }

  Future<void> getCities() async {
    try {
      var res = await RemoteServices.getAPI("city/get_cities.php", '');
      var parsedRes = json.decode(res);
      if (parsedRes is List) {
        for (var x in parsedRes) {
          var temp = CityModel.getCityFromMap(x);
          if (!temp.archived!) {
            cities.add(temp);
          }
        }
      } else {
        log(res);
      }
    } catch (e) {
      log(e.toString());
    }
    update();
  }

  Future<void> getSchool({String? cityID, String? type}) async {
    try {
      var params = <String, dynamic>{};
      params['cityID'] = cityID ?? '';
      params['type'] = type ?? '';
      var data = json.encode(params);
      var encodedData = Uri.encodeComponent(data);
      var res =
          await RemoteServices.getAPI("school/get_schools.php", encodedData);
      var parsedRes = json.decode(res);
      if (parsedRes is List) {
        unfocus();
        schools.clear();
        for (var x in parsedRes) {
          var temp = SchoolModel.getSchoolModelFromMap(x);
          if (!temp.archived!) {
            schools.add(temp);
          }
        }
      } else {
        log(res);
      }
    } catch (e) {
      log(e.toString());
    }
    update();
  }

  Future<void> clearfilters() async {
    // when adding students
    studentCity.value = '';
    studentNameController.value.clear();
    studentType.value = null;
    studentSchool.value = null;

    // for student registration
    cityController.value = null;
    schoolController.value = null;
    typeController.value = null;

    await getSchool();
  }

  // coparent handling
  void onCoparentNameChanged(String value) {
    coparentNameError.value =
        ValidateAddItem.validateName(value, required: false);
    if (value.trim().isEmpty) {
      hasWrittenCoName.value = false;
    } else {
      hasWrittenCoName.value = true;
    }
  }

  void onCoparentEmailChanged(String value) {
    coparentEmailError.value =
        ValidateAddItem.validateEmail(value, required: false);
    if (value.trim().isEmpty) {
      hasWrittenCoEmail.value = false;
    } else {
      hasWrittenCoEmail.value = true;
    }
  }

  bool hasWrittenCoparent() {
    return hasWrittenCoEmail.value || hasWrittenCoName.value;
  }

  bool validateCoparentFields() {
    if (coparentEmail.value.text.isNotEmpty &&
        coparentEmailError.value == null &&
        coparentName.value.text.isNotEmpty &&
        coparentNameError.value == null) {
      return true;
    }
    return false;
  }

  Future<void> sendInvitation() async {}
}
