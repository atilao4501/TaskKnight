import 'package:flutter/material.dart';
import 'package:task_knight_alpha/controllers/knightController.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Main content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Center(
                    child: Text(
                      'Wanderer',
                      style: TextStyle(
                        fontSize: 32,
                        color: Colors.yellow.shade700,
                        shadows: [
                          Shadow(
                            offset: Offset(2, 2),
                            blurRadius: 0,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Progress bar
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  child: Row(
                    children: List.generate(20, (index) {
                      // first 5 filled, rest empty for example
                      final filled = index < 5;
                      return Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 2),
                          height: 12,
                          decoration: BoxDecoration(
                            color: filled
                                ? Colors.yellow.shade700
                                : Colors.black54,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                // Task grid
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: PageView.builder(
                        itemCount: (8 / 4)
                            .ceil(), // replace 8 with your total task count variable
                        controller: PageController(viewportFraction: 1),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, pageIndex) {
                          final start = pageIndex * 4;
                          final end = (start + 4).clamp(0,
                              8); // replace 8 with your total task count variable
                          final tasks = List.generate(
                              end - start, (i) => _buildTaskCard(context));
                          return Center(
                            child: GridView.count(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 164 / 184,
                              children: tasks,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                // Bottom buttons
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFBDA274),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Icon(Icons.add, color: Colors.black),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFBDA274),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Icon(Icons.settings, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xBF393939),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset("assets/images/skullButton.png",
                  width: 40, height: 40),
              SizedBox(width: 30),
              Image.asset("assets/images/penButton.png", width: 40, height: 40)
            ],
          ),
          SizedBox(height: 10),
          Text(
            'Lorem ipsum arcu a cursus in imperdiet viverra tincidunt justo sed sit magna mauris.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Text(
                "TASK ONE",
                style: TextStyle(fontSize: 7),
              ),
              Positioned(
                top: -55,
                width: 100,
                height: 100,
                child: Image.asset(
                  "assets/images/RunGreenSlime.gif",
                  width: 100,
                  height: 100,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
