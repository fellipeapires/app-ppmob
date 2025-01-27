import 'package:flutter/material.dart';

class CircularProgressComponent extends StatelessWidget {
  const CircularProgressComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(5),
              child: Text(
                'Aguarde por favor!',
                style: TextStyle(
                  color: Colors.blue[900],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      ],
    );
  }
}
