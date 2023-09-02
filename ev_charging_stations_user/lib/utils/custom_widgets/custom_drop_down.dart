import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/dimens_constants.dart';
import '../helpers/common_helper.dart';

class CustomDropDown extends StatelessWidget {
  final List<String> displayList;
  final String? labelText;
  final String? Function(String?)? validatorFunction;
  final Function? onChanged;
  Rx<String> selected;

  CustomDropDown({
    Key? key,
    this.labelText,
    required this.displayList,
    required this.selected,
    this.onChanged,
    this.validatorFunction,
  }) : super(key: key);

  bool checkForValueValidation() {
    try {
      for (String value in displayList) {
        if (selected.value == value) {
          return true;
        }
      }
    } catch (e) {
      CommonHelper.printDebugError(e);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    FocusNode focusNode = FocusNode();

    return Obx(
      () {
        try {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (selected.value == '') {
              focusNode.unfocus();
            }

            if (!checkForValueValidation()) {
              selected.value = '';
            }
          });
        } catch (e) {
          CommonHelper.printDebugError("");
        }

        return Center(
          child: Container(
            margin: const EdgeInsets.all(DimenConstants.contentPadding),
            child: DropdownButtonFormField<String>(
              focusNode: focusNode,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                labelText: labelText,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(DimenConstants.buttonCornerRadius),
                  ),
                ),
              ),
              value: _selectedValue(),
              isDense: true,
              onChanged: (value) {
                setSelected(value);
                if (onChanged != null) {
                  onChanged!(value);
                }
              },
              validator: validatorFunction,
              items: displayList.map(
                (String? value) {
                  return DropdownMenuItem<String>(
                    value: dropDownValue(value),
                    child: Text(value ?? ""),
                  );
                },
              ).toList(),
            ),
          ),
        );
      },
    );
  }

  String? _selectedValue() {
    try {
      return selected.value.isNotEmpty ? selected.value : null;
    } catch (e) {
      return null;
    }
  }

  String? dropDownValue(String? value) {
    try {
      return value!.isNotEmpty ? value : null;
    } catch (e) {
      return null;
    }
  }

  void setSelected(String? value) {
    if (value != null) {
      selected.value = value;
    }
  }
}
