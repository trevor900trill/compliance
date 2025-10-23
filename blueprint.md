
# Nairobi County Government Staff Portal - Blueprint

## Overview

This document outlines the design, features, and architecture of the Nairobi County Government (NCG) Official Staff Portal. The application is designed to be a secure, professional, and user-friendly platform for NCG staff to access internal services.

## Design & Style Guide

### Color Palette

- **Primary Color:** `#006A4E` (Deep Green) - Inspired by the Kenyan flag, used for headers, buttons, and primary accents.
- **Accent Color:** `#B22234` (Red) - Used for error messages and critical alerts.
- **Text Color:** `#000000` (Black) - Used for all body text and headings.
- **Background Color:** `#F5F5F5` (Off-white) - Provides a clean and professional backdrop.

### Typography

- **Primary Font:** 'Lato' (from Google Fonts) - Chosen for its clarity and professional appearance.
- **Headings:** Bold weight, various sizes.
- **Body Text:** Regular weight.

### Branding

- **Logo:** A circular logo with the initials "NCG" in the primary green color.
- **Watermark:** A subtle background watermark of the NCG logo is used on authentication screens for brand reinforcement.

## Features

### Implemented

- **Authentication:**
  - Secure login with Staff ID and password.
  - OTP verification for two-factor authentication.
- **Responsive Design:**
  - All pages are designed to be fully responsive, adapting to various screen sizes from mobile phones to tablets and desktops.
  - The login screen features a two-column layout on larger screens, which collapses to a single column on smaller devices.
- **Consistent UI/UX:**
  - A unified design language is applied across all pages, ensuring a consistent user experience.
  - A centralized theme manages colors, fonts, and component styles.
- **Reusable Custom Stepper:**
  - A new `CustomStepper` widget was created to provide a modern and intuitive user experience for multi-step forms.
  - This component includes a progress bar that smoothly animates between steps, clear step titles, and improved navigation.
  - All pages with step-by-step workflows have been refactored to use this new component, improving code reusability and maintainability.

## Current Plan: Animate Stepper Progress

- **Objective:** Enhance the `CustomStepper` widget by adding a smooth animation to the progress bar as the user navigates between steps.
- **Steps:**
    1. **Add AnimationController:** Introduce an `AnimationController` to manage the animation's timing.
    2. **Implement Animation:** Use a `Tween` to create a smooth transition for the `LinearProgressIndicator` from its previous value to the new value.
    3. **Update Stepper State:** Modify the `_CustomStepperState` to trigger the animation whenever the step changes.
    4. **Update Project Blueprint:** Document the new animation feature in the `CustomStepper` component.
