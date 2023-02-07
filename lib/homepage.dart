import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_infinite_scroll_withcaching_rest_api/infiniteScroll.dart';
import 'package:flutter_infinite_scroll_withcaching_rest_api/infinitescrollScrollend.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => InfiniteScrollPage()));
                  },
                  child: Text("Infinite Scroll Button")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => InfiniteScrollPageScrollEnd()));
                  },
                  child: Text("Infinite Scroll End"))
            ],
          ),
        ),
      ),
    );
  }
}
