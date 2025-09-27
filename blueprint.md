'''
# Project Blueprint

## Overview

This document outlines the architecture and design of the Flutter application. The app is a secure, state-managed application with a modern, greenish theme.

## Style, Design, and Features

### Authentication

*   **BLoC State Management:** The authentication flow is managed by `AuthBloc`, which handles login, logout, and session persistence.
*   **Secure Routing:** `go_router` is configured with an authentication guard to protect routes.
*   **UI:**
    *   **Login Page:** A visually engaging login page with a gradient background, a "lifted" card UI for the login form, and icons in the text fields.
    *   **OTP Page:** A simple page for OTP verification.
    *   **Home Page:** The main page after login, with a sidebar and logout button.

### Theme

*   **Material 3:** The application uses Material 3 design principles.
*   **Color Scheme:** A vibrant, greenish theme generated from a seed color using `ColorScheme.fromSeed`.
*   **Typography:** Custom fonts from `google_fonts` are used for improved readability.

### Architecture

*   **Feature-based Structure:** The project is organized by features (e.g., `auth`, `home`).
*   **BLoC for State Management:** The BLoC pattern is used for predictable state management.
*   **Provider for Dependency Injection:** `provider` is used for dependency injection.

## Current Plan

*   [x] Enhance the theme with Material 3 and `google_fonts`.
*   [x] Redesign the login page to be more visually appealing.
*   [ ] Check for any errors and ensure the application is runnable.
'''