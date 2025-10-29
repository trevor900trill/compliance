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
  - This component includes a progress bar that smoothly animates between steps, clear step titles, improved navigation, and a loading state.
- **Customer Management:**
  - A multi-step form for registering new customers, with options for both individual and organization accounts.
  - The form includes a review and confirm step, allowing users to verify all information before submission.
  - The form includes validation to ensure that all required fields are filled out correctly.
  - **Customer Verification:** A verification step checks if a customer already exists before proceeding.
  - **Customer Creation:** If a customer does not exist, their details are collected and submitted to the backend to create a new account upon completion of the form.
  - **Dynamic ID Types:** The ID type dropdown in the verification step is now dynamically populated based on the selected account type (Individual or Organization), ensuring only relevant options are shown.
  - **State Management Bug Fix:** Fixed a crash that occurred when changing the account type after an ID type had already been selected. The selected ID type is now correctly reset.
- **UI Overflow Fix:**
    - The "Account Type" selection step in the customer registration form has been made scrollable to prevent UI overflow on smaller screens.


## Current Plan

All requested features and fixes have been implemented. The application is in a stable state. Awaiting next user request.
