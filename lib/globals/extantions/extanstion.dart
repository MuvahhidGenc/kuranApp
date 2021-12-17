import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension SnippetExtanstion on BuildContext{
  ThemeData get theme=>Theme.of(this);
  MediaQueryData get media=>MediaQuery.of(this);
}