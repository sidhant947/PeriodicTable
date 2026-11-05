import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'helpers/element_store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final store = await ElementStore.create();
  runApp(PeriodicTableApp(store: store));
}

class PeriodicTableApp extends StatelessWidget {
  final ElementStore store;

  const PeriodicTableApp({super.key, required this.store});

  static ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF000000) : const Color(0xFFFFFFFF);
    final fg = isDark ? const Color(0xFFFFFFFF) : const Color(0xFF000000);
    final card = isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF2F2F7);
    final drawerBg = isDark ? const Color(0xFF1C1C1E) : const Color(0xFFFFFFFF);
    final high = isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA);
    final accent = isDark ? const Color(0xFF0A84FF) : const Color(0xFF007AFF);

    return ThemeData(
      brightness: brightness,
      scaffoldBackgroundColor: bg,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: accent,
        onPrimary: const Color(0xFFFFFFFF),
        primaryContainer: card,
        onPrimaryContainer: fg,
        secondary: accent,
        onSecondary: const Color(0xFFFFFFFF),
        surface: bg,
        onSurface: fg,
        surfaceContainer: card,
        surfaceContainerLow: isDark ? card : bg,
        surfaceContainerHigh: high,
        surfaceContainerHighest: card,
        onSurfaceVariant: isDark
            ? const Color(0x99FFFFFF)
            : const Color(0x99000000),
        outline: isDark ? const Color(0x4DFFFFFF) : const Color(0x4D000000),
        outlineVariant: isDark
            ? const Color(0x4DFFFFFF)
            : const Color(0x4D000000),
        error: isDark ? const Color(0xFFFF453A) : const Color(0xFFFF3B30),
        onError: const Color(0xFFFFFFFF),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        foregroundColor: fg,
        scrolledUnderElevation: 0,
      ),
      cardTheme: CardThemeData(color: card, elevation: 0),
      drawerTheme: DrawerThemeData(backgroundColor: drawerBg),
      useMaterial3: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) => ElementStoreScope(
        store: store,
        child: MaterialApp(
          title: 'Periodic Table',
          debugShowCheckedModeBanner: false,
          themeMode: store.themeMode,
          theme: _buildTheme(Brightness.light),
          darkTheme: _buildTheme(Brightness.dark),
          home: const HomeScreen(),
        ),
      ),
    );
  }
}

class ElementStoreScope extends InheritedNotifier<ElementStore> {
  const ElementStoreScope({
    super.key,
    required ElementStore store,
    required super.child,
  }) : super(notifier: store);

  static ElementStore of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<ElementStoreScope>()!
      .notifier!;
}
