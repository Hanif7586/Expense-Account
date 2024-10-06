import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';

import '../widget/round_button.dart';

class AddPostView extends StatefulWidget {
  const AddPostView({super.key});

  @override
  State<AddPostView> createState() => _AddPostViewState();
}

class _AddPostViewState extends State<AddPostView> {
  bool loading = false; // Loading state
  final databaseRef = FirebaseDatabase.instance.ref('Post');

  // Controllers for the text fields
  final postController = TextEditingController();
  final amountController = TextEditingController();
  final priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Add Post'),
        centerTitle: true,
        backgroundColor: const Color(0xFF3478F7),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            // Product Name Text Field
            TextFormField(
              controller: postController,
              decoration: InputDecoration(
                hintText: 'Product name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15), // Circular border
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Amount Text Field
            TextFormField(
              keyboardType: TextInputType.number,
              controller: amountController,
              decoration: InputDecoration(
                hintText: 'Amount',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15), // Circular border
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Price Text Field
            TextFormField(
              keyboardType: TextInputType.number,
              controller: priceController,
              decoration: InputDecoration(
                hintText: 'Price',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15), // Circular border
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Loading Indicator or Add Button
            loading
                ? const CircularProgressIndicator() // Show loading indicator when true
                : RoundButton(
              title: 'Add',
              ontab: () async {
                setState(() {
                  loading = true;
                });

                String postContent = postController.text.trim();
                String amount = amountController.text.trim();
                String price = priceController.text.trim();

                if (postContent.isNotEmpty && amount.isNotEmpty && price.isNotEmpty) {
                  try {
                    await databaseRef.push().set({
                      'content': postContent,
                      'amount': amount,
                      'price': price,
                      'timestamp': DateTime.now().toString(),
                    });
                    postController.clear(); // Clear input fields
                    amountController.clear();
                    priceController.clear();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Post added successfully!'),
                      ),
                    );
                  } catch (e) {
                    print('Error: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: $e'),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('All fields must be filled'),
                    ),
                  );
                }

                setState(() {
                  loading = false;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose the controllers when the widget is destroyed
    postController.dispose();
    amountController.dispose();
    priceController.dispose();
    super.dispose();
  }
}
