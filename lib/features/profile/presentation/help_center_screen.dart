import 'package:flutter/material.dart';
import 'package:movie_fe/core/app_export.dart';

import '../../../core/utils/data.dart';
import 'help_center/widgets/faq.dart';
import 'help_center/widgets/contact.dart';
import 'help_center/widgets/help_center_tabs.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  static const _tabs = ['FAQ', 'Contact us'];
  static const _categories = ['All', 'General', 'Account', 'Service', 'Movies'];

  final List<FaqItem> _faqs = HelpCenterData.faqs;

  int _activeTab = 0;
  int _activeCategory = 0;
  final Set<int> _expandedFaqs = {0};
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _activeFilter = '';

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          'Help Center',
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        centerTitle: false,
      ),
      body: ContentWrappers.page(
        context,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HelpCenterTabs(
              tabs: _tabs,
              activeIndex: _activeTab,
              onTabSelected: (index) => setState(() => _activeTab = index),
            ),
            const SizedBox(height: 24),
            if (_activeTab == 0)
              ..._buildFaqSection()
            else
              HelpCenterContactSection(options: HelpCenterData.contacts),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFaqSection() {
    return [
      HelpCenterCategoryTags(
        categories: _categories,
        activeIndex: _activeCategory,
        onSelected: (index) => setState(() {
          _activeCategory = index;
          _activeFilter = '';
          _expandedFaqs.clear();
          _searchController.clear();
          _searchFocusNode.unfocus();
        }),
      ),
      const SizedBox(height: 24),
      HelpCenterSearchBar(
        controller: _searchController,
        focusNode: _searchFocusNode,
        onQueryChanged: (value) {
          setState(() {
            final trimmed = value.trim();
            if (trimmed.isEmpty && _activeFilter.isNotEmpty) {
              _activeFilter = '';
              _expandedFaqs.clear();
            }
          });
        },
      ),
      if (_searchController.text.trim().isNotEmpty) ...[
        const SizedBox(height: 16),
        HelpCenterSuggestionList(
          query: _searchController.text.trim(),
          faqs: _faqs,
          onSelected: (faq) {
            _searchController
              ..text = faq.question
              ..selection = TextSelection.collapsed(
                offset: faq.question.length,
              );
            _searchFocusNode.unfocus();
            setState(() {
              _activeFilter = faq.question;
              _expandedFaqs
                ..clear()
                ..add(_faqs.indexOf(faq));
            });
          },
        ),
        const SizedBox(height: 24),
      ] else ...[
        const SizedBox(height: 16),
        if (_activeFilter.isNotEmpty) ...[
          HelpCenterFilterBanner(
            label: _activeFilter,
            onClear: () {
              setState(() {
                _activeFilter = '';
                _searchController.clear();
                _expandedFaqs.clear();
              });
            },
          ),
          const SizedBox(height: 24),
        ],
        const SizedBox(height: 24),
      ],
      ..._buildFaqList(),
    ];
  }

  List<Widget> _buildFaqList() {
    Iterable<FaqItem> items = _faqs;

    final selectedCategory = _categories[_activeCategory];
    if (selectedCategory != 'All') {
      items = items.where((faq) => faq.category == selectedCategory);
    }

    if (_activeFilter.isNotEmpty) {
      items = items.where((faq) => faq.question == _activeFilter);
    }

    final itemList = items.toList();

    if (itemList.isEmpty) {
      return [
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Text(
              'No FAQs found',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.getTextSecondary(context),
              ),
            ),
          ),
        ),
      ];
    }

    return [
      for (var i = 0; i < itemList.length; i++) ...[
        _buildFaqTile(itemList[i]),
        if (i != itemList.length - 1) const SizedBox(height: 16),
      ],
      const SizedBox(height: 24),
    ];
  }

  Widget _buildFaqTile(FaqItem faq) {
    final originalIndex = _faqs.indexOf(faq);
    return HelpCenterFaqTile(
      faq: faq,
      isExpanded: _expandedFaqs.contains(originalIndex),
      onPressed: () {
        setState(() {
          if (_expandedFaqs.contains(originalIndex)) {
            _expandedFaqs.remove(originalIndex);
          } else {
            _expandedFaqs.add(originalIndex);
          }
        });
      },
    );
  }
}
