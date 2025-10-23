import 'package:url_launcher/url_launcher.dart';

Future<void> openGoogleMapsNavigation(double lat, double lng) async {
  final url =
      'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving';
  final uri = Uri.parse(url);

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    throw 'Tidak bisa membuka Google Maps';
  }
}
