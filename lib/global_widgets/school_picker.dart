import 'package:flutter/material.dart';
import 'package:sro/global_widgets/custom_drop_down.dart';

import '../services/global_functions.dart';

class SchoolPicker extends StatelessWidget {
  const SchoolPicker(
      {Key? key,
      required this.cities,
      this.schools,
      this.schoolValue,
      this.cityValue,
      this.typeValue,
      this.schoolError,
      this.width,
      this.hasSchool = true,
      this.expand = false,
      required this.onChangeType,
      this.onChangeSchool,
      required this.onChangeCity})
      : super(key: key);

  final List<DropdownMenuItem> cities;
  final List<DropdownMenuItem>? schools;
  final String? schoolValue;
  final String? cityValue;
  final String? typeValue;
  final double? width;
  final bool? expand;

  final Function(dynamic) onChangeType;
  final Function(dynamic)? onChangeSchool;
  final Function(dynamic) onChangeCity;

  final bool? hasSchool;
  final String? schoolError;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment:
              expand! ? CrossAxisAlignment.stretch : CrossAxisAlignment.start,
          children: [
            CustomDropDown(
              values: cities,
              width: width,
              label: 'Select a City',
              selected: cityValue,
              onChanged: onChangeCity,
            ),
            SizedBox(
              height: getSizeWrtHeight(30),
            ),
            CustomDropDown(
              values: ['Elementary', 'Middle', 'High']
                  .map((element) => DropdownMenuItem(
                        value: element,
                        child: Text(element),
                      ))
                  .toList(),
              label: 'School type',
              width: width,
              selected: typeValue,
              onChanged: onChangeType,
            ),
            if (hasSchool!)
              SizedBox(
                height: getSizeWrtHeight(30),
              ),
            if (hasSchool!)
              CustomDropDown(
                width: width,
                values: schools,
                label: 'Choose a School *',
                selected: schoolValue,
                onChanged: onChangeSchool,
                error: schoolError,
              ),
            SizedBox(
              height: getSizeWrtHeight(30),
            ),
          ],
        )
      ],
    );
  }
}
