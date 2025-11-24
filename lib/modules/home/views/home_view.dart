import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hifi/modules/home/controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HiFi'),
        actions: [
          IconButton(
            onPressed: controller.signOut,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome!',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Obx(() => Text(
                      'Email: ${controller.userEmail.value}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    )),
                    const SizedBox(height: 8),
                    Obx(() => Text(
                      'Sign-in method: ${controller.signInMethod.value}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    )),
                    const SizedBox(height: 8),
                    Obx(() => Text(
                      'Auth Token: ${controller.authToken.value}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontFamily: 'monospace',
                      ),
                    )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: controller.signOut,
              child: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}