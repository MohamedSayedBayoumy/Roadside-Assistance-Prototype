import 'package:flutter/material.dart';

class CustomDropDown extends StatelessWidget {
  final String? selectedValue;
  final ValueChanged<String?> onChanged;
  final String? hintText;
  final List<String> values;

  const CustomDropDown({
    super.key,
    required this.selectedValue,
    required this.onChanged,
    this.hintText = 'اختر نوع الخدمة',
    required this.values,
  });

  @override
  Widget build(BuildContext context) {
    // 💡 الحماية هنا: لو القيمة الممررة مش موجودة في القائمة، هنخليها null
    final safeValue = values.contains(selectedValue) ? selectedValue : null;

    return DropdownButtonFormField<String>(
      initialValue: safeValue, // استخدمنا value بدلاً من initialValue
      isExpanded: true,
      hint: Text(
        hintText ?? '',
        style: const TextStyle(color: Colors.grey, fontSize: 16),
      ),
      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 18,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0), // تم توحيد الحواف لـ 30
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
      items: values.map((String service) {
        return DropdownMenuItem<String>(
          value: service,
          child: Text(
            service,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
