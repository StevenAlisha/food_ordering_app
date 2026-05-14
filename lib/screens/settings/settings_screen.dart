import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../utils/app_state.dart';

/// Settings screen — theme toggle, notification toggle, about, and more.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.paddingMD),
        children: [
          // ── Appearance ──
          Text('Appearance', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Card(
            child: SwitchListTile(
              secondary: const Icon(Icons.dark_mode_rounded),
              title: const Text('Dark Mode'),
              subtitle: Text(state.isDarkMode ? 'On' : 'Off'),
              value: state.isDarkMode,
              activeTrackColor: AppColors.primary,
              onChanged: (_) => state.toggleTheme(),
            ),
          ),
          const SizedBox(height: 16),

          // ── Notifications ──
          Text('Notifications', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Card(
            child: SwitchListTile(
              secondary: const Icon(Icons.notifications_rounded),
              title: const Text('Push Notifications'),
              subtitle: Text(_notificationsEnabled ? 'Enabled' : 'Disabled'),
              value: _notificationsEnabled,
              activeTrackColor: AppColors.primary,
              onChanged: (val) => setState(() => _notificationsEnabled = val),
            ),
          ),
          const SizedBox(height: 16),

          // ── Language ──
          Text('Language', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.language_rounded),
              title: const Text('Language'),
              subtitle: Text(_selectedLanguage),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => SimpleDialog(
                    title: const Text('Select Language'),
                    children: ['English', 'Arabic', 'French', 'Spanish'].map((lang) {
                      return SimpleDialogOption(
                        onPressed: () {
                          setState(() => _selectedLanguage = lang);
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Language set to $lang')),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(lang, style: const TextStyle(fontSize: 16)),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // ── About ──
          Text('About', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline_rounded),
                  title: const Text('About ${AppConstants.appName}'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => _showAboutDialog(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: const Text('Privacy Policy'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Privacy Policy page coming soon')),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: const Text('Terms of Service'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Terms of Service page coming soon')),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // App version
          Center(
            child: Text(
              '${AppConstants.appName} v1.0.0',
              style: theme.textTheme.bodySmall,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.restaurant_menu_rounded, color: AppColors.primary),
            const SizedBox(width: 8),
            const Text(AppConstants.appName),
          ],
        ),
        content: const Text(
          '${AppConstants.appName} is a modern food delivery app that lets you browse, order, and track delicious meals from top restaurants near you.\n\nVersion 1.0.0\n© 2026 ${AppConstants.appName}',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }
}
