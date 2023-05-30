import 'package:flutter/material.dart';

class CustomSearch extends StatelessWidget {
  const CustomSearch(
      {super.key,
      required this.controller,
      required this.onCancel,
      this.onChanged});
  final TextEditingController controller;
  final Function()? onCancel;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color(0xffF6F6FA),
        ),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          cursorColor: Colors.black,
          style: TextStyle(decoration: TextDecoration.none),
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.search,
              color: Colors.black,
            ),
            suffixIcon: IconButton(
              icon: const Icon(
                Icons.clear,
                color: Colors.black,
              ),
              onPressed: onCancel,
            ),
            border: InputBorder.none,
            hintText: 'TV shows,movies,and more',
            // enabledBorder: UnderlineInputBorder(),
            // focusedBorder: UnderlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
