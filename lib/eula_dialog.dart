import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EulaDialog extends StatelessWidget {
  const EulaDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('End User License Agreement'),
      content: const SizedBox(
        width: double.maxFinite,
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
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            SystemNavigator.pop(); // Exit app
          },
          child: const Text('Disagree'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true); // Return true when accepted
          },
          child: const Text('Agree'),
        ),
      ],
    );
  }
}