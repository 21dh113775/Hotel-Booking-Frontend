import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/admin_provider.dart';
import '../dto/admin_user_update_dto.dart';
import '../dto/register_dto.dart';
import 'package:http/http.dart' as http; // Giữ import http
import 'package:hotel_booking_frontend/services/api_client.dart'; // Đảm bảo import đúng ApiClient

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  _UserManagementScreenState createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
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

    return Scaffold(
      appBar: AppBar(title: const Text('Quản Lý Người Dùng')),
      body:
          adminProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : adminProvider.errorMessage != null
              ? Center(child: Text(adminProvider.errorMessage!))
              : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: adminProvider.users.length,
                      itemBuilder: (context, index) {
                        final user = adminProvider.users[index];
                        return ListTile(
                          title: Text(user.fullName),
                          subtitle: Text(
                            'Email: ${user.email}, Role: ${user.role}',
                          ),
                          trailing: DropdownButton<int>(
                            value: _getRoleId(user.role),
                            items: const [
                              DropdownMenuItem(value: 1, child: Text('Admin')),
                              DropdownMenuItem(
                                value: 2,
                                child: Text('Customer'),
                              ),
                              DropdownMenuItem(value: 3, child: Text('Staff')),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                final dto = AdminUserUpdateDto(
                                  userId: user.id,
                                  roleId: value,
                                );
                                adminProvider.updateUserRole(dto);
                              }
                            },
                          ),
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder:
                                  (context) => AlertDialog(
                                    title: const Text('Xác nhận xóa'),
                                    content: const Text(
                                      'Bạn có chắc muốn xóa user này?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Hủy'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          // Gọi API xóa user nếu có (chưa có endpoint)
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Xóa'),
                                      ),
                                    ],
                                  ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed:
                          () => _showAddUserDialog(context, adminProvider),
                      child: const Text('Thêm Người Dùng'),
                    ),
                  ),
                ],
              ),
    );
  }

  int _getRoleId(String role) {
    switch (role) {
      case 'Admin':
        return 1;
      case 'Staff':
        return 3;
      default:
        return 2; // Customer
    }
  }

  Future<void> _showAddUserDialog(
    BuildContext context,
    AdminProvider provider,
  ) async {
    final _fullNameController = TextEditingController();
    final _emailController = TextEditingController();
    final _phoneController = TextEditingController();
    final _passwordController = TextEditingController();
    int _roleId = 2; // Default Customer

    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Thêm Người Dùng Mới'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _fullNameController,
                  decoration: const InputDecoration(labelText: 'Họ Tên'),
                ),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Số Điện Thoại'),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Mật khẩu'),
                  obscureText: true,
                ),
                DropdownButton<int>(
                  value: _roleId,
                  items: const [
                    DropdownMenuItem(value: 1, child: Text('Admin')),
                    DropdownMenuItem(value: 2, child: Text('Customer')),
                    DropdownMenuItem(value: 3, child: Text('Staff')),
                  ],
                  onChanged: (value) => setState(() => _roleId = value!),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () async {
                  if (_fullNameController.text.isNotEmpty &&
                      _emailController.text.isNotEmpty &&
                      _phoneController.text.isNotEmpty &&
                      _passwordController.text.isNotEmpty) {
                    final dto = RegisterDto(
                      fullName: _fullNameController.text,
                      email: _emailController.text,
                      phoneNumber: _phoneController.text,
                      password: _passwordController.text,
                      roleId: _roleId,
                    );
                    try {
                      final response = await ApiClient.post(
                        '/api/auth/register', // Sử dụng ApiClient.post thay vì http.post
                        body: dto.toJson(),
                        withAuth: true,
                      );
                      if (response.statusCode == 200) {
                        provider.fetchUsers(); // Refresh list
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Lỗi: ${response.body}')),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Lỗi kết nối: $e')),
                      );
                    }
                  }
                },
                child: const Text('Thêm'),
              ),
            ],
          ),
    );
  }
}
