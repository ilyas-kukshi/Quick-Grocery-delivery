// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:quickgrocerydelivery/models/addressModel.dart';
// import 'package:quickgrocerydelivery/shared/AppThemeShared.dart';
// import 'package:quickgrocerydelivery/shared/utility.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class MyAdresses extends StatefulWidget {
//   const MyAdresses({Key? key}) : super(key: key);

//   @override
//   _MyAdressesState createState() => _MyAdressesState();
// }

// class _MyAdressesState extends State<MyAdresses> {
//   AddressModel addressModel = AddressModel("", "", "", "", "", '');
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppThemeShared.appBar(
//         title: "Address",
//         context: context,
//         leading: GestureDetector(
//           onTap: () => Navigator.pop(context),
//           child: Icon(
//             Icons.chevron_left,
//             size: 30,
//           ),
//         ),
//         actions: [
//           GestureDetector(
//             onTap: () {
//               addressModel.city = "Mumbai";
//               addAddressBottomSheet(addressModel);
//             },
//             child: Padding(
//               padding: const EdgeInsets.only(right: 12),
//               child: Icon(
//                 Icons.add_outlined,
//                 size: 30,
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   addAddressBottomSheet(AddressModel addressModel) {
//     showModalBottomSheet(
//       context: context,
//       shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(20), topRight: Radius.circular(20))),
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (BuildContext context, StateSetter setState) {
//             return Column(
//               children: [
//                 SizedBox(height: 30),
//                 Center(
//                   child: SizedBox(
//                     width: MediaQuery.of(context).size.width * 0.85,
//                     child: AppThemeShared.textFormField(
//                         context: context,
//                         // labelText: 'Enter name \*',
//                         hintText: 'Flat no, Building name, Colony',
//                         // controller: nameController,
//                         validator: Utility.nameValidator,
//                         textInputAction: TextInputAction.next,
//                         autovalidateMode: AutovalidateMode.onUserInteraction),
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Center(
//                   child: SizedBox(
//                     width: MediaQuery.of(context).size.width * 0.85,
//                     child: AppThemeShared.textFormField(
//                         context: context,
//                         // labelText: 'Enter name \*',
//                         hintText: 'Street name, Landmark',
//                         // controller: nameController,
//                         validator: Utility.nameValidator,
//                         textInputAction: TextInputAction.next,
//                         autovalidateMode: AutovalidateMode.onUserInteraction),
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Center(
//                   child: SizedBox(
//                     width: MediaQuery.of(context).size.width * 0.85,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         SizedBox(
//                           width: MediaQuery.of(context).size.width * 0.4,
//                           child: AppThemeShared.textFormField(
//                               context: context,
//                               // labelText: 'Enter name \*',
//                               hintText: 'Locality',
//                               // controller: nameController,
//                               validator: Utility.nameValidator,
//                               textInputAction: TextInputAction.next,
//                               autovalidateMode:
//                                   AutovalidateMode.onUserInteraction),
//                         ),
//                         SizedBox(
//                           width: MediaQuery.of(context).size.width * 0.4,
//                           child: AppThemeShared.textFormField(
//                               context: context,
//                               // labelText: 'Enter name \*',
//                               hintText: 'City ',
//                               // controller: nameController,
//                               validator: Utility.nameValidator,
//                               textInputAction: TextInputAction.next,
//                               autovalidateMode:
//                                   AutovalidateMode.onUserInteraction),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Center(
//                   child: SizedBox(
//                     width: MediaQuery.of(context).size.width * 0.85,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         SizedBox(
//                           width: MediaQuery.of(context).size.width * 0.4,
//                           child: AppThemeShared.textFormField(
//                               context: context,
//                               // labelText: 'Enter name \*',
//                               hintText: 'State ',
//                               // controller: nameController,
//                               validator: Utility.nameValidator,
//                               textInputAction: TextInputAction.next,
//                               autovalidateMode:
//                                   AutovalidateMode.onUserInteraction),
//                         ),
//                         SizedBox(
//                           width: MediaQuery.of(context).size.width * 0.4,
//                           child: AppThemeShared.textFormField(
//                               context: context,
//                               // labelText: 'Enter name \*',
//                               hintText: 'Pincode',
//                               // controller: nameController,
//                               validator: Utility.nameValidator,
//                               textInputAction: TextInputAction.next,
//                               autovalidateMode:
//                                   AutovalidateMode.onUserInteraction),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 30),
//                 Center(
//                     child: AppThemeShared.argonButtonShared(
//                         context: context,
//                         height: 50,
//                         borderRadius: 12,
//                         width: MediaQuery.of(context).size.width * 0.85,
//                         color: AppThemeShared.buttonColor,
//                         buttonText: "Save Address",
//                         onTap: (startLoading, stopLoading, btnState) {})),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }

//   saveAddress() async {
//     SharedPreferences userData = await SharedPreferences.getInstance();
//     FirebaseFirestore.instance
//         .collection("Users")
//         .doc(userData.getString("userId"));
//   }
// }
