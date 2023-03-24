
import 'package:flutter/material.dart';

Future nextPage(BuildContext context, Widget page) async {
  await Navigator.push(context,
      MaterialPageRoute(builder: (BuildContext context) {
        return page;
      }));
}


Future backToPage(BuildContext context) async {
  Navigator.pop(context);
}