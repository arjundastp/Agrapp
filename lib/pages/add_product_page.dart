import 'dart:io';

import 'package:agriplant/components/my_textfield.dart';
import 'package:agriplant/database/firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController titleController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  final FirestoreDatabase database = FirestoreDatabase();

  String imageUrl = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Product"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton.icon(
                label: const Text("Add photo"),
                style: IconButton.styleFrom(),
                onPressed: () async {
                  ImagePicker imagePicker = ImagePicker();
                  XFile? file =
                      await imagePicker.pickImage(source: ImageSource.gallery);
                  //print('${file?.path}');
                  if (file == null) return;
                  String uniqueFileName =
                      DateTime.now().microsecondsSinceEpoch.toString();
                  Reference referenceRoot = FirebaseStorage.instance.ref();
                  Reference referenceDirImage = referenceRoot.child('images');

                  Reference referenceImageToUpload =
                      referenceDirImage.child(uniqueFileName);

                  //store the file
                  try {
                    await referenceImageToUpload.putFile(File(file.path));
                    imageUrl = await referenceImageToUpload.getDownloadURL();
                  } catch (error) {
                    const Text('Error in upload');
                  }
                },
                icon: const Icon(Icons.add_a_photo)),
            const Text(
              "Title",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            MyTextField(
              hintText: "Product Title",
              obscureText: false,
              controller: titleController,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Description",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            MyTextField(
              hintText: "Product Description",
              obscureText: false,
              controller: descriptionController,
            ),
            const SizedBox(height: 10),
            const Text(
              "Phone Number",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                hintText: "Phone number",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: const TextInputType.numberWithOptions(),
            ),
            const SizedBox(height: 10),
            const Text(
              "Price",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(
                hintText: "Price",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: const TextInputType.numberWithOptions(),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: SizedBox(
                  height: 50,
                  width: 250,
                  child: ElevatedButton(
                    onPressed: () {
                      if (imageUrl.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please Upload Image"),
                          ),
                        );

                        return;
                      }
                      database.addProduct(
                          titleController.text,
                          descriptionController.text,
                          phoneController.text,
                          priceController.text,
                          imageUrl);
                      Navigator.pop(context);
                    },
                    child: const Text("Submit"),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
