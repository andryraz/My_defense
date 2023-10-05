import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../components/loader/loader.dart';
import '../providers/user_provider.dart';
import '../screens/authentification/login_screen.dart';
import '../screens/authentification/register_screen.dart';
import '../utils/navigation.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MaterialApp(
        title: 'My defense',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Ajoutez un délai pour simuler l'affichage de l'image
    Future.delayed(Duration(seconds: 3), () {
      // Naviguez vers la page principale (HomePage_in_main dans votre cas)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Ici, vous pouvez afficher l'image de votre choix
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child:  ClipRRect(
          borderRadius: BorderRadius.circular(30.0), // Ajustez le rayon comme vous le souhaitez
          child: Image.asset(
            'images/memory.png', // Remplacez par le chemin de votre image
            width: 200, // Ajustez la largeur de l'image
            height: 200, // Ajustez la hauteur de l'image
          ),
        ), // Remplacez par le chemin de votre image
      ),
    );
  }
}

// create a homepage widget to handle auth workflow and note that we are using a _authService.isLoggedIn so you'll need to use FutureBuilder to handle the async call
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();
  bool visible = true;

  toggle() {
    setState(() {
      visible = !visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _authService.isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loader(); // Affichez un indicateur de chargement si nécessaire
        }

        final isLoggedIn = snapshot.data ?? false;

        if (isLoggedIn) {
          handleLoggedInUser(isLoggedIn, context);
        } else {
          return visible ? LoginScreen(toggle) : RegisterScreen(toggle);
        }

        // Affichez l'écran de connexion
        return Loader();
      },
    );
  }
}
