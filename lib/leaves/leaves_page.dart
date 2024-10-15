import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'leave_detail.dart';
import 'leave_model.dart';
import 'leave_service.dart';

class LeavesPage extends StatelessWidget {
  const LeavesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Example data for leaves
    LeaveModel leaveData = LeaveService.getLeaveData(); // Fetch leave data

    double totalLeaves = leaveData.totalLeaves.toDouble();
    double usedLeaves = leaveData.usedLeaves.toDouble();
    double leaveBalance = totalLeaves - usedLeaves;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 6, right: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(
                          'https://via.placeholder.com/150', // Placeholder image, replace with actual
                        ),
                      ),
                      SizedBox(height: 10),
                      Column(
                        children: [
                          Text(
                            'Full Name',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Employee type',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // My Leaves Section
              Text(
                'My Leaves',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),

              // Circular Leave Balance Indicator
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    CircularPercentIndicator(
                      radius: 100.0,
                      lineWidth: 10.0,
                      percent: leaveBalance / totalLeaves,
                      center: Text(
                        leaveBalance.toString(),
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      progressColor: Colors.blue,
                      // backgroundColor: Colors.grey[300],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Leave', style: TextStyle(fontSize: 16)),
                        Text('Used Leave', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          totalLeaves.toString(),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          usedLeaves.toString(),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Divider(),

                    // Leave Type Breakdown
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildLeaveType('Casual', leaveData.casualLeaves, Colors.blue),
                        _buildLeaveType('Medical', leaveData.medicalLeaves, Colors.green),
                        _buildLeaveType('Annual', leaveData.annualLeaves, Colors.orange),
                        _buildLeaveType('Maternity', leaveData.maternityLeaves, Colors.purple),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),

              // Apply for Leave Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to leave detail page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LeaveDetail(),
                      ),
                    );
                  },
                  child: Text(
                    'APPLY FOR LEAVE',
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blue[300],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for leave type breakdown
  Widget _buildLeaveType(String title, int count, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: color.withOpacity(0.1),
          child: Text(
            count.toString(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        SizedBox(height: 5),
        Text(
          title,
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
