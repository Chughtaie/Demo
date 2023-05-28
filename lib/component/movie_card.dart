import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:path_provider/path_provider.dart';

class MovieCardShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 200.0,
              color: Colors.white,
            ),
            SizedBox(height: 8.0),
            Container(
              width: 100.0,
              height: 12.0,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  final String imageUrl;
  final String title;

  MovieCard({required this.imageUrl, this.title = 'Title'});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 20, left: 15, right: 15),
        // height: MediaQuery.of(context).size.height * 1.3 / 5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.fill,
              placeholder: (context, url) =>
                  SizedBox.shrink(), // Placeholder widget while loading
              errorWidget: (context, url, error) =>
                  SizedBox.shrink(), // Placeholder widget on error
              imageBuilder: (context, imageProvider) => ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image(image: imageProvider, fit: BoxFit.fill),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, bottom: 10),
              child: Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            )
          ],
        ));
  }
}
