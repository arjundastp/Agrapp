import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agriplant/database/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ManagePost extends StatelessWidget {
  ManagePost({super.key});

  final FirestoreDatabase database = FirestoreDatabase();
  final User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Posts"),
      ),
      body: Column(
        children: [
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
                    // Timestamp timestamp = post['TimeStamp'];
                    List postList = snapshot.data!.docs;
                    DocumentSnapshot document = postList[index];
                    String docID = document.id;

                    if (user!.email == userEmail) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 23, 3, 64),
                              borderRadius: BorderRadius.circular(13),
                              border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 137, 198, 248),
                                  width: 2)),
                          child: ListTile(
                            title: Text(
                              message,
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  userEmail,
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 210, 142, 33)),
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text(
                                              'Delete Post',
                                            ),
                                            content: const Text(
                                                'Are you sure you want to remove the Post?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  database.deleteNote(docID);
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text(
                                                  'Yes',
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text(
                                                  'No',
                                                  style: TextStyle(
                                                      color: Colors.blue),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ))
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      return const Text("");
                    }
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
