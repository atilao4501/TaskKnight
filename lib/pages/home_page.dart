import 'package:flutter/material.dart';
import 'package:task_knight_alpha/pages/add_task_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          _buildContentHUD(context),
        ],
      ),
    );
  }

  Widget _buildContentHUD(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: Row(
              children: List.generate(20, (index) {
                final filled = index < 5;
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 2),
                    height: 12,
                    decoration: BoxDecoration(
                      color: filled ? Colors.yellow.shade700 : Colors.black54,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                );
              }),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(12),
                child: PageView.builder(
                  itemCount: (8 / 4).ceil(),
                  controller: PageController(viewportFraction: 1),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, pageIndex) {
                    final start = pageIndex * 4;
                    final end = (start + 4).clamp(0, 8);
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddTaskPage(),
                        ),
                      );
                    },
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
    );
  }

  Widget _buildTaskCard(BuildContext context) {
    return SizedBox(
      width: 164,
      height: 184,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 164,
            height: 184,
            decoration: BoxDecoration(
              color: Color(0xBF393939),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: EdgeInsets.only(top: 10, left: 12, right: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/penButton.png",
                        width: 40, height: 40),
                    SizedBox(width: 30),
                    Image.asset("assets/images/skullButton.png",
                        width: 40, height: 40),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'Lorem ipsum arcu a cursus in imperdiet viverra tincidunt justo sed sit magna mauris lacus sodales erat in placerat ullamcorper suspendisse risus proin facilisis fermentum elit blandit orci volutpat tristique risus.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 7,
                    height: 1.2,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Task1",
                  style: TextStyle(
                    fontSize: 9,
                    color: Color(0xFFFFE100),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2),
                Image.asset(
                  "assets/images/RunGreenSlimeCrop.gif",
                  width: 60,
                  height: 34,
                  filterQuality: FilterQuality.none,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
