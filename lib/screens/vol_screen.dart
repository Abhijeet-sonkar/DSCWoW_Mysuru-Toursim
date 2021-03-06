import 'package:flutter/material.dart';
import 'package:mysuru_toursim/widgets/divider_custom.dart';
import 'package:mysuru_toursim/widgets/new_review.dart';
import 'package:mysuru_toursim/widgets/review_card.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:url_launcher/url_launcher.dart';

import '../providers/volunteers.dart';
// import '../widgets/new_review.dart';

class VolunteerScreen extends StatelessWidget {
  static const routeName = '/volunteer';
  Volunteers _volunteerProvider;
  var _volId = '';

  void _addReview(String desc, double rating, String author) {
    _volunteerProvider.addReview(
      id: _volId,
      author: author,
      desc: desc,
      rating: rating,
    );
  }

  void _startAddNewRev(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return NewReview(_addReview);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _volId = ModalRoute.of(context).settings.arguments as String;
    final vol = Provider.of<Volunteers>(context).findById(_volId);
    _volunteerProvider = Provider.of<Volunteers>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(vol.title),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            CircleAvatar(
              radius: 100,
              child: Image.asset("assets/images/0.png"),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              child: Text(
                vol.title,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w300,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            DividerCustom(),
            SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Text(
                    vol.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Card(
                    color: Colors.amber,
                    child: InkWell(
                      onTap: () async {
                        await launch('tel:${vol.phone}');
                      },
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Icon(Icons.phone),
                            Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Text(
                                vol.phone,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              child: Text(vol.description),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                // physics: NeverScrollableScrollPhysics(),
                itemCount: vol.reviews.length,
                itemBuilder: (context, i) {
                  return ReviewCard(
                    message: vol.reviews[i].message,
                    author: vol.reviews[i].author,
                    rating: vol.reviews[i].rating,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.rate_review),
        onPressed: () => _startAddNewRev(context),
      ),
    );
  }
}
