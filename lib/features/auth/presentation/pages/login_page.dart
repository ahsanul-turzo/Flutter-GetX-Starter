import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/auth_controller.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../routes/app_routes.dart';

class LoginPage extends GetView<AuthController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),

                // Logo or App Icon
                Icon(Icons.lock_outline, size: 80, color: Theme.of(context).colorScheme.primary),

                const SizedBox(height: 24),

                // Title
                Text(
                  'Welcome Back',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                Text(
                  'Login to your account',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 48),

                // Email Field
                CustomTextField(
                  controller: emailController,
                  label: 'Email',
                  hint: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined),
                  validator: Validators.email,
                  textInputAction: TextInputAction.next,
                ),

                const SizedBox(height: 16),

                // Password Field
                CustomTextField(
                  controller: passwordController,
                  label: 'Password',
                  hint: 'Enter your password',
                  obscureText: true,
                  prefixIcon: const Icon(Icons.lock_outlined),
                  validator: Validators.password,
                  textInputAction: TextInputAction.done,
                ),

                const SizedBox(height: 8),

                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Get.snackbar('Info', 'Forgot password coming soon');
                    },
                    child: const Text('Forgot Password?'),
                  ),
                ),

                const SizedBox(height: 24),

                // Login Button
                Obx(
                  () => CustomButton(
                    text: 'Login',
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        controller.login(emailController.text.trim(), passwordController.text);
                      }
                    },
                    isLoading: controller.isLoading.value,
                  ),
                ),

                const SizedBox(height: 16),

                // Register Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account? ", style: TextStyle(color: Colors.grey[600])),
                    TextButton(onPressed: () => Get.toNamed(AppRoutes.register), child: const Text('Register')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
