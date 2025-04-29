import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sro/global_widgets/custom_button.dart';
import 'package:sro/global_widgets/text_field.dart';
import 'package:sro/globals.dart';
import 'package:sro/pages/change_password/change_password_controller.dart';
import 'package:sro/services/global_functions.dart';
import 'package:sro/themes/app_fonts.dart';

class ChangePasswordPage extends GetView<ChangePasswordController> {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
                backgroundColor: Colors.white,
                shadowColor: Colors.white,
                centerTitle: true,
                title: Padding(padding: const EdgeInsets.only(left: 0, top: 25),child: Text('Change Password', style: AppFonts.poppinsSemiBold16Black),),
                foregroundColor: Colors.white,
                elevation: 0,
                leading: InkWell(onTap: Get.back,child: Padding(
                  padding: const EdgeInsets.only(left: 10, top: 0),
                  child: Row(
                    children: [
                      SizedBox(
                          height: getSizeWrtHeight(18),
                          width: getSize(18),
                          child: BackButton(
                            color: Colors.black,
                            onPressed: Get.back,
                          )),
                    ],
                  ),
                ),
                ),
              ),
      body: 
      SingleChildScrollView(child:
      Center(child: 
        Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                   height: height-getSizeWrtHeight(200),  
                   child: 
                   Wrap(children: [
                   CustomTextField(
                    label: 'Current Password',
                    isPass: true,
                    required: true,
                    textController: controller.currentPasswordController.value,
                    onChanged: (value) {
                    },
                    onSubmit: (value) {
                    },
                   ),
                    CustomTextField(
                    label: 'New Password',
                    isPass: true,
                    required: true,
                    textController: controller.newPasswordController.value,
                    onChanged: (value) {
                    },
                    onSubmit: (value) {
                    },
                   ),
                    CustomTextField(
                    label: 'Confirm Password',
                    isPass: true,
                    required: true,
                    textController: controller.confirmPasswordController.value,
                    onChanged: (value) {
                    },
                    onSubmit: (value) {
                    },
                   ),]),),
                   CustomButton(
                    height: getSizeWrtHeight(65),
                    widthh: width - getSize(30),
                    onTap: () async{
                      if(controller.confirmPasswordController.value.text!=controller.newPasswordController.value.text){
                        showToas('Your password and confirmation password do not match.');
                      }else {
                        var res = await controller.changePassword();
                        controller.confirmPasswordController.value.text='';
                        controller.newPasswordController.value.text='';
                        controller.currentPasswordController.value.text='';
                        showToas(res.toString());
                      }
                    },
                    text: 'Save',
                    textStyle: AppFonts.poppinsMedium16White,
                    color: const Color(0xff164B9B),
                    textColor: Colors.white,
                    borderColor:  const Color(0xff164B9B)
                  ),
                   ]),
      )),
    );
  }
}