//Command to run unit tests: flutter test test/business_filter_unit_test.dart     

import 'package:flutter_test/flutter_test.dart';
import 'package:location_filter_candidate_test/broken_location_filter_screen.dart';
import 'package:flutter/foundation.dart';
import 'business_filter_unit_test_helper.dart';

void main() {
  void logResult(
    String testCase,
    List<Business> businesses,
  ) {
    debugPrint('\n====================================================');
    debugPrint('TEST CASE: $testCase');
    debugPrint('Result Count: ${businesses.length}');

    if (businesses.isEmpty) {
      debugPrint('Businesses: NONE');
    } else {
      debugPrint(
        'Businesses: ${businesses.map((e) => e.name).join(', ')}',
      );
    }

    debugPrint('====================================================\n');
  }

  group('BusinessFilterHelper Tests', () {
    test(
      'TC-01: returns all restaurant businesses when category is Restaurant',
      () {
        debugPrint('Running TC-01');

        final result = BusinessFilterUnitTestHelper.apply(
          businesses: demoBusinesses,
          category: 'Restaurant',
          verifiedOnly: false,
          useMyLocation: false,
          maxDistanceMiles: 5,
        );

        logResult('TC-01', result);

        expect(result.length, 2);

        expect(
          result.every(
            (business) => business.category == 'Restaurant',
          ),
          isTrue,
        );

        debugPrint('TC-01 PASSED');
      },
    );

    test(
      'TC-02: returns empty list for Services + Verified Only',
      () {
        debugPrint('Running TC-02');

        final result = BusinessFilterUnitTestHelper.apply(
          businesses: demoBusinesses,
          category: 'Services',
          verifiedOnly: true,
          useMyLocation: false,
          maxDistanceMiles: 5,
        );

        logResult('TC-02', result);

        expect(result, isEmpty);

        debugPrint('TC-02 PASSED');
      },
    );

    test(
      'TC-03: returns Brooklyn Books for Retail + Verified Only',
      () {
        debugPrint('Running TC-03');

        final result = BusinessFilterUnitTestHelper.apply(
          businesses: demoBusinesses,
          category: 'Retail',
          verifiedOnly: true,
          useMyLocation: false,
          maxDistanceMiles: 5,
        );

        logResult('TC-03', result);

        expect(result.length, 1);
        expect(result.first.name, 'Brooklyn Books');

        debugPrint('TC-03 PASSED');
      },
    );

    test(
      'TC-04: returns Harlem Coffee Bar for Restaurant + Verified + Distance <= 1 mile',
      () {
        debugPrint('Running TC-04');

        final result = BusinessFilterUnitTestHelper.apply(
          businesses: demoBusinesses,
          category: 'Restaurant',
          verifiedOnly: true,
          useMyLocation: true,
          maxDistanceMiles: 1,
        );

        logResult('TC-04', result);

        expect(result.length, 1);
        expect(result.first.name, 'Harlem Coffee Bar');

        debugPrint('TC-04 PASSED');
      },
    );

    test(
      'TC-05: returns empty list when verified filter has no matches',
      () {
        debugPrint('Running TC-05');

        final result = BusinessFilterUnitTestHelper.apply(
          businesses: demoBusinesses,
          category: 'Services',
          verifiedOnly: true,
          useMyLocation: false,
          maxDistanceMiles: 10,
        );

        logResult('TC-05', result);

        expect(result, isEmpty);

        debugPrint('TC-05 PASSED');
      },
    );

    test(
      'TC-06: returns empty list when distance filter has no matches',
      () {
        debugPrint('Running TC-06');

        final result = BusinessFilterUnitTestHelper.apply(
          businesses: demoBusinesses,
          category: 'Retail',
          verifiedOnly: true,
          useMyLocation: true,
          maxDistanceMiles: 1,
        );

        logResult('TC-06', result);

        expect(result, isEmpty);

        debugPrint('TC-06 PASSED');
      },
    );

    test(
      'TC-07: combined filters do not reset previously applied filters',
      () {
        debugPrint('Running TC-07');

        final result = BusinessFilterUnitTestHelper.apply(
          businesses: demoBusinesses,
          category: 'Retail',
          verifiedOnly: true,
          useMyLocation: true,
          maxDistanceMiles: 1,
        );

        logResult('TC-07', result);

        expect(result, isEmpty);

        debugPrint('TC-07 PASSED');
      },
    );

    test(
      'TC-08: returns all businesses when no filters are applied',
      () {
        debugPrint('Running TC-08');

        final result = BusinessFilterUnitTestHelper.apply(
          businesses: demoBusinesses,
          category: 'All',
          verifiedOnly: false,
          useMyLocation: false,
          maxDistanceMiles: 10,
        );

        logResult('TC-08', result);

        expect(
          result.length,
          demoBusinesses.length,
        );

        debugPrint('TC-08 PASSED');
      },
    );

    test(
      'TC-09: verified only filter returns only verified businesses',
      () {
        debugPrint('Running TC-09');

        final result = BusinessFilterUnitTestHelper.apply(
          businesses: demoBusinesses,
          category: 'All',
          verifiedOnly: true,
          useMyLocation: false,
          maxDistanceMiles: 10,
        );

        logResult('TC-09', result);

        expect(
          result.every(
            (business) => business.blackOwnedVerified,
          ),
          isTrue,
        );

        debugPrint('TC-09 PASSED');
      },
    );

    test(
      'TC-10: distance filter returns only businesses within selected range',
      () {
        debugPrint('Running TC-10');

        final result = BusinessFilterUnitTestHelper.apply(
          businesses: demoBusinesses,
          category: 'All',
          verifiedOnly: false,
          useMyLocation: true,
          maxDistanceMiles: 5,
        );

        logResult('TC-10', result);

        expect(
          result.every(
            (business) => business.distanceMiles <= 5,
          ),
          isTrue,
        );

        debugPrint('TC-10 PASSED');
      },
    );
  });
}