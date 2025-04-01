import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:camerakit_flutter/camerakit_flutter.dart';
import 'package:camerakit_flutter/lens_model.dart';
import 'package:nouns_dao_ar/constants.dart';
import 'package:nouns_dao_ar/media_result_screen.dart';
import 'package:nouns_dao_ar/shorts/screens/lens_list_screen.dart';
import 'package:nouns_dao_ar/shorts/screens/video_playing.dart';
import 'package:nouns_dao_ar/shorts/screens/settings_screen.dart';
import 'package:nouns_dao_ar/eula_dialog.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Lock device orientation to portrait mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Hive for local storage
  await Hive.initFlutter();

  // Open main storage box
  await Hive.openBox('videoBox');

  // Set up video cache directory
  final appDir = await getApplicationDocumentsDirectory();
  final videoCacheDir = '${appDir.path}/video_cache';

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _checkedEula = false;

  @override
  void initState() {
    super.initState();
    // Schedule check for next frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkEula();
    });
  }

  Future<void> _checkEula() async {
    if (_checkedEula) return;
    _checkedEula = true;

    final videoBox = Hive.box('videoBox');
    final hasAcceptedEula = videoBox.get('accepted_eula', defaultValue: false);

    if (!hasAcceptedEula) {
      if (!mounted) return;

      final accepted = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) => const EulaDialog(),
      );

      if (accepted == true) {
        await videoBox.put('accepted_eula', true);
        if (!mounted) return;
        _startNavigationTimer();
      } else {
        SystemNavigator.pop();
      }
    } else {
      _startNavigationTimer();
    }
  }

  void _startNavigationTimer() {
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyAppState()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/splash_image.png',
              fit: BoxFit.cover,
            ),
          ),
          const Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyAppState extends StatefulWidget {
  const MyAppState({super.key});

  @override
  State<MyAppState> createState() => _MyAppState();
}

class _MyAppState extends State<MyAppState> implements CameraKitFlutterEvents {
  late String _filePath = '';
  late String _fileType = '';
  late List<Lens> lensList = [];
  late List<Map<String, dynamic>> lensJsonList = [];
  late final _cameraKitFlutterImpl =
      CameraKitFlutterImpl(cameraKitFlutterEvents: this);
  int _selectedIndex = 0;

  // Create a key to access the VideoPlayingScreen state
  final GlobalKey<VideoPlayingScreenState> _videoPlayingKey =
      GlobalKey<VideoPlayingScreenState>();

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    // Initialize pages with the video playing key
    _pages = [
      VideoPlayingScreen(key: _videoPlayingKey, isActive: _selectedIndex == 0),
      LensListScreen(lensList: lensList),
      const SettingsScreen(),
    ];

    // _cameraKitFlutterImpl.setCredentials(apiToken: Constants.cameraKitApiToken);

    // Add this to ensure the widget is fully mounted before calling getGroupLenses
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (kDebugMode) {
        print('Getting group lenses [1]');
      }
      getGroupLenses();
    });
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;

        // Update page states based on the selected index
        _pages = [
          VideoPlayingScreen(key: _videoPlayingKey, isActive: index == 0),
          LensListScreen(lensList: lensList),
          const SettingsScreen(),
        ];
      });

      // Notify video screen about activity state change
      if (_videoPlayingKey.currentState != null) {
        _videoPlayingKey.currentState!.setActiveState(index == 0);
      }

      if (index == 1) {
        getGroupLenses();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_movies_outlined),
            label: 'Videos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Lens List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  @override
  void onCameraKitResult(Map<dynamic, dynamic> result) {
    setState(() {
      _filePath = result["path"] as String;
      _fileType = result["type"] as String;

      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MediaResultWidget(
                filePath: _filePath,
                fileType: _fileType,
              )));
    });
  }

  getGroupLenses() async {
    try {
      _cameraKitFlutterImpl.getGroupLenses(
        groupIds: Constants.groupIdList,
      );
      if (kDebugMode) {
        print('Getting group lenses [2]');
      }
    } on PlatformException {
      if (kDebugMode) {
        print("Failed to open camera kit");
      }
    }
  }

  @override
  void receivedLenses(List<Lens> lensList) async {
    if (kDebugMode) {
      print('Received lenses: $lensList');
    }
    setState(() {
      this.lensList = lensList;
      lensJsonList = lensList
          .map((lens) => {
                'id': lens.id,
                'name': lens.name,
                'groupId': lens.groupId,
                'thumbnail': lens.thumbnail,
              })
          .toList();

      // Update pages with new lens list
      _pages = [
        VideoPlayingScreen(
            key: _videoPlayingKey, isActive: _selectedIndex == 0),
        LensListScreen(lensList: lensList),
        const SettingsScreen(),
      ];

      if (kDebugMode) {
        print('Lens list: $lensJsonList');
      }
    });
  }
}
