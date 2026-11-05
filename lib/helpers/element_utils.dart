import 'package:flutter/material.dart';

class CategoryColors {
  final Color primary;
  final Color background;
  final Color border;

  const CategoryColors({
    required this.primary,
    required this.background,
    required this.border,
  });

  factory CategoryColors.fromPrimary(Color primary) {
    final rgb = primary.toARGB32() & 0x00FFFFFF;
    return CategoryColors(
      primary: primary,
      background: Color(0x26000000 | rgb),
      border: Color(0x66000000 | rgb),
    );
  }
}

const _categoryPalette = <String, (Color, Color)>{
  'Alkali Metal': (Color(0xFFDC2626), Color(0xFFF87171)),
  'Alkaline Earth Metal': (Color(0xFFD97706), Color(0xFFFBBF24)),
  'Transition Metal': (Color(0xFF2563EB), Color(0xFF60A5FA)),
  'Post-Transition Metal': (Color(0xFF0D9488), Color(0xFF2DD4BF)),
  'Metalloid': (Color(0xFF65A30D), Color(0xFFA3E635)),
  'Reactive Non-Metal': (Color(0xFF16A34A), Color(0xFF4ADE80)),
  'Non-Metal': (Color(0xFF16A34A), Color(0xFF4ADE80)),
  'Noble Gas': (Color(0xFF7C3AED), Color(0xFFA78BFA)),
  'Lanthanide': (Color(0xFFBE185D), Color(0xFFF472B6)),
  'Actinide': (Color(0xFF9F1239), Color(0xFFFB7185)),
};

CategoryColors getCategoryColors(String category, Brightness brightness) {
  final (light, dark) =
      _categoryPalette[category] ??
      const (Color(0xFF475569), Color(0xFF94A3B8));
  return CategoryColors.fromPrimary(
    brightness == Brightness.dark ? dark : light,
  );
}

Color getCategoryColor(String category, Brightness brightness) =>
    getCategoryColors(category, brightness).primary;

IconData getPhaseIcon(String phase) => switch (phase.toLowerCase()) {
  'gas' => Icons.air,
  'liquid' => Icons.water_drop_outlined,
  'solid' => Icons.terrain_outlined,
  _ => Icons.science_outlined,
};
