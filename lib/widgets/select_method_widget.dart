// import 'package:flutter/material.dart';

// class SelectMethod extends StatefulWidget {
//   @override
//   _SelectMethodState createState() => _SelectMethodState();
// }

// class _SelectMethodState extends State<SelectMethod> {
//   @override
//   Widget build(BuildContext context) {
//     return await async showDialog(
//         context: context,
//         barrierDismissible: true,
//         builder: (_) => AlertDialog(
//           content: Column(
//             children: <Widget>[
//               RadioListTile<String>(
//                 title: Text('Create new wallet'),
//                 value: 'Create new wallet',
//                 groupValue: _tempMethod,
//                 activeColor: Colors.blue,
//                 onChanged: (value) {
//                   setState(() {
//                     _tempMethod = value;
//                   });
//                 },
//               ),
//               RadioListTile<String>(
//                 title: Text('Recover wallet'),
//                 value: 'Recover wallet',
//                 groupValue: _tempMethod,
//                 onChanged: (value) {
//                   setState(() {
//                     _tempMethod = value;
//                   });
//                 },
//               ),
//             ],
//           ),
//           actions: <Widget>[
//             FlatButton(
//               onPressed: () => _setMethod(context, _tempMethod),
//               child: Text('OK'),
//             )
//           ],
//         ),
//       );
//     }
//   }
