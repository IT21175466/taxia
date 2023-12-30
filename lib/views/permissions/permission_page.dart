import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:taxia/constants/app_colors.dart';
import 'package:taxia/providers/auth/permission_provider.dart';
import 'package:taxia/widgets/custom_button.dart';

class PermissionsPage extends StatefulWidget {
  const PermissionsPage({super.key});

  @override
  State<PermissionsPage> createState() => _PermissionsPageState();
}

class _PermissionsPageState extends State<PermissionsPage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 25),
        width: screenWidth,
        child: SingleChildScrollView(
          child: Consumer(
            builder: (BuildContext context,
                    PermissionProvider permissionProvider, Widget? child) =>
                Column(
              children: [
                SizedBox(
                  height: AppBar().preferredSize.height + 20,
                ),
                Text(
                  'Taxia',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textColor,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'You can use the service after enabling the permissions.',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: AppColors.grayColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 15,
                ),
                ExpansionTile(
                  onExpansionChanged: (bool isExpanded) {
                    if (isExpanded) {
                      permissionProvider.requestLocationPermissions(context);
                    }
                  },
                  title: Text(
                    'Location',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textColor,
                    ),
                  ),
                  tilePadding: EdgeInsets.zero,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 15, bottom: 10),
                      child: Text(
                        'It is used for setting up pick-up point and destination.',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: AppColors.grayColor,
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.grey,
                  height: 0,
                  thickness: 0.5,
                ),
                ExpansionTile(
                  onExpansionChanged: (bool isExpanded) {
                    if (isExpanded) {
                      permissionProvider.requestStoragePermissions(context);
                    }
                  },
                  title: Text(
                    'Storage',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textColor,
                    ),
                  ),
                  tilePadding: EdgeInsets.zero,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 15, bottom: 10),
                      child: Text(
                        'Used to retrieve saved information about requests.',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: AppColors.grayColor,
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.grey,
                  height: 0,
                  thickness: 0.5,
                ),
                ExpansionTile(
                  onExpansionChanged: (bool isExpanded) {
                    if (isExpanded) {
                      permissionProvider.requestMicPermissions(context);
                    }
                  },
                  title: Text(
                    '(Optional) Mic',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textColor,
                    ),
                  ),
                  tilePadding: EdgeInsets.zero,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 15, bottom: 10),
                      child: Text(
                        'It is used for setting up pick-up point and destination based on voice recognition.',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: AppColors.grayColor,
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.grey,
                  height: 0,
                  thickness: 0.5,
                ),
                ExpansionTile(
                  onExpansionChanged: (bool isExpanded) {
                    if (isExpanded) {
                      permissionProvider.requestCamaraPermissions(context);
                    }
                  },
                  title: Text(
                    '(Optional) Camera',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textColor,
                    ),
                  ),
                  tilePadding: EdgeInsets.zero,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 15, bottom: 10),
                      child: Text(
                        'It is used for recognizing QR codes and customer complaints.',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: AppColors.grayColor,
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.grey,
                  height: 0,
                  thickness: 0.5,
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "\u2022",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: AppColors.grayColor,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                        "Consent to Optional Permissions will be required if necessary. Even if denied, other services except for the corresponding function are available.",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: AppColors.grayColor,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "\u2022",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: AppColors.grayColor,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              openAppSettings();
                            },
                            child: Text(
                              "Change the access level",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                          Text(
                            "Mobile Phone Settings > App > Taxia",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: AppColors.grayColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () async {
                    await permissionProvider.checkAllPermissions();

                    if (permissionProvider.isAllPermissionGranted) {
                      permissionProvider.savePermissionStatus();
                      Navigator.pushReplacementNamed(context, '/login');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Please Give Required Permissions"),
                        ),
                      );
                    }
                  },
                  child: CustomButton(
                      text: "OK",
                      height: 50,
                      width: screenWidth,
                      backgroundColor: AppColors.buttonColor),
                ),
                SizedBox(
                  height: 25,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
