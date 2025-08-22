import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/admin_provider.dart';
import '../widgets/staff_card.dart';
import '../../auth/providers/auth_provider.dart';

class StaffManagementScreen extends StatefulWidget {
  const StaffManagementScreen({super.key});

  @override
  _StaffManagementScreenState createState() => _StaffManagementScreenState();
}

class _StaffManagementScreenState extends State<StaffManagementScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AdminProvider>(context, listen: false).fetchUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    // === GIẢI THÍCH: Kiểm tra role Admin ===
    // Lý do: Đảm bảo chỉ admin truy cập, tránh lỗi truy cập trái phép ===
    if (authProvider.user?.role != 'Admin') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/home');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản Lý Staff'),
        backgroundColor: Colors.blue.shade700,
      ),
      body:
          adminProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : adminProvider.errorMessage != null
              ? Center(child: Text('Lỗi: ${adminProvider.errorMessage}'))
              : GridView.builder(
                padding: const EdgeInsets.all(16.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount:
                    adminProvider.users
                        .where((user) => user.role == 'Staff')
                        .length,
                itemBuilder: (context, index) {
                  final staff =
                      adminProvider.users
                          .where((user) => user.role == 'Staff')
                          .toList()[index];
                  return StaffCard(user: staff);
                },
              ),
    );
  }
}
