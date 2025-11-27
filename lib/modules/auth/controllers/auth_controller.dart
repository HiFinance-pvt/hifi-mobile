import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hifi/services/auth_service.dart';
import 'package:hifi/app/routes/app_routes.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  // Form controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Observable variables
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final rememberMe = false.obs;

  // Form keys
  late GlobalKey<FormState> signInFormKey;
  late GlobalKey<FormState> signUpFormKey;
  late GlobalKey<FormState> forgotPasswordFormKey;

  @override
  void onInit() {
    super.onInit();
    signInFormKey = GlobalKey<FormState>();
    signUpFormKey = GlobalKey<FormState>();
    forgotPasswordFormKey = GlobalKey<FormState>();
    _loadRememberedEmail();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  // Load remembered email
  void _loadRememberedEmail() async {
    final rememberedEmail = await _authService.getRememberedEmail();
    if (rememberedEmail != null) {
      emailController.text = rememberedEmail;
      rememberMe.value = true;
    }
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  // Toggle remember me
  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }

  // Sign in with email and password
  Future<void> signInWithEmailPassword() async {
    if (!signInFormKey.currentState!.validate()) return;

    try {
      isLoading.value = true;
      
      await _authService.signInWithEmailPassword(
        emailController.text.trim(),
        passwordController.text,
      );

      if (rememberMe.value) {
        await _authService.saveRememberMe(emailController.text.trim());
      }

      Get.snackbar('Success', 'Signed in successfully', snackPosition: SnackPosition.BOTTOM);
      Get.offAllNamed(Routes.home);
      
    } catch (e) {
      Get.snackbar('Error', e.toString(), backgroundColor: Colors.red.shade100);
    } finally {
      isLoading.value = false;
    }
  }

  // Sign up with email and password
  Future<void> signUpWithEmailPassword() async {
    if (!signUpFormKey.currentState!.validate()) return;

    try {
      isLoading.value = true;
      
      await _authService.signUpWithEmailPassword(
        emailController.text.trim(),
        passwordController.text,
      );

      Get.snackbar('Success', 'Account created successfully', snackPosition: SnackPosition.BOTTOM);
      Get.offNamed(Routes.signin);
      
    } catch (e) {
      Get.snackbar('Error', e.toString(), backgroundColor: Colors.red.shade100);
    } finally {
      isLoading.value = false;
    }
  }

  // Sign in with Google
  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;
      print('🔵 Starting Google Sign In...');
      
      final result = await _authService.signInWithGoogle();
      print('🔵 Google Sign In result: $result');
      
      if (result != null) {
        print('✅ Google Sign In successful');
        Get.snackbar('Success', 'Signed in with Google successfully', snackPosition: SnackPosition.BOTTOM);
        Get.offAllNamed(Routes.home);
      } else {
        print('⚠️ Google Sign In returned null');
      }
      
    } catch (e, stackTrace) {
      print('❌ Google Sign In Error: $e');
      print('❌ Stack trace: $stackTrace');
      Get.snackbar('Error', e.toString(), backgroundColor: Colors.red.shade100);
    } finally {
      isLoading.value = false;
    }
  }

  // Sign in with Google (force account selection)
  Future<void> signInWithGoogleForceSelection() async {
    try {
      isLoading.value = true;
      print('🔵 Starting Google Sign In (Force Selection)...');
      
      final result = await _authService.signInWithGoogleForceSelection();
      print('🔵 Google Sign In (Force) result: $result');
      
      if (result != null) {
        print('✅ Google Sign In (Force) successful');
        Get.snackbar('Success', 'Signed in with Google successfully', snackPosition: SnackPosition.BOTTOM);
        Get.offAllNamed(Routes.home);
      } else {
        print('⚠️ Google Sign In (Force) returned null');
      }
      
    } catch (e, stackTrace) {
      print('❌ Google Sign In (Force) Error: $e');
      print('❌ Stack trace: $stackTrace');
      Get.snackbar('Error', e.toString(), backgroundColor: Colors.red.shade100);
    } finally {
      isLoading.value = false;
    }
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail() async {
    if (!forgotPasswordFormKey.currentState!.validate()) return;

    try {
      isLoading.value = true;
      
      await _authService.sendPasswordResetEmail(emailController.text.trim());
      
      Get.snackbar('Success', 'Password reset email sent', snackPosition: SnackPosition.BOTTOM);
      Get.back();
      
    } catch (e) {
      Get.snackbar('Error', e.toString(), backgroundColor: Colors.red.shade100);
    } finally {
      isLoading.value = false;
    }
  }

  // Navigation methods
  void goToSignUp() {
    _clearForm();
    signInFormKey = GlobalKey<FormState>();
    signUpFormKey = GlobalKey<FormState>();
    Get.toNamed(Routes.signup);
  }

  void goToSignIn() {
    _clearForm();
    signInFormKey = GlobalKey<FormState>();
    signUpFormKey = GlobalKey<FormState>();
    Get.offNamed(Routes.signin);
  }

  void goToForgotPassword() {
    Get.toNamed(Routes.forgotPassword);
  }

  // Clear form
  void _clearForm() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    isPasswordVisible.value = false;
    isConfirmPasswordVisible.value = false;
  }

  // Validators
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm password is required';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }
}