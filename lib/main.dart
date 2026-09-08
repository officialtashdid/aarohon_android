import 'package:flutter/material.dart';

void main() {
  runApp(const BcsOneApp());
}

class BcsOneApp extends StatelessWidget {
  const BcsOneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BCS One',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BCS One (আরোহণ)', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // TODO: Open Student Portal / Login
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Daily News Section
            _buildSectionTitle('দৈনিক সংবাদ'),
            _buildHorizontalScrollBox(
              children: [
                _buildCard('সংবাদ ১', 'আজকের আপডেট...'),
                _buildCard('সংবাদ ২', 'গুরুত্বপূর্ণ খবর...'),
              ],
            ),
            const SizedBox(height: 24),

            // Live Exams Box
            _buildSectionTitle('লাইভ এক্সাম'),
            _buildCard('বিসিএস প্রিলিমিনারি লাইভ মডেল টেস্ট', 'সময়: রাত ৯টা', color: Colors.indigo.shade50),
            const SizedBox(height: 24),

            // Free Model Tests Box
            _buildSectionTitle('ফ্রি মডেল টেস্ট'),
            _buildCard('ফ্রি এক্সাম ১: সাধারণ জ্ঞান', 'যেকোনো সময় দিন', color: Colors.green.shade50),
            const SizedBox(height: 24),

            // Upcoming Exams Box
            _buildSectionTitle('আসন্ন লাইভ এক্সাম'),
            _buildCard('বাংলা ব্যাকরণ স্পেশাল', 'আগামীকাল সন্ধ্যা ৭টা', color: Colors.orange.shade50),
            const SizedBox(height: 24),

            // Course Card Grid
            _buildSectionTitle('কোর্স ডিরেক্টরি'),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: [
                _buildCourseCard('সাধারণ কোর্স'),
                _buildCourseCard('বিসিএস প্রিলি'),
                _buildCourseCard('প্রাইমারি শিক্ষক নিয়োগ'),
                _buildCourseCard('ব্যাংক জব'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo),
      ),
    );
  }

  Widget _buildHorizontalScrollBox({required List<Widget> children}) {
    return SizedBox(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: children,
      ),
    );
  }

  Widget _buildCard(String title, String subtitle, {Color? color}) {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 12.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 8),
          Text(subtitle, style: TextStyle(color: Colors.grey.shade700, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildCourseCard(String title) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo.shade400, Colors.indigo.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
