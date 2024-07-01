import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MailScreen extends StatefulWidget {
  const MailScreen({super.key});

  @override
  State<MailScreen> createState() => _MailScreenState();
}

class _MailScreenState extends State<MailScreen> {
  Future<void> _launchUrl() async {
    final String email = 'hafidhabbypratama@gmail.com';
    final String subject = 'test';
    final String body = 'test mail';

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        'subject': subject,
        'body': body,
      },
    );

    if (await canLaunch(emailUri.toString())) {
      await launch(emailUri.toString());
    } else {
      throw 'Could not launch $emailUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        child: Column(
          children: [
            TextFormField(),
            SizedBox(
              height: 16,
            ),
            TextFormField(),
            SizedBox(
              height: 32,
            ),
            InkWell(
              onTap: () {
                _launchUrl();
              },
              child: Text('Kirim Pesan'),
            )
          ],
        ),
      ),
    );
  }
}
