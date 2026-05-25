import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:profile_app/screens/profile_screen.dart';
import 'package:profile_app/services/auth_service.dart';
import 'package:profile_app/services/user_service.dart';
import 'package:profile_app/utils/constants.dart';
import 'package:profile_app/utils/messages.dart';
import 'package:profile_app/utils/validators.dart';
import 'package:profile_app/widgets/custom_button.dart';
import 'package:profile_app/widgets/custom_textfield.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _authService = AuthService();
  final _userService = UserService();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullNameController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _register() async {
    final emailError = Validators.email(_emailController.text);
    final passwordError = Validators.password(_passwordController.text);
    final confirmError = Validators.confirmPassword(
      _confirmPasswordController.text,
      _passwordController.text,
    );
    final nameError =
        Validators.required(_fullNameController.text, 'Full name');
    final usernameError = Validators.username(_usernameController.text);

    final firstError = emailError ??
        passwordError ??
        confirmError ??
        nameError ??
        usernameError;

    if (firstError != null) {
      showErrorMessage(context, firstError);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final credential = await _authService.register(
        email: _emailController.text,
        password: _passwordController.text,
      );

      final user = credential.user;
      if (user == null) {
        throw Exception('User creation failed');
      }

      await _userService.createUserDocument(
        uid: user.uid,
        email: _emailController.text.trim(),
        fullName: _fullNameController.text.trim(),
        username: _usernameController.text.trim(),
      );

      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        CupertinoPageRoute(builder: (_) => const ProfileScreen()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (mounted) _showError(_authService.getErrorMessage(e));
    } catch (e) {
      if (mounted) _showError('Registration failed. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: AppColors.background,
        border: null,
        middle: Text(
          AppStrings.registerTitle,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              CustomTextField(
                controller: _fullNameController,
                label: 'Full Name',
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(
                controller: _usernameController,
                label: 'Username',
                hint: 'johndoe',
              ),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(
                controller: _emailController,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(
                controller: _passwordController,
                label: 'Password',
                obscureText: true,
              ),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(
                controller: _confirmPasswordController,
                label: 'Confirm Password',
                obscureText: true,
              ),
              const SizedBox(height: AppSpacing.xl),
              CustomButton(
                label: 'Create Account',
                isLoading: _isLoading,
                onPressed: _register,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
