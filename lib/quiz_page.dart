import 'package:flutter/material.dart';
import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';

class QuizPage extends StatefulWidget {
  final Map<String, dynamic> examData;

  const QuizPage({super.key, required this.examData});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int remainingSeconds = 0;
  Timer? _timer;
  int currentQuestionIndex = 0;
  String? selectedOption;

  List<Map<String, dynamic>> questions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Default 10 mins if not provided
    remainingSeconds = (widget.examData['timerMinutes'] ?? 10) * 60;
    _fetchQuestions();
  }

  Future<void> _fetchQuestions() async {
    try {
      final examId = widget.examData['id'];
      if (examId == null) {
        throw Exception('Exam ID is missing');
      }

      final response = await Supabase.instance.client
          .from('exam_questions_link')
          .select('order_index, question_bank(q, opts)')
          .eq('exam_id', examId)
          .order('order_index', ascending: true);

      final List<Map<String, dynamic>> loadedQs = [];
      for (var row in response as List<dynamic>) {
        final qb = row['question_bank'];
        if (qb != null) {
          loadedQs.add({
            'q': qb['q'],
            'opts': List<String>.from(qb['opts'] ?? []),
          });
        }
      }

      setState(() {
        questions = loadedQs;
        isLoading = false;
      });
      _startTimer();
    } catch (e) {
      debugPrint('Error fetching questions: $e');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('প্রশ্ন লোড করতে সমস্যা হয়েছে: $e')),
      );
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        _timer?.cancel();
        _submitExam();
      }
    });
  }

  void _submitExam() {
    _timer?.cancel();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('পরীক্ষা শেষ!'),
        content: const Text('আপনার উত্তরগুলো সফলভাবে জমা দেওয়া হয়েছে।'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to exam details
            },
            child: const Text('ওকে'),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get timerText {
    int minutes = remainingSeconds ~/ 60;
    int seconds = remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.examData['title'] ?? 'মডেল টেস্ট'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                timerText,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber),
              ),
            ),
          )
        ],
      ),
      body: isLoading 
        ? const Center(child: CircularProgressIndicator()) 
        : questions.isEmpty 
          ? const Center(child: Text('এই পরীক্ষায় কোনো প্রশ্ন পাওয়া যায়নি।'))
          : _buildQuizContent(),
    );
  }

  Widget _buildQuizContent() {
    final question = questions[currentQuestionIndex];
    final options = question['opts'] as List<String>;

    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'প্রশ্ন ${currentQuestionIndex + 1} / ${questions.length}',
              style: const TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              question['q'],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ...options.map((option) {
              final isSelected = selectedOption == option;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      selectedOption = option;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.indigo.shade50 : Colors.white,
                      border: Border.all(
                        color: isSelected ? Colors.indigo : Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                          color: isSelected ? Colors.indigo : Colors.grey,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(option, style: const TextStyle(fontSize: 16)),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                if (currentQuestionIndex < questions.length - 1) {
                  setState(() {
                    currentQuestionIndex++;
                    selectedOption = null;
                  });
                } else {
                  _submitExam();
                }
              },
              child: Text(
                currentQuestionIndex < questions.length - 1 ? 'পরবর্তী প্রশ্ন' : 'জমা দিন',
                style: const TextStyle(fontSize: 18),
              ),
            )
          ],
        ),
      );
  }
}
