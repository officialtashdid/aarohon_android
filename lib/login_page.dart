import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('লগইন করুন'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.school, size: 80, color: Colors.indigo),
            const SizedBox(height: 24),
            const Text(
              'আরোহণ স্টুডেন্ট পোর্টালে\nস্বাগতম!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.indigo),
            ),
            const SizedBox(height: 48),
            ElevatedButton.icon(
              icon: const Icon(Icons.login),
              label: const Text('Google দিয়ে লগইন করুন', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                // TODO: Implement actual Firebase Google Sign-In
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('গুগল লগইন শীঘ্রই যুক্ত করা হবে!')),
                );
                // Simulate login success and go back
                Future.delayed(const Duration(seconds: 1), () {
                  Navigator.pop(context);
                });
              },
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              child: const Text('ইমেইল ও পাসওয়ার্ড দিয়ে লগইন', style: TextStyle(fontSize: 16)),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.indigo,
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Colors.indigo),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('ইমেইল লগইন ফর্ম এখানে আসবে')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
