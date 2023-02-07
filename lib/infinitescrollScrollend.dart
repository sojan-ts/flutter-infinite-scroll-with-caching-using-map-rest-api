import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InfiniteScrollPageScrollEnd extends StatefulWidget {
  @override
  _InfiniteScrollPageScrollEndState createState() =>
      _InfiniteScrollPageScrollEndState();
}

class _InfiniteScrollPageScrollEndState
    extends State<InfiniteScrollPageScrollEnd> {
  int _page = 1;
  List _posts = [];
  bool _isLoading = false;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchPosts();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _fetchPosts();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  _fetchPosts() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    final response = await http.get(Uri.parse(
        'https://jsonplaceholder.typicode.com/posts?_page=$_page&_limit=40'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      setState(() {
        _posts.addAll(data);
        _page++;
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        controller: _scrollController,
        itemCount: _posts.length + 1,
        itemBuilder: (context, index) {
          if (index == _posts.length) {
            return _buildProgressIndicator();
          } else {
            return _buildPostItem(_posts[index]);
          }
        },
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(
        child: _isLoading ? CircularProgressIndicator() : Container(),
      ),
    );
  }

  Widget _buildPostItem(post) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(post['title']),
      ),
    );
  }
}
