import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InfiniteScrollPage extends StatefulWidget {
  @override
  _InfiniteScrollPageState createState() => _InfiniteScrollPageState();
}

class _InfiniteScrollPageState extends State<InfiniteScrollPage> {
  // List to store the API data
  List<dynamic> items = [];

  // Page counter
  int currentPage = 1;

  // Boolean to keep track of the API call status
  bool isLoading = false;

  // Map to store the cache data
  Map<int, dynamic> cache = {};

  // Timer to delete the cache after 1 minute
  Timer? timer;

  @override
  void initState() {
    super.initState();
    // Call the API and fetch the first page of data
    fetchData();
  }

  // Method to call the API and fetch the data
  Future<void> fetchData() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    var response;

    if (cache[currentPage] != null) {
      response = cache[currentPage];
    } else {
      // API call to fetch the data
      response = await http.get(Uri.parse(
          "https://jsonplaceholder.typicode.com/posts?_page=$currentPage&_limit=40"));

      // Store the data in the cache
      cache[currentPage] = response;

      // Set the timer to delete the cache after 1 minute
      timer = Timer(Duration(minutes: 1), () {
        cache.remove(currentPage);
      });
    }

    // Parse the JSON data
    var data = json.decode(response.body);

    setState(() {
      items.addAll(data);
      isLoading = false;
    });
  }

  // Method to load more data when the user reaches the end of the list
  Future<void> loadMore() async {
    if (isLoading) return;

    currentPage++;
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: items.length + 1,
        itemBuilder: (context, index) {
          if (index == items.length) {
            return Container(
              height: 60,
              child: Center(
                child: isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: loadMore,
                        child: Text("Load More"),
                      ),
              ),
            );
          } else {
            return Card(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(items[index]['title']),
              ),
            );
          }
        },
      ),
    );
  }
}
