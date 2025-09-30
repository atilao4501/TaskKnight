import 'package:flutter/material.dart';
import 'package:task_knight_alpha/pages/add_task_page.dart';
import 'package:task_knight_alpha/models/task.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Task> tasks = [
    Task(
      title: 'Task1',
      description:
          'Lorem ipsum arcu a cursus in imperdiet viverra tincidunt justo sed sit magna mauris lacus sodales erat in placerat ullamcorper suspendisse risus proin facilisis fermentum elit blandit orci volutpat tristique risus.',
      slimeColor: SlimeColor.green,
    ),
    Task(
      title: 'Task2',
      description:
          'Lorem ipsum arcu a cursus in imperdiet viverra tincidunt justo sed sit magna mauris lacus sodales erat in placerat ullamcorper suspendisse risus proin facilisis fermentum elit blandit orci volutpat tristique risus.',
      slimeColor: SlimeColor.red,
    ),
    Task(
      title: 'Task3',
      description:
          'Lorem ipsum arcu a cursus in imperdiet viverra tincidunt justo sed sit magna mauris lacus sodales erat in placerat ullamcorper suspendisse risus proin facilisis fermentum elit blandit orci volutpat tristique risus.',
      slimeColor: SlimeColor.blue,
    ),
    Task(
      title: 'Task4',
      description:
          'Lorem ipsum arcu a cursus in imperdiet viverra tincidunt justo sed sit magna mauris lacus sodales erat in placerat ullamcorper suspendisse risus proin facilisis fermentum elit blandit orci volutpat tristique risus.',
      slimeColor: SlimeColor.green,
    ),
    Task(
      title: 'Task5',
      description:
          'Lorem ipsum arcu a cursus in imperdiet viverra tincidunt justo sed sit magna mauris lacus sodales erat in placerat ullamcorper suspendisse risus proin facilisis fermentum elit blandit orci volutpat tristique risus.',
      slimeColor: SlimeColor.red,
    ),
    Task(
      title: 'Task6',
      description:
          'Lorem ipsum arcu a cursus in imperdiet viverra tincidunt justo sed sit magna mauris lacus sodales erat in placerat ullamcorper suspendisse risus proin facilisis fermentum elit blandit orci volutpat tristique risus.',
      slimeColor: SlimeColor.blue,
    ),
    Task(
      title: 'Task7',
      description:
          'Lorem ipsum arcu a cursus in imperdiet viverra tincidunt justo sed sit magna mauris lacus sodales erat in placerat ullamcorper suspendisse risus proin facilisis fermentum elit blandit orci volutpat tristique risus.',
      slimeColor: SlimeColor.green,
    ),
    Task(
      title: 'Task8',
      description:
          'Lorem ipsum arcu a cursus in imperdiet viverra tincidunt justo sed sit magna mauris lacus sodales erat in placerat ullamcorper suspendisse risus proin facilisis fermentum elit blandit orci volutpat tristique risus.',
      slimeColor: SlimeColor.red,
    ),
  ];

  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

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
                  itemCount: (tasks.length / 4).ceil(),
                  controller: _pageController,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (index) =>
                      setState(() => _currentPage = index),
                  itemBuilder: (context, pageIndex) {
                    final start = pageIndex * 4;
                    final end = (start + 4).clamp(0, tasks.length).toInt();
                    final pageTasks = tasks.sublist(start, end);
                    final taskCards = pageTasks
                        .map((task) => _buildTaskCard(context, task))
                        .toList();
                    return Center(
                      child: GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 164 / 184,
                        children: taskCards,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate((tasks.length / 4).ceil(), (index) {
              return Container(
                width: 8,
                height: 8,
                margin: EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: index == _currentPage
                      ? Colors.yellow.shade700
                      : Colors.black54,
                  shape: BoxShape.circle,
                ),
              );
            }),
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

  Widget _buildTaskCard(BuildContext context, Task task) {
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
                  task.description,
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
                  task.title,
                  style: TextStyle(
                    fontSize: 9,
                    color: Color(0xFFFFE100),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2),
                Image.asset(
                  task.slimeAsset,
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
