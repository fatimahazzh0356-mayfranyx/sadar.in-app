import 'package:flutter/material.dart';
import '../main.dart';
import 'education_detail_screen.dart';

class EducationScreen extends StatelessWidget {
  const EducationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = SizeConfig(context);

    final modules = [
      EducationModule(
        icon: Icons.remove_red_eye_rounded,
        title: 'Tatapan Merendahkan',
        description:
            'Tatapan intens, tidak nyaman, atau mengarah pada bagian tubuh tertentu secara berulang tanpa persetujuan.',
        color: AppColors.pink,
      ),
      EducationModule(
        icon: Icons.back_hand_rounded,
        title: 'Gestur Intimidatif',
        description:
            'Gerakan tubuh yang mengancam, menghalangi jalan, atau membuat seseorang merasa tidak aman.',
        color: AppColors.teal,
      ),
      EducationModule(
        icon: Icons.camera_alt_rounded,
        title: 'Eksploitasi Visual',
        description:
            'Mengambil foto atau merekam seseorang tanpa izin, terutama dalam situasi pribadi atau rentan.',
        color: AppColors.purple,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: size.maxContentWidth),
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                size.horizontalPadding,
                22,
                size.horizontalPadding,
                120,
              ),
              children: [
                const EducationHeader(),

                SizedBox(height: size.height * 0.06),

                Text(
                  'Mengenali Pelecehan\nNon-Verbal',
                  style: TextStyle(
                    fontFamily: 'Melodrama',
                    fontSize: size.responsiveFont(36, tablet: 44),
                    height: 1.12,
                    fontWeight: FontWeight.w900,
                    color: AppColors.darkText,
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  'Pelecehan tidak selalu berupa sentuhan fisik atau kata-kata kasar. '
                  'Pahami batas-batas yang tidak terlihat untuk melindungi dirimu dan orang lain.',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: size.responsiveFont(16, tablet: 18),
                    height: 1.55,
                    color: AppColors.mutedText,
                  ),
                ),

                const SizedBox(height: 26),

                Container(
                  width: double.infinity,
                  height: size.isTablet ? 420 : 340,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF1F4),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.pink.withOpacity(0.08),
                        blurRadius: 24,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset(
                      'assets/illustrations/education_preview.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                SizedBox(height: size.height * 0.045),

                ...modules.map(
                  (module) => Padding(
                    padding: const EdgeInsets.only(bottom: 22),
                    child: EducationCard(module: module, size: size),
                  ),
                ),

                const SizedBox(height: 18),

                GradientButton(
                  text: 'Pelajari Lebih Lanjut',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const EducationDetailScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EducationHeader extends StatelessWidget {
  const EducationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final size = SizeConfig(context);

    return Row(
      children: [
        Image.asset(
          'assets/logo/sadarin_logo.png',
          width: size.isTablet ? 70 : 60,
          height: size.isTablet ? 70 : 60,
          fit: BoxFit.contain,
        ),
        const SizedBox(width: 14),
        Text(
          'Sadar.in',
          style: TextStyle(
            fontFamily: 'Chillax',
            fontSize: size.responsiveFont(32, tablet: 40),
            fontWeight: FontWeight.w800,
            color: AppColors.pink,
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const HomePage(),
              ),
            );
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.pink,
          ),
        ),
      ],
    );
  }
}

class EducationModule {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  EducationModule({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}

class EducationCard extends StatelessWidget {
  final EducationModule module;
  final SizeConfig size;

  const EducationCard({
    super.key,
    required this.module,
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
            color: Colors.black.withOpacity(0.045),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: size.isTablet ? 62 : 54,
            height: size.isTablet ? 62 : 54,
            decoration: BoxDecoration(
              color: module.color.withOpacity(0.14),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              module.icon,
              color: module.color,
              size: size.isTablet ? 30 : 26,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  module.title,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: size.responsiveFont(18, tablet: 22),
                    fontWeight: FontWeight.w900,
                    color: AppColors.darkText,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  module.description,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: size.responsiveFont(14, tablet: 16),
                    height: 1.45,
                    color: AppColors.mutedText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const GradientButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = SizeConfig(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: size.isTablet ? 64 : 58,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.pink, AppColors.softPink],
          ),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: AppColors.pink.withOpacity(0.22),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: size.responsiveFont(16, tablet: 18),
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}