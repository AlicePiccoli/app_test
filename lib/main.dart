import 'import.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
          useMaterial3: true,
          fontFamily: 'Poppins',
        ),
        initialRoute: AuthPage.id,
        routes: {
          LoginPage.id: (context) => const LoginPage(),
          HomePage.id: (context) => HomePage(),
          AuthPage.id: (context) => const AuthPage(),
          CardPage.id: (context) => const CardPage(),
          AddPost.id: (context) => const AddPost(),
        });
  }
}
