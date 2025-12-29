import 'package:flutter/material.dart';
import 'package:flutter_get_starter/config/dot_env_config.dart';
import 'package:flutter_get_starter/core/utils/logger.dart';
import 'package:get/get.dart';

import '../../../../controllers/auth_controller.dart';
import '../../../../routes/app_routes.dart';
import '../controllers/home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    Logger.debug("", {"DotEnvHelper.isLive": DotEnvConfig.isLive});
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [IconButton(icon: const Icon(Icons.logout), onPressed: () => _showLogoutDialog(context))],
      ),
      body: Obx(() {
        final user = authController.user.value;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: Text(
                          user?.name.substring(0, 1).toUpperCase() ?? 'U',
                          style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Welcome back!', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                            const SizedBox(height: 4),
                            Text(
                              user?.name ?? 'User',
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            if (user?.email != null) ...[
                              const SizedBox(height: 2),
                              Text(user!.email, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Features Section
              const Text('Features', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

              const SizedBox(height: 16),

              // Feature Cards Grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _buildFeatureCard(
                    context,
                    icon: Icons.list_alt,
                    title: 'Example Feature',
                    subtitle: 'View sample items',
                    color: Colors.blue,
                    onTap: () => Get.toNamed(AppRoutes.example),
                  ),
                  _buildFeatureCard(
                    context,
                    icon: Icons.person,
                    title: 'Profile',
                    subtitle: 'View your profile',
                    color: Colors.purple,
                    onTap: () {
                      Get.snackbar('Info', 'Profile page coming soon');
                    },
                  ),
                  _buildFeatureCard(
                    context,
                    icon: Icons.settings,
                    title: 'Settings',
                    subtitle: 'App preferences',
                    color: Colors.orange,
                    onTap: () {
                      Get.snackbar('Info', 'Settings page coming soon');
                    },
                  ),
                  _buildFeatureCard(
                    context,
                    icon: Icons.info,
                    title: 'About',
                    subtitle: 'About this app',
                    color: Colors.green,
                    onTap: () => _showAboutDialog(context),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Stats Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Quick Stats', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStat('Items', '0', Icons.inventory_2),
                          _buildStat('Active', '1', Icons.check_circle),
                          _buildStat('Pending', '0', Icons.pending),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeTab,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Items'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Colors.blue),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.find<AuthController>().logout();
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('About'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Flutter Clean Architecture Starter', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Version 1.0.0', style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 16),
            const Text(
              'A production-ready Flutter starter template with Clean Architecture, GetX, and best practices.',
            ),
          ],
        ),
        actions: [TextButton(onPressed: () => Get.back(), child: const Text('Close'))],
      ),
    );
  }
}
