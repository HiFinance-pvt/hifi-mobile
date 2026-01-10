import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hifi/modules/auth/controllers/auth_controller.dart';
import 'package:hifi/modules/auth/widgets/auth_text_field.dart';

class ForgotPasswordView extends GetView<AuthController> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: controller.forgotPasswordFormKey,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 
                    MediaQuery.of(context).padding.top - 
                    MediaQuery.of(context).padding.bottom - 48,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                const SizedBox(height: 48),
                
                // Icon
                Icon(
                  Icons.lock_reset,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 32),
                
                // Title
                Text(
                  'Reset Password',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                
                // Description
                Text(
                  'Enter your email address and we\'ll send you a link to reset your password.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),

                // Email field
                AuthTextField(
                  controller: controller.emailController,
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: controller.validateEmail,
                ),
                const SizedBox(height: 32),

                // Send reset email button
                Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value 
                      ? null 
                      : controller.sendPasswordResetEmail,
                  child: controller.isLoading.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Send Reset Email'),
                )),
                
                const SizedBox(height: 60),

                // Back to sign in
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Back to Sign In'),
                ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}