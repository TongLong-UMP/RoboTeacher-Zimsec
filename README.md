RoboTeacher_Zimsec

Overview

The RoboTeacher_Zimsec is a Flutter-based mobile application designed to enhance primary school education in Zimbabwe, focusing on literacy and curriculum-based learning for grades ECD to Grade 7. Key features include:





Reading Module: Animated book with pronunciation testing, syllable breakdown, and AI-driven feedback (red, yellow, green, or golden star ratings).



Curriculum Portal: Access to ZIMSEC subjects with animated learning videos, project instructions, and homework submission.



User Profiles: Students, teachers, and parents with customizable avatars, progress reports, and privacy controls.



Gamification: Points, badges, and leaderboards to make learning engaging.



Digital Store: Restricted play store for curriculum books (with Stripe integration placeholder).



AI Integration: Pronunciation correction and assignment assessment (placeholders for external AI APIs).



School Integration: School accounts, teacher-administered homework, and tutor support.

The app is designed to run locally for development and can be hosted on Firebase for production.

Prerequisites





Flutter: Version 3.0.0 or higher (Dart 2.17.0 or higher).



Firebase Account: For authentication, Firestore database, and storage.



IDE: VS Code, Android Studio, or Cursor (recommended) with Flutter and Dart plugins.



Stripe Account: For future payment integration (placeholder included).



Node.js: For Firebase CLI tools.



Git: For version control.

Setup Instructions

1. Clone the Repository

git clone <repository-url>
cd roboteacher_zimsec

2. Install Dependencies

Run the following to install Flutter dependencies:

flutter pub get

3. Configure Firebase





Create a Firebase project at console.firebase.google.com.



Enable Authentication (Email/Password provider).



Set up Firestore Database with the following collections:





users: Stores user profiles (email, role, schoolId, avatar, createdAt).



curriculum: Stores grade-specific subjects and content.



assignments: Stores assignment submissions.



Enable Storage for animated videos and digital books.



Download the Firebase configuration file:





For Android: android/app/google-services.json



For iOS: ios/Runner/GoogleService-Info.plist



Install Firebase CLI:

npm install -g firebase-tools
firebase login

4. Local Development





Ensure an emulator or physical device is connected.



Run the app:

flutter run



Test authentication, reading module, and profile customization locally.

5. Firebase Hosting





Initialize Firebase Hosting:

firebase init hosting



Build the Flutter web app:

flutter build web



Deploy to Firebase:

firebase deploy

6. Stripe Integration (Placeholder)





Add the flutter_stripe package to pubspec.yaml when ready to implement payments.



Configure Stripe API keys in a .env file or Firebase Functions.



Update the app to handle digital book purchases and tutor subscriptions.

7. AI Integration (Placeholder)





For pronunciation assessment, integrate with Google Cloud Speech-to-Text or a similar API.



For assignment grading, use an NLP-based AI service (e.g., Hugging Face models).



Replace placeholder code in reading_screen.dart with actual API calls.

Project Structure

roboteacher_zimsec/
├── android/                  # Android-specific files
├── ios/                      # iOS-specific files
├── lib/
│   ├── screens/              # UI screens (login, home, reading, profile, curriculum)
│   ├── services/             # Backend services (auth, database)
│   ├── main.dart             # App entry point
├── assets/                   # Avatars and static assets
├── pubspec.yaml             # Dependencies and configuration

Running Tests

Run unit tests to verify functionality:

flutter test

Enhancements





Gamification: Earn points for tasks, unlock avatars, and view leaderboards.



Dynamic Themes: Customize app appearance (light, dark, colorful).



Interactive Animations: Use flare_flutter for animated books (to be implemented).



Progress Badges: Award badges for milestones (e.g., mastering 100 words).



Tutor Portal: Registered tutors can assist with projects via chat or video.

Contributing





Fork the repository.



Create a feature branch (git checkout -b feature/branch-name).



Commit changes (git commit -m "Add feature").



Push to the branch (git push origin feature/branch-name).



Open a pull request.

License

This project is licensed under the MIT License.

Contact

For issues or suggestions, open a GitHub issue or contact the project maintainer.

## RoboRankings

The RoboRankings screen now includes only three tabs: School Accolades, Student Accolades, and Schools Rankings. The Suppliers Directory has been removed from this section. The tab bar uses a deep orange highlight for the selected tab and white for unselected tabs, ensuring all tabs remain visible and accessible.