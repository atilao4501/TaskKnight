import 'package:flutter/material.dart';
import 'package:task_knight_alpha/controllers/knightController.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Center(
            child: Container(
              width: 363,
              height: 398,
              decoration: BoxDecoration(
                  color: Color(Colors.black.value),
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 10,
                    childAspectRatio: 164 / 184,
                    children: List.generate(4, (index) {
                      return _buildTaskCard();
                    })),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTaskCard() {
    return SizedBox(
      width: 164,
      height: 184,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xBF393939),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Tarefa',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.yellow,
              ),
            ),
            Text(
              'Lorem ipsum arcu a cursus in imperdiet viverra tincidunt justo sed sit magna mauris.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: Colors.white,
                fontFamily: 'PixelifySans',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
