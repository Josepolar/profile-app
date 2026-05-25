import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:profile_app/models/user_model.dart';
import 'package:profile_app/services/storage_service.dart';
import 'package:profile_app/services/user_service.dart';
import 'package:profile_app/utils/constants.dart';
import 'package:profile_app/utils/messages.dart';
import 'package:profile_app/utils/validators.dart';
import 'package:profile_app/widgets/custom_button.dart';
import 'package:profile_app/widgets/custom_textfield.dart';
import 'package:profile_app/widgets/profile_avatar.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;

  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _fullNameController;
  late final TextEditingController _usernameController;
  late final TextEditingController _emailController;
  late final TextEditingController _bioController;
  late final TextEditingController _phoneController;

  final _userService = UserService();
  final _storageService = StorageService();
  final _imagePicker = ImagePicker();

  File? _selectedImage;
  String _photoUrl = '';
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _photoUrl = widget.user.photoUrl;
    _fullNameController = TextEditingController(text: widget.user.fullName);
    _usernameController = TextEditingController(text: widget.user.username);
    _emailController = TextEditingController(text: widget.user.email);
    _bioController = TextEditingController(text: widget.user.bio);
    _phoneController = TextEditingController(text: widget.user.phone);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Error'),
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

  Future<void> _pickImage() async {
    try {
      final picked = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (picked != null) {
        setState(() {
          _selectedImage = File(picked.path);
        });
      }
    } catch (_) {
      _showError('Could not pick image. Please try again.');
    }
  }

  Future<void> _saveProfile() async {
    final nameError =
        Validators.required(_fullNameController.text, 'Full name');
    final usernameError = Validators.username(_usernameController.text);
    final emailError = Validators.email(_emailController.text);

    final firstError = nameError ?? usernameError ?? emailError;
    if (firstError != null) {
      showErrorMessage(context, firstError);
      return;
    }

    setState(() => _isSaving = true);

    try {
      var photoUrl = _photoUrl;

      if (_selectedImage != null) {
        photoUrl = await _storageService.uploadProfileImage(
          uid: widget.user.uid,
          imageFile: _selectedImage!,
        );
      }

      final updatedUser = widget.user.copyWith(
        fullName: _fullNameController.text.trim(),
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        bio: _bioController.text.trim(),
        phone: _phoneController.text.trim(),
        photoUrl: photoUrl,
      );

      await _userService.updateUser(updatedUser);

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        _showError('Failed to save profile. Please try again.');
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppColors.background,
        border: null,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _isSaving ? null : () => Navigator.pop(context),
          child: const Icon(CupertinoIcons.back),
        ),
        middle: const Text(
          AppStrings.editProfileTitle,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              Center(
                child: ProfileAvatar(
                  photoUrl: _photoUrl,
                  localImage: _selectedImage,
                  size: 120,
                  showEditBadge: true,
                  onTap: _isSaving ? null : _pickImage,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                'Tap to change photo',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              CustomTextField(
                controller: _fullNameController,
                label: 'Full Name',
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(
                controller: _usernameController,
                label: 'Username',
              ),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(
                controller: _emailController,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(
                controller: _phoneController,
                label: 'Phone',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(
                controller: _bioController,
                label: 'Bio',
                maxLines: 4,
              ),
              const SizedBox(height: AppSpacing.xl),
              CustomButton(
                label: 'Save Changes',
                isLoading: _isSaving,
                onPressed: _saveProfile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
