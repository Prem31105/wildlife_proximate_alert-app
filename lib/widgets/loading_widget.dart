// lib/widgets/loading_widget.dart
import 'package:flutter/material.dart';
import 'package:wildlife_alert_app/utils/constants.dart';
import 'package:wildlife_alert_app/utils/colors.dart';

class LoadingWidget extends StatelessWidget {
  final String? message;

  const LoadingWidget({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: AppColors.primaryColor,
          ),
          if (message != null)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                message!,
                style: const TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 16,
                ),
              ),
            ),
        ],
      ),
    );
  }
}