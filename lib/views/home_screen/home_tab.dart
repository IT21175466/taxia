import 'package:flutter/material.dart';
import 'package:taxia/constants/app_colors.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 14, 88, 216),
                      width: 1,
                    ),
                  ),
                  labelText: "Where should I go?",
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppColors.grayColor,
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Leave"),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "now",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Icon(Icons.arrow_drop_down_outlined),
                      ],
                    ),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
