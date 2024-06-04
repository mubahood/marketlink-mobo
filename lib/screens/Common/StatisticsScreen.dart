import 'package:flutter/material.dart';
import 'package:flutter_ui/model/Utils.dart';

class StatisticsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory Statistics'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Informative Text with Icon
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.insights_outlined, size: 40.0, color: Colors.blue),
                  SizedBox(width: 10.0),
                  Flexible(
                    child: Text(
                      'In-depth statistics are currently available on the web dashboard.',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),

              // Explanation Text
              Text(
                'Why are statistics important?\n\n* Identify trends in your inventory.\n* Optimize stock levels to avoid stockouts and overstocking.\n* Make data-driven decisions for purchasing and marketing.',
                style: TextStyle(fontSize: 14.0),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 20.0),

              // Dashboard Button
              ElevatedButton(
                onPressed: () {
                  Utils.urlLauncher(Utils.API_URL.replaceAll('/api', ''));
                },
                child: Text('Access Web Dashboard'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(150, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
