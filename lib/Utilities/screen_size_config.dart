import 'package:flutter/cupertino.dart';

class screen_config{
double h;
double w;
double text;

screen_config(BuildContext context)
    : h = MediaQuery.of(context).size.height,
      w = MediaQuery.of(context).size.width,
      text = MediaQuery.of(context).size.width * 0.05; // 5% of the screen width
}
