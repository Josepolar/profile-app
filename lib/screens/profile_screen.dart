import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:profile_app/models/user_model.dart';
import 'package:profile_app/screens/edit_profile_screen.dart';
import 'package:profile_app/screens/login_screen.dart';
import 'package:profile_app/services/auth_service.dart';
import 'package:profile_app/services/user_service.dart';
import 'package:profile_app/utils/constants.dart';
import 'package:profile_app/widgets/custom_button.dart';
import 'package:profile_app/widgets/loading_indicator.dart';
import 'package:profile_app/widgets/profile_avatar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authService = AuthService();
  final _userService = UserService();
  bool _isLoggingOut = false;

  Future<void> _logout() async {
    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isLoggingOut = true);

    try {
      await _authService.logout();
      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        CupertinoPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    } catch (_) {
      if (mounted) {
        _showMessage('Failed to log out. Please try again.');
      }
    } finally {
      if (mounted) setState(() => _isLoggingOut = false);
    }
  }

  void _showMessage(String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _openEditProfile(UserModel user) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (_) => EditProfileScreen(user: user),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const CupertinoPageScaffold(
        child: Center(child: LoadingIndicator()),
      );
    }

    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppColors.background,
        border: null,
        middle: const Text(
          AppStrings.profileTitle,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _isLoggingOut ? null : _logout,
          child: _isLoggingOut
              ? const LoadingIndicator(size: 20)
              : const Text(
                  'Log Out',
                  style: TextStyle(
                    color: AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
      child: SafeArea(
        child: StreamBuilder<UserModel?>(
          stream: _userService.streamUser(uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: LoadingIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Failed to load profile',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              );
            }

            final user = snapshot.data;
            if (user == null) {
              return const Center(
                child: Text('Profile not found'),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  const SizedBox(height: AppSpacing.md),
                  ProfileAvatar(
                    photoUrl: user.photoUrl,
                    size: 140,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    user.fullName.isNotEmpty ? user.fullName : 'No name',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (user.username.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '@${user.username}',
                      style: const TextStyle(
                        fontSize: 17,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.xl),
                  _ProfileInfoCard(user: user),
                  const SizedBox(height: AppSpacing.lg),
                  CustomButton(
                    label: 'Edit Profile',
                    onPressed: () => _openEditProfile(user),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ProfileInfoCard extends StatelessWidget {
  final UserModel user;

  const _ProfileInfoCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _InfoRow(
            icon: CupertinoIcons.mail_solid,
            label: 'Email',
            value: user.email,
          ),
          _divider(),
          _InfoRow(
            icon: CupertinoIcons.phone_fill,
            label: 'Phone',
            value: user.phone.isNotEmpty ? user.phone : 'Not set',
          ),
          _divider(),
          _InfoRow(
            icon: CupertinoIcons.text_quote,
            label: 'Bio',
            value: user.bio.isNotEmpty ? user.bio : 'Not set',
            multiline: true,
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      height: 0.5,
      margin: const EdgeInsets.only(left: 52),
      color: AppColors.divider,
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool multiline;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.multiline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      child: Row(
        crossAxisAlignment:
            multiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 17,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: multiline ? null : 1,
                  overflow: multiline ? null : TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
