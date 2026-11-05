import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/elements.dart';
import '../helpers/element_utils.dart';

class ElementDetailScreen extends StatelessWidget {
  final ElementData element;

  const ElementDetailScreen({super.key, required this.element});

  Future<void> _openWiki() async {
    final uri = Uri.tryParse(element.wikilink);
    if (uri != null) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final catColor = getCategoryColor(element.category, theme.brightness);
    final phaseIcon = getPhaseIcon(element.phase);

    final physicalProperties = [
      ('Appearance', element.appearance),
      ('Phase at STP', element.phase),
      ('Density', element.density),
      ('Melting Point', element.meltingPoint),
      ('Boiling Point', element.boilingPoint),
    ];

    final atomicProperties = [
      ('Classification', element.classification),
      ('Category', element.category),
      ('Chemical Group', element.group),
      ('Electron Configuration', element.electronConfig),
      ('Electronegativity', element.electronegativity),
      ('Orbital Block', element.block),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(element.name),
        centerTitle: true,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: catColor, width: 1.5),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: catColor),
                      ),
                      child: Text(
                        'No. ${element.number}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: catColor,
                        ),
                      ),
                    ),
                    Text(
                      element.atomicMass,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  element.symbol,
                  style: TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                    color: catColor,
                    letterSpacing: -1,
                  ),
                ),
                Text(
                  element.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  alignment: WrapAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: catColor),
                      ),
                      child: Text(
                        element.classification,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: catColor,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: catColor),
                      ),
                      child: Text(
                        element.category,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: catColor,
                        ),
                      ),
                    ),
                    if (element.phase.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              phaseIcon,
                              size: 14,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              element.phase,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _QuickFactCard(
                  icon: phaseIcon,
                  title: 'State',
                  value: element.phase.isEmpty ? 'Unknown' : element.phase,
                  color: catColor,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _QuickFactCard(
                  icon: Icons.layers_outlined,
                  title: 'Block',
                  value: element.block.isEmpty ? 'Unknown' : element.block,
                  color: catColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _QuickFactCard(
            icon: Icons.calendar_today_outlined,
            title: 'Discovered',
            value: element.year.isEmpty ? 'Antiquity' : element.year,
            color: catColor,
          ),
          const SizedBox(height: 8),
          _QuickFactCard(
            icon: Icons.person_outline,
            title: 'Discoverer',
            value: element.discoveredBy.isEmpty
                ? 'Unknown'
                : element.discoveredBy,
            color: catColor,
            maxLines: 3,
          ),
          if (element.summary.isNotEmpty) ...[
            const SizedBox(height: 20),
            _SectionHeader(
              icon: Icons.menu_book_rounded,
              title: 'About ${element.name}',
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 0,
              color: theme.colorScheme.surfaceContainerHighest,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  element.summary,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.6,
                    fontSize: 14.5,
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 20),
          _SectionHeader(
            icon: Icons.science_outlined,
            title: 'Physical Properties',
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            color: theme.colorScheme.surfaceContainerHighest,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Column(
                children: [
                  for (final (label, value) in physicalProperties)
                    if (value.isNotEmpty && !value.startsWith('---'))
                      _PropertyRow(label: label, value: value),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          _SectionHeader(
            icon: Icons.bubble_chart_outlined,
            title: 'Atomic & Chemical Structure',
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            color: theme.colorScheme.surfaceContainerHighest,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Column(
                children: [
                  for (final (label, value) in atomicProperties)
                    if (value.isNotEmpty && !value.startsWith('---'))
                      _PropertyRow(label: label, value: value),
                ],
              ),
            ),
          ),
          if (element.wikilink.isNotEmpty) ...[
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _openWiki,
                icon: const Icon(Icons.open_in_new),
                label: const Text('Read More'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _QuickFactCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;
  final int? maxLines;

  const _QuickFactCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  value,
                  maxLines: maxLines,
                  overflow: maxLines != null ? TextOverflow.ellipsis : null,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
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

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _PropertyRow extends StatelessWidget {
  final String label;
  final String value;

  const _PropertyRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
