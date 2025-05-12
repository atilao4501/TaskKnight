import 'package:flutter/material.dart';

class TaskCardWidget extends StatelessWidget {
  final String taskTitle;
  final String slimeAsset;

  const TaskCardWidget({
    super.key,
    required this.taskTitle,
    required this.slimeAsset,
  });

  @override
  Widget build(BuildContext context) {
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
                  taskTitle,
                  style: TextStyle(
                    fontSize: 9,
                    color: Color(0xFFFFE100),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2),
                Image.asset(
                  slimeAsset,
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
