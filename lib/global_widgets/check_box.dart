import 'package:flutter/material.dart';
import 'package:sro/themes/app_fonts.dart';

// ignore: must_be_immutable
class CheckBoxText extends StatefulWidget {
  CheckBoxText({Key? key,this.value,this.text,this.onChanged}) : super(key: key);
  bool? value;
  final String? text;
  final Function? onChanged;

   @override
  State<CheckBoxText> createState() => _CheckBoxTextState();
}

class _CheckBoxTextState extends State<CheckBoxText> {

  @override
  Widget build(BuildContext context) {
   return 
   InkWell(child:
   Row(children:[
      Transform.scale(
      scale: 1.2,
      child: Checkbox(
              value: widget.value,
              onChanged:(v){
                setState(() {
                  widget.value = v;
                });
                widget.onChanged!.call(widget.value);
                },
              activeColor: const Color(0xFF164B9B),
              checkColor: Colors.white,
              ),),
     Text(widget.text!,style: AppFonts.poppins14Black),
  ]),
  onTap: (){
    setState(() {
      widget.value = widget.value==true?false:true;
    });
    widget.onChanged!.call(widget.value);
  },
  );
  }
}


