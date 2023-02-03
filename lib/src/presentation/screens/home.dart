import 'package:firebase_chat/src/data/remote/repositories/auth_repo_impl.dart';
import 'package:firebase_chat/src/presentation/blocs/home/home_bloc.dart';
import 'package:firebase_chat/src/presentation/screens/profile.dart';
import 'package:firebase_chat/src/presentation/screens/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../core/constant.dart';
import '../widgets/navigation.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DateTime preBackPress = DateTime.now();

  Future<bool> exit() async {
    final Duration timeGap = DateTime.now().difference(preBackPress);
    final bool cantExit = timeGap >= Duration(seconds: 1);
    preBackPress = DateTime.now();

    if (cantExit) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Press back button again to Exit'),
        duration: Duration(seconds: 1),
      ));
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;
    Color primaryContainer = Theme.of(context).colorScheme.primaryContainer;
    Color surface = Theme.of(context).colorScheme.surface;
    Color onSurface = Theme.of(context).colorScheme.onSurface;

    return BlocProvider(
      create: (context) => HomeBloc()..add(HomeLoadedEvent()),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoadedState) {
            return WillPopScope(
              onWillPop: exit,
              child: Scaffold(
                body: SafeArea(
                  child: PageView(
                    controller: state.pageController,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      Column(
                        children: [
                          Text("HomePage"),
                          SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            onPressed: () => AuthRepo().signOut(context),
                            child: Text("Sign Out"),
                          ),
                        ],
                      ),
                      Search(),
                      Profile(),
                    ],
                  ),
                ),
                bottomNavigationBar: HomeNavigationBar(
                  pageIndex: state.pageIndex,
                ),
              ),
            );
          }

          return WillPopScope(
            onWillPop: exit,
            child: Scaffold(
              body: SafeArea(
                child: Center(
                  child: SpinKitCircle(
                    color: primary,
                    size: iconSize * 2,
                  ),
                ),
              ),
              bottomNavigationBar: HomeLoadingNavigationBar(),
            ),
          );
        },
      ),
    );
  }
}
