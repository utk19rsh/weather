import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:weather/utils/constants.dart';

class LocationBottomSheet extends StatelessWidget {
  const LocationBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 5,
            margin: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: white.withAlpha(80),
            ),
          ),
          Text(
            "Turn On Location",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 15),
          Text(
            "We don't have access to location services on your device. Please go to settings and enable location services to fetch your current location.",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 7.5),
          BottomSheetTile(
            color: red,
            icon: MdiIcons.cancel,
            label: "No, I won't",
            onTap: () => Navigator.pop(context),
          ),
          BottomSheetTile(
            color: green,
            icon: MdiIcons.check,
            label: "Yes, take me there!",
            onTap: () async {
              Navigator.pop(context);
              await Geolocator.openLocationSettings();
            },
          ),
        ],
      ),
    );
  }
}

class BottomSheetTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const BottomSheetTile({
    Key? key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.5),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: 16,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
