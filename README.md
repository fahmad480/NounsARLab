# Nouns AR Lab

Nouns AR Lab is an application that combines the concept of YouTube Shorts and Camera Kit SDK from Snapchat. This application serves as a portfolio that displays videos using AR effects, allowing users to interact with and apply AR effects within the app.

## Installation

To install the Flutter project, follow these steps:

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

## Android Setup

To enable Firebase services for Android, place your `google-services.json` file inside the `android/app/` directory.

## iOS Setup

To enable Firebase services for iOS, place your `GoogleService-Info.plist` file inside the `ios/Runner/` directory.

## Enable Localization for CameraKit for iOS

To enable localization for CameraKit, follow these steps:

1. Open the `Localizable.strings` file located at `Pods Project -> Pods -> SCCameraKitReferenceUI -> Resources -> Localizable.strings`.
2. Make sure the `SCCameraKitReferenceUI` target is selected in the "Target Membership" section on the right side of Xcode.
3. Build the project to apply the changes.

![Enable Localization for CameraKit](documentation/enable_localization_camerakit.gif)

## Additional Configuration for Camera Kit SDK

For additional configuration of Camera Kit SDK, refer to the repository:
[Camera Kit Flutter](https://github.com/DevCrew-io/camerakit-flutter).

## Features

1. Scrollable video
2. Preload video
3. Lens list
4. Content preferences
5. Snapchat Camera Kit SDK integration
6. Share to social media
7. Save to gallery

## TODOs

1. Improve UI to be more visually appealing, avoiding Flutter stock UI.
2. Make lens list clickable.
3. Backup server content/storage and database.

## Contributors

- **Imam Solihin** (Project Manager, Nouns DAO Holder)  
  - [Instagram](https://www.instagram.com/mmsolihin)  
  - [LinkedIn](https://www.linkedin.com/in/imam-solihin-9bb04975/)  
- **Faraaz Ahmad Permadi** (App Developer)  
  - [Instagram](https://www.instagram.com/faraaz.id)  
  - [LinkedIn](https://www.linkedin.com/in/faraazahmadpermadi/)  

## Contributing

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

