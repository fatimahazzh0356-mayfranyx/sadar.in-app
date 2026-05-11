import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../main.dart';

class EducationDetailScreen extends StatefulWidget {
  const EducationDetailScreen({super.key});

  @override
  State<EducationDetailScreen> createState() => _EducationDetailScreenState();
}

class _EducationDetailScreenState extends State<EducationDetailScreen> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  final slides = const [
    EducationSlide(
      title: 'Mengenal Pelecehan Non-Verbal',
      label: 'SLIDE 1 DARI 4',
      icon: Icons.visibility_off_rounded,
      imagePath: 'assets/illustrations/education_1.png',
      description:
          'Pelecehan tidak selalu berupa kata-kata atau sentuhan fisik. Pelecehan non-verbal seringkali sulit dibuktikan namun memberikan dampak psikologis yang nyata.',
      quote: null,
      points: [
        'Tatapan yang tidak diinginkan (unwanted staring)',
        'Gestur sugestif atau tidak senonoh',
        'Invasi ruang personal dengan sengaja',
      ],
    ),
    EducationSlide(
      title: '"Trust Your Gut"',
      label: 'SLIDE 2 DARI 4',
      icon: Icons.psychology_rounded,
      imagePath: 'assets/illustrations/education_2.png',
      description:
          'Seringkali kita meragukan insting kita sendiri saat menghadapi situasi yang tidak nyaman. Mengabaikan firasat demi kesopanan bisa berbahaya.',
      quote: '“Jika terasa salah, maka itu salah.”',
      points: [
        'Insting adalah sistem pertahanan alami tubuh.',
        'Tidak perlu mencari pembenaran atas perasaan tidak nyaman Anda.',
        'Utamakan keselamatan Anda di atas rasa sungkan.',
      ],
    ),
    EducationSlide(
      title: 'Batas Personal',
      label: 'SLIDE 3 DARI 4',
      icon: Icons.front_hand_rounded,
      imagePath: 'assets/illustrations/education_3.png',
      description:
          'Setiap orang berhak menentukan batas aman untuk tubuh, ruang pribadi, dan kenyamanannya.',
      quote: '“Batasmu valid, meski orang lain tidak memahaminya.”',
      points: [
        'Berani menjauh dari situasi yang terasa mengancam.',
        'Gunakan kalimat tegas seperti “Tolong berhenti.”',
        'Cari ruang yang lebih ramai atau aman.',
      ],
    ),
    EducationSlide(
      title: 'Apa yang Bisa Dilakukan?',
      label: 'SLIDE 4 DARI 4',
      icon: Icons.shield_rounded,
      imagePath: 'assets/illustrations/education_4.png',
      description:
          'Saat mengalami pelecehan non-verbal, fokus pertama adalah keselamatan dan dukungan.',
      quote: null,
      points: [
        'Percaya pada rasa tidak nyaman yang kamu rasakan.',
        'Catat detail kejadian jika memungkinkan.',
        'Hubungi orang terpercaya atau layanan bantuan.',
      ],
    ),
  ];

  void nextPage() {
    SystemSound.play(SystemSoundType.click);

    if (currentPage < slides.length - 1) {
      _pageController.animateToPage(
        currentPage + 1,
        duration: const Duration(milliseconds: 520),
        curve: Curves.easeInOutCubicEmphasized,
      );
    } else {
      Navigator.pop(context);
    }
  }

  void previousPage() {
    SystemSound.play(SystemSoundType.click);

    if (currentPage > 0) {
      _pageController.animateToPage(
        currentPage - 1,
        duration: const Duration(milliseconds: 520),
        curve: Curves.easeInOutCubicEmphasized,
      );
    } else {
      Navigator.pop(context);
    }
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
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                size.horizontalPadding,
                20,
                size.horizontalPadding,
                20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Modul Edukasi',
                    style: TextStyle(
                      fontFamily: 'Melodrama',
                      fontSize: size.responsiveFont(28, tablet: 36),
                      fontWeight: FontWeight.w900,
                      color: AppColors.darkText,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Pahami bentuk-bentuk pelecehan dan cara meresponsnya untuk menjaga ruang aman bersama.',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: size.responsiveFont(13, tablet: 15),
                      height: 1.45,
                      color: AppColors.mutedText,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      physics: const BouncingScrollPhysics(),
                      itemCount: slides.length,
                      onPageChanged: (index) {
                        SystemSound.play(SystemSoundType.click);
                        setState(() => currentPage = index);
                      },
                      itemBuilder: (context, index) {
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 350),
                          child: EducationSlideCard(
                            key: ValueKey(index),
                            slide: slides[index],
                            size: size,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      SmallButton(
                        text: 'Kembali',
                        onTap: previousPage,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(99),
                          child: LinearProgressIndicator(
                            value: (currentPage + 1) / slides.length,
                            minHeight: 8,
                            backgroundColor: AppColors.pink.withOpacity(0.12),
                            valueColor:
                                const AlwaysStoppedAnimation<Color>(
                              AppColors.pink,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      SmallButton(
                        text: currentPage == slides.length - 1
                            ? 'Selesai'
                            : 'Lanjut',
                        isPrimary: true,
                        onTap: nextPage,
                      ),
                    ],
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

class EducationSlide {
  final String title;
  final String label;
  final IconData icon;
  final String imagePath;
  final String description;
  final String? quote;
  final List<String> points;

  const EducationSlide({
    required this.title,
    required this.label,
    required this.icon,
    required this.imagePath,
    required this.description,
    required this.quote,
    required this.points,
  });
}

class EducationSlideCard extends StatelessWidget {
  final EducationSlide slide;
  final SizeConfig size;

  const EducationSlideCard({
    super.key,
    required this.slide,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(size.isTablet ? 28 : 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: AppColors.pink.withOpacity(0.08),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: ListView(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEEF2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  slide.icon,
                  color: AppColors.pink,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      slide.title,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: size.responsiveFont(18, tablet: 22),
                        fontWeight: FontWeight.w900,
                        color: AppColors.darkText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.cyan,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        slide.label,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: AppColors.teal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Container(
            height: size.isTablet ? 400 : 280,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF1F4),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Image.asset(
              slide.imagePath,
              fit: BoxFit.contain,
            ),
          ),

          const SizedBox(height: 22),

          if (slide.quote != null) ...[
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE7EC),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                slide.quote!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: size.responsiveFont(14, tablet: 16),
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkText,
                ),
              ),
            ),
            const SizedBox(height: 22),
          ],

          Text(
            slide.description,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: size.responsiveFont(14, tablet: 16),
              height: 1.55,
              color: AppColors.mutedText,
            ),
          ),

          const SizedBox(height: 18),

          ...slide.points.map(
            (point) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InfoPill(text: point),
            ),
          ),
        ],
      ),
    );
  }
}

class InfoPill extends StatelessWidget {
  final String text;

  const InfoPill({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 14,
            backgroundColor: AppColors.cyan,
            child: Icon(
              Icons.check_rounded,
              size: 16,
              color: AppColors.teal,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                height: 1.35,
                color: AppColors.darkText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SmallButton extends StatelessWidget {
  final String text;
  final bool isPrimary;
  final VoidCallback onTap;

  const SmallButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 22),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: isPrimary
              ? const LinearGradient(
                  colors: [AppColors.pink, AppColors.softPink],
                )
              : null,
          color: isPrimary ? null : Colors.white,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: isPrimary ? Colors.white : AppColors.mutedText,
          ),
        ),
      ),
    );
  }
}