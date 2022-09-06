import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/themes.dart';

Widget customButton({VoidCallback? callback}) {
  return InkWell(
    onTap: callback,
    child: Container(
      height: 37,
      padding: EdgeInsets.only(left: 15, top: 9.5, right: 15, bottom: 9.5),
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.all(
          Radius.circular(45),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.add,
            color: Colors.white,
            size: 20,
          ),
          Text(
            'Tambah',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget modalButton(
        {VoidCallback? callback, Color? color, String? text, Color? fcolor}) =>
    InkWell(
      onTap: callback,
      child: Container(
        height: 48,
        width: 117,
        // padding: EdgeInsets.only(
        //     left: 15, top: 9.5, right: 15, bottom: 9.5),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(
            Radius.circular(45),
          ),
        ),
        child: Center(
          child: Text(
            text!,
            style: GoogleFonts.poppins(
              color: fcolor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
