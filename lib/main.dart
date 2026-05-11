import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/splash_screen.dart';
import 'screens/education_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/hotline_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(const SadarInApp());
}

class SadarInApp extends StatelessWidget {
  const SadarInApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sadar.in',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Poppins',
      ),
      home: const SplashScreen(),
    );
  }
}

class AppColors {
  static const background = Color(0xFFFFF7F7);
  static const darkText = Color(0xFF4B151B);
  static const mutedText = Color(0xFF8A4650);
  static const pink = Color(0xFFD41461);
  static const softPink = Color(0xFFFF86AA);
  static const cyan = Color(0xFF8DECF5);
  static const purple = Color(0xFFC9A8FF);
  static const teal = Color(0xFF006B78);
}

class SizeConfig {
  final double width;
  final double height;
  final bool isTablet;

  SizeConfig(BuildContext context)
      : width = MediaQuery.sizeOf(context).width,
        height = MediaQuery.sizeOf(context).height,
        isTablet = MediaQuery.sizeOf(context).width >= 600;

  double get horizontalPadding => isTablet ? 48 : width * 0.06;
  double get maxContentWidth => 520;

  double responsiveFont(double mobile, {double? tablet}) {
    return isTablet ? (tablet ?? mobile + 4) : mobile;
  }
}

class MainShell extends StatefulWidget {
  final int initialIndex;

  const MainShell({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int activeIndex;

  @override
  void initState() {
    super.initState();
    activeIndex = widget.initialIndex;
  }

  void changeTab(int index) {
    setState(() {
      activeIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = SizeConfig(context);

    final pages = [
      HomePageContent(
        onGoToEducation: () => changeTab(1),
        onGoToQuiz: () => changeTab(2),
        onGoToHotline: () => changeTab(3),
      ),
      const EducationScreen(),
      const QuizScreen(),
      const HotlineScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: activeIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavBar(
        size: size,
        activeIndex: activeIndex,
        onTap: changeTab,
      ),
    );
  }
}

// Supaya file lain yang masih panggil HomePage tidak error.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainShell(initialIndex: 0);
  }
}

class HomePageContent extends StatefulWidget {
  final VoidCallback onGoToEducation;
  final VoidCallback onGoToQuiz;
  final VoidCallback onGoToHotline;
  const HomePageContent({
    super.key,
    required this.onGoToEducation,
    required this.onGoToQuiz,
    required this.onGoToHotline,
  });

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  final ScrollController _scrollController = ScrollController();
  bool isScrolled = false;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.offset > 10 && !isScrolled) {
        setState(() => isScrolled = true);
      } else if (_scrollController.offset <= 10 && isScrolled) {
        setState(() => isScrolled = false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = SizeConfig(context);

    return SafeArea(
      bottom: false,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: size.maxContentWidth),
          child: Column(
            children: [
              HeaderBar(size: size, isScrolled: isScrolled),
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  padding: EdgeInsets.fromLTRB(
                    size.horizontalPadding,
                    size.height * 0.07,
                    size.horizontalPadding,
                    120,
                  ),
                  children: [
                    HeroSection(size: size),
                    SizedBox(height: size.height * 0.07),
                    GestureDetector(
                      onTap: widget.onGoToEducation,
                      child: MenuCard(
                        icon: Icons.bookmark_rounded,
                        title: 'Edukasi',
                        subtitle: 'Pahami hak dan lindungi dirimu.',
                        color: AppColors.cyan,
                        size: size,
                      ),
                    ),
                    SizedBox(height: size.height * 0.028),
                    GestureDetector(
                      onTap: widget.onGoToQuiz,
                      child: MenuCard(
                        icon: Icons.quiz_rounded,
                        title: 'Kuis',
                        subtitle: 'Uji pemahamanmu tentang isu terkini.',
                        color: AppColors.purple,
                        size: size,
                      ),
                    ),
                    SizedBox(height: size.height * 0.028),
                   MenuCard(
                        icon: Icons.emergency_rounded,
                        title: 'Hotline',
                        subtitle: 'Butuh bantuan darurat? Hubungi sekarang.',
                        color: AppColors.pink,
                        isGradient: true,
                        size: size,
                        onTap: widget.onGoToHotline,
                      ),
                    SizedBox(height: size.height * 0.052),
                    const Divider(color: Color(0x16A15A62)),
                    SizedBox(height: size.height * 0.035),
                    FactTodayCard(size: size),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HeaderBar extends StatefulWidget {
  final SizeConfig size;
  final bool isScrolled;

  const HeaderBar({
    super.key,
    required this.size,
    required this.isScrolled,
  });

  @override
  State<HeaderBar> createState() => _HeaderBarState();
}

class _HeaderBarState extends State<HeaderBar> {
  String userName = '';

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      userName = prefs.getString('userName') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.fromLTRB(
        size.horizontalPadding,
        16,
        size.horizontalPadding,
        16,
      ),
      decoration: BoxDecoration(
        color: widget.isScrolled
            ? Colors.white.withOpacity(0.9)
            : Colors.transparent,
        borderRadius: widget.isScrolled
            ? const BorderRadius.vertical(bottom: Radius.circular(24))
            : BorderRadius.zero,
        boxShadow: widget.isScrolled
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/logo/sadarin_logo.png',
            width: size.isTablet ? 70 : 60,
            height: size.isTablet ? 70 : 60,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName.isEmpty ? 'Halo 👋' : 'Halo, $userName 👋',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: size.responsiveFont(14, tablet: 16),
                  color: AppColors.mutedText,
                ),
              ),
              Text(
                'Sadar.in',
                style: TextStyle(
                  fontFamily: 'Chillax',
                  fontSize: size.responsiveFont(28, tablet: 36),
                  fontWeight: FontWeight.w800,
                  color: AppColors.pink,
                ),
              ),
            ],
          ),
          const Spacer(),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProfileScreen(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Icon(
                  Icons.account_circle_outlined,
                  color: AppColors.pink,
                  size: size.isTablet ? 28 : 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HeroSection extends StatelessWidget {
  final SizeConfig size;

  const HeroSection({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    final bool smallPhone = size.width < 390;

    return SizedBox(
      height: smallPhone ? 440 : 470,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // TEKS KIRI
          Positioned(
            left: 0,
            top: 0,
            width: size.width * 0.72,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  const TextSpan(
                    children: [
                      TextSpan(text: 'Halo,\n'),
                      TextSpan(
                        text: 'Ruang amanmu\n',
                        style: TextStyle(color: AppColors.softPink),
                      ),
                      TextSpan(text: 'ada di sini.'),
                    ],
                  ),
                  style: TextStyle(
                    fontFamily: 'Melodrama',
                    fontSize: size.responsiveFont(30, tablet: 38),
                    height: 1.16,
                    fontWeight: FontWeight.w900,
                    color: AppColors.darkText,
                  ),
                ),

                SizedBox(height: size.height * 0.03),

                Text(
                  'Kami siap mendengarkan,\n'
                  'mengedukasi,\n'
                  'dan memberikan perlindungan\n'
                  'yang kamu butuhkan.',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: size.responsiveFont(15, tablet: 18),
                    height: 1.55,
                    color: AppColors.mutedText,
                  ),
                ),
              ],
            ),
          ),

          // ILUSTRASI KANAN BAWAH
          Positioned(
            right: smallPhone ? -30 : -40,
            bottom: smallPhone ? -15 : -30,
            child: IgnorePointer(
              child: Image.asset(
                'assets/illustrations/hero_safe.png',
                width: smallPhone ? size.width * 2 : size.width * 1.2,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final bool isGradient;
  final SizeConfig size;
  final VoidCallback? onTap;

  const MenuCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.size,
    this.isGradient = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardHeight = size.height < 700 ? 155.0 : 178.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: size.isTablet ? 210 : cardHeight,
        padding: EdgeInsets.all(size.isTablet ? 36 : 30),
        decoration: BoxDecoration(
          gradient: isGradient
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.pink, AppColors.softPink],
                )
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.white, color.withOpacity(0.35)],
                ),
          borderRadius: BorderRadius.circular(size.isTablet ? 34 : 28),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F000000),
              blurRadius: 26,
              offset: Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(size.isTablet ? 18 : 14),
              decoration: BoxDecoration(
                color: isGradient ? Colors.white24 : color,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: isGradient ? Colors.white : AppColors.darkText,
                size: size.isTablet ? 28 : 22,
              ),
            ),
            const Spacer(),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: size.responsiveFont(20, tablet: 25),
                fontWeight: FontWeight.w900,
                color: isGradient ? Colors.white : AppColors.darkText,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: size.responsiveFont(13, tablet: 16),
                color: isGradient ? Colors.white : AppColors.mutedText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FactTodayCard extends StatelessWidget {
  final SizeConfig size;

  const FactTodayCard({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(size.isTablet ? 34 : 28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            AppColors.cyan.withOpacity(0.22),
            const Color(0xFFFFE2E6),
          ],
        ),
        borderRadius: BorderRadius.circular(size.isTablet ? 34 : 28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: size.isTablet ? 28 : 24,
            backgroundColor: Colors.white,
            child: const Icon(Icons.lightbulb, color: AppColors.teal),
          ),
          SizedBox(height: size.height * 0.03),
          Text(
            'FAKTA HARI INI',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: size.responsiveFont(11, tablet: 13),
              letterSpacing: 1.4,
              fontWeight: FontWeight.w800,
              color: AppColors.mutedText,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Kekerasan berbasis gender online (KBGO) meningkat setiap tahunnya. Menjaga privasi data pribadi adalah langkah pertama yang paling krusial.',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: size.responsiveFont(16, tablet: 19),
              height: 1.55,
              color: AppColors.darkText,
            ),
          ),
        ],
      ),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  final SizeConfig size;
  final int activeIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.size,
    required this.activeIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(
          size.horizontalPadding * 0.8,
          10,
          size.horizontalPadding * 0.8,
          12,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [
            BoxShadow(color: Color(0x12000000), blurRadius: 20),
          ],
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: size.maxContentWidth),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => onTap(0),
                  child: BottomNavItem(
                    icon: Icons.home_rounded,
                    label: 'BERANDA',
                    active: activeIndex == 0,
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => onTap(1),
                  child: BottomNavItem(
                    icon: Icons.school_rounded,
                    label: 'EDUKASI',
                    active: activeIndex == 1,
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => onTap(2),
                  child: BottomNavItem(
                    icon: Icons.quiz_rounded,
                    label: 'KUIS',
                    active: activeIndex == 2,
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => onTap(3),
                  child: BottomNavItem(
                    icon: Icons.contact_support_rounded,
                    label: 'HOTLINE',
                    active: activeIndex == 3,
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

class BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const BottomNavItem({
    super.key,
    required this.icon,
    required this.label,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      margin: const EdgeInsets.symmetric(horizontal: 3),
      padding: EdgeInsets.symmetric(
        horizontal: active ? 14 : 8,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        gradient: active
            ? const LinearGradient(
                colors: [AppColors.pink, AppColors.softPink],
              )
            : null,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: active ? Colors.white : AppColors.mutedText,
            size: 22,
          ),
          const SizedBox(height: 4),
          FittedBox(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: active ? Colors.white : AppColors.mutedText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final size = SizeConfig(context);

    return SafeArea(
      bottom: false,
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontFamily: 'Melodrama',
            fontSize: size.responsiveFont(36, tablet: 44),
            fontWeight: FontWeight.w900,
            color: AppColors.darkText,
          ),
        ),
      ),
    );
  }
}