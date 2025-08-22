import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart'; // === GIẢI THÍCH: Import SharedPreferences để lưu remember me ===
// Lý do: Cho phép lưu token khi chọn 'Ghi nhớ đăng nhập', làm form đầy đủ hơn và thân thiện với người dùng ===
import '../providers/auth_provider.dart';
import '../../../core/helpers/validator.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  // === GIẢI THÍCH: Thêm FocusNode để cải thiện UX ===
  // Lý do: Cho phép focus tự động chuyển từ email sang password, làm form đầy đủ và mượt mà hơn ===
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadRememberMe(); // Tải trạng thái remember me từ storage
  }

  // === GIẢI THÍCH: Tải trạng thái remember me từ SharedPreferences ===
  // Lý do: Nếu trước đó chọn remember, tự động điền email và focus password, tăng tính tiện lợi ===
  Future<void> _loadRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    _rememberMe = prefs.getBool('rememberMe') ?? false;
    if (_rememberMe) {
      _emailController.text = prefs.getString('savedEmail') ?? '';
    }
    setState(() {});
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      try {
        await authProvider.login(
          _emailController.text.trim(),
          _passwordController.text,
        );

        // === GIẢI THÍCH: Lưu remember me nếu chọn ===
        // Lý do: Lưu email và trạng thái vào SharedPreferences để lần sau tự điền, làm form đầy đủ và nhớ trạng thái người dùng ===
        final prefs = await SharedPreferences.getInstance();
        if (_rememberMe) {
          prefs.setBool('rememberMe', true);
          prefs.setString('savedEmail', _emailController.text.trim());
        } else {
          prefs.remove('rememberMe');
          prefs.remove('savedEmail');
        }

        if (mounted) {
          Fluttertoast.showToast(
            msg: 'Đăng nhập thành công!',
            backgroundColor: Colors.green,
          );

          // Check for redirect route from arguments
          final Map<String, dynamic>? args =
              ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>?;
          final redirectRoute = args?['redirectRoute'] as String?;
          final redirectArgs = args?['redirectArguments'];

          if (redirectRoute != null) {
            Navigator.pushReplacementNamed(
              context,
              redirectRoute,
              arguments: redirectArgs,
            );
          } else {
            Navigator.pushReplacementNamed(context, '/home');
          }
        }
      } catch (e) {
        if (mounted) {
          Fluttertoast.showToast(
            msg: e.toString().replaceFirst('Exception: ', ''),
            backgroundColor: Colors.red,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Email Field
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                enabled: !authProvider.isLoading,
                focusNode:
                    _emailFocus, // === GIẢI THÍCH: Thêm FocusNode cho email ===
                // Lý do: Chuyển focus sang password khi enter, làm form đầy đủ và tiện lợi hơn ===
                onFieldSubmitted:
                    (_) => FocusScope.of(context).requestFocus(_passwordFocus),
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Nhập địa chỉ email của bạn',
                  prefixIcon: Container(
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.email_outlined,
                      color: Color(0xFF3B82F6),
                      size: 20,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: Color(0xFF3B82F6),
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
                validator: Validator.validateEmail,
              ),

              const SizedBox(height: 20),

              // Password Field
              TextFormField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                textInputAction: TextInputAction.done,
                enabled: !authProvider.isLoading,
                focusNode:
                    _passwordFocus, // === GIẢI THÍCH: Thêm FocusNode cho password ===
                // Lý do: Cho phép submit form khi enter password, tăng tính tiện lợi ===
                onFieldSubmitted: (_) => _handleLogin(),
                decoration: InputDecoration(
                  labelText: 'Mật khẩu',
                  hintText: 'Nhập mật khẩu của bạn',
                  prefixIcon: Container(
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.lock_outlined,
                      color: Color(0xFF3B82F6),
                      size: 20,
                    ),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey[600],
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: Color(0xFF3B82F6),
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
                validator: Validator.validatePassword,
              ),

              const SizedBox(height: 16),

              // Remember Me & Forgot Password
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged:
                        authProvider.isLoading
                            ? null
                            : (value) {
                              setState(() {
                                _rememberMe = value ?? false;
                              });
                            },
                    activeColor: const Color(0xFF3B82F6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const Text(
                    'Ghi nhớ đăng nhập',
                    style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed:
                        authProvider.isLoading
                            ? null
                            : () {
                              Navigator.pushNamed(context, '/forgot-password');
                            },
                    child: const Text(
                      'Quên mật khẩu?',
                      style: TextStyle(
                        color: Color(0xFF3B82F6),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Login Button
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: authProvider.isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shadowColor: const Color(0xFF3B82F6).withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    disabledBackgroundColor: Colors.grey[300],
                  ),
                  child:
                      authProvider.isLoading
                          ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Đang đăng nhập...',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )
                          : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.login, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Đăng Nhập',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
