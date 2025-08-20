import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../providers/auth_provider.dart';
import '../../../core/helpers/validator.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = 'Customer';

  final List<String> _roles = ['Admin', 'Manager', 'Staff', 'Customer'];

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Form(
      key: _formKey,
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(
                  labelText: 'Họ Tên',
                  border: OutlineInputBorder(),
                ),
                validator: Validator.validateFullName,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: Validator.validateEmail,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(
                  labelText: 'Số Điện Thoại',
                  border: OutlineInputBorder(),
                ),
                validator: Validator.validatePhoneNumber,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Mật Khẩu',
                  border: OutlineInputBorder(),
                ),
                validator: Validator.validatePassword,
                obscureText: true,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedRole,
                decoration: const InputDecoration(
                  labelText: 'Vai Trò',
                  border: OutlineInputBorder(),
                ),
                items:
                    _roles.map((role) {
                      return DropdownMenuItem(value: role, child: Text(role));
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRole = value!;
                  });
                },
                validator:
                    (value) => value == null ? 'Vui lòng chọn vai trò' : null,
              ),
              const SizedBox(height: 16),
              authProvider.isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          await authProvider.register({
                            'fullName': _fullNameController.text,
                            'email': _emailController.text,
                            'phoneNumber': _phoneNumberController.text,
                            'password': _passwordController.text,
                            'role': _selectedRole,
                          });
                          Navigator.pushReplacementNamed(context, '/home');
                          Fluttertoast.showToast(
                            msg: 'Đăng ký thành công!',
                            backgroundColor: Colors.green,
                          );
                        } catch (e) {
                          Fluttertoast.showToast(
                            msg: e.toString().replaceFirst('Exception: ', ''),
                            backgroundColor: Colors.red,
                          );
                        }
                      }
                    },
                    child: const Text('Đăng Ký'),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
