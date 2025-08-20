import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(title: const Text('Hồ Sơ')),
      body: Center(
        child:
            user != null
                ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Tên: ${user.fullName}'),
                    Text('Email: ${user.email}'),
                    Text('SĐT: ${user.phoneNumber}'),
                    Text('Vai trò: ${user.role}'),
                    ElevatedButton(
                      onPressed: () async {
                        await authProvider.logout();
                        Navigator.pushReplacementNamed(context, '/login');
                        Fluttertoast.showToast(msg: 'Đăng xuất thành công');
                      },
                      child: const Text('Đăng Xuất'),
                    ),
                  ],
                )
                : const Text('Không có thông tin user'),
      ),
    );
  }
}
