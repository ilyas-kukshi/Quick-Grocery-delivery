// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
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
//   List<DocumentSnapshot> myAddresses = [];
//   AddressModel addressModel = AddressModel("", "", "", "", "", '');


  

//   @override
//   void initState() {
//     super.initState();
//     getSelectedLocation();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppThemeShared.appBar(
//           title: "Address",
//           context: context,
//           leading: GestureDetector(
//             onTap: () => Navigator.pop(context),
//             child: Icon(
//               Icons.chevron_left,
//               size: 30,
//             ),
//           ),
//           actions: [
//             GestureDetector(
//               onTap: () {
//                 addressModel.city = "Mumbai";
//                 addAddressBottomSheet(addressModel);
//               },
//               child: Padding(
//                 padding: const EdgeInsets.only(right: 12),
//                 child: Icon(
//                   Icons.add_outlined,
//                   size: 30,
//                 ),
//               ),
//             )
//           ],
//         ),
//         body: myAddresses.length > 0
//             ? ListView.builder(
//                 itemCount: myAddresses.length,
//                 itemBuilder: (context, index) {
//                   return SizedBox(
//                     width: MediaQuery.of(context).size.width * 0.85,
//                   );
//                 },
//               )
//             : Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'No address available',
//                     style: TextStyle(
//                         color: Colors.black,
//                         fontFamily: "Times New Roman",
//                         fontSize: 20),
//                   ),
//                   SizedBox(height: 8),
//                   Center(
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                           primary: Colors.white,
//                           side: BorderSide(
//                               color: AppThemeShared.buttonColor, width: 2),
//                           minimumSize: Size(
//                               MediaQuery.of(context).size.width * 0.85, 50)),
//                       onPressed: () => addAddressBottomSheet(addressModel),
//                       child: Text(
//                         "Add Address",
//                         style: TextStyle(
//                             color: Colors.black,
//                             fontFamily: "Times New Roman",
//                             fontSize: 20),
//                       ),
//                     ),
//                   ),
//                 ],
//               ));
//   }

 

//   saveAddress() async {
//     SharedPreferences userData = await SharedPreferences.getInstance();
//     FirebaseFirestore.instance
//         .collection("Users")
//         .doc(userData.getString("userId"));
//   }

//   getAddress() async {
//     await FirebaseFirestore.instance
//         .collection("Users")
//         .doc(FirebaseAuth.instance.currentUser!.uid)
//         .collection("My Addresses")
//         .get()
//         .then((value) {
//       value.docs.forEach((element) {
//         myAddresses.add(element);
//       });
//     });
//   }
// }
