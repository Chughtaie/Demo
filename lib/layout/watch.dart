import 'dart:convert';

import 'package:demo_app/component/bottom_nav_bar.dart';
import 'package:demo_app/component/custom_search.dart';
import 'package:demo_app/component/movie_card.dart';
import 'package:demo_app/constants.dart';
import 'package:demo_app/layout/watch_detail.dart';
import 'package:demo_app/model/upcoming_movie_model.dart';
import 'package:demo_app/provider/movie_data_provider.dart';
import 'package:demo_app/services/get_api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class Watch extends StatefulWidget {
  static const id = 'Watch';
  const Watch({super.key});

  @override
  State<Watch> createState() => _WatchState();
}

class _WatchState extends State<Watch> {
  // initUpcomingMovies() async {
  bool searchIcon = true;

  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  List<String> vals = [
    'https://picsum.photos/250?image=9',
    'https://picsum.photos/250?image=9',
    'https://picsum.photos/250?image=9'
  ];

  Future<Map<String, dynamic>> fetchMovieData() async {
    final response = await GetAPI.getApi('movie/upcoming');
    if (response.statusCode == 200) {
      var decodedBody = json.decode(response.body);
      Provider.of<MovieDataProvider>(context, listen: false)
          .setUpcomingMovies(UpcomingMovieModel.fromJson(decodedBody));
      return decodedBody;
    } else {
      throw Exception('Failed to fetch movie data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(96),
          child: Container(
            margin: const EdgeInsets.only(top: 20), // Add margin on top
            child: AppBar(
              elevation: 0,

              // toolbarHeight: 100,
              title: const Text(
                'Watch',
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: Colors.white,
              actions: [
                searchIcon
                    ? GestureDetector(
                        onTap: () {
                          setState(() {
                            searchIcon = false;
                          });
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(right: 12.0),
                          child: Icon(
                            Icons.search,
                            size: 20,
                            color: Colors.black,
                          ),
                        ),
                      )
                    : CustomSearch(
                        controller: controller,
                        onChanged: (value) {
                          setState(() {
                            controller.notifyListeners();
                          });
                        },
                        onCancel: () {
                          setState(() {
                            searchIcon = true;
                          });
                        })
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                  color: const Color(0xffF6F6FA),
                  child: FutureBuilder(
                    future: fetchMovieData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: ListView.builder(
                            itemBuilder: (context, index) =>
                                const MovieCardShimmer(),
                            itemCount: 4,
                          ),
                        );
                      } else if (snapshot.hasData) {
                        return Consumer<MovieDataProvider>(
                          builder: (context, value, child) =>

                              // ? ListView.builder(
                              //     itemBuilder: (context, index) =>
                              //         MovieTapCard(context, index, value),
                              //     itemCount:
                              //         value.upcomingMovies.results!.length,
                              //   )
                              SingleChildScrollView(
                            child: Column(
                                children: value.upcomingMovies.results!
                                    .map((e) => controller.text == ''
                                        ? MovieTapCard(context, e)
                                        : filterMovies(e, context))
                                    .toList()),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return const Text('No data');
                      }
                    },
                  )),
            ),
          ],
        ),
        bottomNavigationBar: const BottomNavBar());
  }

  Widget filterMovies(Results e, BuildContext context) {
    return (e.title!.toLowerCase().contains(controller.text)
        ? MovieTapCard(context, e)
        : SizedBox.shrink());
  }

  GestureDetector MovieTapCard(BuildContext context, Results e) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WatchDetail(
                  // selectedIndex: index,
                  movie: e),
            ));
      },
      child: MovieCard(
        title: e.originalTitle!,
        imageUrl: '$backDropUrl${e.backdropPath!}',
      ),
    );
  }
}
