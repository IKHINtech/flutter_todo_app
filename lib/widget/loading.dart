import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

Widget loadingHexagon({Color? color}) => SizedBox(
      height: 40,
      child: Center(
        child: LoadingAnimationWidget.hexagonDots(
          color: color ?? Colors.white,
          size: 40,
        ),
      ),
    );
