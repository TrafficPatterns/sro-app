import 'package:flutter/cupertino.dart';
import 'package:sro/global_widgets/check_box.dart';
import 'package:sro/services/global_functions.dart';
import 'package:sro/themes/app_fonts.dart';

// ignore: must_be_immutable
class CheckBoxText3 extends StatelessWidget {
  CheckBoxText3({Key? key,this.title,this.valueEmail,this.valueApp,this.valueText,this.onChangedEmail,this.onChangedApp,this.onChangedText}) : super(key: key);
  final String? title;
  bool? valueEmail;
  bool? valueApp;
  bool? valueText;
  final Function? onChangedEmail;
  final Function? onChangedApp;
  final Function? onChangedText;

  @override
  Widget build(BuildContext context) {
   return 
    Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children:[
    Align(alignment: Alignment.centerLeft,
    child: Padding(padding: const EdgeInsets.only(left: 40, top: 25),
    child:
    Text(title!, style: AppFonts.poppins14Black),),
    ),
    SizedBox(height:getSize(5),),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
      CheckBoxText(text:'Email', value: valueEmail, onChanged: (e){
        onChangedEmail!.call(e);
      },),
      CheckBoxText(text:'In-App', value: valueApp, onChanged: (e){
        onChangedApp!.call(e);
      },),
      CheckBoxText(text:'Text', value: valueText, onChanged: (e){
        onChangedText!.call(e);
      },),
      ])]);
  }
}
