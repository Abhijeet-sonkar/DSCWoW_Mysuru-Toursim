// import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

import '../models/hotel.dart';

class Hotels with ChangeNotifier {
  List<Hotel> _hotels = [
    Hotel(
      id: DateTime.now().toIso8601String(),
      imgUrl:
          'https://i.pinimg.com/originals/56/e9/9f/56e99f9882a649e88f8ea54d2a8bd1ab.jpg',
      rating: '5.0',
      hotelName: 'The Grand Hotel',
      hotelAddress: 'B-27, First Street, Mysuru',
      hotelContactNumber: '+91 61278 12712',
    ),
    Hotel(
      id: DateTime.now().toIso8601String(),
      imgUrl:
          'https://i.pinimg.com/originals/56/e9/9f/56e99f9882a649e88f8ea54d2a8bd1ab.jpg',
      rating: '4.0',
      hotelName: 'The Empire Hotel',
      hotelAddress: 'B-27, First Street, Mysuru',
      hotelContactNumber: '+91 61278 12712',
    ),
  ];

  List<Hotel> get hotels {
    return [..._hotels];
  }

  Hotel findById(String id) {
    return _hotels.firstWhere((el) => el.id == id);
  }
}
