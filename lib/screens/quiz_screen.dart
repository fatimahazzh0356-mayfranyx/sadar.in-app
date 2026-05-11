import 'package:flutter/material.dart';
import '../main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = SizeConfig(context);

    return SafeArea(
      bottom: false,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: size.maxContentWidth),
          child: ListView(
            padding: EdgeInsets.fromLTRB(
              size.horizontalPadding,
              34,
              size.horizontalPadding,
              120,
            ),
            children: [
              Text(
                'Kuis Pemahaman',
                style: TextStyle(
                  fontFamily: 'Melodrama',
                  fontSize: size.responsiveFont(38, tablet: 46),
                  fontWeight: FontWeight.w900,
                  color: AppColors.darkText,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Uji pemahamanmu tentang kekerasan seksual non-verbal. Kerjakan kuis ini untuk mengetahui seberapa paham kamu.',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: size.responsiveFont(16, tablet: 18),
                  height: 1.55,
                  color: AppColors.mutedText,
                ),
              ),
              const SizedBox(height: 36),

              const SizedBox(height: 28),

Container(
  width: double.infinity,
  height: size.isTablet ? 420 : 340,
  padding: const EdgeInsets.all(10),
  decoration: BoxDecoration(
    color: const Color(0xFFFFF1F4),
    borderRadius: BorderRadius.circular(30),
  ),
  child: Image.asset(
    'assets/illustrations/quiz_preview.png',
    fit: BoxFit.contain,
  ),
),

const SizedBox(height: 26),

              Container(
                padding: const EdgeInsets.all(26),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.pink.withOpacity(0.10),
                      blurRadius: 28,
                      offset: const Offset(0, 14),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.quiz_rounded,
                      color: AppColors.pink,
                      size: 58,
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Siap mulai?',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: size.responsiveFont(22, tablet: 26),
                        fontWeight: FontWeight.w900,
                        color: AppColors.darkText,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Jawab pertanyaan dengan jujur dan lihat badge yang kamu dapatkan di akhir.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        height: 1.5,
                        color: AppColors.mutedText,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const QuizPlayScreen(),
                    ),
                  );
                },
                child: Container(
                  height: 58,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.pink, AppColors.softPink],
                    ),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: const Text(
                    'Mulai Kuis',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuizPlayScreen extends StatefulWidget {
  const QuizPlayScreen({super.key});

  @override
  State<QuizPlayScreen> createState() => _QuizPlayScreenState();
}

class _QuizPlayScreenState extends State<QuizPlayScreen> {
  late List<Question> quizQuestions;
  int currentIndex = 0;
  int score = 0;
  int? selectedIndex;
  bool answered = false;

  @override
  void initState() {
    super.initState();
    startNewQuiz();
  }

  void startNewQuiz() {
    quizQuestions = List<Question>.from(allQuestions)..shuffle();
    quizQuestions = quizQuestions.take(10).toList();
    currentIndex = 0;
    score = 0;
    selectedIndex = null;
    answered = false;
  }

  void answerQuestion(int index) {
    if (answered) return;

    setState(() {
      selectedIndex = index;
      answered = true;

      if (index == quizQuestions[currentIndex].correctIndex) {
        score++;
      }
    });
  }

  void nextQuestion() {
    if (!answered) return;

    if (currentIndex < quizQuestions.length - 1) {
      setState(() {
        currentIndex++;
        selectedIndex = null;
        answered = false;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => QuizResultScreen(
            score: score,
            total: quizQuestions.length,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = SizeConfig(context);
    final question = quizQuestions[currentIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: size.maxContentWidth),
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                size.horizontalPadding,
                24,
                size.horizontalPadding,
                40,
              ),
              children: [
                Text(
                  'Kuis Pemahaman',
                  style: TextStyle(
                    fontFamily: 'Melodrama',
                    fontSize: size.responsiveFont(32, tablet: 40),
                    fontWeight: FontWeight.w900,
                    color: AppColors.darkText,
                  ),
                ),
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(
                    value: (currentIndex + 1) / quizQuestions.length,
                    minHeight: 9,
                    backgroundColor: AppColors.pink.withOpacity(0.12),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.pink,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'PERTANYAAN ${currentIndex + 1}/${quizQuestions.length}',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                    color: AppColors.mutedText,
                  ),
                ),
                const SizedBox(height: 28),
                Container(
                  padding: const EdgeInsets.all(26),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Text(
                    question.question,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: size.responsiveFont(21, tablet: 25),
                      height: 1.4,
                      fontWeight: FontWeight.w800,
                      color: AppColors.darkText,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ...List.generate(question.options.length, (index) {
                  final isSelected = selectedIndex == index;
                  final isCorrect = question.correctIndex == index;

                  Color bg = Colors.white;
                  Color border = Colors.transparent;

                  if (answered && isSelected && isCorrect) {
                    bg = const Color(0xFFE7F9EF);
                    border = Colors.green;
                  } else if (answered && isSelected && !isCorrect) {
                    bg = const Color(0xFFFFE5E5);
                    border = Colors.redAccent;
                  } else if (answered && isCorrect) {
                    bg = const Color(0xFFE7F9EF);
                    border = Colors.green;
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: GestureDetector(
                      onTap: () => answerQuestion(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: bg,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: border, width: 1.6),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 22,
                              backgroundColor:
                                  AppColors.pink.withOpacity(0.12),
                              child: Text(
                                String.fromCharCode(65 + index),
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.pink,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                question.options[index],
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize:
                                      size.responsiveFont(14, tablet: 16),
                                  height: 1.4,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.darkText,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 18),
                GestureDetector(
                  onTap: nextQuestion,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    height: 58,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: answered
                          ? const LinearGradient(
                              colors: [AppColors.pink, AppColors.softPink],
                            )
                          : null,
                      color: answered ? null : Colors.grey.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Text(
                      currentIndex == quizQuestions.length - 1
                          ? 'Lihat Hasil'
                          : 'Lanjut',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class QuizResultScreen extends StatefulWidget {
  final int score;
  final int total;

  const QuizResultScreen({
    super.key,
    required this.score,
    required this.total,
  });

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  @override
  void initState() {
    super.initState();
    saveHighScore();
  }

  Future<void> saveHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    final oldHighScore = prefs.getInt('quizHighScore') ?? 0;

    if (widget.score > oldHighScore) {
      await prefs.setInt('quizHighScore', widget.score);
      await prefs.setInt('quizTotalQuestion', widget.total);
    }
  }

  String get badge {
    final percent = widget.score / widget.total;

    if (percent >= 0.9) return '🏆 Pelindung Ruang Aman';
    if (percent >= 0.7) return '🎖️ Sadar dan Peduli';
    if (percent >= 0.5) return '✨ Mulai Paham';
    return '💡 Yuk Belajar Lagi';
  }

  String get message {
    final percent = widget.score / widget.total;

    if (percent >= 0.9) return 'Keren! Kamu punya pemahaman yang sangat baik.';
    if (percent >= 0.7) return 'Bagus! Kamu sudah cukup paham.';
    if (percent >= 0.5) return 'Lumayan! Yuk pelajari lagi beberapa situasi.';
    return 'Tidak apa-apa. Belajar pelan-pelan juga bagian dari proses.';
  }

  @override
  Widget build(BuildContext context) {
    final size = SizeConfig(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(size.horizontalPadding),
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(maxWidth: size.maxContentWidth),
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    badge,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Melodrama',
                      fontSize: size.responsiveFont(30, tablet: 38),
                      fontWeight: FontWeight.w900,
                      color: AppColors.darkText,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    '${widget.score} / ${widget.total}',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: size.responsiveFont(42, tablet: 52),
                      fontWeight: FontWeight.w900,
                      color: AppColors.pink,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: size.responsiveFont(15, tablet: 17),
                      height: 1.5,
                      color: AppColors.mutedText,
                    ),
                  ),
                  const SizedBox(height: 28),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const QuizPlayScreen(),
                        ),
                      );
                    },
                    child: Container(
                      height: 56,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.pink, AppColors.softPink],
                        ),
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: const Text(
                        'Coba Lagi',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Kembali'),
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

class Question {
  final String question;
  final List<String> options;
  final int correctIndex;

  const Question({
    required this.question,
    required this.options,
    required this.correctIndex,
  });
}

const allQuestions = [
  Question(
    question: 'Apa contoh pelecehan seksual non-verbal?',
    options: ['Sapaan sopan', 'Tatapan tidak nyaman', 'Bertanya kabar', 'Membantu teman'],
    correctIndex: 1,
  ),
  Question(
    question: 'Mengambil foto seseorang tanpa izin termasuk...',
    options: ['Eksploitasi visual', 'Candaan biasa', 'Sapaan', 'Hal wajar'],
    correctIndex: 0,
  ),
  Question(
    question: 'Apa respons pertama saat merasa tidak aman?',
    options: ['Diam saja', 'Menjauh dan cari tempat aman', 'Tetap di lokasi', 'Abaikan'],
    correctIndex: 1,
  ),
  Question(
    question: 'Gestur sugestif tanpa persetujuan adalah...',
    options: ['Candaan aman', 'Pelecehan non-verbal', 'Cara berteman', 'Hal biasa'],
    correctIndex: 1,
  ),
  Question(
    question: 'Apa arti batas personal?',
    options: ['Batas kenyamanan seseorang', 'Aturan sekolah', 'Hal tidak penting', 'Boleh dilanggar'],
    correctIndex: 0,
  ),
  Question(
    question: 'Menghalangi jalan dengan sengaja bisa termasuk...',
    options: ['Bantuan', 'Intimidasi non-verbal', 'Kesopanan', 'Hal lucu'],
    correctIndex: 1,
  ),
  Question(
    question: 'Apa yang dilakukan jika teman tidak nyaman?',
    options: ['Menertawakan', 'Membantu cari tempat aman', 'Meninggalkan', 'Merekam'],
    correctIndex: 1,
  ),
  Question(
    question: 'Kenapa consent penting?',
    options: ['Karena semua orang berhak atas kenyamanan tubuhnya', 'Formalitas', 'Tidak penting', 'Biar lucu'],
    correctIndex: 0,
  ),
  Question(
    question: 'Contoh invasi ruang personal adalah...',
    options: ['Berdiri terlalu dekat dengan sengaja', 'Memberi ruang', 'Menanyakan izin', 'Menjaga jarak'],
    correctIndex: 0,
  ),
  Question(
    question: 'Apa arti “trust your gut”?',
    options: ['Abaikan rasa takut', 'Percaya insting saat tidak aman', 'Selalu curiga', 'Tidak perlu bantuan'],
    correctIndex: 1,
  ),
  Question(
    question: 'Jika korban bercerita, respons terbaik adalah...',
    options: ['Menyalahkan', 'Mendengarkan dan percaya', 'Menyebarkan', 'Menganggap lebay'],
    correctIndex: 1,
  ),
  Question(
    question: 'Apa yang bukan pelecehan non-verbal?',
    options: ['Gestur cabul', 'Tatapan intimidatif', 'Foto tanpa izin', 'Memberi bantuan setelah diminta'],
    correctIndex: 3,
  ),
  Question(
    question: 'Kenapa korban sering ragu melapor?',
    options: ['Karena sulit dibuktikan', 'Karena pasti bercanda', 'Karena tidak berdampak', 'Karena tidak nyata'],
    correctIndex: 0,
  ),
  Question(
    question: 'Langkah aman di transportasi umum saat diawasi?',
    options: ['Pindah ke area ramai', 'Diam total', 'Ikuti pelaku', 'Balas agresif'],
    correctIndex: 0,
  ),
  Question(
    question: 'Merekam orang dalam situasi rentan tanpa izin adalah...',
    options: ['Tidak masalah', 'Eksploitasi visual', 'Selalu legal', 'Hiburan'],
    correctIndex: 1,
  ),
  Question(
    question: 'Apa sikap tepat saat seseorang berkata “berhenti”?',
    options: ['Abaikan', 'Berhenti dan hormati batasnya', 'Tertawakan', 'Mendekat lagi'],
    correctIndex: 1,
  ),
  Question(
    question: 'Pelecehan non-verbal berdampak pada...',
    options: ['Rasa aman korban', 'Tidak ada', 'Hanya pelaku', 'Hanya pakaian'],
    correctIndex: 0,
  ),
  Question(
    question: 'Apa contoh gestur intimidatif?',
    options: ['Memberi jalan', 'Menghalangi jalan', 'Mengangguk sopan', 'Menjaga jarak'],
    correctIndex: 1,
  ),
  Question(
    question: 'Apa yang harus dihindari saat membantu korban?',
    options: ['Menyalahkan korban', 'Mendengarkan', 'Menawarkan bantuan', 'Menghormati keputusan'],
    correctIndex: 0,
  ),
  Question(
    question: 'Tujuan edukasi pelecehan non-verbal adalah...',
    options: ['Lebih peka menjaga ruang aman', 'Menghakimi orang', 'Membuat takut keluar', 'Mengabaikan masalah'],
    correctIndex: 0,
  ),
  Question(
    question: 'Jika seseorang terus menatap setelah diminta berhenti...',
    options: ['Tidak menghormati batas', 'Sopan', 'Setuju', 'Bantuan'],
    correctIndex: 0,
  ),
  Question(
    question: 'Setelah kejadian tidak nyaman, sebaiknya...',
    options: ['Salahkan diri', 'Catat detail dan cari dukungan', 'Lupakan paksa', 'Diam selamanya'],
    correctIndex: 1,
  ),
  Question(
    question: 'Pelecehan non-verbal bisa terjadi di...',
    options: ['Ruang publik, online, sekolah, transportasi', 'Hanya rumah', 'Hanya internet', 'Tidak bisa'],
    correctIndex: 0,
  ),
  Question(
    question: 'Apa arti ruang aman?',
    options: ['Ruang yang menghormati dan tidak mengancam', 'Tanpa aturan', 'Selalu sepi', 'Untuk orang tertentu'],
    correctIndex: 0,
  ),
  Question(
    question: 'Sebelum memotret seseorang sebaiknya...',
    options: ['Minta izin', 'Langsung foto', 'Sembunyi kamera', 'Upload dulu'],
    correctIndex: 0,
  ),
  Question(
    question: 'Dukungan sederhana untuk korban adalah...',
    options: ['Mendampingi tanpa memaksa', 'Menyuruh diam', 'Menyebarkan cerita', 'Menghakimi'],
    correctIndex: 0,
  ),
  Question(
    question: 'Saat batas seseorang dilanggar, yang penting adalah...',
    options: ['Keselamatan dan kenyamanan', 'Pendapat pelaku', 'Biar lucu', 'Abaikan'],
    correctIndex: 0,
  ),
  Question(
    question: 'Tatapan mengarah ke tubuh secara berulang bisa membuat korban...',
    options: ['Merasa tidak aman', 'Selalu senang', 'Tidak berdampak', 'Merasa dihormati'],
    correctIndex: 0,
  ),
  Question(
    question: 'Gestur non-verbal yang tidak pantas harus...',
    options: ['Dihentikan', 'Dibiarkan', 'Direkam untuk lucu', 'Dianggap biasa'],
    correctIndex: 0,
  ),
  Question(
    question: 'Kalau merasa tidak nyaman, kamu berhak...',
    options: ['Menjauh dan meminta bantuan', 'Tetap diam', 'Menyalahkan diri', 'Menerima saja'],
    correctIndex: 0,
  ),
];