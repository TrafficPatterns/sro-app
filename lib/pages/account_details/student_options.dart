import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sro/globals.dart';
import 'package:sro/pages/account_details/account_details_controller.dart';
import 'package:sro/pages/school/school_controller.dart';
import 'package:sro/services/global_functions.dart';
import 'package:sro/themes/app_fonts.dart';

class StudentOptions extends GetView<SchoolController> {
  final String? name;
  final String? id;
  final bool? parent;
  const StudentOptions({Key? key, this.name, this.id, this.parent = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: Get.back,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: getSizeWrtHeight(50),
                width: width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.transparent),
                child: InkWell(
                  onTap: () {},
                  child: SizedBox(
                    child: Center(
                        child: Text(
                      name!,
                      style: AppFonts.poppins12WhiteBold,
                    )),
                  ),
                ),
              ),
              SizedBox(height: getSize(10)),
              Container(
                height: getSizeWrtHeight(50),
                width: width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xffC70000)),
                child: InkWell(
                  onTap: () async {
                    if (parent!) {
                      var ac = Get.put(AccountDetailsController());
                      ac.deleteCoParent();
                    } else {
                      await controller.deleteStudent(
                          schoolID: id!, studentName: name!);
                    }
                    Get.back();
                  },
                  child: SizedBox(
                    child: Center(
                        child: Text(
                      'Delete ${parent! ? 'Co-Parent' : 'Student'}',
                      style: AppFonts.poppins12WhiteBold,
                    )),
                  ),
                ),
              ),
              SizedBox(height: getSize(10)),
              Container(
                height: getSizeWrtHeight(50),
                width: width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
                child: InkWell(
                  onTap: Get.back,
                  child: SizedBox(
                    child: Center(
                        child: Text(
                      'Cancel',
                      style: AppFonts.poppinsMedium16blue,
                    )),
                  ),
                ),
              )
            ]),
      ),
    );
  }
}
