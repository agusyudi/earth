import 'dart:convert';
import 'package:latlong2/latlong.dart';

class WilayahModel {
  final int id;
  final String provinsi;
  final String kabKota;
  final String offTaker;
  final double debit;
  final String color;
  final List<List<LatLng>> geometry;

  WilayahModel({
    required this.id,
    required this.provinsi,
    required this.kabKota,
    required this.offTaker,
    required this.debit,
    required this.color,
    required this.geometry,
  });

  factory WilayahModel.fromJson(Map<String, dynamic> json) {
    List<List<LatLng>> geomList = [];

    if (json['Geometry'] != null) {
      final geoJson = jsonDecode(json['Geometry']);
      if (geoJson['type'] == 'MultiPolygon') {
        // geoJson['coordinates'] = List of polygons
        for (var polygon in geoJson['coordinates']) {
          // polygon = List of rings (outer + inner)
          for (var ring in polygon) {
            // ring = List of coordinates
            List<LatLng> ringPoints = [];
            for (var coord in ring) {
              ringPoints.add(LatLng(coord[1].toDouble(), coord[0].toDouble()));
            }
            geomList.add(ringPoints);
          }
        }
      }
    }

    return WilayahModel(
      id: json['IdWilayah'],
      provinsi: json['Provinsi'] ?? '',
      kabKota: json['KabKota'] ?? '',
      offTaker: json['OffTaker'] ?? '',
      debit: (json['Debit'] is int)
          ? (json['Debit'] as int).toDouble()
          : (json['Debit'] as num?)?.toDouble() ?? 0.0,
      color: json['Color'] ?? '#338D5D',
      geometry: geomList,
    );
  }
}
