import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:test/home.dart';

late Map mapResponse;
late List data;
List category = ["All"];
Map<String, List<Map<String, String>>> brandData = {};
String otp = "";
int cost = 0;
String status = "";
int coins = 5213;
List homecardid = [];
List homeimage = [];

fetchTitle() async {
  const String apiUrl = "https://loyalty-card.onrender.com/api/category";
  const String bearerToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY2MzBhNjlhNTg3ZWVjNDg3MWI3Mzk4NyIsImlhdCI6MTcxNDQ4MDI4NH0.9iVivjFzBB1CV_eGOD34apiS6zuLGHlVWaFjl50V5Nc";
  http.Response response = await http.get(
    Uri.parse(apiUrl),
    headers: {
      'Authorization': 'Bearer $bearerToken',
    },
  );
  if (response.statusCode == 200) {
    mapResponse = json.decode(response.body);
    data = mapResponse['result'];
    category.addAll(data.map((item) => item['title'].toString()).toList());
    print(category);
  } else {
    print('Failed to load data: ${response.statusCode}');
  }
}

fetchData() async {
  const String apiUrl = "https://loyalty-card.onrender.com/api/loyalitycard";
  const String bearerToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY2MzBhNjlhNTg3ZWVjNDg3MWI3Mzk4NyIsImlhdCI6MTcxNDQ4MDI4NH0.9iVivjFzBB1CV_eGOD34apiS6zuLGHlVWaFjl50V5Nc";
  http.Response response = await http.get(
    Uri.parse(apiUrl),
    headers: {
      'Authorization': 'Bearer $bearerToken',
    },
  );
  if (response.statusCode == 200) {
    mapResponse = json.decode(response.body);
    data = mapResponse['result'];

    for (var item in data) {
      String brand = item['brand'].toString();
      if (!brandData.containsKey(brand)) {
        brandData[brand] = [];
      }
      brandData[brand]?.add({
        'title': item['title'].toString(),
        'brandlogo': item['brand_logo'].toString(),
        'image': item['image'].toString(),
        'id': item['_id'].toString(),
        
      });
    }
  } else {
    print('Failed to load data: ${response.statusCode}');
  }
}

redeemCard(id) async {
  final String url = 'https://loyalty-card.onrender.com/api/redeemcard/otpCheck';
  const String bearerToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY2MzBhNjlhNTg3ZWVjNDg3MWI3Mzk4NyIsImlhdCI6MTcxNDQ4MDI4NH0.9iVivjFzBB1CV_eGOD34apiS6zuLGHlVWaFjl50V5Nc";
  final Map<String, dynamic> payload = {
    "loyalityId": "$id",
    "otp": otp,
    "clientId": "Test123",
    "note": {}
  };

  final http.Response response = await http.post(
    Uri.parse(url),
    headers: {
      'Authorization': 'Bearer $bearerToken',
      'Content-Type': 'application/json',
    },
    body: json.encode(payload),
  );
  final Map<String, dynamic> responseData = json.decode(response.body);
  status = responseData['message'];

  if (response.statusCode == 200) {
    if (responseData['status']) {
      cost = responseData['data']['coin_worth'];
      streamController.add(cost);
      homecardid.add(id);
      await fetchCardData(id);
      print('Coins reduced successfully');
    } else {
      print('Failed to redeem card');
    }
  } else {
    print(responseData['message']);
  }
}

fetchCardData(String id1) async {
  String apiUrl = "https://loyalty-card.onrender.com/api/loyalitycard/$id1";
  const String bearerToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY2MzBhNjlhNTg3ZWVjNDg3MWI3Mzk4NyIsImlhdCI6MTcxNDQ4MDI4NH0.9iVivjFzBB1CV_eGOD34apiS6zuLGHlVWaFjl50V5Nc";
  http.Response response = await http.get(
    Uri.parse(apiUrl),
    headers: {
      'Authorization': 'Bearer $bearerToken',
    },
  );
  if (response.statusCode == 200) {
    Map<String, dynamic> mapResponse1 = json.decode(response.body);
    homeimage.add(mapResponse1['data']['image'].toString());
    streamController1.add(homeimage);
    print(homeimage);
    print("hello");
  } else {
    print('Failed to load data: ${response.statusCode}');
  }
}
