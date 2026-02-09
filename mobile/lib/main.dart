import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'braille_engine/braille_translator.dart';
import 'braille_engine/temporal_encoder.dart';
import 'package:flutter/services.dart';
import 'socket_client/socket_manager.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => BrailleTranslator()),
        Provider(create: (_) => TemporalEncoder()),
      ],
      child: const VibroApp(),
    ),
  );
}

class VibroApp extends StatelessWidget {
  const VibroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(useMaterial3: true),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late SocketManager socketManager;
  String status = "Disconnected";
  String lastText = "";

  @override
  void initState() {
    super.initState();
    // Using local IP for reliable connection on physical devices
    // Replace '192.168.0.103' with your computer's IP if different
    socketManager = SocketManager(
      url: 'ws://192.168.0.103:3000',
      onMessageReceived: (text) {
        setState(() => lastText = text);
        _triggerHaptics(text);
      },
      onConnected: () {
        setState(() => status = "Connected");
        print("Connected to WebSocket");
      },
      onDisconnected: () {
        setState(() => status = "Disconnected");
        print("Disconnected from WebSocket");
      },
    );
  }

  void _triggerHaptics(String text) {
    final translator = context.read<BrailleTranslator>();
    final encoder = context.read<TemporalEncoder>();
    final dots = translator.translate(text);
    final pattern = encoder.encodeText(dots);

    print(
        "Sending Haptics: Timings: ${pattern.timings}, Amplitudes: ${pattern.amplitudes}");

    // Call Native Haptic Bridge via MethodChannel here
    const platform = MethodChannel('com.vibrobraille/haptics');
    try {
      platform.invokeMethod('vibrateWaveform', {
        'timings': pattern.timings,
        'amplitudes': pattern.amplitudes,
      });
    } on PlatformException catch (e) {
      print("Failed to vibrate: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("VibroBraille Hybrid")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(status, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => socketManager.connect("MOCK-SESSION-123"),
              child: const Text("Connect to AI Brain"),
            ),
            const SizedBox(height: 40),
            Text("Last Message:", style: TextStyle(color: Colors.grey)),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(lastText,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
