import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:weather/controller/providers/location.dart';
import 'package:weather/controller/weather.dart';
import 'package:weather/model/statistics.dart';
import 'package:weather/utils/constants.dart';
import 'package:weather/utils/functions/convertors.dart';
import 'package:weather/utils/screen.dart';
import 'package:weather/utils/widgets/app_bar.dart';
import 'package:weather/utils/widgets/bottom_sheets.dart';
import 'package:weather/view/home/components/components.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Convertor con = Convertor();
  Color secondaryColor = white.withAlpha(225);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => inception());
  }

  inception() async {
    if (!(await Geolocator.isLocationServiceEnabled())) {
      Future.delayed(
        const Duration(seconds: 2),
        () => showModalBottomSheet(
          context: context,
          builder: (builder) => const LocationBottomSheet(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Screen s = Screen(context);
    return RefreshIndicator(
      onRefresh: () async {
        Provider.of<LocationProvider>(context, listen: false).inception();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (builder) => const Home()),
        );
      },
      child: Scaffold(
        backgroundColor: theme,
        appBar: const ZeroAppBar(),
        body: Consumer<LocationProvider>(
          builder: (BuildContext context, value, Widget? _) => ListView(
            padding: EdgeInsets.all(30 * s.customWidth).copyWith(bottom: 0),
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  LocationAndDate(value.address, con),
                  SwitchLocation(secondaryColor),
                ],
              ),
              SizedBox(height: 20 * s.customWidth),
              FutureBuilder<Statistics?>(
                future: Weather().getStatistics(value.address),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return const Center(child: Text("Something went wrong!"));
                    case ConnectionState.waiting || ConnectionState.active:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    case ConnectionState.done:
                      if (snapshot.hasData) {
                        Statistics stats = snapshot.data!;
                        return _showWeatherStats(stats, context, s);
                      } else {
                        return const SizedBox.shrink();
                      }
                    default:
                      return const SizedBox.shrink();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column _showWeatherStats(Statistics stats, BuildContext context, Screen s) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _mainTemperature(stats, context, s),
        SizedBox(height: 10 * s.customWidth),
        _description(stats, context),
        SizedBox(height: 45 * s.customWidth),
        _tile3x1(s, stats),
        SizedBox(height: 20 * s.customWidth),
        _coordinates(stats, s),
        _tile2x3(stats, s),
      ],
    );
  }

  GridView _tile2x3(Statistics stats, Screen s) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 20 * s.customWidth,
      mainAxisSpacing: 20 * s.customWidth,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: 20 * s.customWidth),
      children: [
        InfoTiles(
          icon: MdiIcons.thermometerLines,
          label: "Feels like",
          value: stats.feelsLikeTemperature,
        ),
        InfoTiles(
          icon: MdiIcons.wavesArrowUp,
          label: "Pressure",
          value: "${stats.pressure} hPa",
        ),
        InfoTiles(
          icon: MdiIcons.eyeCheck,
          label: "Visibility",
          value: "${stats.visibility} km",
        ),
        InfoTiles(
          icon: MdiIcons.elevationRise,
          label: "Ground Level",
          value: "${stats.groundLevel} m",
        ),
        InfoTiles(
          icon: MdiIcons.weatherSunsetUp,
          label: "Sunrise",
          value: con.extractTime(stats.sunriseTime),
        ),
        InfoTiles(
          icon: MdiIcons.weatherSunsetDown,
          label: "Sunset",
          value: con.extractTime(stats.sunsetTime),
        ),
      ],
    );
  }

  Padding _coordinates(Statistics stats, Screen s) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5 * s.customWidth),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CoordinateText(
            label: "Latitude",
            value: stats.latitude,
          ),
          SizedBox(width: 20 * s.customWidth),
          CoordinateText(
            label: "Longitude",
            value: stats.longitude,
          ),
        ],
      ),
    );
  }

  Container _tile3x1(Screen s, Statistics stats) {
    return Container(
      width: s.width,
      padding: EdgeInsets.symmetric(vertical: 15 * s.customWidth),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15 * s.customWidth),
        color: secondaryColor,
      ),
      child: Row(
        children: [
          HomeTileComponent(
            image: "wind.png",
            label: "Wind",
            value: stats.windSpeed,
            unit: "m/s",
          ),
          HomeTileComponent(
            image: "seaLevel.png",
            label: "Sea Level",
            value: stats.seaLevel,
            unit: "m",
          ),
          HomeTileComponent(
            image: "humidity.png",
            label: "Humidity",
            value: stats.humidity,
            unit: "%",
          ),
        ],
      ),
    );
  }

  Column _description(Statistics stats, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          stats.description,
          style:
              Theme.of(context).textTheme.headlineSmall!.copyWith(color: white),
        ),
        Text(
          "(${stats.maxTemperature} / ${stats.minTemperature})",
          style:
              Theme.of(context).textTheme.titleMedium!.copyWith(color: white),
        ),
      ],
    );
  }

  Widget _mainTemperature(Statistics stats, BuildContext context, Screen s) {
    return Material(
      color: Colors.transparent,
      textStyle: GoogleFonts.lilitaOne(
        textStyle:
            Theme.of(context).textTheme.displayLarge!.copyWith(color: white),
      ),
      child: Transform.translate(
        offset: Offset(-5 * s.customWidth, 0),
        child: Text(stats.temperature),
      ),
    );
  }
}
