import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

class GoogleAutoCompleteTextFiled extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const GoogleAutoCompleteTextFiled(
      {super.key,
      required this.controller,
      required this.hintText,
      required Null Function(dynamic place) onPlaceSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      height: 50,
      child: GooglePlaceAutoCompleteTextField(
        boxDecoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        textEditingController: controller,
        googleAPIKey: "AIzaSyDWlxEQU9GMmFEmZwiT3OGVVxTyc984iNY",
        inputDecoration: InputDecoration(
          hintText: hintText,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        ),
        debounceTime: 800,
        isLatLngRequired: true,
        getPlaceDetailWithLatLng: (Prediction prediction) {
          print("placeDetails" + prediction.lng.toString());
        },
        itemClick: (Prediction prediction) {
          controller.text = prediction.description!;
          controller.selection = TextSelection.fromPosition(
            TextPosition(offset: prediction.description!.length),
          );
        },
        itemBuilder: (context, index, Prediction prediction) {
          return Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Icon(Icons.location_on),
                SizedBox(
                  width: 7,
                ),
                Expanded(child: Text("${prediction.description ?? ""}")),
              ],
            ),
          );
        },
        isCrossBtnShown: true,
      ),
    );
  }
}
