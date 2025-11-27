import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hifi/modules/auth/controllers/auth_controller.dart';
import 'package:hifi/modules/auth/widgets/auth_text_field.dart';
import 'package:hifi/modules/auth/widgets/google_sign_in_button.dart';
import 'package:hifi/shared/themes/app_theme.dart';

class SignUpView extends GetView<AuthController> {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF3461FD).withOpacity(0.1),
              Colors.white,
              const Color(0xFF3461FD).withOpacity(0.05),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 31),
              child: Form(
                key: controller.signUpFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 93),
                    
                    // Title and subtitle
                    const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primary600,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const SizedBox(
                      width: 283,
                      height: 60,
                      child: Text(
                        'It was popularised in the 1960s with the release of Letraset ',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppTheme.gray700,
                          height: 1.57,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 39),

                    // Name field
                    SizedBox(
                      width: 314,
                      child: AuthTextField(
                        controller: controller.nameController,
                        label: 'Name',
                        keyboardType: TextInputType.name,
                        validator: controller.validateName,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Email field
                    SizedBox(
                      width: 314,
                      child: AuthTextField(
                        controller: controller.emailController,
                        label: 'Email/Phone Number',
                        keyboardType: TextInputType.emailAddress,
                        validator: controller.validateEmail,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Password field
                    SizedBox(
                      width: 314,
                      child: Obx(() => AuthTextField(
                        controller: controller.passwordController,
                        label: 'Password',
                        obscureText: !controller.isPasswordVisible.value,
                        validator: controller.validatePassword,
                        suffixIcon: IconButton(
                          onPressed: controller.togglePasswordVisibility,
                          icon: Icon(
                            controller.isPasswordVisible.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppTheme.gray600,
                            size: 24,
                          ),
                        ),
                      )),
                    ),
                    const SizedBox(height: 14),

                    // Confirm Password field
                    SizedBox(
                      width: 314,
                      child: Obx(() => AuthTextField(
                        controller: controller.confirmPasswordController,
                        label: 'Confirm Password',
                        obscureText: !controller.isConfirmPasswordVisible.value,
                        validator: controller.validateConfirmPassword,
                        suffixIcon: IconButton(
                          onPressed: controller.toggleConfirmPasswordVisibility,
                          icon: Icon(
                            controller.isConfirmPasswordVisible.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppTheme.gray600,
                            size: 24,
                          ),
                        ),
                      )),
                    ),
                    const SizedBox(height: 13),

                    // Or divider
                    SizedBox(
                      width: 345,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 1,
                              color: Colors.grey.shade300,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 19.5),
                            child: Text(
                              'Or',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppTheme.gray900,
                                height: 1.57,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 1,
                              color: Colors.grey.shade300,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Google sign in button
                    SizedBox(
                      width: 329,
                      child: Obx(() => GoogleSignInButton(
                        onPressed: controller.isLoading.value 
                            ? null 
                            : controller.signInWithGoogle,
                        isLoading: controller.isLoading.value,
                      )),
                    ),
                    const SizedBox(height: 3),

                    // Terms checkbox
                    SizedBox(
                      width: 314,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() => GestureDetector(
                            onTap: controller.toggleRememberMe,
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: AppTheme.gray50,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: controller.rememberMe.value
                                  ? const Icon(
                                      Icons.check,
                                      size: 16,
                                      color: AppTheme.primary500,
                                    )
                                  : null,
                            ),
                          )),
                          const SizedBox(width: 14),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: AppTheme.gray800,
                                  height: 1.83,
                                ),
                                children: [
                                  const TextSpan(text: "I'm agree to The "),
                                  TextSpan(
                                    text: 'Terms of Service',
                                    style: const TextStyle(
                                      color: AppTheme.primary500,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        // Handle terms tap
                                      },
                                  ),
                                  const TextSpan(text: ' and '),
                                  TextSpan(
                                    text: 'Privacy Policy',
                                    style: const TextStyle(
                                      color: AppTheme.primary500,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        // Handle privacy tap
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 56),

                    // Create Account button
                    SizedBox(
                      width: 301,
                      child: Obx(() => Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primary500.withOpacity(0.3),
                              blurRadius: 22,
                              offset: const Offset(0, 38),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: controller.isLoading.value 
                              ? null 
                              : controller.signUpWithEmailPassword,
                          child: controller.isLoading.value
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Text('Create Account'),
                        ),
                      )),
                    ),
                    const SizedBox(height: 14),

                    // Sign in link
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppTheme.gray800,
                          height: 1.57,
                        ),
                        children: [
                          const TextSpan(text: 'Do you have account? '),
                          TextSpan(
                            text: 'Sign In',
                            style: const TextStyle(
                              color: AppTheme.primary500,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = controller.goToSignIn,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).padding.bottom + 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
