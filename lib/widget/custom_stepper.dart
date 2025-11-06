import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/theme.dart';

class CustomStep {
  final String title;
  final Widget content;

  CustomStep({required this.title, required this.content});
}

class CustomStepper extends StatefulWidget {
  final List<CustomStep> steps;
  final VoidCallback? onComplete;
  final int currentStep;
  final VoidCallback? onStepContinue;
  final VoidCallback? onStepBack;
  final bool isLoading;
  final String pageTitle;

  const CustomStepper({
    super.key,
    required this.steps,
    required this.pageTitle,
    this.onComplete,
    this.currentStep = 0,
    this.onStepContinue,
    this.onStepBack,
    this.isLoading = false,
  });

  @override
  State<CustomStepper> createState() => _CustomStepperState();
}

class _CustomStepperState extends State<CustomStepper>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _progressController =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 1000),
        )..addListener(() {
          setState(() {});
        });
    _updateProgress();
  }

  @override
  void didUpdateWidget(CustomStepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentStep != oldWidget.currentStep) {
      _updateProgress();
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  void _updateProgress() {
    final double targetProgress =
        (widget.currentStep + 1) / widget.steps.length;
    _progressAnimation =
        Tween<double>(
          begin: _progressController.value,
          end: targetProgress,
        ).animate(
          CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
        );
    _progressController.forward(from: _progressAnimation.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.primaryColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppTheme.primaryColor,
              child: Text(
                '${widget.currentStep + 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.pageTitle} (${widget.currentStep + 1}/${widget.steps.length})',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  widget.steps[widget.currentStep].title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: LinearProgressIndicator(
            value: _progressAnimation.value,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppTheme.primaryColor,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: widget.steps[widget.currentStep].content,
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
              onPressed: widget.currentStep == 0
                  ? () => context.go('/home')
                  : widget.onStepBack,
              child: Text(
                widget.currentStep == 0 ? 'Back to Dashboard' : 'Back',
              ),
            ),
            ElevatedButton.icon(
              icon: widget.isLoading
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    )
                  : const Icon(Icons.arrow_forward),
              onPressed: widget.isLoading ? null : widget.onStepContinue,
              label: Text(
                widget.currentStep < widget.steps.length - 1
                    ? 'Next'
                    : 'Complete',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
