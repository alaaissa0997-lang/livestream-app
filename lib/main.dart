import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'services/api_client.dart';
import 'services/auth_provider.dart';
import 'services/realtime_service.dart';
import 'services/zego_service.dart';

void main() => runApp(const LiveApp());

class LiveApp extends StatefulWidget {
  const LiveApp({super.key});
  @override
  State<LiveApp> createState() => _LiveAppState();
}

class _LiveAppState extends State<LiveApp> {
  late final ApiClient _api = ApiClient(const FlutterSecureStorage());
  late final RealtimeService _rt = RealtimeService(_api);
  late final ZegoService _zego = ZegoService(_api);
  late final AuthProvider _auth = AuthProvider(_api, _rt, _zego)..restore();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiClient>.value(value: _api),
        Provider<RealtimeService>.value(value: _rt),
        Provider<ZegoService>.value(value: _zego),
        ChangeNotifierProvider<AuthProvider>.value(value: _auth),
      ],
      child: MaterialApp(
        title: 'بث مباشر',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorSchemeSeed: Colors.pink, useMaterial3: true),
        // واجهة عربية من اليمين لليسار
        builder: (context, child) =>
            Directionality(textDirection: TextDirection.rtl, child: child!),
        home: const _Gate(),
      ),
    );
  }
}

class _Gate extends StatelessWidget {
  const _Gate();
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if (auth.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return auth.loggedIn ? const HomeScreen() : const LoginScreen();
  }
}
