import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_chat/src/core/constant.dart';
import 'package:firebase_chat/src/presentation/blocs/search/search_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;
    Color surface = Theme.of(context).colorScheme.surface;
    Color onSurface = Theme.of(context).colorScheme.onSurface;

    return BlocProvider(
      create: (context) => SearchBloc()..add(SearchLoadedEvent()),
      child: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state is SearchResultState) {
            return Scaffold(
              body: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: sWidth(context) * .04,
                  vertical: 10,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Container(
                            height: 30,
                            margin: EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              color: surface,
                              borderRadius:
                                  BorderRadius.circular(cBorderRadius),
                              boxShadow: [
                                BoxShadow(
                                  color: onSurface.withOpacity(.05),
                                  spreadRadius: 2,
                                  blurRadius: 3,
                                )
                              ],
                            ),
                            child: TextFormField(
                              controller: state.searchController,
                              textInputAction: TextInputAction.search,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 5),
                                prefixIcon: Icon(Icons.search_rounded),
                                prefixIconColor: onSurface,
                                hintText: 'Search',
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                              onTap: () => BlocProvider.of<SearchBloc>(context)
                                ..add(SearchToggleEvent(searching: true)),
                              onChanged: (value) {},
                            ),
                          ),
                        ),
                        if (state.searching)
                          TextButton(
                            onPressed: () =>
                                BlocProvider.of<SearchBloc>(context)
                                  ..add(SearchToggleEvent(searching: false)),
                            style: TextButton.styleFrom(minimumSize: Size.zero),
                            child: Text("Cancel", style: mediumBoldText),
                          ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: state.userDataModels.length,
                      separatorBuilder: (context, index) => Padding(
                        padding:
                            EdgeInsets.only(left: sWidth(context) * .13 + 10),
                        child: Divider(
                          color: onSurface.withOpacity(.3),
                        ),
                      ),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {},
                          child: Row(
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
                                    width: sWidth(context) * .13,
                                    fit: BoxFit.cover,
                                    imageUrl:
                                        state.userDataModels[index].photoUrl,
                                    placeholder: (context, url) =>
                                        SpinKitCircle(
                                      color: primary,
                                      size: iconSize,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Center(
                                      child: Icon(
                                        Icons.bug_report_rounded,
                                        size: iconSize,
                                        color: primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  state.userDataModels[index].name,
                                  textAlign: TextAlign.start,
                                  style: largeText.copyWith(color: onSurface),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }

          return Center(
            child: SpinKitCircle(
              color: primary,
              size: iconSize * 2,
            ),
          );
        },
      ),
    );
  }
}
