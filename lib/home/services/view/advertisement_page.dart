import 'package:flutter/material.dart';
import '../../../widget/custom_stepper.dart';

class AdvertisementPage extends StatelessWidget {
  const AdvertisementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomStepper(
      pageTitle: 'Advertisement (Small Format)',
      backButtonText: 'Back to Services',
      steps: [
        CustomStep(
          title: 'Step 1',
          content: const Center(child: Text('Content for Step 1')),
        ),
        CustomStep(
          title: 'Step 2',
          content: const Center(child: Text('Content for Step 2')),
        ),
        CustomStep(
          title: 'Step 3',
          content: const Center(child: Text('Content for Step 3')),
        ),
      ],
    );
  }
}
