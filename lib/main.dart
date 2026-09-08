import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase with the URL and Anon Key from your website
  await Supabase.initialize(
    url: 'https://braytjbujysjydxbuqhv.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJyYXl0amJ1anlzanlkeGJ1cWh2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODgwMjM1MTIsImV4cCI6MjEwMzU5OTUxMn0.AmDl16yYjHd3yg83Zs_rJ0z1uU__pNK99OEvd_Iar0w',
  );
  
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
  List<dynamic> allExams = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final response = await Supabase.instance.client.from('exams').select('*');
      setState(() {
        allExams = response as List<dynamic>;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Separate exams based on isFree property (simulated logic for now based on db fields)
    final freeExams = allExams.where((e) => e['isFree'] == true).toList();
    final liveExams = allExams.where((e) => e['isFree'] != true).toList(); // Paid/Live exams

    return Scaffold(
      appBar: AppBar(
        title: const Text('BCS One (আরোহণ)', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {},
          ),
        ],
      ),
      body: isLoading 
        ? const Center(child: CircularProgressIndicator()) 
        : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Daily News Section (Still static for now)
            _buildSectionTitle('দৈনিক সংবাদ'),
            _buildHorizontalScrollBox(
              children: [
                _buildCard('সংবাদ ১', 'আজকের আপডেট...'),
              ],
            ),
            const SizedBox(height: 24),

            // Live Exams Box (From Database)
            _buildSectionTitle('লাইভ এক্সাম (${liveExams.length})'),
            if (liveExams.isEmpty) const Text('এই মুহূর্তে কোনো লাইভ এক্সাম নেই।') else
            _buildHorizontalScrollBox(
              children: liveExams.map((exam) {
                return _buildCard(
                  exam['title'] ?? 'অজানা এক্সাম', 
                  exam['course'] ?? 'কোর্স', 
                  color: Colors.indigo.shade50
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Free Model Tests Box (From Database)
            _buildSectionTitle('ফ্রি মডেল টেস্ট (${freeExams.length})'),
             if (freeExams.isEmpty) const Text('কোনো ফ্রি এক্সাম পাওয়া যায়নি।') else
            _buildHorizontalScrollBox(
              children: freeExams.map((exam) {
                return _buildCard(
                  exam['title'] ?? 'ফ্রি এক্সাম', 
                  exam['course'] ?? 'যেকোনো সময় দিন', 
                  color: Colors.green.shade50
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Course Card Grid (Static for now)
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
          Text(subtitle, style: TextStyle(color: Colors.grey.shade700, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
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
