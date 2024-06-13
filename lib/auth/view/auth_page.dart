import 'package:instagrume/auth/view/login_or_register.dart';
import 'package:instagrume/import.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  static String id = 'auth';

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user is logged in
          if (snapshot.hasData) {
            return HomePage();
          }

          // user is NOT logged in
          else {
            return const LoginOrRegister();
          }
          return Container();
        },
      ),
    );
  }
}
