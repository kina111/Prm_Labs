import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'API-powered List Screen'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Post>> _postsFuture;
  ApiService apiService = ApiService();

  List<Post> _posts = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // _postsFuture = apiService.fetch();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    try{
      final data = await apiService.fetch();
      setState(() {
        _posts = data;
        _isLoading = false;
      });
    }catch(e){
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
      ),
      // body: FutureBuilder(
      //     future: _postsFuture,
      //     builder: (context, snapshot) {
      //       if (snapshot.connectionState == ConnectionState.waiting){
      //         return const Center(child: CircularProgressIndicator());
      //       }else if (snapshot.hasError){
      //         return Center(child: Text('Error: ${snapshot.error}'));
      //       }else if (!snapshot.hasData || snapshot.data!.isEmpty){
      //         return const Center(child: Text('No data'));
      //       }
      //       final posts = snapshot.data!;
      //       return ListView.builder(
      //           itemCount: posts.length,
      //           itemBuilder: (context, index) => ListTile(
      //             leading: Text(posts[index].id.toString()),
      //             title: Text(posts[index].title),
      //             subtitle: Text(posts[index].body),
      //         )
      //       );
      //     }
      // ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(child: Text(_errorMessage!))
          : ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (context, index) => ListTile(
          leading: Text(_posts[index].id.toString()),
          title: Text(_posts[index].title),
          subtitle: Text(_posts[index].body),
        ),
      ),
      // button to show add-post form
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPostForm()),
          );
          if (result != null && result is Map) {
            try {
              final newPost = await apiService.addPost(result['title'], result['body']);
              setState(() {
                _posts.insert(0, newPost); // <-- Chèn lên đầu danh sách tại đây
              });
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Lỗi: $e')),
              );
            }
          }
        },
        tooltip: 'Add Post',
        child: const Icon(Icons.add),
      ),
    );
  }
}
class AddPostForm extends StatefulWidget {
  const AddPostForm({super.key});
  @override
  State<AddPostForm> createState() => _AddPostFormState();
}
class _AddPostFormState extends State<AddPostForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Post'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _bodyController,
                decoration: const InputDecoration(
                  labelText: 'Body',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a body';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final title = _titleController.text;
                    final body = _bodyController.text;
                    Navigator.pop(context, {'title': title, 'body': body});
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }
}
class Post{
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
  factory Post.fromJson(Map<String, dynamic> json){
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }

  @override
  String toString() {
    return 'Post(id: $id, userId: $userId, title: $title)';
  }
}

class ApiService{
  final http.Client client;
  ApiService({http.Client? client}) : client = client ?? http.Client();

  Future<List<Post>> fetch() async {
    final url = Uri.parse("https://jsonplaceholder.typicode.com/posts");
    final response = await client.get(url);
    if (response.statusCode != 200) {
      throw Exception("Failed to load posts");
    }
    final List<dynamic> body = jsonDecode(response.body);
    List<Post> posts = body.map((dynamic item) => Post.fromJson(item)).toList();
    return posts;
  }

  // post a new post to the head of list
  Future<Post> addPost(String title, String body) async {
    final url = Uri.parse("https://jsonplaceholder.typicode.com/posts");
    final response = await client.post(url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'title': title,
          'body': body,
          'userId': 1,
        }
      )
    );
    if (response.statusCode != 201) {
      throw Exception("Failed to add post");
    }
    final Post post = Post.fromJson(jsonDecode(response.body));
    return post;
  }
}
