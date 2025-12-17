# QHSE Violation Management System

<p align="center">
  <img src="assets/images/qhse_icon.png" alt="QHSE App Logo" width="120"/>
</p>

<p align="center">
  <strong>Enterprise-grade Quality, Health, Safety & Environment Management</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.0+-02569B?style=for-the-badge&logo=flutter" alt="Flutter"/>
  <img src="https://img.shields.io/badge/Dart-3.0+-0175C2?style=for-the-badge&logo=dart" alt="Dart"/>
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-green?style=for-the-badge" alt="Platform"/>
  <img src="https://img.shields.io/badge/License-Proprietary-red?style=for-the-badge" alt="License"/>
</p>

---

## 📋 Overview

A comprehensive mobile application for managing **Quality, Health, Safety, and Environment (QHSE)** violations. Built with Flutter for cross-platform deployment, featuring real-time GPS tracking, cloud synchronization, and multi-language support.

### Key Highlights

- 🎯 **171 Violation Types** across 4 QHSE domains
- 👥 **13 User Roles** with granular permissions
- 🌍 **Bilingual Support** (Arabic & English with RTL)
- 📍 **GPS Location Tracking** with interactive maps
- 📸 **Photo Evidence** capture and attachment
- ☁️ **Cloud Backend** integration

---

## ✨ Features

### Core Functionality

| Feature | Description |
|---------|-------------|
| **Violation Reporting** | Quick submission with auto-populated fields |
| **Employee Lookup** | Search employees by ID with auto-fill |
| **Project Management** | Associate violations with specific projects |
| **Multi-domain Support** | Safety, Health, Quality, Environment |
| **Severity Levels** | Low, Medium, High, Critical classification |

### QHSE Domains

| Domain | Icon | Description |
|--------|------|-------------|
| 🔴 **Safety** | Workplace safety violations |
| 🟢 **Health** | Occupational health issues |
| 🔵 **Quality** | Quality control deviations |
| 🟡 **Environment** | Environmental compliance |

### User Roles

The system supports a comprehensive role hierarchy:

- **Executive**: CEO with full oversight
- **Management**: Safety, Quality, Health, Environment, HSE, Project Managers
- **Officers**: Domain-specific officers for each QHSE category
- **System**: Admin with full configuration access
- **Users**: Standard employees for violation reporting

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.0+
- Dart SDK 3.0+
- Android Studio / VS Code
- Git

### Installation

```bash
# Clone the repository
git clone https://github.com/egyadmin/QHSE-Violation-Management-System.git

# Navigate to project directory
cd qhse_app

# Install dependencies
flutter pub get

# Run the application
flutter run
```

### Build for Production

```bash
# Android APK
flutter build apk --release

# Android App Bundle (Play Store)
flutter build appbundle --release

# iOS (requires macOS)
flutter build ios --release
```

---

## 🏗️ Architecture

```
lib/
├── core/                    # Core utilities & configuration
│   ├── constants/           # App constants & API config
│   ├── theme/               # Material Design theming
│   ├── l10n/                # Localization resources
│   └── utils/               # Helper utilities
│
├── data/                    # Data layer
│   ├── models/              # Data models
│   └── services/            # API & local services
│
├── providers/               # State management (Provider)
│
└── presentation/            # UI layer
    ├── screens/             # App screens
    └── widgets/             # Reusable components
```

---

## 🔧 Configuration

### API Configuration

Edit `lib/core/constants/app_constants.dart`:

```dart
static const String baseUrl = 'https://your-api-url.app';
static const String apiKey = 'your-api-key';
```

### Environment Setup

1. Copy API configuration template
2. Set your production/development URLs
3. Configure API keys securely

---

## 📱 Screenshots

| Login | Dashboard | New Violation |
|-------|-----------|---------------|
| Secure authentication | Real-time statistics | Step-by-step form |

---

## 🛠️ Tech Stack

| Category | Technology |
|----------|------------|
| **Framework** | Flutter 3.0+ |
| **Language** | Dart 3.0+ |
| **State Management** | Provider |
| **Networking** | Dio |
| **Maps** | Flutter Map + OpenStreetMap |
| **Localization** | Easy Localization |
| **Storage** | Shared Preferences, Secure Storage |

---

## 🌐 Supported Platforms

- ✅ Android (API 21+)
- ✅ iOS (12.0+)
- ✅ Web (Chrome, Edge, Safari, Firefox)

---

## 📄 License

**Proprietary** - All rights reserved © SAJCO 2025

This software is proprietary and confidential. Unauthorized copying, distribution, or modification is strictly prohibited.

---

## 📞 Contact

For support or inquiries:
- 📧 Email: support@sajco.com
- 🌐 Website: [sajco.com](https://sajco.com)

---

<p align="center">
  <strong>Built with ❤️ using Flutter</strong>
</p>

<p align="center">
  <em>Version 1.0.0 | December 2025</em>
</p>
