# Nozie - Movie Streaming App

A movie streaming application built with Flutter.

## Features

- 🔐 **Authentication**: Login, registration, password recovery with Firebase Auth
- 🏠 **Home**: Discover movies by genre and trending content
- 🔍 **Search**: Advanced movie search with filters
- ❤️ **Wishlist**: Save favorite movies
- 💳 **Payment**: Stripe integration for movie purchases
- 📱 **Video Player**: Built-in video player with playback controls
- 🌐 **Internationalization**: Support for Vietnamese and English
- 🌙 **Dark Mode**: Light and dark theme support
- 🔔 **Notifications**: In-app notification system

## Tech Stack

### Frontend (Flutter)
- **State Management**: Riverpod
- **Routing**: GoRouter
- **Backend**: Firebase (Auth, Firestore, Storage)
- **Payment**: Stripe
- **i18n**: Slang
- **UI**: Material Design with custom theme

### Backend (Node.js)
- Express server for Stripe payment processing
- Firebase Admin SDK
- Email service with Nodemailer

## Installation

### Requirements
- Flutter SDK ^3.8.1
- Node.js (for backend)
- Firebase project with service account key

## Demo

Watch the app demo: [Demo Video](https://drive.google.com/file/d/1kuqE5ovGwGaspJyN6Eh5gFMxHCyMnfME/view?usp=sharing)

## Project Structure

```
lib/
├── app/              # App configuration
├── core/             # Core utilities, widgets, services
├── features/         # Feature modules
│   ├── auth/         # Authentication
│   ├── home/         # Home screen
│   ├── discover/     # Discover movies
│   ├── movie/        # Movie details & player
│   ├── search/       # Search functionality
│   ├── wishlist/     # Wishlist
│   ├── purchase/     # Purchase & payment
│   └── profile/      # User profile
├── routes/           # Navigation & routing
└── i18n/             # Internationalization

backend/
└── server.js         # Express server for Stripe
```
