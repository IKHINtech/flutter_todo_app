import 'package:flutter/material.dart';
import 'package:todo_app/model/todo_model.dart';
import 'package:todo_app/themes.dart';

// Widget todoCard(
//     {required TodoModel todo, required int index, VoidCallback? callback}) {
//   bool isSelected = false;

//   return InkWell(
//     onTap: callback,
//     child: Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12.0),
//       ),
//       elevation: 5,
//       child: ListTile(
//         trailing: InkWell(
//             onTap: () {},
//             child:
//                 Image.asset('assets/images/activity-item-delete-button.png')),
//         leading: Checkbox(
//           value: isSelected,
//           onChanged: (value) {
//             isSelected = !isSelected;
//           },
//         ),
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: todo.data![index].priority == 'very-high'
//                       ? Colors.red
//                       : todo.data![index].priority == 'high'
//                           ? Colors.orange
//                           : todo.data![index].priority == 'normal'
//                               ? Colors.green
//                               : todo.data![index].priority == 'low'
//                                   ? Colors.blue
//                                   : Colors.purple),
//               height: 5,
//               width: 5,
//             ),
//             SizedBox(
//               width: 10,
//             ),
//             Text(
//               todo.data![index].title!,
//               style: text14,
//             ),
//             SizedBox(
//               width: 10,
//             ),
//             InkWell(
//                 onTap: () {},
//                 child: Image.asset('assets/images/todo-item-edit-button.png'))
//           ],
//         ),
//       ),
//     ),
//   );
// }
