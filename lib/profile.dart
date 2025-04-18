import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  Future<DocumentSnapshot> fetchDriverProfile() async {
    return await FirebaseFirestore.instance.collection('drivers').doc('driver1').get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<DocumentSnapshot>(
        future: fetchDriverProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('No profile data found.'));
          }

          final data = snapshot.data!;
          final name = data['name'] ?? 'N/A';
          final age = data['age']?.toString() ?? 'N/A';
          final license = data['license_number'] ?? 'N/A';
          final blood = data['blood_type'] ?? 'N/A';
          final drivingScore = data['driving_score']?.toString() ?? 'N/A';
          final vehicleScore = data['vehicle_score']?.toString() ?? 'N/A';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 15),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Driver profile',
                    style: GoogleFonts.poppins(
                      fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),

                // Profile Picture
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('images/profile.png'),
                ),

                const SizedBox(height: 20),
                _buildDetailRow('Name', name),
                _buildDetailRow('Age', age),
                _buildDetailRow('License number', license),
                _buildDetailRow('Blood type', blood),
                _buildDetailRow('Driving Score', drivingScore),
                _buildDetailRow('Vehicle Score', vehicleScore),

                const Divider(color: Colors.white),
                const Divider(color: Colors.white),

                ElevatedButton(
                  onPressed: () {
                    debugPrint('View History clicked');
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
