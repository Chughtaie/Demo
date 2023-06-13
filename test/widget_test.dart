// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:demo_app/component/movie_card.dart';
import 'dart:convert';
import 'package:demo_app/services/get_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  // API Tests
  test('JSON data on successful API call', () async {
    final result = await GetAPI.getApiWithoutToken('movie/upcoming');
    Map<String, dynamic> _responseType = Map<String, dynamic>();
    // expected JSON data
    expect(result.runtimeType, _responseType.runtimeType);
  });

  test('Failure on API call', () async {
    // expected a failure
    var result = await GetAPI.getApiWithoutToken('/no such api');
    expect(result['success'], false);
  });

// Run when Internet is off
  test('Exception on API call ', () async {
    // expected an exception on socket failure/Internet

    expect(await GetAPI.getApiWithoutToken('Turn Internet Off'), Exception);
  });

// Widget Test
  testWidgets('MovieCard test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MovieCard(
            imageUrl: 'https://via.placeholder.com/300x200',
            title: 'Sample Title',
          ),
        ),
      ),
    );

    expect(find.byType(Container), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
    expect(find.byType(Text), findsOneWidget);
    expect(find.byType(Stack), findsOneWidget);
  });
}
