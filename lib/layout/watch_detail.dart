import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_app/constants.dart';
import 'package:demo_app/provider/movie_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WatchDetail extends StatelessWidget {
  WatchDetail({selectedIndex}) {
    selectedIndexs = selectedIndex;
  }
  static const id = 'WatchDetail';

  int selectedIndexs = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Consumer<MovieDataProvider>(
          builder: (context, value, child) => Column(
            children: [
              CachedNetworkImage(
                imageUrl: backDropUrl +
                    value.upcomingMovies.results![selectedIndexs].posterPath!,
                fit: BoxFit.fill,
                placeholder: (context, url) =>
                    SizedBox.shrink(), // Placeholder widget while loading
                errorWidget: (context, url, error) =>
                    SizedBox.shrink(), // Placeholder widget on error
                imageBuilder: (context, imageProvider) =>
                    Image(image: imageProvider, fit: BoxFit.fill),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
