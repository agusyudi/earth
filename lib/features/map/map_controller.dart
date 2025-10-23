import 'dart:async';
import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/extension_api.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geodesy/geodesy.dart';
import 'package:get/get.dart';
import 'package:gis/models/pipa_model.dart';

import '../../components/marker/pulseeffect.dart';
import '../../cores/color.dart';
import '../../cores/response.dart';
import '../../models/aksesoris_model.dart';
import '../../models/wilayah_model.dart';
import '../../services/drop_down_service.dart';
import '../../services/rest_api_client_service.dart';

class MapMainController extends GetxController {
  final popupController = PopupController();
  var isSateliteView = false.obs;
  var isHoveredRightContent = true.obs;
  var selectedType = "".obs;
  var selectedTool = "".obs;
  var popupPosition = Rx<LatLng?>(null);

  Future initial() async {
    await getAksesoris();
    await getPipa();
    await getWilayah();
  }

  var aksesoris = <Marker>[].obs;
  var aksesorisDetails = <AksesorisModel>[].obs;
  var isLoadingAksesoris = false.obs;

  Future<ResponseResult> getAksesoris() async {
    var result = ResponseResult();

    aksesoris.clear();
    aksesorisDetails.clear();

    try {
      isLoadingAksesoris.value = true;
      var cancelToken = CancelToken();

      var apiResponse = await RestApiClient().getAsync(
        'aksesoris',
        {},
        cancelToken: cancelToken,
      );

      if (apiResponse.status == true) {
        for (var i in apiResponse.data) {
          var jsonRes = AksesorisModel.fromJson(i);
          aksesorisDetails.add(jsonRes);

          var size = 30.0;

          Widget icon = SvgPicture.asset(
            height: 30,
            "assets/images/pin.svg",
            color: Color(int.parse(jsonRes.color!.replaceFirst('#', '0xFF'))),
          );

          // Widget icon = Icon(
          //   Icons.pin_drop_rounded,
          //   color: Color(int.parse(jsonRes.color!.replaceFirst('#', '0xFF'))),
          //   size: 30,
          // );

          // switch (jsonRes.icon) {
          //   case "hydrant":
          //     size = 30;
          //     icon = SvgPicture.asset(
          //       height: 30,
          //       "assets/images/hydrant.svg",
          //       color: Color(
          //         int.parse(jsonRes.color!.replaceFirst('#', '0xFF')),
          //       ),
          //     );
          //     break;
          //   case "reservoir":
          //     size = 30;
          //     icon = SvgPicture.asset(
          //       height: 30,
          //       "assets/images/reservoir.svg",
          //       color: Color(
          //         int.parse(jsonRes.color!.replaceFirst('#', '0xFF')),
          //       ),
          //     );
          //     break;
          //   case "meter":
          //     size = 30;
          //     icon = SvgPicture.asset(
          //       height: 30,
          //       "assets/images/meter.svg",
          //       color: Color(
          //         int.parse(jsonRes.color!.replaceFirst('#', '0xFF')),
          //       ),
          //     );
          //     break;
          //   case "valve":
          //     size = 30;
          //     icon = SvgPicture.asset(
          //       height: 30,
          //       "assets/images/valve.svg",
          //       color: Color(
          //         int.parse(jsonRes.color!.replaceFirst('#', '0xFF')),
          //       ),
          //     );
          //     break;
          //   case "pompa":
          //     size = 30;
          //     icon = SvgPicture.asset(
          //       height: 30,
          //       "assets/images/pompa.svg",
          //       color: Color(
          //         int.parse(jsonRes.color!.replaceFirst('#', '0xFF')),
          //       ),
          //     );
          //     break;
          //   default:
          // }

          if (jsonRes.warning == "Rusak") {
            icon = PulseEffect(color: buttonRedColor, child: icon);
          } else if (jsonRes.warning == "Perlu Perawatan") {
            icon = PulseEffect(color: buttonBlueColor, child: icon);
          }

          aksesoris.add(
            Marker(
              width: size,
              height: size,
              point: LatLng(jsonRes.latitude!, jsonRes.longitude!),
              child: MouseRegion(
                onEnter: (event) => selectedType.value = "Marker",
                child: icon,
              ),
            ),
          );
        }
      }

      result = ResponseResult(
        status: apiResponse.status,
        message: apiResponse.message,
      );
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoadingAksesoris.value = false;
    }

    return result;
  }

  final pipa = <Polyline>[].obs;
  var pipaDetails = <PipaModel>[].obs;
  var isLoadingPipa = false.obs;
  var selectedPipaIndex = 0.obs;
  Rx<Color> blinkColorPipa = Colors.blue.obs;

  Future<ResponseResult> getPipa() async {
    var result = ResponseResult();

    pipa.clear();
    pipaDetails.clear();

    try {
      isLoadingPipa.value = true;
      var cancelToken = CancelToken();

      var apiResponse = await RestApiClient().getAsync(
        'pipa',
        {},
        cancelToken: cancelToken,
      );

      if (apiResponse.status == true) {
        for (var i in apiResponse.data) {
          var jsonRes = PipaModel.fromJson(i);
          pipaDetails.add(jsonRes);

          for (var x in jsonRes.geometry) {
            pipa.add(
              Polyline(
                borderStrokeWidth: 3,
                points: x,
                strokeWidth: 5,
                color: Color(
                  int.parse(jsonRes.color!.replaceFirst('#', '0xff')),
                ),
              ),
            );
          }
        }
      }

      result = ResponseResult(
        status: apiResponse.status,
        message: apiResponse.message,
      );
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoadingPipa.value = false;
    }

    return result;
  }

  Rx<Polyline?> selectedPolyline = Rx<Polyline?>(null);
  var showColor = true;
  Timer? _timer;

  void startBlinking() {
    _timer = Timer.periodic(const Duration(milliseconds: 400), (timer) {
      if (selectedPipaIndex.value == -1) {
        stopBlinking();
        return;
      }

      if (showColor) {
        blinkColorPipa.value = Colors.red;
        showColor = false;
      } else {
        blinkColorPipa.value = Colors.orange;
        showColor = true;
      }
    });
  }

  void stopBlinking() {
    selectedPipaIndex.value = -1;
    _timer?.cancel();
    _timer = null;
  }

  /// hitung jarak terpendek (meter) antara titik p dan segmen garis ab
  double _distancePointToSegment(LatLng p, LatLng a, LatLng b) {
    // ubah jadi koordinat dalam meter relatif terhadap titik a
    final distance = const Distance();
    // jarak dari a ke b
    final ab = distance(a, b);
    // kalau a dan b sama, jarak p ke a saja
    if (ab == 0) return distance(p, a);

    // vector unit ab
    final bearingAB = distance.bearing(a, b);
    final bearingAP = distance.bearing(a, p);

    // proyeksi panjang dari a ke titik proyeksi p pada garis ab
    final ap = distance(a, p);
    final proj = ap * math.cos((bearingAP - bearingAB) * math.pi / 180.0);

    // kalau proyeksi di luar segmen, jarak ke endpoint terdekat
    if (proj < 0) return distance(p, a);
    if (proj > ab) return distance(p, b);

    // jarak tegak lurus ke garis
    final perp = ap * math.sin((bearingAP - bearingAB) * math.pi / 180.0);
    return perp.abs();
  }

  /// cek apakah titik tap dekat polyline dalam threshold meter
  bool isPointNearPolyline(
    LatLng tapPoint,
    List<LatLng> polyline,
    double thresholdMeters,
  ) {
    for (int i = 0; i < polyline.length - 1; i++) {
      final d = _distancePointToSegment(tapPoint, polyline[i], polyline[i + 1]);
      if (d < thresholdMeters) {
        return true;
      }
    }
    return false;
  }

  final wilayah = <Polygon>[].obs;
  var wilayahDetails = <WilayahModel>[].obs;
  var isLoadingWilayah = false.obs;

  Future<ResponseResult> getWilayah() async {
    var result = ResponseResult();

    wilayah.clear();
    wilayahDetails.clear();

    try {
      isLoadingWilayah.value = true;
      var cancelToken = CancelToken();

      var apiResponse = await RestApiClient().getAsync(
        'wilayah',
        {},
        cancelToken: cancelToken,
      );

      if (apiResponse.status == true) {
        for (var i in apiResponse.data) {
          var jsonRes = WilayahModel.fromJson(i);
          wilayahDetails.add(jsonRes);

          for (var x in jsonRes.geometry) {
            wilayah.add(
              Polygon(
                points: x,
                color: Color(
                  int.parse(jsonRes.color.replaceFirst('#', '0xff')),
                ).withOpacity(0.3),
                borderColor: Colors.white,
                borderStrokeWidth: 2,
              ),
            );
          }
        }
      }

      result = ResponseResult(
        status: apiResponse.status,
        message: apiResponse.message,
      );
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoadingWilayah.value = false;
    }

    return result;
  }

  var jumlahFilterAktif = 0.obs;
  void countJumlahFilter(bool value) {
    switch (value) {
      case true:
        jumlahFilterAktif.value += 1;
        break;
      case false:
        jumlahFilterAktif.value -= 1;
        break;
    }
  }

  var tabFilter = "".obs;

  var ischeckFilterJenisPipa = false.obs;
  var filterJenisPipa = <DropDownHelperResponse>[].obs;

  var ischeckFilterKondisiPipa = false.obs;
  var filterKondisiPipa = <DropDownHelperResponse>[].obs;

  var ischeckFilterUkuranPipa = false.obs;
  var filterUkuranPipa = <DropDownHelperResponse>[].obs;

  var ischeckFilterStatusPipa = false.obs;
  var filterStatusPipa = <DropDownHelperResponse>[].obs;

  var ischeckFilterTahunBuat = false.obs;
  var filterTahunBuat = TextEditingController();

  RxList<LatLng> pointsTemp = <LatLng>[].obs;
  RxDouble totalDistance = 0.0.obs;

  final geodesy = Geodesy();

  void addPointTemp(LatLng point) {
    pointsTemp.add(point);
  }

  void resetPanjangPipa() {
    pointsTemp.clear();
    totalDistance.value = 0.0;
  }

  void calculateDistance() {
    if (pointsTemp.length < 2) {
      totalDistance.value = 0.0;
      return;
    }
    double sum = 0.0;
    for (int i = 0; i < pointsTemp.length - 1; i++) {
      sum += geodesy.distanceBetweenTwoGeoPoints(
        LatLng(pointsTemp[i].latitude, pointsTemp[i].longitude),
        LatLng(pointsTemp[i + 1].latitude, pointsTemp[i + 1].longitude),
      );
    }
    totalDistance.value = sum; // meter
  }

  String formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.toStringAsFixed(0)} m';
    } else {
      return '${(meters / 1000).toStringAsFixed(2)} km';
    }
  }
}
