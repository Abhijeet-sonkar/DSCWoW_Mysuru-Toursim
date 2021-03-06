import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../models/volunteer.dart';
import '../models/review.dart';

class Volunteers with ChangeNotifier {
  List<Volunteer> _volunteers = [];
  final String userId;
  final String userModelId;
  final String name;
  final bool hasCreatedProfile;
  String volId = '';
  String title = '';
  String description = '';
  String phone = '';
  bool isCab = false;
  // final String authToken;

  Volunteers(
    this.userId,
    this.userModelId,
    this.name,
    this.hasCreatedProfile,
    this._volunteers,
  );

  List<Volunteer> get volunteers {
    return [..._volunteers];
  }

  List<Volunteer> get cabVolunteers {
    return _volunteers.where((el) => el.isCab).toList();
  }

  List<Volunteer> get tourVolunteers {
    return _volunteers.where((el) => !el.isCab).toList();
  }

  Map<String, Object> get volDetails {
    return {
      'title': title,
      'description': description,
      'phone': phone,
    };
  }

  Volunteer findById(String id) {
    return _volunteers.firstWhere((el) => el.id == id);
  }

  Volunteer getCurrentVolunteer() {
    return _volunteers.firstWhere((el) => el.userId == userId);
  }

  Future<void> addVolunteer({
    String title,
    String description,
    String phone,
    bool isCab,
  }) async {
    final url =
        'https://mysuru-tourism-7d522-default-rtdb.firebaseio.com/volunteers.json';
    final userUrl =
        'https://mysuru-tourism-7d522-default-rtdb.firebaseio.com/users/$userModelId.json';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'userId': userId,
          'name': name,
          'title': title,
          'description': description,
          'phone': phone,
          'isCab': isCab,
          'reviews': [],
        }),
      );

      await http.patch(
        userUrl,
        body: json.encode({
          'hasCreatedProfile': true,
        }),
      );

      final newVolunteer = Volunteer(
        id: json.decode(response.body)['name'],
        userId: userId,
        name: name,
        title: title,
        description: description,
        phone: phone,
        isCab: isCab,
      );
      _volunteers.add(newVolunteer);
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> updateVolunteer({
    String title,
    String description,
    String phone,
  }) async {
    final volUrl =
        'https://mysuru-tourism-7d522-default-rtdb.firebaseio.com/volunteers/$volId.json';
    try {
      await http.patch(
        volUrl,
        body: json.encode({
          'title': title,
          'description': description,
          'phone': phone,
        }),
      );

      fetchAndSetVolunteers();
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> fetchAndSetVolunteers() async {
    final url =
        'https://mysuru-tourism-7d522-default-rtdb.firebaseio.com/volunteers.json';

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      if (extractedData == null) return;

      final List<Volunteer> loadedVolunteers = [];
      List<Review> reviews = [];
      Review review;
      extractedData.forEach((volId, data) {
        if (data['reviews'] != null && data['reviews'].length > 0) {
          reviews = [];
          data['reviews'].forEach(
            (key, val) {
              review = Review(
                id: key,
                creatorId: val['creatorId'],
                author: val['author'],
                message: val['message'],
                rating: val['rating'],
              );
              reviews.add(review);
            },
          );
        }
        loadedVolunteers.add(
          Volunteer(
            id: volId,
            description: data['description'],
            isCab: data['isCab'],
            name: data['name'],
            title: data['title'],
            phone: data['phone'],
            userId: data['userId'],
            reviews: reviews,
          ),
        );
      });
      _volunteers = loadedVolunteers;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> setDetails() async {
    final curVol = getCurrentVolunteer();
    final volUrl =
        'https://mysuru-tourism-7d522-default-rtdb.firebaseio.com/volunteers/${curVol.id}.json';
    final response = await http.get(volUrl);
    if (response != null) {
      final data = json.decode(response.body);
      volId = curVol.id;
      title = data['title'];
      description = data['description'];
      phone = data['phone'];
      isCab = data['isCab'];
    }
  }

  void addReview({
    String id,
    String desc,
    double rating,
    String author,
  }) async {
    final url =
        'https://mysuru-tourism-7d522-default-rtdb.firebaseio.com/volunteers/$id/reviews.json';
    try {
      // Make an Entry on the Firebase
      final response = await http.post(
        url,
        body: json.encode({
          'author': author,
          'message': desc,
          'rating': rating,
          'creatorId': userId,
        }),
      );

      // Create a local object for the new review
      final newReview = Review(
        author: author,
        message: desc,
        rating: rating,
        creatorId: userId,
        id: json.decode(response.body)['name'],
      );

      final volunteer = _volunteers.firstWhere((el) => el.id == id);
      volunteer.reviews.add(newReview);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
