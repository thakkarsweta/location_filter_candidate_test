//Command to run unit tests: flutter test test/business_filter_unit_test.dart     

import 'package:flutter_test/flutter_test.dart';
import 'package:location_filter_candidate_test/broken_location_filter_screen.dart';

import 'business_filter_unit_test_helper.dart';

void main() {
  void logResult(
    String testCase,
    List<Business> businesses,
  ) {
    print('\n====================================================');
    print('TEST CASE: $testCase');
    print('Result Count: ${businesses.length}');

    if (businesses.isEmpty) {
      print('Businesses: NONE');
    } else {
      print(
        'Businesses: ${businesses.map((e) => e.name).join(', ')}',
      );
    }

    print('====================================================\n');
  }

  group('BusinessFilterHelper Tests', () {
    test(
      'TC-01: returns all restaurant businesses when category is Restaurant',
      () {
        print('Running TC-01');

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

        print('TC-01 PASSED');
      },
    );

    test(
      'TC-02: returns empty list for Services + Verified Only',
      () {
        print('Running TC-02');

        final result = BusinessFilterUnitTestHelper.apply(
          businesses: demoBusinesses,
          category: 'Services',
          verifiedOnly: true,
          useMyLocation: false,
          maxDistanceMiles: 5,
        );

        logResult('TC-02', result);

        expect(result, isEmpty);

        print('TC-02 PASSED');
      },
    );

    test(
      'TC-03: returns Brooklyn Books for Retail + Verified Only',
      () {
        print('Running TC-03');

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

        print('TC-03 PASSED');
      },
    );

    test(
      'TC-04: returns Harlem Coffee Bar for Restaurant + Verified + Distance <= 1 mile',
      () {
        print('Running TC-04');

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

        print('TC-04 PASSED');
      },
    );

    test(
      'TC-05: returns empty list when verified filter has no matches',
      () {
        print('Running TC-05');

        final result = BusinessFilterUnitTestHelper.apply(
          businesses: demoBusinesses,
          category: 'Services',
          verifiedOnly: true,
          useMyLocation: false,
          maxDistanceMiles: 10,
        );

        logResult('TC-05', result);

        expect(result, isEmpty);

        print('TC-05 PASSED');
      },
    );

    test(
      'TC-06: returns empty list when distance filter has no matches',
      () {
        print('Running TC-06');

        final result = BusinessFilterUnitTestHelper.apply(
          businesses: demoBusinesses,
          category: 'Retail',
          verifiedOnly: true,
          useMyLocation: true,
          maxDistanceMiles: 1,
        );

        logResult('TC-06', result);

        expect(result, isEmpty);

        print('TC-06 PASSED');
      },
    );

    test(
      'TC-07: combined filters do not reset previously applied filters',
      () {
        print('Running TC-07');

        final result = BusinessFilterUnitTestHelper.apply(
          businesses: demoBusinesses,
          category: 'Retail',
          verifiedOnly: true,
          useMyLocation: true,
          maxDistanceMiles: 1,
        );

        logResult('TC-07', result);

        expect(result, isEmpty);

        print('TC-07 PASSED');
      },
    );

    test(
      'TC-08: returns all businesses when no filters are applied',
      () {
        print('Running TC-08');

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

        print('TC-08 PASSED');
      },
    );

    test(
      'TC-09: verified only filter returns only verified businesses',
      () {
        print('Running TC-09');

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

        print('TC-09 PASSED');
      },
    );

    test(
      'TC-10: distance filter returns only businesses within selected range',
      () {
        print('Running TC-10');

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

        print('TC-10 PASSED');
      },
    );
  });
}