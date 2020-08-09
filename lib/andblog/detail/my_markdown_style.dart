import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MyMarkdownStyle extends MarkdownStyleSheet {
  MyMarkdownStyle({TextStyle h2}) : super(h1: h2){}
}
