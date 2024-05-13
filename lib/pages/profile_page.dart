//import 'package:agriplant/components/my_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final User? currentUser = FirebaseAuth.instance.currentUser;
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser!.email)
        .get();
  }

  void logout() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: getUserDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text('Error : ${snapshot.error}');
          } else if (snapshot.hasData) {
            Map<String, dynamic>? user = snapshot.data!.data();
            return SafeArea(
              child: Center(
                child: Column(
                  children: [
                    // const Row(
                    //   children: [
                    //     MyBackButton(),
                    //   ],
                    // ),
                    const SizedBox(height: 30),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(
                          Radius.circular(25),
                        ),
                      ),
                      padding: const EdgeInsets.all(25),
                      child: const Icon(
                        Icons.person,
                        size: 64,
                      ),
                    ),
                    Text(
                      user!['username'],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    Text(
                      user['email'],
                      style: const TextStyle(fontSize: 18),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(35.0),
                      child: Text(
                          'This mobile App is Developed as part of academic project of Btech CSE 2020-24 batch of MES  College of Engineering,   App version 0.1.2  Admin Contact: aaaan19212429@gmail.com'),
                    )
                  ],
                ),
              ),
            );
          } else {
            return const Text('No data');
          }
        },
      ),
    );
  }
}
