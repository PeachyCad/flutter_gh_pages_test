import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:things_todo_app/components/text_fragment.dart';

class AndroidSettingsInfo extends StatefulWidget {
  const AndroidSettingsInfo({super.key});

  @override
  State<AndroidSettingsInfo> createState() => _AndroidSettingsInfoState();
}

class _AndroidSettingsInfoState extends State<AndroidSettingsInfo> {
  static const _platform = MethodChannel('com.example.flutter/device_info');
  String _deviceInfo = "";

  Future<void> _getDeviceInfo() async {
    String result;
    try {
      _platform.invokeMethod('getDeviceInfo').then((value) {
        result = value.toString();
        setState(() {
          _deviceInfo = result;
        });
      });
    } on PlatformException catch (e) {
      if (kDebugMode) print("_getDeviceInfo==>${e.message}");
    }
  }

  @override
  void initState() {
    _getDeviceInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const TextFragment(
              text:
                  "We wiil use your device info only to improve our app later...",
              isOverflowClip: true,
            ),
            const SizedBox(
              height: 10,
            ),
            const TextFragment(
              text: "UwU",
              isOverflowClip: true,
            ),
            const SizedBox(
              height: 10,
            ),
            TextFragment(
              text: _deviceInfo,
              isOverflowClip: true,
            ),
          ],
        ),
      ),
    );
  }
}
