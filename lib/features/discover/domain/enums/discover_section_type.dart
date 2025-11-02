enum DiscoverSectionType {
  topCharts,
  topSelling,
  topFree,
  topNewReleases,
}

extension DiscoverSectionTypeExtension on DiscoverSectionType {
  String get title {
    switch (this) {
      case DiscoverSectionType.topCharts:
        return 'Top Charts';
      case DiscoverSectionType.topSelling:
        return 'Top Selling';
      case DiscoverSectionType.topFree:
        return 'Top Free';
      case DiscoverSectionType.topNewReleases:
        return 'Top New Releases';
    }
  }
}

