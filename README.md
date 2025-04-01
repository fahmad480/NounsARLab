# 🎭 Nouns AR Lab

<p align="center">
  <img src="https://img.shields.io/badge/Platform-iOS%20%7C%20Android-blue" alt="Platform iOS | Android">
  <img src="https://img.shields.io/badge/Flutter-3.0+-blueviolet" alt="Flutter 3.0+">
  <a href="https://apps.apple.com/us/app/nouns-ar-lab/id6737252963"><img src="https://img.shields.io/badge/App%20Store-Available-brightgreen" alt="App Store Available"></a>
  <img src="https://img.shields.io/badge/Google%20Play-Closed%20Testing-orange" alt="Google Play Closed Testing">
</p>

<p align="center">
  <a href="https://apps.apple.com/us/app/nouns-ar-lab/id6737252963">
    <img src="https://developer.apple.com/assets/elements/badges/download-on-the-app-store.svg" height="50" alt="Download on the App Store">
  </a>
</p>

Nouns AR Lab is an innovative application that combines the concept of YouTube Shorts with Snapchat's Camera Kit SDK. Experience the future of social media with our portfolio showcase that enables users to interact with videos using cutting-edge AR effects.

## ✨ Features

- 📱 **Seamless Video Scrolling** - Enjoy smooth, TikTok-like vertical scrolling
- ⚡ **Smart Preloading** - Videos buffer in advance for uninterrupted viewing
- 🎭 **AR Lens Gallery** - Explore a variety of augmented reality effects
- 🔍 **Personalized Content** - Tailor your experience with content preferences
- 📸 **Snapchat Camera Integration** - Powered by Snapchat's Camera Kit SDK
- 🔄 **Social Sharing** - Share your favorite AR experiences with friends
- 💾 **Save to Gallery** - Download videos and AR effects to your device

## 📱 App Availability

- **iOS**: Now available on the [App Store](https://apps.apple.com/us/app/nouns-ar-lab/id6737252963)!
- **Android**: Currently in closed testing phase. Stay tuned for the public release!

## 🚀 Installation

To install the Flutter project for development, follow these steps:

1. Make sure you have Flutter SDK installed on your machine. If not, you can download it from the official Flutter website.
2. Clone the project repository using the following command:
    ```bash
    git clone https://github.com/fahmad480/NounsARLab
    ```
3. Navigate to the project directory:
    ```bash
    cd NounsARLab
    ```
4. Run the following command to fetch the project dependencies:
    ```bash
    flutter pub get
    ```
5. For iOS, follow this step first before proceeding to step 7:
    ```bash
    cd ios
    pod install
    ```
6. Open the Xcode workspace inside the `ios` folder.
7. Connect your device or start an emulator.
8. Run the project using the following command:
    ```bash
    flutter run
    ```

This will start the Flutter project on your device or emulator.

## ⚙️ Platform Setup

### Android Setup

To enable Firebase services for Android, place your `google-services.json` file inside the `android/app/` directory.

### iOS Setup

To enable Firebase services for iOS, place your `GoogleService-Info.plist` file inside the `ios/Runner/` directory.

## 🌐 Enable Localization for CameraKit for iOS

To enable localization for CameraKit, follow these steps:

1. Open the `Localizable.strings` file located at `Pods Project -> Pods -> SCCameraKitReferenceUI -> Resources -> Localizable.strings`.
2. Make sure the `SCCameraKitReferenceUI` target is selected in the "Target Membership" section on the right side of Xcode.
3. Build the project to apply the changes.

<p align="center">
  <img src="documentation/enable_localization_camerakit.gif" alt="Enable Localization for CameraKit" width="600">
</p>

## 📚 Additional Configuration for Camera Kit SDK

For additional configuration of Camera Kit SDK, refer to the repository:
[Camera Kit Flutter](https://github.com/DevCrew-io/camerakit-flutter).

## 📝 TODOs

1. 🎨 Improve UI to be more visually appealing, avoiding Flutter stock UI.
2. 👆 Make lens list clickable.
3. 🔄 Backup server content/storage and database.

## 👥 Contributors

- **Imam Solihin** (Project Manager, Nouns DAO Holder)  
  - [Instagram](https://www.instagram.com/mmsolihin)  
  - [LinkedIn](https://www.linkedin.com/in/imam-solihin-9bb04975/)  
- **Faraaz Ahmad Permadi** (App Developer)  
  - [Instagram](https://www.instagram.com/faraaz.id)  
  - [LinkedIn](https://www.linkedin.com/in/faraazahmadpermadi/)  

## 🤝 Contributing

We welcome contributions! Follow these steps to contribute:

1. **Fork the repository** – Click on the "Fork" button at the top-right corner of the repository page.
2. **Clone your fork** – Download your forked repository to your local machine:
   ```bash
   git clone https://github.com/your-username/NounsARLab.git
   ```
3. **Create a new branch** – Work on your changes in a dedicated branch:
   ```bash
   git checkout -b feature-your-feature-name
   ```
4. **Make your changes** – Implement your changes and commit them:
   ```bash
   git add .
   git commit -m "Added feature: your feature name"
   ```
5. **Push to GitHub** – Upload your branch:
   ```bash
   git push origin feature-your-feature-name
   ```
6. **Open a Pull Request** – Go to the repository on GitHub and open a Pull Request describing your changes.

We will review your changes and merge them if they align with the project's direction. Thank you for your contributions! 🎉

