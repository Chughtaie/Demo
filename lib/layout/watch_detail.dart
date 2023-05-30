import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_app/component/custom_button.dart';
import 'package:demo_app/component/movie_card.dart';
import 'package:demo_app/constants.dart';
import 'package:demo_app/model/genre_model.dart';
import 'package:demo_app/provider/movie_data_provider.dart';
import 'package:demo_app/services/get_api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter_randomcolor/flutter_randomcolor.dart';

class WatchDetail extends StatefulWidget {
  WatchDetail({super.key, selectedIndex, movieId}) {
    index = selectedIndex;
    idMovie = movieId;
  }
  static const id = 'WatchDetail';
  int index = 0;
  int idMovie = 0;

  @override
  State<WatchDetail> createState() => _WatchDetailState();
}

class _WatchDetailState extends State<WatchDetail> {
  TextStyle localStyle = textStyle.copyWith(color: Color(0xff202C43));

  late YoutubePlayerController controller;
  int index = 0;
  late GenreModel genre;
  List<String> genres = [];

  String key = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    index = widget.index;

    fetchVideo();
    fetchGenre();
  }

  void playTrailer() {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.landscapeLeft,
    //   DeviceOrientation.landscapeRight,
    // ]);
// https://www.youtube.com/watch
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          body: Center(
            child: YoutubePlayer(
              controller: controller,
              showVideoProgressIndicator: true,
              onEnded: (value) {
                Navigator.pop(context);
                // SystemChrome.setPreferredOrientations([
                //   DeviceOrientation.portraitDown,
                //   DeviceOrientation.portraitUp,
                // ]);
              },
            ),
          ),
        ),
      ),
    );
  }

  fetchVideo() async {
    final response =
        await GetAPI.getApiWithoutToken('movie/${widget.idMovie}/videos');
    // print(response);

    for (Map i in response['results']) {
      if (i['type'] == 'Trailer' &&
          i['official'] == true &&
          i['site'] == 'YouTube') {
        key = i['key'];
        controller = YoutubePlayerController(
          initialVideoId: key,
        );
        print(key);
        break;
      }
    }
  }

  fetchGenre() async {
    final response = await GetAPI.getApi('genre/movie/list');

    print((response.body));
    genre = GenreModel.fromJson(json.decode(response.body));
    setState(() {
      for (Genres i in genre.genres!) {
        if (Provider.of<MovieDataProvider>(context, listen: false)
            .upcomingMovies
            .results![widget.index]
            .genreIds!
            .contains(i.id)) genres.add(i.name!);
      }
    });

    // randomColor();
  }

  String generateRandomColorCode() {
    Random random = Random();
    int colorValue = random.nextInt(0xFFFFFF + 1);

    String colorCode = colorValue.toRadixString(16).padLeft(6, '0');

    return '#$colorCode';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MovieDataProvider>(
        builder: (context, value, child) =>
            MediaQuery.of(context).orientation != Orientation.landscape
                ? Column(
                    children: [Poster(context, value), Details(value)],
                  )
                : Row(
                    children: [Poster(context, value), Details(value)],
                  ),
      ),
    );
  }

  Widget Details(MovieDataProvider value) {
    return Expanded(
      child: Container(
        alignment: Alignment.topLeft,
        margin: EdgeInsets.all(30),
        width: MediaQuery.of(context).size.width,

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
                children: genres
                    .map((e) => Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(int.parse(
                                      generateRandomColorCode().substring(1, 7),
                                      radix: 16) +
                                  0xFF000000)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            e,
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
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Divider(),
            ),
            Text(
              'Overview',
              style: localStyle,
            ),
            Text(
              value.upcomingMovies.results![widget.index].overview!,
              style: const TextStyle(color: Colors.blueGrey),
            )
          ],
        ),
      ),
    );
  }

  Widget Poster(BuildContext context, MovieDataProvider value) {
    return Flexible(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CachedNetworkImage(
            width: MediaQuery.of(context).size.width,
            imageUrl: backDropUrl +
                value.upcomingMovies.results![widget.index].posterPath!,
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
                    'In Theaters  ${formatDate(value.upcomingMovies.results![widget.index].releaseDate!)}',
                    style: textStyle.copyWith(fontWeight: FontWeight.w500),
                  ),
                  CustomButton(
                    widget: Text(
                      'Get Tickets',
                      textAlign: TextAlign.center,
                      style: textStyle.copyWith(fontWeight: FontWeight.w400),
                    ),
                  ),
                  CustomButton(
                    onTap: () {
                      playTrailer();
                    },
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
                          style:
                              textStyle.copyWith(fontWeight: FontWeight.w400),
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
    );
  }
}
