import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import '../../../../../../core/app_export.dart';
import '../../../../../../core/utils/validation_utils.dart';

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
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  final FocusNode _fullNameFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _dobFocus = FocusNode();

  Map<String, String> _formData = {};
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  // Countries data
  final List<DropdownItem> _countries = [
    DropdownItem(value: 'vn', label: 'Vietnam'),
    DropdownItem(value: 'us', label: 'United States'),
    DropdownItem(value: 'uk', label: 'United Kingdom'),
    DropdownItem(value: 'ca', label: 'Canada'),
    DropdownItem(value: 'au', label: 'Australia'),
    DropdownItem(value: 'de', label: 'Germany'),
    DropdownItem(value: 'fr', label: 'France'),
    DropdownItem(value: 'jp', label: 'Japan'),
    DropdownItem(value: 'kr', label: 'South Korea'),
    DropdownItem(value: 'cn', label: 'China'),
    DropdownItem(value: 'in', label: 'India'),
    DropdownItem(value: 'br', label: 'Brazil'),
    DropdownItem(value: 'mx', label: 'Mexico'),
    DropdownItem(value: 'sg', label: 'Singapore'),
    DropdownItem(value: 'my', label: 'Malaysia'),
    DropdownItem(value: 'th', label: 'Thailand'),
    DropdownItem(value: 'ph', label: 'Philippines'),
    DropdownItem(value: 'id', label: 'Indonesia'),
    DropdownItem(value: 'tw', label: 'Taiwan'),
    DropdownItem(value: 'hk', label: 'Hong Kong'),
  ];

  @override
  void initState() {
    super.initState();
    _initializeForm();
    _setupFocusListeners();

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
    }
  }

  void _setupFocusListeners() {
    // tránh validate form khi build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fullNameController.addListener(_validateForm);
      _phoneController.addListener(_validateForm);
      _dobController.addListener(_validateForm);
    });
  }

  void _validateForm() {
    final fullName = _fullNameController.text.trim();
    final phone = _phoneController.text.trim();
    final dob = _dobController.text.trim();

    _formData['fullName'] = fullName;
    _formData['phone'] = phone;
    _formData['dob'] = dob;

    print('StepProfile _validateForm: $_formData');

    widget.onProfileCompleted(_formData);
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 6570)),

      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).brightness == Brightness.dark
                ? ColorScheme.dark(
                    primary: AppColors.primary500,
                    onPrimary: AppColors.white,
                    surface: AppColors.dark2,
                    onSurface: AppColors.white,
                  )
                : ColorScheme.light(
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
      _dobController.text =
          "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      _validateForm();
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        // lấy ảnh
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80, // -> giảm chất lượng
      );

      if (image != null && mounted) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _selectedImage = null);
      }
    }
  }

  String? _validateFullName(String? value) {
    return ValidationUtils.validateFullName(value, context);
  }

  String? _validatePhone(String? value) {
    return ValidationUtils.validatePhone(value, context);
  }

  String? _validateDOB(String? value) {
    return ValidationUtils.validateDOB(value, context);
  }

  String? _validateCountry(String? value) {
    return ValidationUtils.validateCountry(value, context);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _fullNameFocus.dispose();
    _phoneFocus.dispose();
    _dobFocus.dispose();
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

          Text(
            context.l10n.completeYourProfile,
            style: AppTypography.h3.copyWith(
              color: AppColors.getText(context),
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            context.l10n.profilePrivacyNote,
            style: AppTypography.bodyLRegular.copyWith(
              color: AppColors.getTextSecondary(context),
            ),
          ),

          const SizedBox(height: 32),

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
                      border: Border.all(color: AppColors.primary500, width: 2),
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
                                context.l10n.addPhoto,
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
                  context.l10n.tapToAddProfilePicture,
                  style: AppTypography.bodySBRegular.copyWith(
                    color: AppColors.greyscale600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),


          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [

                  InfoField(
                    label: context.l10n.fullName,
                    hintText: context.l10n.enterYourFullName,
                    controller: _fullNameController,
                    focusNode: _fullNameFocus,
                    isRequired: true,
                    validator: _validateFullName,
                    keyboardType: TextInputType.name,
                    onSubmitted: (_) => _phoneFocus.requestFocus(),
                  ),

                  const SizedBox(height: 16),

                  InfoField(
                    label: context.l10n.phoneNumber,
                    hintText: context.l10n.enterYourPhoneNumber,
                    controller: _phoneController,
                    focusNode: _phoneFocus,
                    isRequired: true,
                    validator: _validatePhone,
                    keyboardType: TextInputType.phone,
                    onSubmitted: (_) => _dobFocus.requestFocus(),
                  ),

                  const SizedBox(height: 16),

                  InfoField(
                    label: context.l10n.dateOfBirth,
                    hintText: context.l10n.dateFormat,
                    controller: _dobController,
                    focusNode: _dobFocus,
                    isRequired: true,
                    validator: _validateDOB,
                    isReadOnly: true,
                    onTap: _selectDate,
                    onSubmitted: (_) {},
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

                  CustomDropdown(
                    label: context.l10n.country,
                    value: _formData['country'],
                    hint: context.l10n.enterYourCountry,
                    items: _countries,
                    isRequired: true,
                    onChanged: (value) {
                      setState(() {
                        _formData['country'] = value ?? '';
                      });
                      _validateForm();
                    },
                    validator: _validateCountry,
                    suffixIcon: Transform.scale(
                      scale: 0.5,
                      child: SvgPicture.asset(
                        ImageConstant.dropdownIcon,
                        colorFilter: ColorFilter.mode(
                          AppColors.getTextSecondary(context),
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
