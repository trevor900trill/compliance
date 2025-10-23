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

  const CustomStepper({super.key, required this.steps, this.onComplete});

  @override
  State<CustomStepper> createState() => _CustomStepperState();
}

class _CustomStepperState extends State<CustomStepper>
    with SingleTickerProviderStateMixin {
  int _currentStep = 0;
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
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  void _updateProgress() {
    final double newProgress = (_currentStep + 1) / widget.steps.length;
    _progressAnimation = Tween<double>(
      begin: _progressController.value,
      end: newProgress,
    ).animate(
      CurvedAnimation(
        parent: _progressController,
        curve: Curves.easeInOut,
      ),
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
                    '${_currentStep + 1}',
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
                      'STEP ${_currentStep + 1}/${widget.steps.length}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      widget.steps[_currentStep].title,
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
        child: widget.steps[_currentStep].content,
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_currentStep > 0)
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _currentStep--;
                      _updateProgress();
                    });
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Previous'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.primaryColor,
                  ),
                )
              else
                const SizedBox(), // To keep the Next button to the right
              ElevatedButton(
                onPressed: () {
                  if (_currentStep < widget.steps.length - 1) {
                    setState(() {
                      _currentStep++;
                      _updateProgress();
                    });
                  } else {
                    widget.onComplete?.call();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 24.0,
                  ),
                  child: Text(
                    _currentStep < widget.steps.length - 1 ? 'Next' : 'Finish',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
