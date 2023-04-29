import 'dart:convert';

import 'package:http/http.dart' as http;

Future sendEmail({
  required String name,
  required String email,
  required String subject,
  required String message,
}) async{
  final serviceId = "service_5e0fvja";
  final templateId = "template_eahwj35";
  final userId = "0eAfq8oNbB_bC1sA6";

  final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
  final response = await http.post(
    url,
    headers: {
      'origin': "http://localhost",
      'Content-Type': 'application/json',
    },
    body: json.encode({
      'service_id': serviceId,
      'template_id': templateId,
      'user_id': userId,
      'template_params':{
        'user_name': name,
        'user_email': email,
        'user_subject': subject,
        'user_message': message,
      }
    }),

  );
  print(response.body);
}

