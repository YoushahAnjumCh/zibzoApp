import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zibzo/core/constant/string_constant.dart';
import 'package:zibzo/core/theme/app_colors.dart';

class CustomBottomSheet {
  static void show({
    required BuildContext context,
    required VoidCallback onConfirm,
  }) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: AppColors.onPrimaryLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.close,
                      color: Theme.of(context).colorScheme.primary),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              Text(
                StringConstant.doYouWantExit,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        StringConstant.cancel,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (Platform.isAndroid) {
                          SystemNavigator.pop();
                        } else if (Platform.isIOS) {
                          exit(0);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        StringConstant.exit,
                        style: TextStyle(
                            fontSize: 16, color: AppColors.onPrimaryLight),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
