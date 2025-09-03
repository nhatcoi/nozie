import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_fe/core/app_export.dart';
import 'package:movie_fe/core/widgets/lined_text_divider.dart';
import '../../../../i18n/translations.g.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = '';
  bool _isSearching = false;
  bool _submitted = false;

  // previousSearches state
  final List<String> _previousSearches = [
    'Inception',
    'The Dark Knight',
    'Interstellar',
    'Parasite',
    'Avengers: Endgame',
    'Inception',
    'The Dark Knight',
    'Interstellar',
    'Parasite',
    'Avengers: Endgame',
    'Inception',
    'The Dark Knight',
    'Interstellar',
    'Parasite',
    'Avengers: Endgame',
    'Inception',
    'The Dark Knight',
    'Interstellar',
    'Parasite',
    'Avengers: Endgame',
    'Inception',
    'The Dark Knight',
    'Interstellar',
    'Parasite',
    'Avengers: Endgame',
    'Inception',
    'The Dark Knight',
    'Interstellar',
    'Parasite',
    'Avengers: Endgame',
    'Inception',
    'The Dark Knight',
    'Interstellar',
    'Parasite',
    'Avengers: Endgame',
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _isSearching = _searchQuery.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              _buildSearchHeader(context, t),

              const SizedBox(height: 24),

              if (!_isSearching) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Previous Search',
                      style: AppTypography.h5.copyWith(
                        color: AppColors.getText(context),
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        // TODO: xóa lịch sử
                      },
                      child: SvgPicture.asset(
                        ImageConstant.closeIcon,
                        width: 12,
                        height: 12,
                        colorFilter: ColorFilter.mode(
                          AppColors.getTextSecondary(context),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                LinedTextDivider(),

                const SizedBox(height: 24),

                _buildListPreviousSearches(context, t),
              ],

              // if (_isSearching)
              // Expanded(
              //   child: _buildSearchContent(context, t),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchHeader(BuildContext context, Translations t) {


    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: SvgPicture.asset(
            ImageConstant.arrowIcon,
            width: 16,
            height: 16,
            colorFilter: ColorFilter.mode(
              AppColors.getText(context),
              BlendMode.srcIn,
            ),
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: InfoField(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),

            controller: _searchController,
            focusNode: _searchFocusNode,
            showDivider: false,
            showBorder: true,
            borderRadius: 16,

            fontSize: 16,
            cursorHeight: 13,
            // cursor text ngắn hơn
            cursorColor: AppColors.getText(context),
            prefixIcon: Transform.scale(
              scale: 0.35,
              child: SvgPicture.asset(
                ImageConstant.searchIcon,
                colorFilter: ColorFilter.mode(
                  AppColors.getText(context),
                  BlendMode.srcIn, // vẽ svg
                ),
              ),
            ),
            suffixIcon: _searchQuery.isNotEmpty
                ? GestureDetector(
                    onTap: _clearSearch,
                    child: Transform.scale(
                      scale: 0.25,
                      child: SvgPicture.asset(
                        ImageConstant.closeIcon,
                        colorFilter: ColorFilter.mode(
                          AppColors.getText(context),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  )
                : null,

            onSubmitted: (value) {
              setState(() {
                _submitted = true;
              });
              _searchFocusNode.unfocus();
              _showIn(value);
            },

            backgroundColor: _submitted ? AppColors.getSurface(context) : AppColors.trOrange ,
            focusedBackgroundColor: AppColors.trOrange,
            borderColor:  _submitted ? null : AppColors.primary500,


          ),
        ),

        // GestureDetector(
        //   onTap: () => Navigator.of(context).pop(),
        //   child: SvgPicture.asset(
        //     ImageConstant
        //   )
        // )
      ],
    );
  }

  Widget _buildListPreviousSearches(BuildContext context, Translations t) {
    return Expanded(
      child: ListView.separated(
        itemCount: _previousSearches.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        // cách mục
        itemBuilder: (context, index) {
          final oldSearch = _previousSearches[index];
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  /// TODO: search lại
                  _searchController.text = oldSearch;
                },
                child: Text(
                  oldSearch,
                  style: AppTypography.h5.copyWith(
                    color: AppColors.getTextThird(context),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              GestureDetector(
                onTap: () {
                  setState(() {
                    _previousSearches.removeAt(index);
                  });
                },
                child: SvgPicture.asset(
                  ImageConstant.closeIcon,
                  width: 12,
                  height: 12,
                  colorFilter: ColorFilter.mode(
                    AppColors.getTextSecondary(context),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _clearSearch() {
    _searchController.clear();
    _searchFocusNode.unfocus();
  }

  void _showIn(String value) {}
}
