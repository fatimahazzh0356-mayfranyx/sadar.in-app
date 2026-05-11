import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'auth_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = 'Pengguna Sadar.in';
  String userEmail = '-';

  int quizHighScore = 0;
  int quizTotalQuestion = 10;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      userName = prefs.getString('userName') ?? 'Pengguna Sadar.in';
      userEmail = prefs.getString('userEmail') ?? '-';

      // 🔥 AMBIL HIGH SCORE
      quizHighScore = prefs.getInt('quizHighScore') ?? 0;
      quizTotalQuestion = prefs.getInt('quizTotalQuestion') ?? 10;
    });
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('userName');
    await prefs.remove('userEmail');

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const AuthScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = SizeConfig(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: size.maxContentWidth),
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                size.horizontalPadding,
                28,
                size.horizontalPadding,
                40,
              ),
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        color: AppColors.pink,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Profil',
                      style: TextStyle(
                        fontFamily: 'Melodrama',
                        fontSize: size.responsiveFont(34, tablet: 42),
                        fontWeight: FontWeight.w900,
                        color: AppColors.darkText,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
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
                      CircleAvatar(
                        radius: 46,
                        backgroundColor: AppColors.pink.withOpacity(0.12),
                        child: const Icon(
                          Icons.person_rounded,
                          color: AppColors.pink,
                          size: 54,
                        ),
                      ),

                      const SizedBox(height: 18),

                      Text(
                        userName.isEmpty ? 'Pengguna Sadar.in' : userName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: size.responsiveFont(22, tablet: 26),
                          fontWeight: FontWeight.w900,
                          color: AppColors.darkText,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        userEmail.isEmpty ? '-' : userEmail,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: size.responsiveFont(14, tablet: 16),
                          color: AppColors.mutedText,
                        ),
                      ),

                      const SizedBox(height: 28),

                      ProfileInfoTile(
                        icon: Icons.shield_rounded,
                        title: 'Status',
                        value: 'Akun aktif',
                        size: size,
                      ),

                      const SizedBox(height: 12),

                      ProfileInfoTile(
                        icon: Icons.favorite_rounded,
                        title: 'Ruang Aman',
                        value: 'Sadar dan Peduli',
                        size: size,
                      ),

                      const SizedBox(height: 12),

                      // 🔥 HIGH SCORE QUIZ
                      ProfileInfoTile(
                        icon: Icons.emoji_events_rounded,
                        title: 'High Score Quiz',
                        value: '$quizHighScore / $quizTotalQuestion',
                        size: size,
                      ),
                    ],
                  ),
                ),

               const SizedBox(height: 24),

               GestureDetector(
                  onTap: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                      builder: (_) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: const Text(
                    'Keluar Akun?',
                    style: TextStyle(fontFamily: 'Poppins'),
                    ),
                    content: const Text(
                    'Kamu yakin ingin keluar?',
            style: TextStyle(fontFamily: 'Poppins'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                'Keluar',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      logout();
    }
  },
  child: Container(
    height: 56,
    padding: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      color: const Color(0xFFFFE5E5),
      borderRadius: BorderRadius.circular(30),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(Icons.logout_rounded, color: Colors.redAccent),
        SizedBox(width: 8),
        Text(
          'Keluar Akun',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Colors.redAccent,
          ),
        ),
      ],
    ),
  ),
                ),
              ]
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileInfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final SizeConfig size;

  const ProfileInfoTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.pink.withOpacity(0.12),
            child: Icon(
              icon,
              color: AppColors.pink,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: size.responsiveFont(14, tablet: 16),
                fontWeight: FontWeight.w700,
                color: AppColors.darkText,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: size.responsiveFont(13, tablet: 15),
              color: AppColors.mutedText,
            ),
          ),
        ],
      ),
    );
  }
}