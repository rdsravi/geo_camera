import 'package:flutter/material.dart';

class LeaveDetail extends StatefulWidget {
  const LeaveDetail({super.key});

  @override
  _LeaveDetailState createState() => _LeaveDetailState();
}

class _LeaveDetailState extends State<LeaveDetail> {
  // This variable holds the selected leave type
  String? selectedLeaveType;

  // List of leave types
  final List<String> leaveTypes = ['Casual', 'Medical', 'Annual', 'Maternity'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Apply for Leave'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Leave Application Form',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Dropdown for Leave Type
            DropdownButtonFormField<String>(
              value: selectedLeaveType,
              decoration: const InputDecoration(
                labelText: 'Leave Type',
                border: OutlineInputBorder(),
              ),
              items: leaveTypes.map((leaveType) {
                return DropdownMenuItem<String>(
                  value: leaveType,
                  child: Text(leaveType),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedLeaveType = value;
                });
              },
            ),
            const SizedBox(height: 20),

            // TextField for From Date
            TextField(
              decoration: const InputDecoration(
                labelText: 'From Date',
                border: OutlineInputBorder(),
              ),
              readOnly: true,
              // Add functionality for date picker here if needed
            ),
            const SizedBox(height: 20),

            // TextField for To Date
            TextField(
              decoration: const InputDecoration(
                labelText: 'To Date',
                border: OutlineInputBorder(),
              ),
              readOnly: true,
              // Add functionality for date picker here if needed
            ),
            const SizedBox(height: 20),

            // TextField for Reason
            TextField(
              decoration: const InputDecoration(
                labelText: 'Reason for Leave',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 20),

            // Submit Button
            ElevatedButton(
              onPressed: () {
                // Handle leave application submission
                if (selectedLeaveType != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Leave applied successfully!')),
                  );
                  Navigator.pop(context); // Go back to the previous page
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select a leave type!')),
                  );
                }
              },
              child: const Text('Submit Leave Application'),
            ),
          ],
        ),
      ),
    );
  }
}
