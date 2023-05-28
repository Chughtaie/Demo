setUrl(String uri) {
  String url = api + uri;
  return ('$url?api_key=$apiKey');
}

String backDropUrl = 'https://image.tmdb.org/t/p/w500';
String api = 'https://api.themoviedb.org/3/movie';
String apiKey = 'fdec09d3d837b9ebb29484b267652a23';
