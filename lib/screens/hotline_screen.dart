import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';

class HotlineScreen extends StatelessWidget {
  const HotlineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = SizeConfig(context);

    final hotlines = [
      Hotline(
        name: 'Kementerian PPPA (SAPA 129)',
        number: '129',
        description: 'Layanan resmi perlindungan perempuan & anak',
      ),
      Hotline(
        name: 'Sejiwa 119',
        number: '119',
        description: 'Layanan kesehatan mental nasional',
      ),
      Hotline(
        name: 'Komnas Perempuan',
        number: '0213903963',
        description: 'Pendampingan korban kekerasan',
      ),
      Hotline(
        name: 'WhatsApp SAPA 129',
        number: '6281290012900',
        description: 'Chat bantuan cepat via WhatsApp',
        isWhatsApp: true,
      ),
    ];

    return SafeArea(
      bottom: false,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: size.maxContentWidth),
          child: ListView(
            padding: EdgeInsets.fromLTRB(
              size.horizontalPadding,
              28,
              size.horizontalPadding,
              120,
            ),
            children: [
              Text(
                'Hotline Bantuan',
                style: TextStyle(
                  fontFamily: 'Melodrama',
                  fontSize: size.responsiveFont(34, tablet: 42),
                  fontWeight: FontWeight.w900,
                  color: AppColors.darkText,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Jika kamu atau orang lain membutuhkan bantuan, hubungi layanan berikut.',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: size.responsiveFont(15, tablet: 17),
                  height: 1.5,
                  color: AppColors.mutedText,
                ),
              ),
              const SizedBox(height: 28),

              const SizedBox(height: 26),

Container(
  width: double.infinity,
  height: size.isTablet ? 420 : 340,
  padding: const EdgeInsets.all(10),
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
      'assets/illustrations/hotline_preview.png',
      fit: BoxFit.contain,
    ),
  ),
),

const SizedBox(height: 28),

              ...hotlines.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: HotlineCard(item: item),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Hotline {
  final String name;
  final String number;
  final String description;
  final bool isWhatsApp;

  Hotline({
    required this.name,
    required this.number,
    required this.description,
    this.isWhatsApp = false,
  });
}

class HotlineCard extends StatelessWidget {
  final Hotline item;

  const HotlineCard({super.key, required this.item});

  Future<void> _handleTap(BuildContext context) async {
    final Uri url = item.isWhatsApp
        ? Uri.parse(
            "https://wa.me/${item.number}?text=Halo%20saya%20butuh%20bantuan")
        : Uri.parse("tel:${item.number}");

    if (!await launchUrl(url)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal membuka layanan')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = SizeConfig(context);

    return GestureDetector(
      onTap: () => _handleTap(context),
      child: Container(
        padding: EdgeInsets.all(size.isTablet ? 26 : 22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: AppColors.pink.withOpacity(0.08),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.pink.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                item.isWhatsApp
                    ? Icons.chat_rounded
                    : Icons.phone_rounded,
                color: AppColors.pink,
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: size.responsiveFont(17, tablet: 20),
                      fontWeight: FontWeight.w800,
                      color: AppColors.darkText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.description,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: size.responsiveFont(13, tablet: 15),
                      color: AppColors.mutedText,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}