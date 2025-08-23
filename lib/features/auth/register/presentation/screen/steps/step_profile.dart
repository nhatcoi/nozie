import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import '../../../../../../core/util/image_constant.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_typography.dart';
import '../../../../../../core/widgets/info_field.dart';

class StepProfile extends StatefulWidget {
  final Function(Map<String, String>) onProfileCompleted;
  final Map<String, String>? initialData;

  const StepProfile({
    super.key,
    required this.onProfileCompleted,
    this.initialData,
  });

  @override
  State<StepProfile> createState() => _StepProfileState();
}

class _StepProfileState extends State<StepProfile> {
  static const String title = 'Complete Your Profile';
  static const String subtitle = 'Don\'t worry, only you can see your personal data. No one else will be able to see it.';

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  final FocusNode _fullNameFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _dobFocus = FocusNode();
  final FocusNode _countryFocus = FocusNode();

  Map<String, String> _formData = {};
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initializeForm();
    _setupFocusListeners();
    
    // Schedule validation after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _validateForm();
    });
  }

  void _initializeForm() {
    if (widget.initialData != null) {
      _formData = Map.from(widget.initialData!);
      _fullNameController.text = _formData['fullName'] ?? '';
      _phoneController.text = _formData['phone'] ?? '';
      _dobController.text = _formData['dob'] ?? '';
      _countryController.text = _formData['country'] ?? '';
    }
  }

  void _setupFocusListeners() {
    // Use post-frame callback to avoid build-time validation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fullNameController.addListener(_validateForm);
      _phoneController.addListener(_validateForm);
      _dobController.addListener(_validateForm);
      _countryController.addListener(_validateForm);
    });
  }

  void _validateForm() {
    final fullName = _fullNameController.text.trim();
    final phone = _phoneController.text.trim();
    final dob = _dobController.text.trim();
    final country = _countryController.text.trim();

    // Update form data
    _formData = {
      'fullName': fullName,
      'phone': phone,
      'dob': dob,
      'country': country,
    };

    // Notify parent
    widget.onProfileCompleted(_formData);
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 6570)), // 18 years ago
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary500,
              onPrimary: AppColors.white,
              surface: AppColors.white,
              onSurface: AppColors.greyscale900,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      _dobController.text = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      _validateForm();
    }
  }

  Future<void> _pickImage() async {
    // Check if running on web
    if (kIsWeb) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image picker is not supported on web platform'),
            backgroundColor: AppColors.red,
          ),
        );
      }
      return;
    }

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (image != null && mounted) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      // For Simulator testing - use a placeholder image
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Using placeholder image for Simulator testing'),
            backgroundColor: AppColors.primary500,
            duration: const Duration(seconds: 2),
          ),
        );
        
        // Set a placeholder image for testing
        setState(() {
          // This will show the default avatar state
          _selectedImage = null;
        });
      }
    }
  }

  String? _validateFullName(String? value) {
    if (value?.trim().isEmpty ?? true) {
      return 'Full name is required';
    }
    if (value!.trim().length < 2) {
      return 'Full name must be at least 2 characters';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value?.trim().isEmpty ?? true) {
      return 'Phone number is required';
    }
    // Basic phone validation - can be enhanced based on requirements
    if (value!.trim().length < 10) {
      return 'Phone number must be at least 10 digits';
    }
    return null;
  }

  String? _validateDOB(String? value) {
    if (value?.trim().isEmpty ?? true) {
      return 'Date of birth is required';
    }
    return null;
  }

  String? _validateCountry(String? value) {
    if (value?.trim().isEmpty ?? true) {
      return 'Country is required';
    }
    return null;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _countryController.dispose();
    _fullNameFocus.dispose();
    _phoneFocus.dispose();
    _dobFocus.dispose();
    _countryFocus.dispose();
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
            title,
            style: AppTypography.h3.copyWith(
              color: AppColors.greyscale900,
              fontWeight: FontWeight.w600,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Subtitle
          Text(
            subtitle,
            style: AppTypography.bodyLRegular.copyWith(
              color: AppColors.greyscale900,
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Avatar Section
          Center(
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.greyscale100,
                      border: Border.all(
                        color: AppColors.primary500,
                        width: 2,
                      ),
                    ),
                    child: _selectedImage != null
                        ? ClipOval(
                            child: Image.file(
                              _selectedImage!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera_alt_outlined,
                                size: 32,
                                color: AppColors.greyscale500,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Add Photo',
                                style: AppTypography.bodySBRegular.copyWith(
                                  color: AppColors.greyscale500,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Tap to add profile picture',
                  style: AppTypography.bodySBRegular.copyWith(
                    color: AppColors.greyscale600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Form Fields
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Full Name Field
                InfoField(
                    label: 'Full Name',
                    hintText: 'Enter your full name',
                    controller: _fullNameController,
                    focusNode: _fullNameFocus,
                    isRequired: true,
                    validator: _validateFullName,
                    keyboardType: TextInputType.name,
                    onSubmitted: (_) => _phoneFocus.requestFocus(),
                   ),
                  
                  const SizedBox(height: 16),
                  
                  // Phone Number Field
                  InfoField(
                     label: 'Phone Number',
                     hintText: 'Enter your phone number',
                     controller: _phoneController,
                     focusNode: _phoneFocus,
                     isRequired: true,
                     validator: _validatePhone,
                     keyboardType: TextInputType.phone,
                     onSubmitted: (_) => _dobFocus.requestFocus(),
                   ),
                  
                  const SizedBox(height: 16),
                  
                  // Date of Birth Field
                  InfoField(
                     label: 'Date of Birth',
                     hintText: 'DD/MM/YYYY',
                     controller: _dobController,
                     focusNode: _dobFocus,
                     isRequired: true,
                     validator: _validateDOB,
                     isReadOnly: true,
                     onTap: _selectDate,
                     onSubmitted: (_) => _countryFocus.requestFocus(),
                     suffixIcon: Transform.scale(
                       scale: 0.5,
                       child: SvgPicture.asset(
                         ImageConstant.scheduleIcon,
                         colorFilter: const ColorFilter.mode(
                           AppColors.primary500,
                           BlendMode.srcIn,
                         ),
                       ),
                     ),
                   ),
                  
                  const SizedBox(height: 16),
                  
                  // Country Field
                  InfoField(
                     label: 'Country',
                     hintText: 'Enter your country',
                     controller: _countryController,
                     focusNode: _countryFocus,
                     isRequired: true,
                     validator: _validateCountry,
                     keyboardType: TextInputType.text,
                      suffixIcon: Transform.scale(
                        scale: 0.5,
                        child: SvgPicture.asset(
                          ImageConstant.toggleIcon,
                          colorFilter: const ColorFilter.mode(
                            AppColors.primary500,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
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