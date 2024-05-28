import 'package:flutter/material.dart';
import 'package:rbgproject/home.dart';
import 'package:rbgproject/drugdetails.dart';
import 'package:rbgproject/healthdetails.dart';

class HomeScreen extends StatefulWidget {
  final String userId;
  const HomeScreen({super.key,required this.userId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int pageIndex = 0;
  final List<Widget> pages = [];

  @override
  void initState() {
    super.initState();
    pages.addAll([
      MyHomePage(
          userId: widget.userId),
      const DrugSearch(),
      UserHealthDetails(userId: widget.userId),
    ]);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white24,
      body: pages[pageIndex],
      bottomNavigationBar: buildMyNavBar(context),
    );
  }

  Container buildMyNavBar(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 0;
              });
            },
            icon: pageIndex == 0
                ? const Icon(
              Icons.home_filled,
              color: Colors.white,
              size: 35,
            )
                : const Icon(
              Icons.home_outlined,
              color: Colors.white,
              size: 35,
            ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 1;
              });
            },
            icon: pageIndex == 1
                ? const Icon(
              Icons.medical_information,
              color: Colors.white,
              size: 35,
            )
                : const Icon(
              Icons.medical_information_outlined,
              color: Colors.white,
              size: 35,
            ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 2;
              });
            },
            icon: pageIndex == 2
                ? const Icon(
              Icons.health_and_safety,
              color: Colors.white,
              size: 35,
            )
                : const Icon(
              Icons.health_and_safety_outlined,
              color: Colors.white,
              size: 35,
            ),
          ),
        ],
      ),
    );
  }
}
