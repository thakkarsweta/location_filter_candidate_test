Manual test cases candidate should cover:

1. Category = Restaurant, Verified only = false, Location off: should show all Restaurant businesses.
2. Category = Services, Verified only = true: should show zero results because the only Services sample is not verified.
3. Category = Retail, Verified only = true: should show Brooklyn Books only when distance allows it.
4. Category = Restaurant, Verified only = true, distance <= 1 mile after location enabled: should show Harlem Coffee Bar only.
5. Category = Restaurant, Verified only = true, distance <= 1 mile after changing data so no businesses match: should show zero results, not all demo businesses.
6. Permission denied: should not get stuck loading.
7. Permission deniedForever: should show settings dialog and not get stuck loading.
8. Location services disabled: should show clear message and not request position.
