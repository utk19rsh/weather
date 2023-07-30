import 'package:flutter/material.dart';
import 'package:weather/utils/constants.dart';
import 'package:weather/utils/screen.dart';
import 'package:weather/view/searchLocation/components/components.dart';

class SearchLocation extends StatefulWidget {
  const SearchLocation({super.key});

  @override
  State<SearchLocation> createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {
  TextEditingController controller = TextEditingController();
  String searchValue = "";

  @override
  Widget build(BuildContext context) {
    Screen s = Screen(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text("Search Location", style: TextStyle(color: white)),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(20 * s.customWidth),
              children: [
                CustomTextFormField(
                  controller: controller,
                  onChanged: (value) => setState(() {
                    searchValue = value;
                  }),
                ),
                SizedBox(height: 20 * s.customWidth),
                searchValue.isEmpty
                    ? const TopCities()
                    : SearchResults(searchValue: searchValue),
              ],
            ),
          ),
          UseCurrentLocation(mounted),
        ],
      ),
    );
  }
}
