import 'package:location_filter_candidate_test/broken_location_filter_screen.dart';

class BusinessFilterUnitTestHelper {
  static List<Business> apply({
    required List<Business> businesses,
    required String category,
    required bool verifiedOnly,
    required bool useMyLocation,
    required double maxDistanceMiles,
  }) {
    var list = businesses;

    if (category != 'All') {
      list = list.where((b) => b.category == category).toList();
    }

    if (verifiedOnly) {
      list = list.where((b) => b.blackOwnedVerified).toList();
    }

    if (useMyLocation) {
      list = list
          .where((b) => b.distanceMiles <= maxDistanceMiles)
          .toList();
    }

    return list;
  }
}