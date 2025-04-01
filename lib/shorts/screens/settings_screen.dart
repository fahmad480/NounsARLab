// settings_screen.dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Privacy Policy',
                style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PrivacyPolicyScreen()),
              );
            },
          ),
          ListTile(
            title: const Text('Terms and Conditions',
                style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const TermsAndConditionsScreen()),
              );
            },
          ),
          ListTile(
            title: const Text('Liked Content',
                style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const LikedContentScreen()),
              );
            },
          ),
          ListTile(
            title: const Text('Disliked Content',
                style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const DislikedContentScreen()),
              );
            },
          ),
          ListTile(
            title:
                const Text('Liked Tags', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const LikedTagsScreen()),
              );
            },
          ),
          ListTile(
            title: const Text('Disliked Tags',
                style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const DislikedTagsScreen()),
              );
            },
          ),
          ListTile(
            title: const Text('End User License Agreement',
                style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EulaScreen()),
              );
            },
          ),
          ListTile(
            title:
                const Text('Remove Cache', style: TextStyle(color: Colors.red)),
            onTap: () async {
              bool? confirm = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Confirm'),
                    content: const Text(
                        'Are you sure you want to remove all cache?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: const Text('Confirm'),
                      ),
                    ],
                  );
                },
              );

              if (confirm == true) {
                var videoBox = Hive.box('videoBox');
                await videoBox.clear();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cache cleared successfully')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            'The Nouns AR Lab application (hereinafter referred to as the "App") values your privacy and is committed to protecting your personal information. This Privacy Policy outlines how we collect, use, and protect the data you provide when using this App.\n\n'
            '1. Information We Collect\n'
            'This App may collect information you provide directly when using certain features, such as giving likes, sharing content, reporting content, and selecting options to see more or less content like this. We do not collect sensitive personal information without your consent.\n\n'
            '2. Actions Users Can Take\n'
            'As a user of the App, you can perform the following actions:\n'
            '- Give a like/dislike to content you enjoy.\n'
            '- Share content to other platforms.\n'
            '- Report content that violates community guidelines.\n'
            '- Adjust content preferences by selecting "see more" or "see less" similar content.\n\n'
            '3. Actions Users Cannot Take\n'
            'Users cannot add or upload new content to the App. This feature is only available to administrators who have the authority to add content to the platform.\n\n'
            '4. Use of Data\n'
            'We use the information collected to enhance the user experience, manage content, and provide content recommendations that are more relevant to your preferences. No user data is shared or stored on our servers except for actions like/dislike and report. Other actions such as see more and see less are stored locally on the user\'s device.\n\n'
            '5. Data Security\n'
            'We are committed to protecting your personal data. We use industry-standard security technologies to prevent unauthorized access, alteration, or disclosure of your personal data.\n\n'
            '6. Changes to Privacy Policy\n'
            'We may update this Privacy Policy from time to time. Any changes will be communicated through App updates or direct notifications to you.\n\n'
            'By using the Nouns AR Lab App, you agree to the collection and use of data in accordance with this Privacy Policy.',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms and Conditions'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            'Terms and Conditions for Nouns AR Lab\n\n'
            'These Terms and Conditions ("Terms") govern your use of the Nouns AR Lab mobile application (the "App"). By accessing or using the App, you agree to comply with these Terms. Please read them carefully before using the App.\n\n'
            '1. Acceptance of Terms\n'
            'By using the Nouns AR Lab App, you agree to be bound by these Terms and any other policies, guidelines, or rules applicable to specific features of the App. If you do not agree with these Terms, please do not use the App.\n\n'
            '2. User Conduct\n'
            'As a user, you agree to:\n'
            '- Use the App only for lawful purposes and in a manner that does not infringe on the rights of others or violate any applicable laws or regulations.\n'
            '- Not engage in any activity that may interfere with or disrupt the functioning of the App or its services.\n'
            '- Not upload, post, or share any content that is harmful, offensive, defamatory, or violates the intellectual property rights of others.\n\n'
            '3. User Actions and Content Interaction\n'
            'Within the App, you can perform the following actions:\n'
            '- Like content you enjoy.\n'
            '- Share content to other platforms.\n'
            '- Report content that violates community guidelines or terms of service.\n'
            '- Adjust content preferences by selecting options to see more or see less content similar to what you have engaged with.\n'
            'Please note that users cannot add or upload new content to the App. Content creation and management are reserved exclusively for authorized administrators.\n\n'
            '4. Content Ownership\n'
            'All content available within the App, including but not limited to images, text, videos, and graphics, is owned or licensed by Nouns AR Lab. By using the App, you are granted a limited, non-exclusive, non-transferable license to interact with the content in accordance with these Terms.\n\n'
            '5. Privacy and Data Collection\n'
            'The App does not require registration or the storage of personal user data. However, certain information may be collected to improve the user experience, such as:\n'
            '- Likes: Data on which content you engage with by liking.\n'
            '- Reports: Information on content you report for violating guidelines.\n'
            'These actions may be stored temporarily to ensure the proper functioning of the App and to tailor content recommendations, but no personally identifiable data is stored or required.\n\n'
            'By using the App, you consent to the collection of this limited data. For more information on how we handle your data, please refer to our Privacy Policy.\n\n'
            '6. Restrictions\n'
            'You may not:\n'
            '- Modify, distribute, or create derivative works based on the content or features of the App without our express permission.\n'
            '- Attempt to reverse engineer, decompile, or disassemble the App or any of its components.\n'
            '- Use the App for any unlawful purposes, including infringing on intellectual property rights or violating the privacy rights of others.\n\n'
            '7. Termination\n'
            'We reserve the right to suspend or terminate your access to the App at any time, without prior notice, for any violation of these Terms or if we believe you are engaging in activities that may harm the App or its users.\n\n'
            '8. Disclaimers\n'
            'The App is provided "as is," and we make no representations or warranties regarding the availability, reliability, or functionality of the App. We do not guarantee that the App will be free from errors, interruptions, or security vulnerabilities.\n\n'
            '9. Limitation of Liability\n'
            'To the fullest extent permitted by law, Nouns AR Lab and its affiliates will not be liable for any direct, indirect, incidental, special, or consequential damages arising from your use or inability to use the App.\n\n'
            '10. Indemnity\n'
            'You agree to indemnify and hold Nouns AR Lab harmless from any claims, losses, damages, or liabilities arising from your violation of these Terms or your use of the App.\n\n'
            '11. Changes to the Terms\n'
            'We may update these Terms from time to time. Any changes will be effective immediately upon posting in the App. We encourage you to review these Terms regularly to stay informed of any updates.\n\n'
            '12. Governing Law\n'
            'These Terms are governed by and construed in accordance with the laws of the jurisdiction in which Nouns AR Lab operates. Any disputes arising under or in connection with these Terms shall be resolved in the appropriate courts of that jurisdiction.\n\n'
            '13. Contact Information\n'
            'If you have any questions or concerns about these Terms, please contact us at [imamsolihin@gmail.com].',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}

class DislikedContentScreen extends StatelessWidget {
  const DislikedContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Box videoBox = Hive.box('videoBox');
    final dislikedVideos = videoBox.keys
        .where(
            (key) => key.toString().endsWith('_disliked') && videoBox.get(key))
        .map((key) => key.toString().replaceAll('_disliked', ''))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Disliked Content'),
      ),
      body: ListView.builder(
        itemCount: dislikedVideos.length,
        itemBuilder: (context, index) {
          final videoId = dislikedVideos[index];
          final videoData = videoBox.get(videoId);
          final videoDescription = videoData['videoDescription'] ?? '';
          final effectName = videoData['effectName'] ?? '';
          final effectIcon = videoData['effectIcon'] ?? '';

          return ListTile(
            leading: Image.network(effectIcon),
            title: Text(effectName),
            subtitle: Text(
              videoDescription.length > 50
                  ? '${videoDescription.substring(0, 50)}...'
                  : videoDescription,
            ),
          );
        },
      ),
    );
  }
}

class LikedContentScreen extends StatelessWidget {
  const LikedContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Box videoBox = Hive.box('videoBox');
    final likedVideos = videoBox.keys
        .where((key) => key.toString().endsWith('_liked') && videoBox.get(key))
        .map((key) => key.toString().replaceAll('_liked', ''))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Liked Content'),
      ),
      body: ListView.builder(
        itemCount: likedVideos.length,
        itemBuilder: (context, index) {
          final videoId = likedVideos[index];
          final videoData = videoBox.get(videoId);
          final videoDescription = videoData['videoDescription'] ?? '';
          final effectName = videoData['effectName'] ?? '';
          final effectIcon = videoData['effectIcon'] ?? '';

          return ListTile(
            leading: Image.network(effectIcon),
            title: Text(effectName),
            subtitle: Text(
              videoDescription.length > 50
                  ? '${videoDescription.substring(0, 50)}...'
                  : videoDescription,
            ),
          );
        },
      ),
    );
  }
}

class LikedTagsScreen extends StatelessWidget {
  const LikedTagsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Box videoBox = Hive.box('videoBox');
    final likedTags = videoBox.keys
        .where((key) =>
            key.toString().startsWith('liked_tag_') && videoBox.get(key))
        .map((key) => key.toString().replaceAll('liked_tag_', ''))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Liked Tags'),
      ),
      body: ListView.builder(
        itemCount: likedTags.length,
        itemBuilder: (context, index) {
          final tag = likedTags[index];
          return ListTile(
            title: Text(tag),
          );
        },
      ),
    );
  }
}

class DislikedTagsScreen extends StatelessWidget {
  const DislikedTagsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Box videoBox = Hive.box('videoBox');
    final dislikedTags = videoBox.keys
        .where((key) =>
            key.toString().startsWith('disliked_tag_') && videoBox.get(key))
        .map((key) => key.toString().replaceAll('disliked_tag_', ''))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Disliked Tags'),
      ),
      body: ListView.builder(
        itemCount: dislikedTags.length,
        itemBuilder: (context, index) {
          final tag = dislikedTags[index];
          return ListTile(
            title: Text(tag),
          );
        },
      ),
    );
  }
}

class EulaScreen extends StatelessWidget {
  const EulaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('End User License Agreement'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            'End User License Agreement (EULA)\n\n'
            'This End User License Agreement ("Agreement") is a legal agreement between you and Nouns AR Lab ("Company") for the use of the Nouns AR Lab mobile application ("App"). By installing or using the App, you agree to be bound by the terms of this Agreement.\n\n'
            '1. License Grant\n'
            'The Company grants you a limited, non-exclusive, non-transferable, revocable license to use the App for personal, non-commercial purposes in accordance with the terms of this Agreement.\n\n'
            '2. Restrictions\n'
            'You may not:\n'
            '- Modify, reverse engineer, decompile, or disassemble the App.\n'
            '- Rent, lease, loan, sell, distribute, or create derivative works based on the App.\n'
            '- Use the App for any unlawful purpose or in violation of any applicable laws or regulations.\n\n'
            '3. Ownership\n'
            'The App is licensed, not sold. The Company retains all rights, title, and interest in and to the App, including all intellectual property rights.\n\n'
            '4. Termination\n'
            'This Agreement is effective until terminated. Your rights under this Agreement will terminate automatically without notice if you fail to comply with any term(s) of this Agreement. Upon termination, you must cease all use of the App and delete all copies of the App.\n\n'
            '5. Disclaimer of Warranties\n'
            'The App is provided "as is" without warranty of any kind. The Company disclaims all warranties, whether express, implied, or statutory, including, but not limited to, implied warranties of merchantability, fitness for a particular purpose, and non-infringement.\n\n'
            '6. Limitation of Liability\n'
            'To the fullest extent permitted by law, in no event shall the Company be liable for any indirect, incidental, special, consequential, or punitive damages, or any damages whatsoever arising out of or related to your use or inability to use the App.\n\n'
            '7. Governing Law\n'
            'This Agreement shall be governed by and construed in accordance with the laws of the jurisdiction in which the Company is based, without regard to its conflict of law principles.\n\n'
            '8. Changes to this Agreement\n'
            'The Company reserves the right to modify this Agreement at any time. Any changes will be effective immediately upon posting the revised Agreement in the App. Your continued use of the App following the posting of changes will constitute your acceptance of such changes.\n\n'
            '9. Contact Information\n'
            'If you have any questions about this Agreement, please contact us at [imamsolihin@gmail.com].',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
