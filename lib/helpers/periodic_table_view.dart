import 'package:flutter/material.dart';

import '../data/elements.dart';
import 'element_utils.dart';
import '../screens/element_detail_screen.dart';

class PeriodicTableView extends StatelessWidget {
  const PeriodicTableView({super.key});

  static (int, int) _getCoords(int z) => switch (z) {
    1 => (0, 0),
    2 => (0, 17),
    >= 3 && <= 4 => (1, z - 3),
    >= 5 && <= 10 => (1, z + 7),
    >= 11 && <= 12 => (2, z - 11),
    >= 13 && <= 18 => (2, z - 1),
    >= 19 && <= 36 => (3, z - 19),
    >= 37 && <= 54 => (4, z - 37),
    55 => (5, 0),
    56 => (5, 1),
    >= 57 && <= 71 => (8, z - 54),
    >= 72 && <= 86 => (5, z - 69),
    87 => (6, 0),
    88 => (6, 1),
    >= 89 && <= 103 => (9, z - 86),
    _ => (6, z - 101),
  };

  static final Map<(int, int), ElementData> _elementGrid = {
    for (final el in elementsData) _getCoords(el.number): el,
  };

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      constrained: false,
      boundaryMargin: const EdgeInsets.all(32),
      minScale: 0.3,
      maxScale: 2.5,
      child: RepaintBoundary(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(10, (row) {
              if (row == 7) {
                return const SizedBox(height: 16);
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: List.generate(18, (col) {
                    final el = _elementGrid[(row, col)];
                    final Widget cell = switch ((row, col)) {
                      _ when el != null => _TableElementCell(element: el),
                      (5, 2) => const _TablePlaceholderCell(
                        range: '57-71',
                        label: 'La-Lu',
                      ),
                      (6, 2) => const _TablePlaceholderCell(
                        range: '89-103',
                        label: 'Ac-Lr',
                      ),
                      _ => const SizedBox(width: 58, height: 58),
                    };

                    return Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: cell,
                    );
                  }),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _TableElementCell extends StatelessWidget {
  final ElementData element;

  const _TableElementCell({required this.element});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = getCategoryColors(element.category, theme.brightness);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ElementDetailScreen(element: element),
          ),
        );
      },
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          color: colors.background,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: colors.border),
        ),
        padding: const EdgeInsets.all(2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${element.number}',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: colors.primary,
              ),
            ),
            Text(
              element.symbol,
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: colors.primary,
              ),
            ),
            FittedBox(
              child: Text(
                element.name,
                style: TextStyle(
                  fontSize: 8,
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TablePlaceholderCell extends StatelessWidget {
  final String range;
  final String label;

  const _TablePlaceholderCell({required this.range, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      padding: const EdgeInsets.all(2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            range,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
