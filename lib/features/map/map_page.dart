import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:gis/components/divider/divider_bold.dart';
import 'package:gis/components/text/text_secondary.dart';
import 'package:gis/components/textfield/textfield_integer.dart';
import 'package:gis/cores/color.dart';
import 'package:gis/services/map_navigation.dart';
import 'package:gis/services/street_view.dart';
import 'package:latlong2/latlong.dart';

import '../../components/container/info_container.dart';
import '../../components/container/info_text.dart';
import '../../components/dropdown/dropdownbase.dart';
import '../../components/page/page.dart';
import '../../components/text/text.dart';
import '../../components/text/text_selected.dart';
import '../../cores/constant.dart';
import 'map_controller.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final controller = Get.put(MapMainController());
  final GlobalKey mapKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    controller.initial();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      backgroundcolor: Theme.of(context).cardColor,
      page: "map",
      rigthPanel: null,
      centerPanel: Stack(children: [map, rightContent]),
    );
  }

  SystemMouseCursor get cursor {
    switch (controller.selectedTool.value) {
      case "panjang-pipa":
        return SystemMouseCursors.precise;
      case "street-view":
        return SystemMouseCursors.precise;
      case "petunjuk-arah":
        return SystemMouseCursors.precise;
      case "penunjuk-titik":
        return SystemMouseCursors.precise;
      case "perhitungan-area":
        return SystemMouseCursors.precise;
      default:
    }

    return SystemMouseCursors.basic;
  }

  PopupScope get map {
    return PopupScope(
      popupController: controller.popupController,
      child: Obx(
        () => MouseRegion(
          cursor: cursor,
          child: FlutterMap(
            key: mapKey,
            options: MapOptions(
              initialCenter: LatLng(baseLat, baseLng),
              initialZoom: 13,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
              ),
              onTap: (tapPosition, point) {
                controller.popupController.hideAllPopups();

                Polyline? tapped;
                for (int i = 0; i < controller.pipa.length; i++) {
                  final line = controller.pipa[i];
                  if (controller.isPointNearPolyline(point, line.points, 15)) {
                    controller.stopBlinking();
                    tapped = line;
                    controller.selectedPipaIndex.value = i;
                    controller.startBlinking();
                    break;
                  }
                }

                if (tapped != null) {
                  controller.selectedPolyline.value = tapped;
                  controller.popupPosition.value = point;
                } else {
                  controller.selectedPolyline.value = null;
                  controller.popupPosition.value = null;
                }

                switch (controller.selectedTool.value) {
                  case "panjang-pipa":
                    controller.addPointTemp(point);
                    controller.calculateDistance();
                    break;
                  case "street-view":
                    openStreetView(point.latitude, point.longitude);
                    break;
                  case "petunjuk-arah":
                    openGoogleMapsNavigation(point.latitude, point.longitude);
                    break;
                  case "penunjuk-titik":
                    controller.pointsTemp.clear();
                    controller.addPointTemp(point);
                    break;
                  default:
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: controller.isSateliteView.value == false
                    ? 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'
                    : 'https://services.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
                tileProvider: CancellableNetworkTileProvider(), // Gunakan ini
                subdomains: const ['a', 'b', 'c', 'd'],
                userAgentPackageName: 'com.example.app',
              ),

              PolygonLayer(polygons: [...controller.wilayah]),

              if (controller.pipa.isNotEmpty)
                // PolylineLayer(polylines: [...controller.pipa]),
                PolylineLayer(
                  polylines: controller.pipa.map((line) {
                    final selected = controller.selectedPolyline.value == line;
                    return Polyline(
                      points: line.points,
                      color: selected
                          ? controller.blinkColorPipa.value
                          : line.color,
                      strokeWidth: selected ? 5 : line.strokeWidth,
                    );
                  }).toList(),
                ),

              ///Line Hitung panjang pipa
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: controller.pointsTemp,
                    strokeWidth: 4.0,
                    color: Colors.blue,
                  ),
                ],
              ),

              ///Marker Hitung panjang pipa
              MarkerLayer(
                markers: controller.pointsTemp
                    .map(
                      (p) => Marker(
                        point: p,
                        width: 10,
                        height: 10,
                        child: const Icon(
                          Icons.circle,
                          size: 10,
                          color: Colors.red,
                        ),
                      ),
                    )
                    .toList(),
              ),

              //popup aksesoris
              if (controller.aksesoris.isNotEmpty)
                MarkerClusterLayerWidget(
                  options: MarkerClusterLayerOptions(
                    maxClusterRadius: 10,
                    markers: controller.aksesoris,
                    size: const Size(20, 20),
                    builder: (context, markers) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.7),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: BaseText(
                          label: '${markers.length}',
                          color: "ffffff",
                        ),
                      );
                    },
                    popupOptions: aksesorisPopup,
                  ),
                ),

              //popup selected polyline
              if (controller.popupPosition.value != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: controller.popupPosition.value!,
                      width: 350,
                      height: 250,
                      alignment: Alignment.topCenter,

                      child: Transform.translate(
                        offset: const Offset(0, -20),
                        child: Card(
                          color: Theme.of(context).cardColor.withOpacity(0.80),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            color: Colors.transparent,
                            width: 450,
                            height: 350,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BaseText(
                                  label: controller
                                      .pipaDetails[controller
                                          .selectedPipaIndex
                                          .value]
                                      .id
                                      .toString(),
                                  size: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                                const Gap(10),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        BaseInfoContainer(
                                          isTransparent: true,
                                          listInfo: [
                                            BaseInfoText(
                                              label: "Jenis Pipa",
                                              value: controller
                                                  .pipaDetails[controller
                                                      .selectedPipaIndex
                                                      .value]
                                                  .jenisPipa
                                                  .toString(),
                                            ),
                                            BaseInfoText(
                                              label: "Ketebalan",
                                              value: controller
                                                  .pipaDetails[controller
                                                      .selectedPipaIndex
                                                      .value]
                                                  .ketebalan
                                                  .toString(),
                                            ),
                                            BaseInfoText(
                                              label: "Elevasi",
                                              value: controller
                                                  .pipaDetails[controller
                                                      .selectedPipaIndex
                                                      .value]
                                                  .elevasi
                                                  .toString(),
                                            ),
                                            BaseInfoText(
                                              label: "Kondisi Pipa",
                                              value: controller
                                                  .pipaDetails[controller
                                                      .selectedPipaIndex
                                                      .value]
                                                  .kondisiPipa
                                                  .toString(),
                                            ),
                                            BaseInfoText(
                                              label: "Status Pipa",
                                              value: controller
                                                  .pipaDetails[controller
                                                      .selectedPipaIndex
                                                      .value]
                                                  .statusPipa
                                                  .toString(),
                                            ),
                                            BaseInfoText(
                                              label: "Tgl.Pasang",
                                              value: controller
                                                  .pipaDetails[controller
                                                      .selectedPipaIndex
                                                      .value]
                                                  .tanggalPemasangan
                                                  .toString(),
                                            ),
                                            BaseInfoText(
                                              label: "Tgl.Perawatan",
                                              value: controller
                                                  .pipaDetails[controller
                                                      .selectedPipaIndex
                                                      .value]
                                                  .tanggalPerawatan
                                                  .toString(),
                                            ),
                                            BaseInfoText(
                                              label: "Tahun Buat",
                                              value: controller
                                                  .pipaDetails[controller
                                                      .selectedPipaIndex
                                                      .value]
                                                  .thnBuat
                                                  .toString(),
                                            ),
                                            BaseInfoText(
                                              label: "Ukuran Pipa",
                                              value: controller
                                                  .pipaDetails[controller
                                                      .selectedPipaIndex
                                                      .value]
                                                  .ukuranPipa
                                                  .toString(),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  PopupOptions get aksesorisPopup {
    var scrollController = ScrollController();
    return PopupOptions(
      popupController: controller.popupController,
      popupBuilder: (context, marker) {
        int index = controller.aksesoris.indexOf(marker);
        final data = controller.aksesorisDetails[index];

        return Card(
          elevation: 10,
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Container(
            padding: const EdgeInsets.all(20),
            width: 450,
            height: 350,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BaseText(
                  label: data.nama.toString(),
                  size: 15,
                  fontWeight: FontWeight.w700,
                ),
                const Gap(10),
                Expanded(
                  child: Scrollbar(
                    thumbVisibility: true,
                    controller: scrollController,
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BaseInfoContainer(
                            listInfo: [
                              BaseInfoText(
                                label: "Kode",
                                value: data.kode.toString(),
                              ),
                              if (data.warning != "")
                                BaseInfoText(
                                  label: "Warning",
                                  value: data.warning.toString(),
                                ),
                              BaseInfoText(
                                label: "Jenis Aksesoris",
                                value: data.jenisAksesoris.toString(),
                              ),
                              BaseInfoText(
                                label: "Diameter Aksesoris",
                                value: data.diameterAksesoris.toString(),
                              ),
                              BaseInfoText(
                                label: "Keterangan",
                                value: data.keterangan.toString(),
                              ),
                              BaseInfoText(
                                label: "Frequency",
                                value: data.frequency.toString(),
                              ),
                              BaseInfoText(
                                label: "Voltage",
                                value: data.voltage.toString(),
                              ),
                              BaseInfoText(
                                label: "Current",
                                value: data.current.toString(),
                              ),
                              BaseInfoText(
                                label: "Speed",
                                value: data.speed.toString(),
                              ),
                              BaseInfoText(
                                label: "Power",
                                value: data.power.toString(),
                              ),
                              BaseInfoText(
                                label: "Igbt_temp",
                                value: data.igbtTemp.toString(),
                              ),
                              BaseInfoText(
                                label: "Flow_rate",
                                value: data.flowRate.toString(),
                              ),
                              BaseInfoText(
                                label: "Pressure",
                                value: data.pressure.toString(),
                              ),
                              BaseInfoText(
                                label: "Totalizer",
                                value: data.totalizer.toString(),
                              ),
                              BaseInfoText(
                                label: "Power_status",
                                value: data.powerStatus.toString(),
                              ),
                              BaseInfoText(
                                label: "Power_status",
                                value: data.powerStatus.toString(),
                              ),
                              BaseInfoText(
                                label: "Pt_status",
                                value: data.ptStatus.toString(),
                              ),
                              BaseInfoText(
                                label: "Pressure_boost",
                                value: data.pressureBoost.toString(),
                              ),
                              BaseInfoText(
                                label: "Proportional",
                                value: data.proportional.toString(),
                              ),
                              BaseInfoText(
                                label: "Integral",
                                value: data.integral.toString(),
                              ),
                              BaseInfoText(
                                label: "Set_point",
                                value: data.setPoint.toString(),
                              ),
                              BaseInfoText(
                                label: "Is_over_pressure",
                                value: data.isOverPressure.toString(),
                              ),
                              BaseInfoText(
                                label: "Is_under_pressure",
                                value: data.isUnderPressure.toString(),
                              ),
                              BaseInfoText(
                                label: "Dead_band",
                                value: data.deadBand.toString(),
                              ),
                              BaseInfoText(
                                label: "Pt_current",
                                value: data.ptCurrent.toString(),
                              ),
                              BaseInfoText(
                                label: "Pt_voltage",
                                value: data.ptVoltage.toString(),
                              ),
                              BaseInfoText(
                                label: "Water_temp",
                                value: data.waterTemp.toString(),
                              ),
                              BaseInfoText(
                                label: "Ph",
                                value: data.ph.toString(),
                              ),
                              BaseInfoText(
                                label: "Turbidity_value",
                                value: data.turbidityValue.toString(),
                              ),
                              BaseInfoText(
                                label: "Chlorine",
                                value: data.chlorine.toString(),
                              ),
                              BaseInfoText(
                                label: "Level",
                                value: data.level.toString(),
                              ),
                              BaseInfoText(
                                label: "RunningCount",
                                value: data.runningCount.toString(),
                              ),
                              BaseInfoText(
                                label: "IsForceStop",
                                value: data.isForceStop.toString(),
                              ),
                              BaseInfoText(
                                label: "IsBoosting",
                                value: data.isBoosting.toString(),
                              ),
                              BaseInfoText(
                                label: "IsUnderPressure",
                                value: data.isUnderPressure.toString(),
                              ),
                              BaseInfoText(
                                label: "IsOverPressure",
                                value: data.isOverPressure.toString(),
                              ),
                              BaseInfoText(
                                label: "IsPressureTransmitterError",
                                value: data.isPressureTransmitterError
                                    .toString(),
                              ),
                              BaseInfoText(
                                label: "IsWaterShortage",
                                value: data.isWaterShortage.toString(),
                              ),
                              BaseInfoText(
                                label: "IsAnalogInputError",
                                value: data.isAnalogInputError.toString(),
                              ),
                              BaseInfoText(
                                label: "IsAnalogOutputFault",
                                value: data.isAnalogOutputFault.toString(),
                              ),
                              BaseInfoText(
                                label: "IsDigitalOutputFault",
                                value: data.isDigitalOutputFault.toString(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Obx get rightContent {
    return Obx(() {
      return Positioned(
        top: 8,
        right: 8,
        width: 350,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              child: BaseText(label: "Tools", fontWeight: FontWeight.w700),
            ),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor.withOpacity(0.70),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              padding: const EdgeInsets.all(14),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 15,
                children: [
                  Tooltip(
                    message: "Ukur Panjang Pipa",
                    child: InkWell(
                      onTap: () {
                        if (controller.selectedTool.value != "panjang-pipa") {
                          controller.selectedTool.value = "panjang-pipa";
                        } else {
                          controller.selectedTool.value = "";
                        }
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 2,
                            color: Theme.of(
                              context,
                            ).textTheme.bodySmall!.color!.withOpacity(0.3),
                          ),
                          color: controller.selectedTool.value == "panjang-pipa"
                              ? Theme.of(context).secondaryHeaderColor
                              : null,
                        ),
                        child: Icon(
                          Icons.calculate_outlined,
                          size: 25,
                          color: controller.selectedTool.value == "panjang-pipa"
                              ? Colors.white
                              : buttonGreenColorSecondary,
                        ),
                      ),
                    ),
                  ),
                  Tooltip(
                    message: "Screenshot Peta",
                    child: InkWell(
                      onTap: () {
                        if (controller.selectedTool.value != "screenshot") {
                          controller.selectedTool.value = "screenshot";
                        } else {
                          controller.selectedTool.value = "";
                        }
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 2,
                            color: Theme.of(
                              context,
                            ).textTheme.bodySmall!.color!.withOpacity(0.3),
                          ),
                          color: controller.selectedTool.value == "screenshot"
                              ? Theme.of(context).secondaryHeaderColor
                              : null,
                        ),
                        child: Icon(
                          Icons.screenshot_monitor_outlined,
                          size: 25,
                          color: controller.selectedTool.value == "screenshot"
                              ? Colors.white
                              : buttonGreenColorSecondary,
                        ),
                      ),
                    ),
                  ),
                  Tooltip(
                    message: "Lihat Dengan Street View",
                    child: InkWell(
                      onTap: () async {
                        if (controller.selectedTool.value != "street-view") {
                          controller.selectedTool.value = "street-view";
                        } else {
                          controller.selectedTool.value = "";
                        }
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 2,
                            color: Theme.of(
                              context,
                            ).textTheme.bodySmall!.color!.withOpacity(0.3),
                          ),
                          color: controller.selectedTool.value == "street-view"
                              ? Theme.of(context).secondaryHeaderColor
                              : null,
                        ),
                        child: Icon(
                          Icons.streetview_outlined,
                          size: 25,
                          color: controller.selectedTool.value == "street-view"
                              ? Colors.white
                              : buttonGreenColorSecondary,
                        ),
                      ),
                    ),
                  ),
                  Tooltip(
                    message: "Petunjuk Arah",
                    child: InkWell(
                      onTap: () {
                        if (controller.selectedTool.value != "petunjuk-arah") {
                          controller.selectedTool.value = "petunjuk-arah";
                        } else {
                          controller.selectedTool.value = "";
                        }
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 2,
                            color: Theme.of(
                              context,
                            ).textTheme.bodySmall!.color!.withOpacity(0.3),
                          ),
                          color:
                              controller.selectedTool.value == "petunjuk-arah"
                              ? Theme.of(context).secondaryHeaderColor
                              : null,
                        ),
                        child: Icon(
                          Icons.navigation_outlined,
                          size: 20,
                          color:
                              controller.selectedTool.value == "petunjuk-arah"
                              ? Colors.white
                              : buttonGreenColorSecondary,
                        ),
                      ),
                    ),
                  ),
                  Tooltip(
                    message: "Penunjuk Titik Lokasi",
                    child: InkWell(
                      onTap: () {
                        if (controller.selectedTool.value != "penunjuk-titik") {
                          controller.selectedTool.value = "penunjuk-titik";
                        } else {
                          controller.selectedTool.value = "";
                        }
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 2,
                            color: Theme.of(
                              context,
                            ).textTheme.bodySmall!.color!.withOpacity(0.3),
                          ),
                          color:
                              controller.selectedTool.value == "penunjuk-titik"
                              ? Theme.of(context).secondaryHeaderColor
                              : null,
                        ),
                        child: Icon(
                          Icons.location_searching_outlined,
                          size: 20,
                          color:
                              controller.selectedTool.value == "penunjuk-titik"
                              ? Colors.white
                              : buttonGreenColorSecondary,
                        ),
                      ),
                    ),
                  ),
                  Tooltip(
                    message: "Hitung Luas Area",
                    child: InkWell(
                      onTap: () {
                        if (controller.selectedTool.value !=
                            "perhitungan-area") {
                          controller.selectedTool.value = "perhitungan-area";
                        } else {
                          controller.selectedTool.value = "";
                        }
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 2,
                            color: Theme.of(
                              context,
                            ).textTheme.bodySmall!.color!.withOpacity(0.3),
                          ),
                          color:
                              controller.selectedTool.value ==
                                  "perhitungan-area"
                              ? Theme.of(context).secondaryHeaderColor
                              : null,
                        ),
                        child: Icon(
                          Icons.area_chart_outlined,
                          size: 20,
                          color:
                              controller.selectedTool.value ==
                                  "perhitungan-area"
                              ? Colors.white
                              : buttonGreenColorSecondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(8),
            if (controller.selectedTool.value == "panjang-pipa")
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor.withOpacity(0.70),
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: const EdgeInsets.all(14),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BaseText(
                      label: "Mulai Hitung Panjang Pipa",
                      fontWeight: FontWeight.w700,
                      color: fontBlueString,
                    ),
                    const Gap(3),
                    BaseTextSecondary(
                      useEllipsis: false,
                      label:
                          "Tentukan titik dan jalur untuk mengukur panjang pipa...",
                    ),
                    const Gap(14),
                    BaseText(
                      label: "Hasil Pengukuran Panjang Pipa",
                      fontWeight: FontWeight.w700,
                    ),
                    const Gap(5),
                    BaseText(
                      size: 17,
                      label: controller.formatDistance(
                        controller.totalDistance.value,
                      ),
                      fontWeight: FontWeight.w700,
                    ),
                    const Gap(20),
                    InkWell(
                      onTap: () {
                        controller.selectedTool.value = "";
                        controller.resetPanjangPipa();
                      },
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(12, 3, 12, 3),
                        decoration: BoxDecoration(
                          color: Theme.of(context).secondaryHeaderColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: BaseText(label: "Selesai", color: "ffffff"),
                      ),
                    ),
                  ],
                ),
              ),
            if (controller.selectedTool.value == "screenshot")
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor.withOpacity(0.70),
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: const EdgeInsets.all(14),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BaseText(
                      label: "Screenshot peta yang tampil",
                      fontWeight: FontWeight.w700,
                      color: fontBlueString,
                    ),
                    const Gap(3),
                    Row(
                      children: [
                        Expanded(
                          child: BaseTextSecondary(
                            useEllipsis: false,
                            label:
                                "Tentukan gambar pada peta yang akan diambil",
                          ),
                        ),
                      ],
                    ),
                    const Gap(20),
                    InkWell(
                      onTap: () {
                        controller.selectedTool.value = "";
                      },
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(12, 3, 12, 3),
                        decoration: BoxDecoration(
                          color: Theme.of(context).secondaryHeaderColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: BaseText(label: "Ambil Gambar", color: "ffffff"),
                      ),
                    ),
                  ],
                ),
              ),
            if (controller.selectedTool.value == "street-view")
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor.withOpacity(0.70),
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: const EdgeInsets.all(14),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BaseText(
                      label: "Pilih Lokasi",
                      fontWeight: FontWeight.w700,
                      color: fontBlueString,
                    ),
                    const Gap(3),
                    Row(
                      children: [
                        Expanded(
                          child: BaseTextSecondary(
                            useEllipsis: false,
                            label:
                                "Tentukan titik lokasi untuk menuju street view",
                          ),
                        ),
                      ],
                    ),
                    const Gap(20),
                    InkWell(
                      onTap: () {
                        controller.selectedTool.value = "";
                      },
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(12, 3, 12, 3),
                        decoration: BoxDecoration(
                          color: Theme.of(context).secondaryHeaderColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: BaseText(label: "Selesai", color: "ffffff"),
                      ),
                    ),
                  ],
                ),
              ),
            if (controller.selectedTool.value == "petunjuk-arah")
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor.withOpacity(0.70),
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: const EdgeInsets.all(14),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BaseText(
                      label: "Pilih Lokasi",
                      fontWeight: FontWeight.w700,
                      color: fontBlueString,
                    ),
                    const Gap(3),
                    Row(
                      children: [
                        Expanded(
                          child: BaseTextSecondary(
                            useEllipsis: false,
                            label:
                                "Tentukan titik lokasi untuk menuju petunjuk arah lokasi",
                          ),
                        ),
                      ],
                    ),
                    const Gap(20),
                    InkWell(
                      onTap: () {
                        controller.selectedTool.value = "";
                      },
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(12, 3, 12, 3),
                        decoration: BoxDecoration(
                          color: Theme.of(context).secondaryHeaderColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: BaseText(label: "Selesai", color: "ffffff"),
                      ),
                    ),
                  ],
                ),
              ),
            if (controller.selectedTool.value == "penunjuk-titik")
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor.withOpacity(0.70),
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: const EdgeInsets.all(14),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BaseText(
                      label: "Pilih Lokasi",
                      fontWeight: FontWeight.w700,
                      color: fontBlueString,
                    ),
                    const Gap(3),
                    Row(
                      children: [
                        Expanded(
                          child: BaseTextSecondary(
                            useEllipsis: false,
                            label:
                                "Tentukan titik lokasi untuk mendapatkan titik koordinat lokasi",
                          ),
                        ),
                      ],
                    ),
                    const Gap(14),
                    BaseText(label: "Koordinat", fontWeight: FontWeight.w700),
                    const Gap(5),
                    BaseSelectedText(
                      size: 11,
                      label: controller.pointsTemp.isEmpty
                          ? "-"
                          : "${controller.pointsTemp.first.latitude.toString()}, ${controller.pointsTemp.first.longitude.toString()}",
                      fontWeight: FontWeight.w700,
                      color: fontBlueString,
                    ),
                    const Gap(20),
                    InkWell(
                      onTap: () {
                        controller.selectedTool.value = "";
                        controller.pointsTemp.clear();
                      },
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(12, 3, 12, 3),
                        decoration: BoxDecoration(
                          color: Theme.of(context).secondaryHeaderColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: BaseText(label: "Selesai", color: "ffffff"),
                      ),
                    ),
                  ],
                ),
              ),

            const Gap(8),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              child: BaseText(label: "Filter", fontWeight: FontWeight.w700),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor.withOpacity(0.70),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          controller.tabFilter.value = "pipa";
                        },
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(12, 3, 12, 3),
                          decoration: BoxDecoration(
                            color: controller.tabFilter.value == "pipa"
                                ? Theme.of(context).secondaryHeaderColor
                                : null,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: BaseText(
                            label: "Pipa",
                            color: controller.tabFilter.value == "pipa"
                                ? "ffffff"
                                : fontBlueString,
                          ),
                        ),
                      ),
                      const Gap(5),
                      InkWell(
                        onTap: () {
                          controller.tabFilter.value = "aksesoris";
                        },
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(12, 3, 12, 3),
                          decoration: BoxDecoration(
                            color: controller.tabFilter.value == "aksesoris"
                                ? Theme.of(context).secondaryHeaderColor
                                : null,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: BaseText(
                            label: "Aksesoris",
                            color: controller.tabFilter.value == "aksesoris"
                                ? "ffffff"
                                : fontBlueString,
                          ),
                        ),
                      ),
                      const Gap(5),
                      InkWell(
                        onTap: () {
                          controller.tabFilter.value = "wilayah";
                        },
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(12, 3, 12, 3),
                          decoration: BoxDecoration(
                            color: controller.tabFilter.value == "wilayah"
                                ? Theme.of(context).secondaryHeaderColor
                                : null,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: BaseText(
                            label: "Wilayah",
                            color: controller.tabFilter.value == "wilayah"
                                ? "ffffff"
                                : fontBlueString,
                          ),
                        ),
                      ),
                    ],
                  ),

                  if (controller.tabFilter.value == "pipa")
                    Column(
                      children: [
                        const BaseDivider(),
                        BaseDropDown(
                          checkbox: Checkbox(
                            shape: const CircleBorder(),
                            value: controller.ischeckFilterJenisPipa.value,
                            onChanged: (value) {
                              if (value != null) {
                                controller.ischeckFilterJenisPipa.value = value;
                                controller.countJumlahFilter(value);
                              }
                            },
                          ),
                          height: 39,
                          readOnly:
                              controller.ischeckFilterJenisPipa.value == false,
                          title: 'Jenis Pipa',
                          endPoint: "jenis-pipa",
                          value: "IdJenisPipa",
                          label: "JenisPipa",
                          selectedValue: controller.filterJenisPipa.isEmpty
                              ? null
                              : controller.filterJenisPipa.first.value,
                          onChanged: (value) {
                            if (value != null) {
                              controller.filterJenisPipa.value = [];
                              controller.filterJenisPipa.add(value);
                            }
                          },
                        ),
                        const Gap(5),
                        BaseDropDown(
                          checkbox: Checkbox(
                            shape: const CircleBorder(),
                            value: controller.ischeckFilterUkuranPipa.value,
                            onChanged: (value) {
                              if (value != null) {
                                controller.ischeckFilterUkuranPipa.value =
                                    value;
                                controller.countJumlahFilter(value);
                              }
                            },
                          ),
                          height: 39,
                          readOnly:
                              controller.ischeckFilterUkuranPipa.value == false,
                          title: 'Ukuran Pipa',
                          endPoint: "ukuran-pipa",
                          value: "IdUkuranPipa",
                          label: "UkuranPipa",
                          selectedValue: controller.filterUkuranPipa.isEmpty
                              ? null
                              : controller.filterUkuranPipa.first.value,
                          onChanged: (value) {
                            if (value != null) {
                              controller.filterUkuranPipa.value = [];
                              controller.filterUkuranPipa.add(value);
                            }
                          },
                        ),
                        const Gap(5),
                        BaseDropDown(
                          checkbox: Checkbox(
                            shape: const CircleBorder(),
                            value: controller.ischeckFilterKondisiPipa.value,
                            onChanged: (value) {
                              if (value != null) {
                                controller.ischeckFilterKondisiPipa.value =
                                    value;
                                controller.countJumlahFilter(value);
                              }
                            },
                          ),
                          height: 39,
                          readOnly:
                              controller.ischeckFilterKondisiPipa.value ==
                              false,
                          title: 'Kondisi Pipa',
                          endPoint: "kondisi-pipa",
                          value: "IdKondisiPipa",
                          label: "KondisiPipa",
                          selectedValue: controller.filterKondisiPipa.isEmpty
                              ? null
                              : controller.filterKondisiPipa.first.value,
                          onChanged: (value) {
                            if (value != null) {
                              controller.filterKondisiPipa.value = [];
                              controller.filterKondisiPipa.add(value);
                            }
                          },
                        ),
                        const Gap(5),
                        BaseDropDown(
                          checkbox: Checkbox(
                            shape: const CircleBorder(),
                            value: controller.ischeckFilterStatusPipa.value,
                            onChanged: (value) {
                              if (value != null) {
                                controller.ischeckFilterStatusPipa.value =
                                    value;
                                controller.countJumlahFilter(value);
                              }
                            },
                          ),
                          height: 39,
                          readOnly:
                              controller.ischeckFilterStatusPipa.value == false,
                          title: 'Status Pipa',
                          endPoint: "status-pipa",
                          value: "IdStatusPipa",
                          label: "StatusPipa",
                          selectedValue: controller.filterStatusPipa.isEmpty
                              ? null
                              : controller.filterStatusPipa.first.value,
                          onChanged: (value) {
                            if (value != null) {
                              controller.filterStatusPipa.value = [];
                              controller.filterStatusPipa.add(value);
                            }
                          },
                        ),
                        const Gap(5),
                        BaseTextFieldInteger(
                          label: "Tahun Pembuatan",
                          controller: controller.filterTahunBuat,
                          readOnly:
                              controller.ischeckFilterTahunBuat.value == false,
                          checkbox: Checkbox(
                            shape: const CircleBorder(),
                            value: controller.ischeckFilterTahunBuat.value,
                            onChanged: (value) {
                              if (value != null) {
                                controller.ischeckFilterTahunBuat.value = value;
                                controller.countJumlahFilter(value);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
