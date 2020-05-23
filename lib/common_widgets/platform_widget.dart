import 'dart:io';
import 'package:flutter/material.dart';

// custom abstract class to build a platform aware dialog
abstract class PlatformWidget extends StatelessWidget {

  Widget buildCupertinoWidget(BuildContext context);

  Widget buildMaterialWidget(BuildContext context);
  @override
  Widget build(BuildContext context) {
   if (Platform.isIOS) {
     return buildCupertinoWidget(context);
   }
   return buildMaterialWidget(context);
  }
}

