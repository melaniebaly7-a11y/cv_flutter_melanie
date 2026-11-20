import 'package:flutter/material.dart';

class CvPage extends StatelessWidget {
  const CvPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 55,
                  backgroundImage: AssetImage('assets/images/profil.jpg'),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Mélanie Balley',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Étudiante en Informatique & Génie Logiciel',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const Divider(height: 32),
          _buildSectionTitle('Formation'),
          _buildItem('Licence en Informatique de Gestion', 'Université (En cours)'),
          _buildItem('Architecture des Ordinateurs & Réseaux', 'Travaux pratiques & Certification'),
          _buildSectionTitle('Expériences & Projets'),
          _buildItem('Application Mobile CV (Flutter)', 'Développement multi-écrans et déploiement GitHub'),
          _buildItem('Site Web SEO & Fashion (Next.js)', 'Création, référencement et mise en ligne sur Vercel'),
          _buildItem('Application de Gestion CRUD (PHP / MySQL)', 'Conception de base de données relationnelle'),
          _buildSectionTitle('Compétences Techniques'),
          const Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              Chip(label: Text('Flutter / Dart')),
              Chip(label: Text('PHP / MySQL')),
              Chip(label: Text('Next.js / TypeScript')),
              Chip(label: Text('Python (PyQt5)')),
              Chip(label: Text('C#')),
              Chip(label: Text('Git / GitHub')),
              Chip(label: Text('Réseaux (Cisco)')),
            ],
          ),
          const SizedBox(height: 16),
          _buildSectionTitle('Langues'),
          _buildItem('Français', 'Courant'),
          _buildItem('Swahili', 'Courant'),
          _buildItem('Anglais', 'Intermédiaire / Technique'),
          _buildSectionTitle('Centres d\'intérêt'),
          const Text('• Développement d\'applications mobiles et web\n• Cinéma & Culture\n• Entrepreneuriat & Technologie'),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo),
      ),
    );
  }

  Widget _buildItem(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
        ],
      ),
    );
  }
}
