import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
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
  final String? backButtonText;

  const CustomStepper({
    super.key,
    required this.steps,
    required this.pageTitle,
    this.onComplete,
    this.currentStep = 0,
    this.onStepContinue,
    this.onStepBack,
    this.isLoading = false,
    this.backButtonText,
  });

  @override
  State<CustomStepper> createState() => _CustomStepperState();
}

class _CustomStepperState extends State<CustomStepper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.primaryColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.pageTitle,
              style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Step ${widget.currentStep + 1} of ${widget.steps.length}: ${widget.steps[widget.currentStep].title}',
              style: GoogleFonts.lato(
                fontSize: 13,
                color: Colors.grey[600],
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Column(
            children: [
              // Segmented Progress Indicators
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Row(
                  children: List.generate(
                    widget.steps.length,
                    (index) {
                      final isCompleted = index < widget.currentStep;
                      final isCurrent = index == widget.currentStep;
                      final isFuture = index > widget.currentStep;

                      return Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: AnimatedContainer(
                                duration: AppTheme.mediumAnimation,
                                height: 4,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  gradient: isCompleted || isCurrent
                                      ? AppTheme.primaryGradient
                                      : null,
                                  color: isFuture ? Colors.grey[300] : null,
                                ),
                              ),
                            ),
                            if (index < widget.steps.length - 1)
                              const SizedBox(width: 8),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              // Step indicators
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    widget.steps.length,
                    (index) {
                      final isCompleted = index < widget.currentStep;
                      final isCurrent = index == widget.currentStep;

                      return AnimatedContainer(
                        duration: AppTheme.mediumAnimation,
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          gradient: isCompleted || isCurrent
                              ? AppTheme.primaryGradient
                              : null,
                          color: !isCompleted && !isCurrent
                               ? Colors.grey[300]
                              : null,
                          shape: BoxShape.circle,
                          boxShadow: isCurrent
                              ? [
                                  BoxShadow(
                                    color: AppTheme.primaryColor.withOpacity(0.4),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Center(
                          child: isCompleted
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 18,
                                )
                              : Text(
                                  '${index + 1}',
                                  style: GoogleFonts.lato(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: isCurrent
                                        ? Colors.white
                                        : Colors.grey[600],
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: AnimatedSwitcher(
        duration: AppTheme.mediumAnimation,
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.1, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: Padding(
          key: ValueKey(widget.currentStep),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: widget.steps[widget.currentStep].content,
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton.icon(
                  onPressed: widget.currentStep == 0
                      ? () => context.pop()
                      : widget.onStepBack,
                  icon: Icon(
                    widget.currentStep == 0
                        ? Icons.close
                        : Icons.arrow_back,
                    size: 20,
                  ),
                  label: Text(
                    widget.currentStep == 0
                        ? (widget.backButtonText ?? 'Cancel')
                        : 'Back',
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey[700],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(
                      AppTheme.buttonBorderRadius,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    icon: widget.isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Icon(
                            widget.currentStep < widget.steps.length - 1
                                ? Icons.arrow_forward
                                : Icons.check,
                            size: 20,
                          ),
                    onPressed: widget.isLoading ? null : widget.onStepContinue,
                    label: Text(
                      widget.currentStep < widget.steps.length - 1
                          ? 'Next'
                          : 'Complete',
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppTheme.buttonBorderRadius,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

