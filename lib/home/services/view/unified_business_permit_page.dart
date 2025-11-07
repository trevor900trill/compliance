import 'package:flutter/material.dart';
import '../../../widget/custom_stepper.dart';

class UnifiedBusinessPermitPage extends StatelessWidget {
  const UnifiedBusinessPermitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomStepper(
      pageTitle: 'Unified Business Permit',
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
