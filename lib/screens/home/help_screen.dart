import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wildlife_alert_app/utils/constants.dart';
import 'package:wildlife_alert_app/widgets/custom_button.dart';
import 'package:wildlife_alert_app/utils/colors.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

  // Function to call emergency numbers
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $launchUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Mock data for forest department contacts
    // In production, this could come from Firebase
    final List<Map<String, String>> emergencyContacts = [
      {'name': 'Wildlife Emergency Hotline', 'number': '1800-123-4567'},
      {'name': 'Forest Department Control Room', 'number': '1800-425-6789'},
      {'name': 'District Forest Officer', 'number': '9876543210'},
      {'name': 'Local Animal Rescue', 'number': '8765432109'},
      {'name': 'Wildlife SOS', 'number': '9632587410'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Help'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Emergency Contacts',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'In case of wildlife emergencies, contact the forest department immediately:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: emergencyContacts.length,
                itemBuilder: (context, index) {
                  final contact = emergencyContacts[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      title: Text(contact['name']!),
                      subtitle: Text(contact['number']!),
                      trailing: IconButton(
                        icon: const Icon(Icons.call, color: AppColors.accentColor),
                        onPressed: () => _makePhoneCall(contact['number']!),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              const Text(
                'Safety Tips',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _buildSafetyTip(
                'Stay inside your home if you receive an alert',
                Icons.home_outlined,
              ),
              _buildSafetyTip(
                'Keep children and pets indoors',
                Icons.child_care,
              ),
              _buildSafetyTip(
                'Avoid going out alone in the dark',
                Icons.dark_mode,
              ),
              _buildSafetyTip(
                'Store food securely to avoid attracting wildlife',
                Icons.food_bank_outlined,
              ),
              _buildSafetyTip(
                'Report sightings to authorities immediately',
                Icons.report_outlined,
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Report Wildlife Sighting',
                onPressed: () {
                  // Show dialog to report a sighting (could be connected to a form)
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Report Wildlife Sighting'),
                      content: const Text(
                          'This feature would allow users to manually report animal sightings. Would you like to implement this in a future version?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSafetyTip(String tip, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              tip,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}