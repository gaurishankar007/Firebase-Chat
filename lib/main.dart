import 'package:firebase_chat/firebase_options.dart';
import 'package:firebase_chat/src/config/routes/route.dart';
import 'package:firebase_chat/src/config/themes/theme.dart';
import 'package:firebase_chat/src/data/local/local_data.dart';
import 'package:firebase_chat/src/presentation/blocs/theme/theme_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await LocalData.setInstance();

  runApp(FirebaseChat());
}

class FirebaseChat extends StatelessWidget {
  const FirebaseChat({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeBloc(),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Firebase Chat',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: state.themeMode,
            initialRoute: LocalData.initialRoute,
            onGenerateRoute: AppRoutes.onGenerated,
          );
        },
      ),
    );
  }
}
