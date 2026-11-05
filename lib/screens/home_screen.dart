import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/elements.dart';
import '../main.dart';
import '../helpers/element_utils.dart';
import 'element_detail_screen.dart';
import 'periodic_table_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  static bool _matches(ElementData e, String q) =>
      e.name.toLowerCase().contains(q) ||
      e.symbol.toLowerCase().contains(q) ||
      e.number.toString().contains(q) ||
      e.category.toLowerCase().contains(q) ||
      e.classification.toLowerCase().contains(q) ||
      e.group.toLowerCase().contains(q);

  Future<void> _launch(String urlString) async {
    final uri = Uri.tryParse(urlString);
    if (uri != null) {
      await launchUrl(
        uri,
        mode: urlString.startsWith('mailto:')
            ? LaunchMode.platformDefault
            : LaunchMode.externalApplication,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = ElementStoreScope.of(context);
    final theme = Theme.of(context);

    final q = _query.trim().toLowerCase();
    final List<ElementData> filtered = q.isEmpty
        ? elementsData
        : elementsData.where((e) => _matches(e, q)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Periodic Table'),
        centerTitle: true,
        scrolledUnderElevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHigh,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.science,
                    size: 77,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Periodic Table',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: Text(
                'Theme',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            RadioGroup<ThemeMode>(
              groupValue: store.themeMode,
              onChanged: (val) {
                if (val != null) store.setThemeMode(val);
              },
              child: const Column(
                children: [
                  RadioListTile<ThemeMode>(
                    value: ThemeMode.system,
                    title: Text('Follow System'),
                    secondary: Icon(Icons.brightness_auto),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                  RadioListTile<ThemeMode>(
                    value: ThemeMode.light,
                    title: Text('Light'),
                    secondary: Icon(Icons.light_mode),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                  RadioListTile<ThemeMode>(
                    value: ThemeMode.dark,
                    title: Text('Dark'),
                    secondary: Icon(Icons.dark_mode),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ],
              ),
            ),
            const Divider(height: 16),
            ListTile(
              leading: const Icon(Icons.code),
              title: const Text('Source Code'),
              onTap: () =>
                  _launch('https://github.com/sidhant947/PeriodicTable'),
            ),
            ListTile(
              leading: const Icon(Icons.coffee),
              title: const Text('Buy Me a Coffee'),
              onTap: () => _launch('https://ko-fi.com/sidhant947'),
            ),
            ListTile(
              leading: const Icon(Icons.email_outlined),
              title: const Text('Report error/mistake'),
              onTap: () => _launch('mailto:sidhant947@proton.me'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PeriodicTableScreen()),
          );
        },
        icon: const Icon(Icons.grid_on),
        label: const Text('Table View'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _query = val),
              decoration: InputDecoration(
                hintText: 'Search any element...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _query = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 48,
                            color: theme.colorScheme.outline,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No elements matched the "$_query"',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    itemExtent: 72,
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final el = filtered[index];
                      final colors = getCategoryColors(
                        el.category,
                        theme.brightness,
                      );

                      return ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ElementDetailScreen(element: el),
                            ),
                          );
                        },
                        leading: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: colors.border),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${el.number}',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: colors.primary,
                                ),
                              ),
                              Text(
                                el.symbol,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: colors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        title: Text(
                          el.name,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          '${el.classification} • ${el.phase}',
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        trailing: Text(
                          el.atomicMass,
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
