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
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _api = ApiService();
  bool _loading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final result = await _api.seConnecter(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (!mounted) return;

      if (result['success'] == true) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeShell()),
        );
      } else {
        setState(() {
          _errorMessage = result['message']?.toString() ?? 'Connexion refusee';
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Erreur : $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  void _enterDirectly() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeShell()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connexion - CV Melanie Balley')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(Icons.account_circle, size: 56, color: Colors.indigo),
                    const SizedBox(height: 12),
                    const Text(
                      'Bienvenue',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 14),
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
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _loading ? null : _login,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(_loading ? 'Connexion...' : 'Se connecter'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: _enterDirectly,
                      child: const Text('Continuer directement vers le CV et la famille'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 1;

  void _logout() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      const CvProfileTab(),
      const FamilyCrudTab(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_currentIndex == 0 ? 'Mon CV' : 'Membres de famille'),
        actions: [
          IconButton(
            tooltip: 'Deconnexion',
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.badge), label: 'CV'),
          NavigationDestination(icon: Icon(Icons.family_restroom), label: 'Famille'),
        ],
      ),
    );
  }
}

class CvProfileTab extends StatelessWidget {
  const CvProfileTab({super.key});

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

  Future<void> _reload() async {
    final nextFuture = _api.getFamilyMembers();
    setState(() {
      _membersFuture = nextFuture;
    });
    await nextFuture;
  }

  Future<void> _openMemberForm({Map<String, dynamic>? member}) async {
    final isEdit = member != null;
    final nomCtrl = TextEditingController(text: member?['nom']?.toString() ?? '');
    final postnomCtrl = TextEditingController(text: member?['postnom']?.toString() ?? '');
    final prenomCtrl = TextEditingController(text: member?['prenom']?.toString() ?? '');
    final lieuCtrl = TextEditingController(text: member?['lieu_naissance']?.toString() ?? '');
    final dateCtrl = TextEditingController(text: member?['date_naissance']?.toString() ?? '');
    final parenteCtrl = TextEditingController(text: member?['parente']?.toString() ?? '');
    bool saving = false;
    String? formError;

    await showDialog<void>(
      context: context,
      barrierDismissible: !saving,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            Future<void> submit() async {
              setDialogState(() {
                saving = true;
                formError = null;
              });

              try {
                if (isEdit) {
                  final rawId = member['id'];
                  final id = rawId is int ? rawId : int.tryParse(rawId.toString()) ?? 0;
                  await _api.modifierMembre(
                    id: id,
                    nom: nomCtrl.text.trim(),
                    postnom: postnomCtrl.text.trim(),
                    prenom: prenomCtrl.text.trim(),
                    lieuNaissance: lieuCtrl.text.trim(),
                    dateNaissance: dateCtrl.text.trim(),
                    parente: parenteCtrl.text.trim(),
                  );
                } else {
                  await _api.ajouterMembre(
                    nom: nomCtrl.text.trim(),
                    postnom: postnomCtrl.text.trim(),
                    prenom: prenomCtrl.text.trim(),
                    lieuNaissance: lieuCtrl.text.trim(),
                    dateNaissance: dateCtrl.text.trim(),
                    parente: parenteCtrl.text.trim(),
                  );
                }

                await _reload();
                if (!ctx.mounted) return;
                Navigator.of(ctx).pop();
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isEdit ? 'Membre modifie avec succes.' : 'Membre enregistre avec succes.',
                    ),
                  ),
                );
              } catch (e) {
                setDialogState(() {
                  saving = false;
                  formError = e.toString();
                });
              }
            }

            return AlertDialog(
              title: Text(isEdit ? 'Modifier un membre' : 'Ajouter un membre'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nomCtrl,
                      decoration: const InputDecoration(labelText: 'Nom'),
                    ),
                    TextField(
                      controller: postnomCtrl,
                      decoration: const InputDecoration(labelText: 'Postnom'),
                    ),
                    TextField(
                      controller: prenomCtrl,
                      decoration: const InputDecoration(labelText: 'Prenom'),
                    ),
                    TextField(
                      controller: lieuCtrl,
                      decoration: const InputDecoration(labelText: 'Lieu de naissance'),
                    ),
                    TextField(
                      controller: dateCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Date de naissance (AAAA-MM-JJ)',
                        hintText: '2000-08-15',
                      ),
                    ),
                    TextField(
                      controller: parenteCtrl,
                      decoration: const InputDecoration(labelText: 'Parente'),
                    ),
                    if (formError != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        formError!,
                        style: const TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: saving ? null : () => Navigator.of(ctx).pop(),
                  child: const Text('Annuler'),
                ),
                ElevatedButton(
                  onPressed: saving ? null : submit,
                  child: Text(saving ? 'Enregistrement...' : 'Enregistrer'),
                ),
              ],
            );
          },
        );
      },
    );

    nomCtrl.dispose();
    postnomCtrl.dispose();
    prenomCtrl.dispose();
    lieuCtrl.dispose();
    dateCtrl.dispose();
    parenteCtrl.dispose();
  }

  Future<void> _deleteMember(Map<String, dynamic> member) async {
    final rawId = member['id'];
    final id = rawId is int ? rawId : int.tryParse(rawId.toString()) ?? 0;
    try {
      await _api.supprimerMembre(id);
      await _reload();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Membre supprime.')),
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
      body: RefreshIndicator(
        onRefresh: _reload,
        child: FutureBuilder<List<dynamic>>(
          future: _membersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Erreur : ${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: _reload,
                        child: const Text('Reessayer'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final items = snapshot.data ?? [];
            if (items.isEmpty) {
              return const Center(child: Text('Aucun membre de famille trouve.'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = Map<String, dynamic>.from(items[index] as Map);
                final nomStr = (item['nom'] ?? '').toString().trim();
                final postnomStr = (item['postnom'] ?? '').toString().trim();
                final prenomStr = (item['prenom'] ?? '').toString().trim();
                final fullName = [nomStr, postnomStr, prenomStr]
                    .where((s) => s.isNotEmpty)
                    .join(' ');
                final parente = (item['parente'] ?? '').toString().trim();
                final lieu = (item['lieu_naissance'] ?? '').toString().trim();
                final dateN = (item['date_naissance'] ?? '').toString().trim();

                return Card(
                  child: ListTile(
                    title: Text(
                      fullName.isEmpty ? 'Membre #${item['id'] ?? ''}' : fullName,
                    ),
                    subtitle: Text(
                      [
                        if (parente.isNotEmpty) 'Parente : $parente',
                        if (lieu.isNotEmpty) 'Lieu : $lieu',
                        if (dateN.isNotEmpty) 'Date : $dateN',
                      ].join(' | '),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: 'Modifier',
                          icon: const Icon(Icons.edit),
                          onPressed: () => _openMemberForm(member: item),
                        ),
                        IconButton(
                          tooltip: 'Supprimer',
                          icon: const Icon(Icons.delete, color: Colors.red),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openMemberForm(),
        icon: const Icon(Icons.add),
        label: const Text('Ajouter'),
      ),
    );
  }
}