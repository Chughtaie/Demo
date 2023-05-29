import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_app/component/custom_button.dart';
import 'package:demo_app/component/movie_card.dart';
import 'package:demo_app/constants.dart';
import 'package:demo_app/provider/movie_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WatchDetail extends StatelessWidget {
  WatchDetail({super.key, selectedIndex}) {
    index = selectedIndex;
  }
  static const id = 'WatchDetail';

  int index = 0;
  TextStyle localStyle = textStyle.copyWith(color: Color(0xff202C43));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MovieDataProvider>(
        builder: (context, value, child) => Column(
          children: [
            Flexible(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  CachedNetworkImage(
                    width: MediaQuery.of(context).size.width,
                    imageUrl: backDropUrl +
                        value.upcomingMovies.results![index].posterPath!,
                    fit: BoxFit.fill,
                    placeholder: (context, url) => const MovieCardShimmer(
                        height: 500), // Placeholder widget while loading
                    errorWidget: (context, url, error) =>
                        const SizedBox.shrink(), // Placeholder widget on error
                    imageBuilder: (context, imageProvider) =>
                        Image(image: imageProvider, fit: BoxFit.fill),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            'In Theaters  ${formatDate(value.upcomingMovies.results![index].releaseDate!)}',
                            style:
                                textStyle.copyWith(fontWeight: FontWeight.w500),
                          ),
                          CustomButton(
                            widget: Text(
                              'Get Tickets',
                              textAlign: TextAlign.center,
                              style: textStyle.copyWith(
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          CustomButton(
                            backgroundColor: Colors.transparent,
                            widget: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                ),
                                Text(
                                  ' Watch Trailer',
                                  style: textStyle.copyWith(
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.all(30),
              // color: Colors.blueAccent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Genres',
                    style: localStyle,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      children: value.upcomingMovies.results![index].genreIds!
                          .map((e) => Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.amber,
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Text(
                                  "${e}fks",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Divider(),
                  ),
                  Text(
                    'Overview',
                    style: localStyle,
                  ),
                  Text(
                    value.upcomingMovies.results![index].overview!,
                    style: TextStyle(color: Colors.blueGrey),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
