import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_chat/src/data/local/local_data.dart';
import 'package:firebase_chat/src/data/remote/models/google_user_model.dart';
import 'package:firebase_chat/src/presentation/blocs/theme/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../core/constant.dart';
import '../../data/remote/repositories/auth_repo_impl.dart';

class Profile extends StatelessWidget {
  final GoogleUserModel googleUserModel = LocalData.googleUserModel!;
  Profile({super.key});

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;
    Color primaryContainer = Theme.of(context).colorScheme.primaryContainer;
    Color surface = Theme.of(context).colorScheme.surface;
    Color onSurface = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                primary.withOpacity(.5),
                primary,
                primaryContainer.withOpacity(.5),
                primaryContainer,
              ],
              transform: GradientRotation(90),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: sWidth(context) * .04,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: surface,
                boxShadow: [
                  BoxShadow(
                    color: onSurface.withOpacity(.05),
                    spreadRadius: 2,
                    blurRadius: 3,
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: surface,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: onSurface.withOpacity(.05),
                              spreadRadius: 2,
                              blurRadius: 3,
                              offset: Offset(2, 2),
                            )
                          ],
                        ),
                        child: ClipOval(
                          child: CachedNetworkImage(
                            height: sWidth(context) * .2,
                            width: sWidth(context) * .2,
                            fit: BoxFit.cover,
                            imageUrl: googleUserModel.photoUrl,
                            placeholder: (context, url) => SpinKitCircle(
                              color: primary,
                              size: iconSize,
                            ),
                            errorWidget: (context, url, error) => Center(
                              child: Icon(
                                Icons.bug_report_rounded,
                                size: iconSize,
                                color: primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: sWidth(context) * .6,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              googleUserModel.displayName,
                              textAlign: TextAlign.start,
                              style: largeText.copyWith(
                                color: onSurface,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              googleUserModel.email,
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              style: smallBoldText.copyWith(
                                color: onSurface.withOpacity(.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, state) {
                bool darkMode = state.themeMode == ThemeMode.dark;
                return ListTile(
                  onTap: () => AuthRepo().signOut(context: context),
                  leading: Icon(
                    darkMode
                        ? Icons.dark_mode_rounded
                        : Icons.light_mode_rounded,
                    color: primary,
                    size: iconSize + 5,
                  ),
                  title: Text(
                    darkMode ? "Dark Mode" : "Light Mode",
                    style: mediumBoldText.copyWith(
                      color: onSurface,
                    ),
                  ),
                  trailing: Switch(
                    value: darkMode,
                    activeColor: onSurface,
                    onChanged: (value) {
                      if (darkMode) {
                        BlocProvider.of<ThemeBloc>(context)
                            .add(ThemeEvent(themeMode: ThemeMode.light));
                        return;
                      }
                      BlocProvider.of<ThemeBloc>(context)
                          .add(ThemeEvent(themeMode: ThemeMode.dark));
                    },
                  ),
                );
              },
            ),
            ListTile(
              onTap: () => AuthRepo().signOut(context: context),
              leading: Icon(
                Icons.logout_rounded,
                color: primary,
                size: iconSize + 5,
              ),
              title: Text(
                "Log out",
                style: mediumBoldText.copyWith(
                  color: onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
