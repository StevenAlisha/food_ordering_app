import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/user_model.dart';
import '../../utils/app_state.dart';
import '../../utils/routes.dart';

/// Profile screen — avatar, user info, order history, settings link.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    final theme = Theme.of(context);
    final user = state.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () => Navigator.pushNamed(context, Routes.settings),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMD),
        child: Column(
          children: [
            // ── Avatar & Info ──
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(user.avatarUrl),
              onBackgroundImageError: (_, __) {},
              child: const Icon(Icons.person, size: 50),
            ),
            const SizedBox(height: 16),
            Text(user.name, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 4),
            Text(user.email, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 24),

            // ── Edit Profile ──
            Card(
              child: ListTile(
                leading: const Icon(Icons.edit_rounded, color: AppColors.primary),
                title: const Text('Edit Profile'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => _showEditProfile(context, state, user),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.location_on_rounded, color: AppColors.primary),
                title: const Text('Address'),
                subtitle: Text(user.address, maxLines: 1, overflow: TextOverflow.ellipsis),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {},
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.phone_rounded, color: AppColors.primary),
                title: const Text('Phone'),
                subtitle: Text(user.phone),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {},
              ),
            ),
            const SizedBox(height: 24),

            // ── Order History ──
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Order History', style: theme.textTheme.titleLarge),
            ),
            const SizedBox(height: 12),
            if (state.orders.isEmpty)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Text('No orders yet'),
              )
            else
              ...state.orders.map((order) => Card(
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.receipt_long_rounded, color: AppColors.primary),
                  ),
                  title: Text(order.id, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('${order.items.length} items  •  \$${order.total.toStringAsFixed(2)}'),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: order.status.index == 3 ? AppColors.success.withValues(alpha: 0.1) : AppColors.accent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      order.statusLabel,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: order.status.index == 3 ? AppColors.success : AppColors.accent,
                      ),
                    ),
                  ),
                  onTap: () => Navigator.pushNamed(context, Routes.orderTracking, arguments: order.id),
                ),
              )),
            const SizedBox(height: 24),

            // ── Logout ──
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, Routes.login, (_) => false);
                },
                icon: const Icon(Icons.logout_rounded, color: AppColors.error),
                label: const Text('Logout', style: TextStyle(color: AppColors.error)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.error),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  /// Shows a bottom sheet to edit profile info.
  void _showEditProfile(BuildContext context, AppStateData state, UserModel user) {
    final nameCtrl = TextEditingController(text: user.name);
    final phoneCtrl = TextEditingController(text: user.phone);
    final addressCtrl = TextEditingController(text: user.address);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Edit Profile', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
              const SizedBox(height: 20),
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person_outline))),
              const SizedBox(height: 12),
              TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'Phone', prefixIcon: Icon(Icons.phone_outlined))),
              const SizedBox(height: 12),
              TextField(controller: addressCtrl, decoration: const InputDecoration(labelText: 'Address', prefixIcon: Icon(Icons.location_on_outlined))),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    state.updateUser(UserModel(
                      name: nameCtrl.text,
                      email: user.email,
                      phone: phoneCtrl.text,
                      avatarUrl: user.avatarUrl,
                      address: addressCtrl.text,
                    ));
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile updated!')),
                    );
                  },
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
