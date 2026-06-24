import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Business {
  final String name;
  final String category;
  final double distanceMiles;
  final bool blackOwnedVerified;

  const Business({
    required this.name,
    required this.category,
    required this.distanceMiles,
    required this.blackOwnedVerified,
  });
}

const demoBusinesses = <Business>[
  Business(name: 'Harlem Coffee Bar', category: 'Restaurant', distanceMiles: 0.8, blackOwnedVerified: true),
  Business(name: 'Brooklyn Books', category: 'Retail', distanceMiles: 2.2, blackOwnedVerified: true),
  Business(name: 'Queens Fitness Studio', category: 'Services', distanceMiles: 4.7, blackOwnedVerified: false),
  Business(name: 'Bronx Vegan Kitchen', category: 'Restaurant', distanceMiles: 7.9, blackOwnedVerified: true),
  Business(name: 'Newark Skin Care', category: 'Retail', distanceMiles: 14.2, blackOwnedVerified: false),
];

class BrokenLocationFilterScreen extends StatefulWidget {
  const BrokenLocationFilterScreen({super.key});

  @override
  State<BrokenLocationFilterScreen> createState() => _BrokenLocationFilterScreenState();
}

class _BrokenLocationFilterScreenState extends State<BrokenLocationFilterScreen> {
  bool isLocating = false;
  bool useMyLocation = false;
  String selectedCategory = 'All';
  bool verifiedOnly = false;
  double maxDistanceMiles = 5;
  String status = 'Tap "Use my location" to test permission flow.';

  // Known-broken method. Candidate should fix this safely.
  Future<void> useCurrentLocation() async {
    setState(() {
      isLocating = true;
      status = 'Checking location permission...';
    });

    LocationPermission permission = await Geolocator.checkPermission();

    // BUG 1: If permission is denied, this code does not request permission.
    // BUG 2: denied and deniedForever are treated the same.
    // BUG 3: isLocating is not reset on every early return path.
    // BUG 4: no service-enabled check.
    // BUG 5: no mounted checks after async work before setState/showDialog.
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      setState(() {
        status = 'Location denied. Nothing else happens.';
      });
      return;
    }

    final position = await Geolocator.getCurrentPosition();

    setState(() {
      useMyLocation = true;
      status = 'Location loaded: ${position.latitude.toStringAsFixed(3)}, ${position.longitude.toStringAsFixed(3)}';
      isLocating = false;
    });
  }

  // Known-broken method. Candidate should fix this without changing product behavior.
  List<Business> get filteredBusinesses {
    var list = demoBusinesses;

    if (selectedCategory != 'All') {
      list = list.where((b) => b.category == selectedCategory).toList();
    }

    if (verifiedOnly) {
      final verified = list.where((b) => b.blackOwnedVerified).toList();
      // BUG 6: bad fallback. If there are no verified results, it shows all results again.
      list = verified.isNotEmpty ? verified : demoBusinesses;
    }

    if (useMyLocation) {
      final nearby = list.where((b) => b.distanceMiles <= maxDistanceMiles).toList();
      // BUG 7: bad fallback. If there are no nearby results, it shows all results again.
      list = nearby.isNotEmpty ? nearby : demoBusinesses;
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final businesses = filteredBusinesses;

    return Scaffold(
      appBar: AppBar(title: const Text('Location + Filter Test')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: isLocating ? null : useCurrentLocation,
                  child: Text(isLocating ? 'Locating...' : 'Use my location'),
                ),
                DropdownButton<String>(
                  value: selectedCategory,
                  items: const [
                    DropdownMenuItem(value: 'All', child: Text('All')),
                    DropdownMenuItem(value: 'Restaurant', child: Text('Restaurant')),
                    DropdownMenuItem(value: 'Retail', child: Text('Retail')),
                    DropdownMenuItem(value: 'Services', child: Text('Services')),
                  ],
                  onChanged: (value) => setState(() => selectedCategory = value ?? 'All'),
                ),
                FilterChip(
                  label: const Text('Verified only'),
                  selected: verifiedOnly,
                  onSelected: (value) => setState(() => verifiedOnly = value),
                ),
                SizedBox(
                  width: 220,
                  child: Row(
                    children: [
                      const Text('Distance'),
                      Expanded(
                        child: Slider(
                          min: 1,
                          max: 10,
                          divisions: 9,
                          label: '${maxDistanceMiles.round()} mi',
                          value: maxDistanceMiles,
                          onChanged: (value) => setState(() => maxDistanceMiles = value),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(status),
            const Divider(height: 32),
            Text('Results (${businesses.length})', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Expanded(
              child: businesses.isEmpty
                  ? const Center(child: Text('No matching businesses.'))
                  : ListView.builder(
                      itemCount: businesses.length,
                      itemBuilder: (context, index) {
                        final b = businesses[index];
                        return ListTile(
                          title: Text(b.name),
                          subtitle: Text('${b.category} • ${b.distanceMiles} mi'),
                          trailing: b.blackOwnedVerified ? const Icon(Icons.verified) : null,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
