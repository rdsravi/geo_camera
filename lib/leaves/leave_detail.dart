import 'package:flutter/material.dart';

class LeaveDetail extends StatelessWidget {
  const LeaveDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Apply for Leave'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Leave Application Form',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Leave Type',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'From Date',
                border: OutlineInputBorder(),
              ),
              readOnly: true,
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'To Date',
                border: OutlineInputBorder(),
              ),
              readOnly: true,
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Reason for Leave',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle leave application submission
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Leave applied successfully!')),
                );
                Navigator.pop(context); // Go back to the previous page
              },
              child: Text('Submit Leave Application'),
            ),
          ],
        ),
      ),
    );
  }
}
