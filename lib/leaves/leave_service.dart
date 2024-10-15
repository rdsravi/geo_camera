import 'leave_model.dart';

class LeaveService {
  static LeaveModel getLeaveData() {
    // In a real app, this data might come from an API or database.
    return LeaveModel(
      totalLeaves: 16,
      usedLeaves: 8,
      casualLeaves: 22,
      medicalLeaves: 2,
      annualLeaves: 8,
      maternityLeaves: 8,
    );
  }
}
