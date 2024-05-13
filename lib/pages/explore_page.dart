import 'package:agriplant/components/my_button.dart';
import 'package:agriplant/components/product_card.dart';
import 'package:agriplant/database/firestore.dart';
import 'package:agriplant/pages/manage_product_page.dart';
import 'package:flutter/material.dart';

class ExplorePage extends StatelessWidget {
  ExplorePage({super.key});
  final FirestoreDatabase database = FirestoreDatabase();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: MyButton(
            text: "Manage Products",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ManageProductPage(),
                ),
              );
            },
          ),
        ),
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
                  // Timestamp timestamp = post['TimeStamp'];

                  //.............................................

                  // List productList = snapshot.data!.docs;
                  // DocumentSnapshot documentNew = productList[index];
                  // String docID = documentNew.id;

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ProductCard(
                        title: title,
                        description: description,
                        phone: phone,
                        price: price,
                        userEmail: userEmail,
                        imageUrl: imageUrl),
                  );
                },
              ),
            );
          },
        )
      ],
    );
  }
}
