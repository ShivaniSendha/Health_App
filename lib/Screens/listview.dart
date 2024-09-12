import 'package:flutter/material.dart';

class Listview extends StatelessWidget {
  const Listview({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 100,
                height: 100,
                color: Colors.pink,
                child: Text("Apple"),
              ),
            ),
           
            Container(
              width: 100,
              height: 100,
              color: Colors.amber,
              child: Text("Banana"),
            )
          ],
        ),
      ),
    );
  }
}
