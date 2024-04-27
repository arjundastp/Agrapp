import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class CartPage extends StatefulWidget {
  const CartPage({super.key});
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  File? imageselect;
  String? message = "";
  String? description = "";
  String prevention = "";
  uploadImage() async {
    final request = http.MultipartRequest(
        "POST",
        Uri.parse(
            "https://925b-2409-4073-4d9e-6bb-c82d-17c-317-e485.ngrok-free.app/upload"));
    final headers = {"content-type": "multipart/form-data"};
    request.files.add(http.MultipartFile('image',
        imageselect!.readAsBytes().asStream(), imageselect!.lengthSync(),
        filename: imageselect!.path.split("/").last));
    request.headers.addAll(headers);

    final response = await request.send();
    http.Response res = await http.Response.fromStream(response);
    final resjson = jsonDecode(res.body);
    message = resjson['name'];
    description = resjson['desc'];
    prevention = resjson['prev'];

    setState(() {});
  }

  Future pickImage() async {
    message = "";
    description = "";
    prevention = "";
    final imageselect =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imageselect == null) return;
    final imageTemp = File(imageselect.path);
    setState(() => this.imageselect = imageTemp);
  }

  Future pickcamera() async {
    message = "";
    description = "";
    prevention = "";
    final imageselect =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (imageselect == null) return;
    final imageTemp = File(imageselect.path);
    setState(() => this.imageselect = imageTemp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Plant Leaf Image for Testing"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              imageselect == null
                  ? const Text(
                      "please pick a Image to test the disease in Leaf")
                  : Image.file(imageselect!),
              TextButton.icon(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                  ),
                  onPressed: uploadImage,
                  icon: const Icon(Icons.upload_file, color: Colors.white),
                  label: const Text("Upload",
                      style: TextStyle(
                        color: Colors.white,
                      ))),
              ElevatedButton(
                  onPressed: pickcamera,
                  child: const Text('Take Photo using camera')),
              Text(message!,
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.red)),
              const SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.all(15),
                child: Text(description!,
                    style: TextStyle(
                      fontSize: 20,
                    )),
              ),
              const SizedBox(height: 24),
              imageselect != null
                  ? Text('Remarks',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ))
                  : Text(''),
              Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(prevention,
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.blue,
                      ))),
              const SizedBox(height: 14),
              imageselect != null
                  ? ElevatedButton(
                      onPressed: () {
                        //navigate(context, prevention);
                      },
                      child: const Text('view more',
                          style: TextStyle(fontSize: 18)))
                  : const Text('')
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: pickImage,
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}
