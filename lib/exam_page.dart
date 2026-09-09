import 'package:flutter/material.dart';
import 'login_page.dart';
import 'quiz_page.dart';

class ExamPage extends StatelessWidget {
  final Map<String, dynamic> examData;

  const ExamPage({super.key, required this.examData});

  @override
  Widget build(BuildContext context) {
    final title = examData['title'] ?? 'পরীক্ষা';
    final course = examData['course'] ?? 'অজানা কোর্স';
    final isFree = examData['isFree'] == true;
    final timerMinutes = examData['timerMinutes'] ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('পরীক্ষার বিস্তারিত', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.indigo.shade100),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.indigo),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.book, size: 20, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text('কোর্স: $course', style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.timer, size: 20, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text('সময়: $timerMinutes মিনিট', style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.money_off, size: 20, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text('ফি: ${isFree ? "সম্পূর্ণ ফ্রি" : "পেইড (কোর্স কিনতে হবে)"}', style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  if (isFree) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizPage(examData: examData),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('আপনাকে প্রথমে লগইন করে কোর্সটি কিনতে হবে।')),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  }
                },
                child: Text(
                  isFree ? 'পরীক্ষা শুরু করুন' : 'কোর্স এনরোল করুন',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
