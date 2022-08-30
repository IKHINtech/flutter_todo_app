import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/model/activity_model.dart';
import 'package:todo_app/themes.dart';

Widget activityCard(
    {required ActivityModel activity,
    required int index,
    VoidCallback? callback}) {
  DateTime parseDate = new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
      .parse(activity.data![index].createdAt!);
  var inputDate = DateTime.parse(parseDate.toString());
  var outputFormat = DateFormat('dd MMMM yyyy ');
  var outputDate = outputFormat.format(inputDate);
  return InkWell(
    onTap: callback,
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 10,
      child: Container(
        padding: EdgeInsets.all(17),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              activity.data![index].title!,
              style: text14,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  outputDate,
                  style: text12,
                ),
                Container(
                  child: Image.asset(
                      'assets/images/activity-item-delete-button.png'),
                )
              ],
            )
          ],
        ),
        height: 150,
        width: 150,
      ),
    ),
  );
}
