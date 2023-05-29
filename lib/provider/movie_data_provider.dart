import 'package:demo_app/model/upcoming_movie_model.dart';
import 'package:flutter/material.dart';

class MovieDataProvider extends ChangeNotifier {
  late UpcomingMovieModel upcomingMovies;
  int selectedIndex = 0;

  setUpcomingMovies(UpcomingMovieModel source) {
    upcomingMovies = source;
    notifyListeners();
  }
}
