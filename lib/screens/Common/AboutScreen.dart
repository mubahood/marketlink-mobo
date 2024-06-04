import 'package:flutter/material.dart';
import 'package:flutter_ui/model/Utils.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Invetortrack'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          // Enable scrolling for longer content
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Logo (replace with your logo image)
              Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  // Replace with your image path
                  height: 100.0,
                  width: 100.0,
                ),
              ),
              SizedBox(height: 20.0),

              // App Description
              Text(
                'Invetortrack is a mobile app and web dashboard system designed to empower you with efficient inventory management.',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 10.0),

              // Features List
              Text(
                'Key Features:',
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5.0),
              Text(
                '* Add, edit, and manage inventory items.',
                style: TextStyle(fontSize: 14.0),
              ),
              Text(
                '* Track stock levels and receive low stock alerts.',
                style: TextStyle(fontSize: 14.0),
              ),
              Text(
                '* Scan barcodes for quick and easy product management.',
                style: TextStyle(fontSize: 14.0),
              ),
              SizedBox(height: 10.0),

              // Developer Information (Optional)
              Text(
                'Developed by:',
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5.0),
              Text(
                'InvetoTrack Team', // Replace with your information
                style: TextStyle(fontSize: 14.0),
              ),
              SizedBox(height: 10.0),

              // Website Link (Optional)
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Website:',
                    style:
                        TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 5.0),
                  InkWell(
                    onTap: () {
                      Utils.urlLauncher(Utils.API_URL.replaceAll('/api', ''));
                    },
                    // Replace with your website URL
                    child: Text(
                      Utils.API_URL.replaceAll('/api', ''),
                      // Replace with your website domain
                      style: TextStyle(fontSize: 14.0, color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
