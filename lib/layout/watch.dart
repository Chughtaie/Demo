import 'dart:convert';

import 'package:demo_app/component/bottom_nav_bar.dart';
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
  Watch({super.key});

  @override
  State<Watch> createState() => _WatchState();
}

class _WatchState extends State<Watch> {
  // initUpcomingMovies() async {
  bool searchIcon = true;

  List<String> vals = [
    'https://picsum.photos/250?image=9',
    'https://picsum.photos/250?image=9',
    'https://picsum.photos/250?image=9'
  ];

  @override
  Widget build(BuildContext context) {
    Future<Map<String, dynamic>> fetchMovieData() async {
      final response = await GetAPI.getApi('/upcoming');
      if (response.statusCode == 200) {
        var decodedBody = json.decode(response.body);
        Provider.of<MovieDataProvider>(context, listen: false)
            .setUpcomingMovies(UpcomingMovieModel.fromJson(decodedBody));
        return decodedBody;
      } else {
        throw Exception('Failed to fetch movie data');
      }
    }

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(96),
          child: Container(
            margin: EdgeInsets.only(top: 20), // Add margin on top
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
                            print('search');
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
                    : Expanded(
                        child: Container(
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: () {
                                  setState(() {
                                    searchIcon = true;
                                  });
                                },
                              ),
                              border: InputBorder.none,
                              hintText: 'Search...',
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                  color: Color(0xffF6F6FA),
                  child: FutureBuilder(
                    future: fetchMovieData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: ListView.builder(
                            itemBuilder: (context, index) => MovieCardShimmer(),
                            itemCount: 4,
                          ),
                        );
                      } else if (snapshot.hasData) {
                        return ListView.builder(
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WatchDetail(
                                      selectedIndex: index,
                                    ),
                                  ));
                            },
                            child: MovieCard(
                              title: Provider.of<MovieDataProvider>(context)
                                  .upcomingMovies
                                  .results![index]
                                  .originalTitle!,
                              imageUrl:
                                  '$backDropUrl${Provider.of<MovieDataProvider>(context).upcomingMovies.results![index].backdropPath!}',
                            ),
                          ),
                          itemCount: Provider.of<MovieDataProvider>(context)
                              .upcomingMovies
                              .results!
                              .length,
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return Text('No data');
                      }
                    },
                  )),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavBar());
  }
}
