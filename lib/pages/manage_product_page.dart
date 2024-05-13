import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agriplant/database/firestore.dart';
import 'package:agriplant/pages/add_product_page.dart';
import 'package:agriplant/pages/product_details_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ManageProductPage extends StatelessWidget {
  ManageProductPage({super.key});
  final FirestoreDatabase database = FirestoreDatabase();
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Products "),
      ),
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddProductPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(minimumSize: const Size(200, 50)),
              child: const Text("Add Product"),
            ),
          ),
          const SizedBox(height: 15),
          StreamBuilder(
            stream: database.getProductStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final products = snapshot.data!.docs;
              if (snapshot.data == null || products.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(25),
                    child: Text('No products.....'),
                  ),
                );
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    String title = product['Title'];
                    String userEmail = product['UserEmail'];
                    String description = product['Description'];
                    String phone = product['PhoneNo'];
                    String price = product['Price'];
                    String imageUrl = product['ImageUrl'];
                    //Timestamp timestamp = product['TimeStamp'];
                    List productList = snapshot.data!.docs;
                    DocumentSnapshot documentNew = productList[index];
                    String docID = documentNew.id;

                    if (user!.email == userEmail) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 231, 252, 230),
                              borderRadius: BorderRadius.circular(13)),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetailsPage(
                                        title: title,
                                        description: description,
                                        phone: phone,
                                        price: price,
                                        userEmail: userEmail,
                                        imageUrl: imageUrl),
                                  ));
                            },
                            child: ListTile(
                              title: Text(
                                title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              leading: CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(imageUrl),
                              ),
                              subtitle: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text('Price : INR $price'),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(userEmail),
                                      IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text(
                                                  'Delete Product',
                                                ),
                                                content: const Text(
                                                    'Are you sure you want to remove this product?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      database
                                                          .deleteProduct(docID);
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text(
                                                      'Yes',
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
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
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
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

          // Container(
          //   color: const Color.fromARGB(255, 227, 255, 227),
          //   height: 100,
          //   width: double.infinity,
          //   child: const Padding(
          //     padding:  EdgeInsets.all(8.0),
          //     child: Row(
          //       children: [
          //         CircleAvatar(
          //           radius: 30,
          //           backgroundImage: NetworkImage(
          //               "https://th.bing.com/th/id/OIP.691Hw6NXrfwl4cskWAja_QHaFj?w=249&h=187&c=7&r=0&o=5&dpr=1.3&pid=1.7"),
          //         ),
          //       ],
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
