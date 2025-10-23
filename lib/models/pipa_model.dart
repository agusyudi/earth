import 'dart:convert';

import 'package:latlong2/latlong.dart';

class PipaModel {
  final int id;
  final String? kode;
  final int? idUkuranPipa;
  final String? ukuranPipa;
  final int? idJenisPipa;
  final String? jenisPipa;
  final int? thnBuat;
  final DateTime? tanggalPemasangan;
  final DateTime? tanggalPerawatan;
  final double? elevasi;
  final int? idStatusPipa;
  final String? statusPipa;
  final int? idKondisiPipa;
  final String? kondisiPipa;
  final double? panjang;
  final String? keterangan;
  final String? color;
  final double? ketebalan;
  final List<List<LatLng>> geometry;

  bool? isloading;

  PipaModel({
    required this.id,
    this.kode,
    this.idUkuranPipa,
    this.ukuranPipa,
    this.idJenisPipa,
    this.jenisPipa,
    this.thnBuat,
    this.tanggalPemasangan,
    this.tanggalPerawatan,
    this.elevasi,
    this.idStatusPipa,
    this.statusPipa,
    this.idKondisiPipa,
    this.kondisiPipa,
    this.panjang,
    this.keterangan,
    this.color,
    this.ketebalan,
    required this.geometry,
  });

  factory PipaModel.fromJson(Map<String, dynamic> json) {
    // Parsing geometry MultiLineString
    List<List<LatLng>> geomList = [];
    if (json['Geometry'] != null) {
      final geoJson = jsonDecode(json['Geometry']);
      if (geoJson['type'] == 'MultiLineString') {
        for (var line in geoJson['coordinates']) {
          List<LatLng> linePoints = [];
          for (var coord in line) {
            // coord[0]=lon, coord[1]=lat
            linePoints.add(LatLng(coord[1].toDouble(), coord[0].toDouble()));
          }
          geomList.add(linePoints);
        }
      }
    }

    return PipaModel(
      id: json['Id'],
      kode: json['Kode'],
      idUkuranPipa: json['IdUkuranPipa'],
      ukuranPipa: json['UkuranPipa'] ?? "",
      idJenisPipa: json['IdJenisPipa'],
      jenisPipa: json['JenisPipa'] ?? "",
      thnBuat: json['ThnBuat'],
      tanggalPemasangan: json['TanggalPemasangan'] == null
          ? null
          : DateTime.parse(json['TanggalPemasangan']),
      tanggalPerawatan: json['TanggalPerawatan'] == null
          ? null
          : DateTime.parse(json['TanggalPerawatan']),
      elevasi: json['Elevasi'],
      idStatusPipa: json['IdStatusPipa'],
      statusPipa: json['StatusPipa'] ?? "",
      idKondisiPipa: json['IdKondisiPipa'],
      kondisiPipa: json['KondisiPipa'] ?? "",
      panjang: json['Panjang'],
      keterangan: json['Keterangan'] ?? "",
      color: json['Color'] ?? "#FF4A6D",
      ketebalan: json['Ketebalan'] ?? 4,
      geometry: geomList,
    );
  }
}
