import 'package:flutter/material.dart';
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
  final VoidCallback? onStepCancel;
  final bool isLoading;

  const CustomStepper({
    super.key,
    required this.steps,
    this.onComplete,
    this.currentStep = 0,
    this.onStepContinue,
    this.onStepCancel,
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
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
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
    final double targetProgress = (widget.currentStep + 1) / widget.steps.length;
    _progressAnimation = Tween<double>(
      begin: _progressController.value,
      end: targetProgress,
    ).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );
    _progressController.value = _progressAnimation.value;
    _progressController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Column(
          children: [
            Row(
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
                      'STEP ${widget.currentStep + 1}/${widget.steps.length}',
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
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: _progressAnimation.value,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppTheme.primaryColor,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: widget.steps[widget.currentStep].content,
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (widget.currentStep > 0)
                TextButton.icon(
                  onPressed: widget.isLoading ? null : widget.onStepCancel,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Previous'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.primaryColor,
                  ),
                )
              else
                const SizedBox(),
              ElevatedButton.icon(
                icon: widget.isLoading
                    ? Container(
                        width: 24,
                        height: 24,
                        padding: const EdgeInsets.all(2.0),
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : const Icon(Icons.arrow_forward),
                onPressed: widget.isLoading ? null : widget.onStepContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                label: Text(
                  widget.currentStep < widget.steps.length - 1 ? 'Next' : 'Finish',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
