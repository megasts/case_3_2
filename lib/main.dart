import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);



  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late Future<Post> futurePost;

  @override
  void initState() {
    super.initState();
    futurePost = fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Проба сети'),
      ),
      body: Center(
            child: FutureBuilder<Post>(
                    future: futurePost,
                    builder: (context, snapshot) {
                          if (snapshot.hasData) {
                          return
                            Column(
                              children: [
                                Text('Заголовок:\n ${snapshot.data!.title}',
                                style: Theme.of(context).textTheme.headline5,),
                                const SizedBox(height: 25,),
                                Text('Публикация:\n\n${snapshot.data!.body}',
                                    style: Theme.of(context).textTheme.headline6,)
                              ],
                            );

                          }
                          else if (snapshot.hasError) {
                          return Text('Произошла ошибка:\n${snapshot.error}');
                          }
                          return const CircularProgressIndicator();
                          }
                        ),
                    ),
    );
  }
}

class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body']
    );
  }
}

Future<Post> fetchPost() async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));

  if (response.statusCode == 200) {
    return Post.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load');
  }
}