import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/auth_controller.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';

class RegisterPage extends GetView<AuthController> {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),

                // Name Field
                CustomTextField(
                  controller: nameController,
                  label: 'Full Name',
                  hint: 'Enter your full name',
                  prefixIcon: const Icon(Icons.person_outline),
                  validator: (value) => Validators.required(value, fieldName: 'Name'),
                  textInputAction: TextInputAction.next,
                ),

                const SizedBox(height: 16),

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
                  validator: (value) => Validators.minLength(value, 8, fieldName: 'Password'),
                  textInputAction: TextInputAction.next,
                ),

                const SizedBox(height: 16),

                // Confirm Password Field
                CustomTextField(
                  controller: confirmPasswordController,
                  label: 'Confirm Password',
                  hint: 'Re-enter your password',
                  obscureText: true,
                  prefixIcon: const Icon(Icons.lock_outlined),
                  validator: (value) {
                    if (value != passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.done,
                ),

                const SizedBox(height: 32),

                // Register Button
                Obx(
                  () => CustomButton(
                    text: 'Register',
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        controller.register(
                          nameController.text.trim(),
                          emailController.text.trim(),
                          passwordController.text,
                        );
                      }
                    },
                    isLoading: controller.isLoading.value,
                  ),
                ),

                const SizedBox(height: 16),

                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account? ', style: TextStyle(color: Colors.grey[600])),
                    TextButton(onPressed: () => Get.back(), child: const Text('Login')),
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
