import 'package:flutter/material.dart';

class FamilyMember {
  final String name;
  final String relation;
  final String job;
  final String image;

  const FamilyMember({
    required this.name,
    required this.relation,
    required this.job,
    required this.image,
  });
}

class FamilyPage extends StatelessWidget {
  const FamilyPage({super.key});

  static const List<FamilyMember> familyMembers = [
    FamilyMember(
      name: 'Papa Balyahamwabo',
      relation: 'Père',
      job: 'Ingénieur / Entrepreneur',
      image: 'assets/images/pere.jpg',
    ),
    FamilyMember(
      name: 'Maman Balyahamwabo',
      relation: 'Mère',
      job: 'Commerçante',
      image: 'assets/images/mere.jpg',
    ),
    FamilyMember(
      name: 'Sœur Balyahamwabo',
      relation: 'Sœur',
      job: 'Étudiante',
      image: 'assets/images/soeur.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: familyMembers.length,
      itemBuilder: (context, index) {
        final member = familyMembers[index];
        return Card(
          elevation: 3,
          margin: const EdgeInsets.only(bottom: 16.0),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(member.image),
            ),
            title: Text(
              member.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Text('${member.relation} • ${member.job}'),
          ),
        );
      },
    );
  }
}
