import 'package:flutter_dotenv/flutter_dotenv.dart';

// final String baseurl =
//     dotenv.env['BASE_API_URL'] ?? 'https://localhost:7291/api/';

final String baseurl =
    dotenv.env['BASE_API_URL'] ?? 'https://localhost:7291/api/';

final String env = dotenv.env['ENV'] ?? 'STAGING';
final String apiKey = "Testing123!";

final baseLat = -8.652869052157518;
final baseLng = 115.25443483090473;
