import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';

import '../data/api.dart';

class CouponPage extends StatefulWidget {
  const CouponPage({super.key});
  @override
  State<CouponPage> createState() => _CouponPageState();
}

class _CouponPageState extends State<CouponPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Redeem Coupons'),
      ),
      body: Column(
        children: [
          FilterBar(),
          Expanded(
            child: MainCardList(),
          ),
        ],
      ),
    );
  }
}

class MainCardList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: brandData.keys.map((brand) {
          return MainCard(
            brand: brand,
            cards: brandData[brand]!,
          );
        }).toList(),
      ),
    );
  }
}

class FilterBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i in category) FilterButton(label: i.toString()),
        ],
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  final String label;

  FilterButton({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Chip(
        label: Text(label),
      ),
    );
  }
}

class MainCard extends StatelessWidget {
  final String brand;
  final List<Map<String, String>> cards;

  MainCard({required this.brand, required this.cards});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromRGBO(253, 250, 214, 1),
      elevation: 5,
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(cards[0]['brandlogo']!),
                  radius: 24,
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      brand,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(cards[0]['title']!, style: TextStyle(fontSize: 16)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: cards.length,
                itemBuilder: (context, index) {
                  return InnerCard(
                    image: cards[index]['image']!,
                    id: cards[index]['id']!,
                    brandlogo: cards[index]['brandlogo']!,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class InnerCard extends StatelessWidget {
  var image;
  var id;
  var brandlogo;
  InnerCard({required this.image, required this.id, required this.brandlogo});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (BuildContext context) =>
            CustomPopupDialog(image: image, id: id),
      ),
      child: Card(
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
                Spacer(),
                Image.network(
                  image,
                  height: 70,
                  width: 60,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 8),
                Text(
                  'Grab your ticket for next purchase',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Image.network(
                    brandlogo,
                    height: 14,
                    width: 54,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomPopupDialog extends StatelessWidget {
  var image;
  var id;
  final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: const TextStyle(fontSize: 22, color: Colors.black),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Color.fromARGB(255, 211, 203, 203),
          border: Border.all(color: Colors.transparent)));
  CustomPopupDialog({required this.image, required this.id});

  Future<void> _redeem(BuildContext context) async {
    await redeemCard(id);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(status),
      behavior: SnackBarBehavior.floating,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListView(children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.9,
          width: MediaQuery.of(context).size.width * 0.95,
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.2,
                color: Colors
                    .grey[200], // Replace with your image or background color
                child: Center(
                  child: Image.network(
                    image, // Replace with your image asset
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text("Enter Vendor Code:", style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50,
                    width: 214,
                    child: Pinput(
                        length: 4,
                        defaultPinTheme: defaultPinTheme,
                        focusedPinTheme: defaultPinTheme.copyWith(
                          decoration: defaultPinTheme.decoration!.copyWith(
                            border: Border.all(color: Colors.green),
                          ),
                        ),
                        onCompleted: (pin) {
                          debugPrint(pin);
                          otp = pin;
                        }),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                "Grab your ticket for next purchase",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                "Effortlessly expand your payment options",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Expiry"),
                        SizedBox(height: 8),
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text("22 March 2024"),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Worth of Voucher"),
                        SizedBox(height: 8),
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Text(
                                "342 AED",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Total coins cost"),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "140 Coins",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _redeem(context),
                child: Center(child: Text("Redeem Now")),
                style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(50),
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromARGB(
                        255, 20, 81, 131) // Set your button color here
                    ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
