import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import '../widget/custom_text.dart';
import 'add_post_view.dart';

class HomeView extends StatefulWidget {
  final String? name;
  final String? email;

  const HomeView({Key? key, this.name, this.email}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  double totalPrice = 0.0; // Store total price

  @override
  void initState() {
    super.initState();
    _fetchTotalPrice();
  }

  Future<void> _fetchTotalPrice() async {
    final databaseRef = FirebaseDatabase.instance.ref('Post');

    databaseRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        double sum = 0.0;
        data.forEach((key, value) {
          if (value['price'] != null) {
            sum += double.tryParse(value['price'].toString()) ?? 0.0;
          }
        });
        setState(() {
          totalPrice = sum; // Update total price
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0E1E3),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Home",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: const Color(0xFFF3F4F9),
        actions: [
          IconButton(
            onPressed: () {
              // Implement logout functionality
              Navigator.pop(context);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                CustomText(
                  text: 'Name:',
                  fontsize: 15,
                  fontWeight: FontWeight.w700,
                  itemcolor: Colors.black87,
                ),
                Text(
                  ' ${widget.name ?? 'Unknown'}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                CustomText(
                  text: 'Email:',
                  fontsize: 15,
                  fontWeight: FontWeight.w700,
                  itemcolor: Colors.black87,
                ),
                Text(
                  ' ${widget.email ?? 'Unknown'}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Display total price
            Row(
              children: [
                const CustomText(
                  text: 'Total Price:',
                  fontsize: 15,
                  fontWeight: FontWeight.w700,
                  itemcolor: Colors.black87,
                ),
                Text(
                  ' \$${totalPrice.toStringAsFixed(2)}', // Format to 2 decimal places
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddPostView(),
            ),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.lightGreen,
      ),
    );
  }
}
