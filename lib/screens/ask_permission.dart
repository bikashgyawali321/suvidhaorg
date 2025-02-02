import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:suvidhaorg/widgets/custom_button.dart';

import '../services/notification.dart';
import '../widgets/form_bottom_sheet_header.dart';

class AskPermission extends StatelessWidget {
  const AskPermission({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => const AskPermission(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notificationService = context.read<NotificationService>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const FormBottomSheetHeader(title: "Stay Connected"),
            const SizedBox(height: 20),
            Text(
              'Enable notifications to stay updated with important messages and alerts.',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.width * 0.6,
              child: const RiveAnimation.asset(
                'assets/animations/notification.riv',
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    label: "Not Now",
                    backgroundColor: Colors.redAccent,
                    onPressed: () {
                      context.pop();
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomButton(
                    label: "Enable Notifications",
                    onPressed: () async {
                      await notificationService.requestPermission();
                      context.pop();
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
