import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // for launching links

class ContactUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Us'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Information
            Text(
              'Invetortrack',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5.0),
            Text(
              'Developed by the Invetortrack Team',
              style: TextStyle(fontSize: 14.0),
            ),
            SizedBox(height: 10.0),

            // Location
            Row(
              children: [
                Icon(Icons.place_outlined, size: 18.0, color: Colors.blue),
                SizedBox(width: 5.0),
                Text(
                  'Based in Uganda',
                  style: TextStyle(fontSize: 14.0),
                ),
              ],
            ),
            SizedBox(height: 10.0),

            // Contact Methods
            Text(
              'Get in touch:',
              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5.0),

            // Email
            Row(
              children: [
                Icon(Icons.email_outlined, size: 18.0, color: Colors.blue),
                SizedBox(width: 5.0),
                InkWell(
                  onTap: () => launch('mailto:mubahood360@gmail.com'),
                  child: Text(
                    'mubahood360@gmail.com',
                    style: TextStyle(fontSize: 14.0, color: Colors.blue),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5.0),

            // Phone Number
            Row(
              children: [
                Icon(Icons.phone_outlined, size: 18.0, color: Colors.blue),
                SizedBox(width: 5.0),
                InkWell(
                  onTap: () => launch('tel:+256783204665'),
                  child: Text(
                    '+256783204665',
                    style: TextStyle(fontSize: 14.0, color: Colors.blue),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5.0),

            // WhatsApp
            Row(
              children: [
                Icon(Icons.chat_outlined, size: 18.0, color: Colors.blue),
                SizedBox(width: 5.0),
                InkWell(
                  onTap: () => launch('whatsapp://send?phone=+256783204665'),
                  child: Text(
                    '+256783204665 (WhatsApp)',
                    style: TextStyle(fontSize: 14.0, color: Colors.blue),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
