
import 'package:flutter/material.dart';
import '../../../core/database/DBHelper.dart';
import '../../../read.dart';
import '../../../screens/tasks_screen.dart';
import '../../models/User.dart';


class SignUpController {
  final GlobalKey<FormState> _formSignupKey;
  final TextEditingController _emailController;
  final TextEditingController _passwordController;
  final ValueNotifier<bool> _agreePersonalDataNotifier;
  final BuildContext _context;

  SignUpController({
    required GlobalKey<FormState> formSignupKey,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required ValueNotifier<bool> agreePersonalDataNotifier,
    required BuildContext context,
  })   : _formSignupKey = formSignupKey,
        _emailController = emailController,
        _passwordController = passwordController,
        _agreePersonalDataNotifier = agreePersonalDataNotifier,
        _context = context;

  Future<void> signUp() async {
    if (_formSignupKey.currentState!.validate() &&
        _agreePersonalDataNotifier.value) {
      bool isExists =
          await DBHelper().emailExists(_emailController.text);
      if (isExists) {
        ScaffoldMessenger.of(_context).showSnackBar(
          const SnackBar(
            content: Text('This email is already registered. Please login instead.'),
          ),
        );
        return;
      }

      User user = User(_emailController.text, _passwordController.text);
      int result = await DBHelper().insertUser(user);

      ScaffoldMessenger.of(_context).showSnackBar(
        SnackBar(
          content: result > 0
              ? const Text('User registered successfully')
              : const Text('Failed to register user'),
        ),
      );

      if (result > 0) {
        Navigator.push(
          _context,
          MaterialPageRoute(
            builder: (context) => const TasksScreen(),
          ),
        );
      }
    } else if (!_agreePersonalDataNotifier.value) {
      ScaffoldMessenger.of(_context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to the processing of personal data'),
        ),
      );
    }
  }
}
