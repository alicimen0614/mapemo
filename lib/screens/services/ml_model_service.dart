import 'package:http/http.dart' as http;
import 'dart:convert';

class MlModelService {
  Future getImageAndClassNameFromServer(String imageFile) async {
    print("attempting to connect to server......");
    var headers = {
      'Content-Type': 'application/json',
      'authorization': 'Basic c3R1ZHlkb3RlOnN0dWR5ZG90ZTEyMw=='
    };

    final response = await http.post(Uri.parse('http://10.242.43.18:5000/test'),
        headers: headers, body: json.encode({"image": imageFile}));

    if (response.statusCode == 200) {
      print("image sent successfully");
      return response.body;
    } else {
      print("Failed to send image");
    }
  }
}
