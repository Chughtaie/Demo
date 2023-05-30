import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String backDropUrl = 'https://image.tmdb.org/t/p/w500';
String api = 'https://api.themoviedb.org/3/';
String apiKey = 'fdec09d3d837b9ebb29484b267652a23';
String youtubeApiKey = 'AIzaSyClgaVhrTnWI9gaYVTy60pjHERjsBP-gGY';

TextStyle textStyle = const TextStyle(
    color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500);

setUrl(String uri) {
  String url = api + uri;
  return ('$url?api_key=$apiKey');
}

String formatDate(String dateStr) {
  DateTime date = DateTime.parse(dateStr);
  String formattedDate = DateFormat('MMMM y, d').format(date);

  return formattedDate;
}
