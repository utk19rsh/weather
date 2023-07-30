import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:weather/controller/providers/location.dart';
import 'package:weather/utils/constants.dart';
import 'package:weather/utils/screen.dart';
import 'package:weather/utils/widgets/bottom_sheets.dart';
import 'package:weather/view/home/home.dart';

class TopCities extends StatelessWidget {
  const TopCities({super.key});

  static List<String> topCities = [
    "Delhi",
    "Mumbai",
    "Kolkata",
    "Bangalore",
    "Chennai",
    "Hyderabad",
    "Pune",
    "Ahmedabad",
    "Surat",
    "Prayagraj",
    "Lucknow",
    "Jaipur",
    "Kanpur",
    "Mirzapur",
    "Nagpur",
    "Ghaziabad",
    "Vadodara",
    "Vishakhapatnam",
    "Indore",
    "Thane",
    "Bhopal",
    "Chinchvad",
    "Patna",
  ];
  @override
  Widget build(BuildContext context) {
    Screen s = Screen(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Top cities in India",
          style:
              Theme.of(context).textTheme.headlineSmall!.copyWith(color: white),
        ),
        ListView.separated(
          separatorBuilder: (context, index) => Divider(
            color: white.withAlpha(80),
          ),
          padding: EdgeInsets.symmetric(vertical: 20 * s.customWidth),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: topCities.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Provider.of<LocationProvider>(context, listen: false)
                    .updateAddress(topCities[index]);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (builder) => const Home(),
                  ),
                  (route) => false,
                );
              },
              child: Padding(
                padding: EdgeInsets.all(8 * s.customWidth),
                child: Text(
                  topCities[index],
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: white),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.controller,
    this.onChanged,
  });

  final TextEditingController controller;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    Screen s = Screen(context);

    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      autofocus: true,
      textCapitalization: TextCapitalization.sentences,
      style: Theme.of(context).textTheme.titleMedium!.copyWith(color: white),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]"))],
      decoration: InputDecoration(
        fillColor: white.withAlpha(25),
        filled: true,
        contentPadding: EdgeInsets.all(20 * s.customWidth),
        prefixIcon: Icon(MdiIcons.mapMarker, color: white),
        suffixIcon: TextButton(
          onPressed: () {
            if (controller.text.isNotEmpty) {
              Provider.of<LocationProvider>(context, listen: false)
                  .updateAddress(controller.text);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (builder) => const Home(),
                ),
                (route) => false,
              );
            }
          },
          child: controller.text.isEmpty
              ? Icon(
                  MdiIcons.magnify,
                  color: white,
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Proceed",
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge!
                          .copyWith(color: white),
                    ),
                    Icon(
                      MdiIcons.chevronRight,
                      color: white,
                    )
                  ],
                ),
        ),
        hintText: "Enter a location",
        hintStyle:
            Theme.of(context).textTheme.titleMedium!.copyWith(color: white),
        border: border(),
        enabledBorder: border(),
        focusedBorder: border(),
      ),
    );
  }

  OutlineInputBorder border() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(color: white),
    );
  }
}

class SearchResults extends StatelessWidget {
  const SearchResults({
    super.key,
    required this.searchValue,
  });

  final String searchValue;

  @override
  Widget build(BuildContext context) {
    Screen s = Screen(context);
    return Consumer<LocationProvider>(builder: (context, value, _) {
      List<String> result = value.listOfCities
          .where((element) =>
              element.toLowerCase().startsWith(searchValue.toLowerCase()))
          .toList();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Search results",
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(color: white),
          ),
          ListView.separated(
            separatorBuilder: (context, index) => Divider(
              color: white.withAlpha(80),
            ),
            padding: EdgeInsets.symmetric(vertical: 20 * s.customWidth),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: result.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Provider.of<LocationProvider>(context, listen: false)
                      .updateAddress(result[index]);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (builder) => const Home(),
                    ),
                    (route) => false,
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(8 * s.customWidth),
                  child: Text(
                    result[index],
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: white),
                  ),
                ),
              );
            },
          ),
        ],
      );
    });
  }
}

class UseCurrentLocation extends StatelessWidget {
  const UseCurrentLocation(this.mounted, {super.key});

  final bool mounted;

  @override
  Widget build(BuildContext context) {
    Screen s = Screen(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        if (!(await Geolocator.isLocationServiceEnabled())) {
          if (mounted) {
            await showModalBottomSheet(
              context: context,
              builder: (builder) => const LocationBottomSheet(),
            );
          }
        } else {
          if (mounted) {
            await Provider.of<LocationProvider>(context, listen: false)
                .inception();
          }
          if (mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (builder) => const Home(),
              ),
              (route) => false,
            );
          }
        }
      },
      child: Container(
        padding: EdgeInsets.all(20 * s.customWidth),
        color: white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Use current location",
              style:
                  Theme.of(context).textTheme.titleLarge!.copyWith(color: blue),
            ),
            Icon(MdiIcons.crosshairsGps, color: blue),
          ],
        ),
      ),
    );
  }
}
