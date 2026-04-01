import 'package:flutter/material.dart';

abstract class AbstractHomePage extends StatefulWidget {
  const AbstractHomePage({super.key});

  @override
  State<AbstractHomePage> createState() => _AbstractHomePageState();

  IconData getIcon();
}

class _AbstractHomePageState extends State<AbstractHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}