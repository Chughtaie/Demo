import 'package:demo_app/model/upcoming_movie_model.dart';
import 'package:demo_app/services/get_api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class MovieDataProvider extends ChangeNotifier {
  late UpcomingMovieModel upcomingMovies;
  int selectedIndex = 0;

  setUpcomingMovies(UpcomingMovieModel source) {
    upcomingMovies = source;
    notifyListeners();
  }
}
