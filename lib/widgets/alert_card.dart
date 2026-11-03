// // lib/widgets/alert_card.dart
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';
// import 'package:wildlife_alert_app/models/alert_model.dart';
// import 'package:wildlife_alert_app/utils/constants.dart';

// class AlertCard extends StatelessWidget {
//   final AlertModel alert;

//   const AlertCard({Key? key, required this.alert}) : super(key: key);

//   String _getEmoji(String animal) {
//     // Match animals to emojis - expand this list as needed
//     switch (animal.toLowerCase()) {
//       case 'leopard':
//         return '🐆';
//       case 'tiger':
//         return '🐅';
//       case 'elephant':
//         return '🐘';
//       case 'bear':
//         return '🐻';
//       case 'snake':
//         return '🐍';
//       case 'wolf':
//         return '🐺';
//       case 'boar':
//         return '🐗';
//       default:
//         return '⚠️';
//     }
//   }

//   Color _getAlertColor(String animal) {
//     // Different colors for different threat levels
//     switch (animal.toLowerCase()) {
//       case 'leopard':
//       case 'tiger':
//       case 'bear':
//         return Colors.red.shade100;
//       case 'elephant':
//       case 'wolf':
//       case 'boar':
//         return Colors.orange.shade100;
//       default:
//         return Colors.yellow.shade100;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final DateTime alertTime = alert.time;
//     final String formattedTime = DateFormat('MMM d, y - h:mm a').format(alertTime);
    
//     // Check if alert is recent (less than 1 hour old)
//     final bool isRecent = DateTime.now().difference(alertTime).inHours < 1;

//     return Card(
//       elevation: 3,
//       margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
//       color: _getAlertColor(alert.animal),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//         side: BorderSide(
//           color: isRecent ? Colors.red : Colors.transparent,
//           width: isRecent ? 1.5 : 0,
//         ),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Text(
//                   _getEmoji(alert.animal),
//                   style: const TextStyle(fontSize: 24),
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: Text(
//                     '${alert.animal} Detected',
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 if (isRecent)
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: Colors.red,
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     child: const Text(
//                       'ACTIVE',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Row(
//               children: [
//                 const Icon(Icons.location_on_outlined, size: 16),
//                 const SizedBox(width: 4),
//                 Text(
//                   'Location: ${alert.location}',
//                   style: const TextStyle(fontSize: 14),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 4),
//             Row(
//               children: [
//                 const Icon(Icons.access_time, size: 16),
//                 const SizedBox(width: 4),
//                 Text(
//                   'Time: $formattedTime',
//                   style: const TextStyle(fontSize: 14),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             Text(
//               isRecent
//                   ? 'CAUTION: Stay indoors and alert others!'
//                   : 'Alert is no longer active but stay cautious.',
//               style: TextStyle(
//                 fontWeight: isRecent ? FontWeight.bold : FontWeight.normal,
//                 color: isRecent ? Colors.red.shade900 : Colors.black87,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// lib/widgets/alert_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wildlife_alert_app/models/alert_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wildlife_alert_app/utils/constants.dart';

class AlertCard extends StatelessWidget {
  final AlertModel alert;
  final bool isActive;

  const AlertCard({
    Key? key,
    required this.alert,
    required this.isActive,
  }) : super(key: key);

  String _getEmoji(String animal) {
    switch (animal.toLowerCase()) {
      case 'leopard':
        return '🐆';
      case 'tiger':
        return '🐅';
      case 'elephant':
        return '🐘';
      case 'bear':
        return '🐻';
      case 'snake':
        return '🐍';
      case 'wolf':
        return '🐺';
      case 'boar':
        return '🐗';
      default:
        return '⚠️';
    }
  }

  Color _getAlertColor(String animal) {
    switch (animal.toLowerCase()) {
      case 'leopard':
      case 'tiger':
      case 'bear':
        return Colors.red.shade100;
      case 'elephant':
      case 'wolf':
      case 'boar':
        return Colors.orange.shade100;
      default:
        return Colors.yellow.shade100;
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateTime alertTime = alert.time;
    final String formattedTime = DateFormat('MMM d, y - h:mm a').format(alertTime);

    final bool isRecent = DateTime.now().difference(alertTime).inHours < 1;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      color: _getAlertColor(alert.animal),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isRecent ? Colors.red : Colors.transparent,
          width: isRecent ? 1.5 : 0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  _getEmoji(alert.animal),
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${alert.animal} Detected',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (isActive)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      'ACTIVE',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 16),
                const SizedBox(width: 4),
                Text(
                  'Location: ${alert.location}',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16),
                const SizedBox(width: 4),
                Text(
                  'Time: $formattedTime',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              isActive
                  ? 'CAUTION: Stay indoors and alert others!'
                  : 'Alert is no longer active but stay cautious.',
              style: TextStyle(
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive ? Colors.red.shade900 : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
