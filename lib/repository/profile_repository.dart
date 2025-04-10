import 'dart:convert';
import 'package:erp_app/models/login_response.dart';
import 'package:erp_app/models/profile_model.dart';
import 'package:http/http.dart' as http;

Map<String, String> buildHeaders(LoginResponse response) {
  return {
    'Cookie':
        '_ga_P21KD3ESV2=GS1.1.1717220027.3.0.1717220027.0.0.0; _ga=GA1.2.257840654.1716482344; _gid=GA1.2.287587932.1716482344',
    'Authorization': 'Bearer ${response.accessToken}',
    'X-Wb': '1',
    'Sessionid': response.sessionId,
    'X-Contextid': '194',
    'X-Userid': response.xUserId,
    'X_token': response.xToken,
    'X-Rx': '1',
  };
}

class ProfileRepository {
  Future<UserProfile> fetchUserProfile(LoginResponse loginResponse) async {
    final headers = buildHeaders(loginResponse);

    final userId = loginResponse.xUserId;
    final url =
        'https://akgecerp.edumarshal.com/api/User/GetByUserId/$userId?y=0';

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return UserProfile.fromJson(jsonData);
    } else {
      throw Exception('Failed to fetch profile: ${response.statusCode}');
    }
  }
}
