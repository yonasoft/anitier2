import 'package:flutter/material.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: () {},
              child: Text("Create New"),
            ),
            SizedBox(
              height: 8,
            ),
            OutlinedButton(
              onPressed: () {},
              child: Text("Edit Tier List"),
            ),
            SizedBox(
              height: 8,
            ),
            OutlinedButton(
              onPressed: () {},
              child: Text("Create From Template"),
            ),
          ],
        ),
      ),
    );
  }
}
