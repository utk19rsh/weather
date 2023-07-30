import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:weather/utils/constants.dart';
import 'package:weather/utils/functions/convertors.dart';
import 'package:weather/utils/screen.dart';
import 'package:weather/view/searchLocation/search_location.dart';

class HomeTileComponent extends StatelessWidget {
  const HomeTileComponent({
    super.key,
    required this.image,
    required this.value,
    required this.label,
    required this.unit,
  });
  final String image, value, label, unit;

  @override
  Widget build(BuildContext context) {
    Screen s = Screen(context);
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(left: 30 * s.customWidth),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              "$imagesPath/$image",
              width: 30 * s.customWidth,
              height: 30 * s.customWidth,
            ),
            SizedBox(height: 5 * s.customWidth),
            value != "null"
                ? RichText(
                    text: TextSpan(
                      style: GoogleFonts.mavenPro(),
                      children: [
                        TextSpan(
                          text: value,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        TextSpan(
                          text: " $unit",
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ],
                    ),
                  )
                : Text(
                    "-",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
            SizedBox(height: 5 * s.customWidth),
            Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .copyWith(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoTiles extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const InfoTiles({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    Screen s = Screen(context);
    return Container(
      padding: EdgeInsets.all(30 * s.customWidth),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15 * s.customWidth),
        color: white.withAlpha(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: white,
            size: 40 * s.customWidth,
          ),
          SizedBox(height: 5 * s.customWidth),
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .labelLarge!
                .copyWith(color: white.withOpacity(0.5)),
          ),
          SizedBox(height: 10 * s.customWidth),
          Text(
            value.contains("null") ? "-" : value,
            style:
                Theme.of(context).textTheme.titleLarge!.copyWith(color: white),
          ),
        ],
      ),
    );
  }
}

class CoordinateText extends StatelessWidget {
  const CoordinateText({
    super.key,
    required this.value,
    required this.label,
  });

  final String value, label;

  @override
  Widget build(BuildContext context) {
    Screen s = Screen(context);

    return RichText(
      text: TextSpan(
        style: GoogleFonts.mavenPro(
          textStyle: const TextStyle(color: white),
        ),
        children: [
          TextSpan(text: "$label : "),
          TextSpan(text: value, style: TextStyle(fontSize: 18 * s.customWidth)),
        ],
      ),
    );
  }
}

class SwitchLocation extends StatelessWidget {
  const SwitchLocation(this.secondaryColor, {super.key});

  final Color secondaryColor;

  @override
  Widget build(BuildContext context) {
    Screen s = Screen(context);

    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (builder) => const SearchLocation(),
          ),
        );
      },
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(10 * s.customWidth),
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          MdiIcons.mapMarker,
          color: theme,
        ),
      ),
    );
  }
}

class LocationAndDate extends StatelessWidget {
  const LocationAndDate(this.location, this.con, {super.key});

  final Convertor con;
  final String location;

  @override
  Widget build(BuildContext context) {
    Screen s = Screen(context);
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            location,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .headlineLarge!
                .copyWith(color: white),
          ),
          SizedBox(height: 10 * s.customWidth),
          Text(
            con.formatCurrentDateInDMW(),
            style:
                Theme.of(context).textTheme.titleLarge!.copyWith(color: grey),
          )
        ],
      ),
    );
  }
}
