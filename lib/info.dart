import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vehicle Info',
      home: const VehicleInfo(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class VehicleInfo extends StatelessWidget {
  const VehicleInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('vehicles')
            .doc('vehicle1') // Replace with your document ID
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('No vehicle data found.'));
          }

          var data = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 40),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Vehicle Info',
                    style: GoogleFonts.poppins(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                ClipRRect(
  borderRadius: BorderRadius.circular(15),
  child: Image.network(
    data['image_url'] ?? '',
    width: 250,
    height: 150,
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) {
      return const Icon(Icons.broken_image, size: 100);
    },
    loadingBuilder: (context, child, loadingProgress) {
      if (loadingProgress == null) return child;
      return const Center(child: CircularProgressIndicator());
    },
  ),
),

                const SizedBox(height: 20),
                _buildDetailRow('Name', data['name'] ?? 'N/A'),
                _buildDetailRow('Number', data['number'] ?? 'N/A'),
                _buildDetailRow('Next Service', data['next_service'] ?? 'N/A'),
                _buildDetailRow('License Number', data['license'] ?? 'N/A'),
                _buildDetailRow(
                    'Accident Detected', data['accident'] ?? 'N/A'),
                _buildDetailRow('Vehicle Score', data['score']?.toString() ?? 'N/A'),
                const Divider(color: Colors.white),
                const Divider(color: Colors.white),
                ElevatedButton(
                  onPressed: () {
                    debugPrint('View History pressed');
                  },
                  child: const Text('View History'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  static Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
