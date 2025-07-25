// // Flutter imports:
// import 'package:flutter/material.dart';

// // Package imports:
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:task_management/view/screen/group_call/group_constant.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

// // Project imports:

// class GroupHomePage extends StatefulWidget {
//   final String token;
//   final int? meetingId;
//   const GroupHomePage({Key? key, required this.token, this.meetingId})
//       : super(key: key);

//   @override
//   State<StatefulWidget> createState() => GroupHomePageState();
// }

// class GroupHomePageState extends State<GroupHomePage> {
//   /// Users who use the same callID can in the same call.
//   final callIDTextCtrl = TextEditingController(text: 'call_id');

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: WillPopScope(
//           onWillPop: () async {
//             return false;
//           },
//           child: Stack(
//             children: [
//               Positioned(
//                 top: 20,
//                 right: 10,
//                 child: logoutButton(),
//               ),
//               Positioned(
//                 top: 50,
//                 left: 10,
//                 child: Text('Your Phone Number: ${currentUser.id}'),
//               ),
//               joinCallContainer(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget logoutButton() {
//     return Ink(
//       width: 35,
//       height: 35,
//       decoration: const BoxDecoration(
//         shape: BoxShape.circle,
//         color: Colors.redAccent,
//       ),
//       child: ValueListenableBuilder<bool>(
//         valueListenable:
//             ZegoUIKitPrebuiltCallController().minimize.isMinimizingNotifier,
//         builder: (context, isMinimized, _) {
//           return IconButton(
//             icon: const Icon(Icons.exit_to_app_sharp),
//             iconSize: 20,
//             color: Colors.white,
//             onPressed: isMinimized
//                 ? null
//                 : () async {
//                     final prefs = await SharedPreferences.getInstance();
//                     prefs.remove(cacheUserIDKey);

//                     Navigator.pushNamed(
//                       context,
//                       PageRouteNames.login,
//                     );
//                   },
//           );
//         },
//       ),
//     );
//   }

//   Widget joinCallContainer() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Expanded(
//               child: TextFormField(
//                 controller: callIDTextCtrl,
//                 decoration: const InputDecoration(
//                   labelText: 'join a group call by id',
//                 ),
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 if (ZegoUIKitPrebuiltCallController().minimize.isMinimizing) {
//                   /// when the application is minimized (in a minimized state),
//                   /// disable button clicks to prevent multiple PrebuiltCall components from being created.
//                   return;
//                 }

//                 Navigator.pushNamed(context, PageRouteNames.prebuilt_call,
//                     arguments: <String, String>{
//                       PageParam.call_id: callIDTextCtrl.text.trim(),
//                     });
//               },
//               child: const Text('join'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
