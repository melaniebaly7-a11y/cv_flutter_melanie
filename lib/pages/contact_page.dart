import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Impossible d\'ouvrir $urlString');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const Text(
          'Me contacter',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.indigo),
        ),
        const SizedBox(height: 8),
        const Text('Cliquez sur un élément pour interagir directement :'),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: const Icon(Icons.phone, color: Colors.green),
            title: const Text('Téléphone'),
            subtitle: const Text('+243 000 000 000'),
            onTap: () => _launchUrl('tel:+243000000000'),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.email, color: Colors.red),
            title: const Text('E-mail'),
            subtitle: const Text('melanie.balley@exemple.com'),
            onTap: () => _launchUrl('mailto:melanie.balley@exemple.com'),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.location_on, color: Colors.orange),
            title: const Text('Adresse'),
            subtitle: const Text('Goma, Nord-Kivu, RDC'),
            onTap: () => _launchUrl('https://maps.google.com/?q=Goma,RDC'),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.code, color: Colors.black),
            title: const Text('GitHub'),
            subtitle: const Text('github.com/MélanieBalley7-a11y'),
            onTap: () => _launchUrl('https://github.com/MélanieBalley7-a11y'),
          ),
        ),
      ],
    );
  }
}
