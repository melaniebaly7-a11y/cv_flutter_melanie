import 'package:flutter/material.dart';
import 'services/api_service.dart';

void main() {
  runApp(const CvMelanieApp());
}

class CvMelanieApp extends StatelessWidget {
  const CvMelanieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CV Melanie Balley',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _api = ApiService();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final Map<String, dynamic> result = await _api.seConnecter(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (!mounted) return;

      final bool success = result['success'] == true || result['status'] == 'success';
      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeHubScreen()),
        );
      } else {
        setState(() {
          _errorMessage = (result['message'] ?? 'Identifiants invalides').toString();
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Erreur de connexion : $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connexion - CV Melanie')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Melanie Balley',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Connectez-vous pour acceder au CV et a la gestion familiale',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Mot de passe',
                    border: OutlineInputBorder(),
                  ),
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _errorMessage!,
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ],
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Se connecter'),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeHubScreen()),
                    );
                  },
                  child: const Text('Continuer directement vers le CV et la famille'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeHubScreen extends StatefulWidget {
  const HomeHubScreen({super.key});

  @override
  State<HomeHubScreen> createState() => _HomeHubScreenState();
}

class _HomeHubScreenState extends State<HomeHubScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const CvOverviewTab(),
      const FamilyCrudTab(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_currentIndex == 0 ? 'Mon CV' : 'Membres de famille'),
        actions: [
          IconButton(
            tooltip: 'Deconnexion',
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.badge), label: 'CV'),
          NavigationDestination(icon: Icon(Icons.family_restroom), label: 'Famille'),
        ],
      ),
    );
  }
}

class CvOverviewTab extends StatelessWidget {
  const CvOverviewTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: const [
        Card(
          child: ListTile(
            leading: Icon(Icons.person, size: 36),
            title: Text('Melanie Balley'),
            subtitle: Text('Developpement Web, Mobile & Logiciel'),
          ),
        ),
        SizedBox(height: 12),
        Card(
          child: ListTile(
            leading: Icon(Icons.code),
            title: Text('Competences techniques'),
            subtitle: Text('Flutter, Dart, PHP / MySQL, Python, Next.js, Git'),
          ),
        ),
        SizedBox(height: 12),
        Card(
          child: ListTile(
            leading: Icon(Icons.school),
            title: Text('Formation & Projets'),
            subtitle: Text('Applications mobiles, web et bases de donnees relationnelles'),
          ),
        ),
      ],
    );
  }
}

class FamilyCrudTab extends StatefulWidget {
  const FamilyCrudTab({super.key});

  @override
  State<FamilyCrudTab> createState() => _FamilyCrudTabState();
}

class _FamilyCrudTabState extends State<FamilyCrudTab> {
  final _api = ApiService();
  late Future<List<dynamic>> _membersFuture;

  @override
  void initState() {
    super.initState();
    _membersFuture = _api.getFamilyMembers();
  }

  Future<void> _refreshMembers() async {
    setState(() {
      _membersFuture = _api.getFamilyMembers();
    });
  }

  Future<void> _openMemberDialog({Map<String, dynamic>? existing}) async {
    final nomCtrl = TextEditingController(text: existing?['nom']?.toString() ?? '');
    final postnomCtrl = TextEditingController(text: existing?['postnom']?.toString() ?? '');
    final prenomCtrl = TextEditingController(text: existing?['prenom']?.toString() ?? '');
    final lieuCtrl = TextEditingController(
      text: existing?['lieu_naissance']?.toString() ?? existing?['lieuNaissance']?.toString() ?? '',
    );
    final dateCtrl = TextEditingController(
      text: existing?['date_naissance']?.toString() ?? existing?['dateNaissance']?.toString() ?? '',
    );
    final parenteCtrl = TextEditingController(text: existing?['parente']?.toString() ?? '');

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(existing == null ? 'Ajouter un membre' : 'Modifier un membre'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nomCtrl, decoration: const InputDecoration(labelText: 'Nom')),
              TextField(controller: postnomCtrl, decoration: const InputDecoration(labelText: 'Postnom')),
              TextField(controller: prenomCtrl, decoration: const InputDecoration(labelText: 'Prenom')),
              TextField(controller: lieuCtrl, decoration: const InputDecoration(labelText: 'Lieu de naissance')),
              TextField(
                controller: dateCtrl,
                decoration: const InputDecoration(labelText: 'Date de naissance (AAAA-MM-JJ)'),
              ),
              TextField(controller: parenteCtrl, decoration: const InputDecoration(labelText: 'Parente')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Annuler')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Enregistrer')),
        ],
      ),
    );

    if (saved != true || !mounted) return;

    try {
      if (existing == null) {
        await _api.ajouterMembre(
          nom: nomCtrl.text.trim(),
          postnom: postnomCtrl.text.trim(),
          prenom: prenomCtrl.text.trim(),
          lieuNaissance: lieuCtrl.text.trim(),
          dateNaissance: dateCtrl.text.trim(),
          parente: parenteCtrl.text.trim(),
        );
      } else {
        final rawId = existing['id'];
        final id = rawId is int ? rawId : int.parse(rawId.toString());
        await _api.modifierMembre(
          id: id,
          nom: nomCtrl.text.trim(),
          postnom: postnomCtrl.text.trim(),
          prenom: prenomCtrl.text.trim(),
          lieuNaissance: lieuCtrl.text.trim(),
          dateNaissance: dateCtrl.text.trim(),
          parente: parenteCtrl.text.trim(),
        );
      }

      if (!mounted) return;
      await _refreshMembers();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(existing == null ? 'Membre ajoute' : 'Membre modifie')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : $e')),
      );
    }
  }

  Future<void> _deleteMember(Map<String, dynamic> member) async {
    final rawId = member['id'];
    final id = rawId is int ? rawId : int.tryParse(rawId.toString());
    if (id == null) return;

    try {
      await _api.supprimerMembre(id);
      if (!mounted) return;
      await _refreshMembers();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Membre supprime')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur suppression : $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openMemberDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Ajouter'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshMembers,
        child: FutureBuilder<List<dynamic>>(
          future: _membersFuture,
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Erreur : ${snapshot.error}'),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: _refreshMembers,
                        child: const Text('Reessayer'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final members = snapshot.data ?? [];
            if (members.isEmpty) {
              return const Center(child: Text('Aucun membre de famille trouve.'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: members.length,
              itemBuilder: (context, index) {
                final item = Map<String, dynamic>.from(members[index] as Map);
                final fullName = '  '.trim();
                final parente = (item['parente'] ?? '').toString();
                final lieu = (item['lieu_naissance'] ?? '').toString();
                final dateN = (item['date_naissance'] ?? '').toString();

                return Card(
                  child: ListTile(
                    title: Text(fullName.isEmpty ? 'Membre #' : fullName),
                    subtitle: Text(
                      [
                        if (parente.isNotEmpty) 'Parente : ',
                        if (lieu.isNotEmpty || dateN.isNotEmpty) ' - ',
                      ].join(' | '),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: 'Modifier',
                          icon: const Icon(Icons.edit),
                          onPressed: () => _openMemberDialog(existing: item),
                        ),
                        IconButton(
                          tooltip: 'Supprimer',
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteMember(item),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
