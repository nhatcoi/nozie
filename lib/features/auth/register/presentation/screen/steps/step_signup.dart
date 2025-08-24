import 'package:flutter/material.dart';
import '../../../../../../core/app_export.dart';

class StepSignup extends StatefulWidget {
  final Function(Map<String, dynamic>) onSignupCompleted;
  final Map<String, dynamic>? initialData;

  const StepSignup({
    super.key,
    required this.onSignupCompleted,
    this.initialData,
  });

  @override
  State<StepSignup> createState() => _StepSignupState();
}

class _StepSignupState extends State<StepSignup> {

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  Map<String, dynamic> _formData = {};
  bool _rememberMe = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _initializeForm();
    _setupFocusListeners();
  }

  void _initializeForm() {
    if (widget.initialData != null) {
      _formData = Map.from(widget.initialData!);
      _usernameController.text = _formData['username'] ?? '';
      _emailController.text = _formData['email'] ?? '';
      _passwordController.text = _formData['password'] ?? '';
      _confirmPasswordController.text = _formData['confirmPassword'] ?? '';
      _rememberMe = _formData['rememberMe'] ?? false;
    }
  }

  void _setupFocusListeners() {
    // Use post-frame callback to avoid build-time validation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _usernameController.addListener(_validateForm);
      _emailController.addListener(_validateForm);
      _passwordController.addListener(_validateForm);
      _confirmPasswordController.addListener(_validateForm);
    });
  }

  void _validateForm() {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    // Update form data
    _formData = {
      'username': username,
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
      'rememberMe': _rememberMe,
    };

    // Notify parent
    widget.onSignupCompleted(_formData);
  }

  void _toggleRememberMe(bool? value) {
    setState(() {
      _rememberMe = value ?? false;
    });
    _validateForm();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  String? _validateUsername(String? value) {
    if (value?.trim().isEmpty ?? true) {
      return context.l10n.usernameRequired;
    }
    if (value!.trim().length < 3) {
      return context.l10n.usernameMinLength;
    }
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value.trim())) {
      return context.l10n.usernameInvalidChars;
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value?.trim().isEmpty ?? true) {
      return context.l10n.emailRequired;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!.trim())) {
      return context.l10n.emailInvalid;
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value?.trim().isEmpty ?? true) {
      return context.l10n.passwordRequired;
    }
    if (value!.trim().length < 8) {
      return context.l10n.passwordMinLength;
    }
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value.trim())) {
      return context.l10n.passwordComplexity;
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value?.trim().isEmpty ?? true) {
      return context.l10n.confirmPasswordRequired;
    }
    if (value!.trim() != _passwordController.text.trim()) {
      return context.l10n.passwordsDoNotMatch;
    }
    return null;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _usernameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          
          // Title
          Text(
            context.l10n.createAnAccount,
            style: AppTypography.h3.copyWith(
              color: AppColors.getText(context),
              fontWeight: FontWeight.w600,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Subtitle
          Text(
            context.l10n.signupDescription,
            style: AppTypography.bodyLRegular.copyWith(
              color: AppColors.getTextSecondary(context),
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Form Fields
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Username Field
                  InfoField(
                    label: context.l10n.username,
                    hintText: context.l10n.enterYourUsername,
                    controller: _usernameController,
                    focusNode: _usernameFocus,
                    isRequired: true,
                    validator: _validateUsername,
                    keyboardType: TextInputType.text,
                    onSubmitted: (_) => _emailFocus.requestFocus(),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Email Field
                  InfoField(
                    label: context.l10n.email,
                    hintText: context.l10n.enterYourEmailAddress,
                    controller: _emailController,
                    focusNode: _emailFocus,
                    isRequired: true,
                    validator: _validateEmail,
                    keyboardType: TextInputType.emailAddress,
                    onSubmitted: (_) => _passwordFocus.requestFocus(),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Password Field
                  InfoField(
                    label: context.l10n.password,
                    hintText: context.l10n.enterYourPassword,
                    controller: _passwordController,
                    focusNode: _passwordFocus,
                    isRequired: true,
                    validator: _validatePassword,
                    isPassword: true,
                    onSubmitted: (_) => _confirmPasswordFocus.requestFocus(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                        color: AppColors.greyscale500,
                        size: 20,
                      ),
                      onPressed: _togglePasswordVisibility,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Confirm Password Field
                  InfoField(
                    label: context.l10n.confirmPassword,
                    hintText: context.l10n.confirmYourPassword,
                    controller: _confirmPasswordController,
                    focusNode: _confirmPasswordFocus,
                    isRequired: true,
                    validator: _validateConfirmPassword,
                    isPassword: true,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                        color: AppColors.greyscale500,
                        size: 20,
                      ),
                      onPressed: _toggleConfirmPasswordVisibility,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Remember Me Checkbox
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: _toggleRememberMe,
                        activeColor: AppColors.primary500,
                        checkColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          context.l10n.rememberMe,
                          style: AppTypography.bodyMRegular.copyWith(
                            color: AppColors.getText(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
