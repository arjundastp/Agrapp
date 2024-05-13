import 'package:agriplant/components/my_textfield.dart';
import 'package:agriplant/database/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:agriplant/pages/manage_post_page.dart';

class ForumPage extends StatelessWidget {
  ForumPage({super.key});
  final FirestoreDatabase database = FirestoreDatabase();
  final TextEditingController newPostController = TextEditingController();

  final CollectionReference users =
      FirebaseFirestore.instance.collection('Users');

  void postMessage() {
    if (newPostController.text.isNotEmpty) {
      database.addPost(newPostController.text);
    }
    newPostController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FORUM DISCUSSION'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
                  child: MyTextField(
                      hintText: "New Post",
                      obscureText: false,
                      controller: newPostController),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(shape: const CircleBorder()),
                  onPressed: postMessage,
                  child: const Icon(Icons.done),
                ),
              ],
            ),
          ),

          //Posts
          StreamBuilder(
            stream: database.getPostStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final posts = snapshot.data!.docs;
              if (snapshot.data == null || posts.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(25),
                    child: Text('No posts.....'),
                  ),
                );
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    String message = post['PostMessage'];
                    String userEmail = post['UserEmail'];
                    //Timestamp timestamp = post['TimeStamp'];

                    return Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 0, 2, 60),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                width: 2,
                                color:
                                    const Color.fromARGB(255, 76, 130, 175))),
                        child: ListTile(
                          title: Text(
                            message,
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Row(
                            children: [
                              Text(
                                'User Email : $userEmail',
                                style: TextStyle(color: Colors.yellow[800]),
                              ),
                              //Text(timestamp.toString()),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ManagePost(),
            ),
          );
        },
        child: const Icon(Icons.edit),
      ),
    );
  }
}
