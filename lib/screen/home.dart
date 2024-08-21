import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:test/data/api.dart';
import 'package:test/screen/coupons.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  HomePage({required this.stream, required this.stream1});
  final Stream<int> stream;
  final Stream<List> stream1;
  @override
  State<HomePage> createState() => _HomePageState();
}

StreamController<int> streamController = StreamController<int>();
StreamController<List> streamController1 = StreamController<List>();

class _HomePageState extends State<HomePage> {
  void redeemCoins(int coin) {
    setState(() {
      coins -= coin;
    });
  }

  void homeCards(List homeimage1) {
    setState(() {
      homeimage = homeimage1;
    });
  }

  var points;
  getPoints() async {
    points = await fetchUser();
  }

  @override
  void initState() {
    super.initState();
    getPoints();
    widget.stream.listen((cost) {
      redeemCoins(cost);
    });
    widget.stream1.listen((homeimage1) {
      homeCards(homeimage1);
    });
  }

  @override
  Widget build(BuildContext context) {
    print(points);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 13, 98, 168),
        leading: Icon(Icons.menu),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage('https://via.placeholder.com/150'),
            ),
          )
        ],
      ),
      body: Container(
        color: const Color.fromARGB(255, 13, 98, 168),
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              'Rewards',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '$points',
              style: TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CouponPage(),
                    ));
              },
              child: Text('Redeem Now'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue, // Adjust text color
              ),
            ),
            SizedBox(height: 130),
            Flexible(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Redeemed Coupons',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              backgroundColor: Color(0xFFF1F4FF),
                              foregroundColor: Colors.blue,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text('View all'),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 190,
                        child: Flexible(
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              for (int i = 0; i < homeimage.length; i++)
                                RedeemedCard(
                                  image: homeimage[i],
                                )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class RedeemedCard extends StatelessWidget {
  var image;
  RedeemedCard({required this.image});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: const Color.fromARGB(255, 168, 255, 171),
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        width: 120,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 10,
              ),
              CachedNetworkImage(
                imageUrl: image,
                errorWidget: (context, url, error) =>
                    Image.network('https://placehold.co/600x400'),
              ),
              SizedBox(height: 8),
              Text(
                'Grab your ticket for next purchase',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Align(
                  alignment: Alignment.bottomLeft,
                  child: CachedNetworkImage(
                    imageUrl: image,
                    errorWidget: (context, url, error) =>
                        Image.network('https://placehold.co/600x400'),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
