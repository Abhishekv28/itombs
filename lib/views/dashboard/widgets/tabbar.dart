import 'package:flutter/material.dart';

class TabbarView extends StatelessWidget {
  final int length;
  final TabController controller;
  final int currentIndex;
  final List<String> labels;
  final List<Widget> widgets;
  final double fontSize;
  final FontWeight fontWeight;
  final Color selectedColor;
  final Color unselectedColor;
  final double labelPadding;
  final double indicatorWeight;

  TabbarView(
      {Key key,
      this.length,
      this.controller,
      this.currentIndex,
      this.labels,
      this.widgets,
      this.fontSize = 18,
      this.fontWeight = FontWeight.bold,
      this.selectedColor = Colors.blueAccent,
      this.unselectedColor = Colors.grey,
      this.indicatorWeight = 2,
      this.labelPadding = 5})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: length,
      child: Column(
        children: [
          Stack(
            fit: StackFit.passthrough,
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: this.unselectedColor, width: 1.0),
                  ),
                ),
              ),
              TabBar(
                labelColor: this.selectedColor,
                unselectedLabelColor: this.unselectedColor,
                indicatorColor: this.selectedColor,
                controller: controller,
                labelStyle:
                    TextStyle(fontWeight: fontWeight, fontSize: fontSize),
                indicatorWeight: indicatorWeight,
                labelPadding: EdgeInsets.all(labelPadding),
                onTap: (index) {},
                tabs: <Widget>[
                  for (int i = 0; i < this.length; i++)
                    Text(
                      this.labels[i],
                      style: TextStyle(
                          fontSize: this.fontSize, fontWeight: this.fontWeight),
                    ),
                ],
              ),
            ],
          ),
          Expanded(
            child: TabBarView(controller: controller, children: this.widgets),
          )
        ],
      ),
    );
  }
}
