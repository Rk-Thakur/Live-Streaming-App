import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zego Home Page',
      home: HomePage(),
    );
  }
}

final String userId = Random().nextInt(9000000 + 1000000).toString();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final liveIdController =
      TextEditingController(text: Random().nextInt(900000 + 100000).toString());
  var buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: const Color(0xff034ada),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/header_illustration.svg',
              width: MediaQuery.of(context).size.width * 0.7,
            ),
            const SizedBox(
              height: 20,
            ),
            Text("Your UserId: $userId"),
            const SizedBox(
              height: 20,
            ),
            const Text("Please test with two or more devices"),
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: liveIdController,
              decoration: const InputDecoration(
                  labelText: 'Join or Start a Live by input an ID',
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                style: buttonStyle,
                onPressed: () {
                  print('Start a Live');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LivePage(
                                liveID: liveIdController.text,
                                isHost: true,
                              )));
                },
                child: const Text("Start a Live")),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
                style: buttonStyle,
                onPressed: () {
                  // jumpToLivePage(context, liveId: liveIdController.text, isHost: false);
                  print('join  alive');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LivePage(
                                liveID: liveIdController.text,
                                isHost: false,
                              )));
                },
                child: const Text("Join a Live")),
          ],
        ),
      ),
    );
  }

  jumpToLivePage(BuildContext context, {required String liveId, required bool isHost}) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LivePage(
                  liveID: liveId,
                  isHost: isHost,
                )));
  }
}

class LivePage extends StatelessWidget {
  final String liveID;
  final bool isHost;
  LivePage({super.key, required this.liveID, this.isHost = false});
  final int appID = int.parse(dotenv.get('ZEGO_APP_ID'));
  final String appSign = dotenv.get('ZEGO_APP_SIGN');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltLiveStreaming(
        appID: appID,
        appSign: appSign,
        userID: userId,
        userName: 'user _$userId',
        liveID: liveID,
        config: isHost
            ? ZegoUIKitPrebuiltLiveStreamingConfig.host()
            : ZegoUIKitPrebuiltLiveStreamingConfig.audience(),
      ),
    );
  }
}
