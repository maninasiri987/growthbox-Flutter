import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/auth_provider.dart';
import 'logo_widget.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showLogo;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showLogo = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return AppBar(
      title: showLogo
          ? const LogoWidget(size: 32, showText: true)
          : Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
      actions: [
        IconButton(
          icon: Icon(
            isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            color: isDark ? Colors.amberAccent : Colors.grey[800],
          ),
          onPressed: () => themeProvider.toggleTheme(),
          tooltip: isDark ? 'Switch to Light mode' : 'Switch to Dark mode',
        ),
        if (actions != null) ...actions!,
        const SizedBox(width: 8),
      ],
    );
  }
}
