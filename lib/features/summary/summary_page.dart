import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:flutter_masonry_view/flutter_masonry_view.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:gis/components/divider/divider_bold.dart';
import 'package:gis/components/divider/vertical_line.dart';
import 'package:gis/components/loading/proses_loading.dart';
import 'package:gis/components/text/text.dart';
import 'package:gis/components/text/text_secondary.dart';
import 'package:gis/cores/color.dart';
import 'package:gis/models/spam_summary_model.dart';
import 'package:gis/services/format_angkta.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../cores/theme/theme_service.dart';
import '../../models/offtaker_summary_model.dart';
import 'summary_controller.dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage({super.key});

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  final controller = Get.put(SummaryController());
  final GlobalKey mapKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    controller.initial();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).cardColor,
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                border: Border.all(
                  width: 2,
                  color: Theme.of(
                    context,
                  ).textTheme.bodySmall!.color!.withOpacity(0.4),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Image.asset("assets/images/company_logo.jpg", height: 50),
                      BaseText(
                        label: "UPT SPAM BALI",
                        size: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(height: 17, child: const BaseVerticalLine()),
                      Container(
                        height: 35,
                        decoration: BoxDecoration(
                          color: Theme.of(context).highlightColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Consumer<ThemeService>(
                          builder: (context, themeService, _) {
                            return SizedBox(
                              height: 50,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(
                                    themeService.isDarkMode == true
                                        ? Icons.dark_mode
                                        : Icons.light_mode,
                                    color: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium!.color!,
                                    size: 15,
                                  ),
                                  BaseText(
                                    label: themeService.isDarkMode == true
                                        ? "Tema Gelap "
                                        : "Tema Terang",
                                  ),
                                  const Gap(10),
                                  SizedBox(
                                    height: 20,
                                    child: FittedBox(
                                      fit: BoxFit.fill,
                                      child: Switch(
                                        trackOutlineColor:
                                            WidgetStatePropertyAll(
                                              Theme.of(
                                                context,
                                              ).shadowColor.withOpacity(0.3),
                                            ),
                                        value: themeService.isDarkMode == true,
                                        onChanged: (value) =>
                                            themeService.toggleTheme(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 17, child: const BaseVerticalLine()),
                      BaseText(
                        label: DateFormat(
                          "EE, dd MMMM yyyy HH:mm",
                          "id_ID",
                        ).format(DateTime.now()),
                      ),
                      SizedBox(height: 17, child: const BaseVerticalLine()),
                      Icon(Icons.notifications, color: buttonRedColor),
                      SizedBox(height: 17, child: const BaseVerticalLine()),
                      CircleAvatar(child: Icon(Icons.people)),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 500,
                      height: double.infinity,
                      padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 2,
                          color: Theme.of(
                            context,
                          ).textTheme.bodySmall!.color!.withOpacity(0.4),
                        ),
                      ),
                      child: Obx(
                        () => SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.info_outline_rounded, size: 20),
                                  const Gap(5),
                                  BaseText(
                                    label: "OFFTAKER SUMMARY",
                                    fontWeight: FontWeight.w700,
                                    size: 16,
                                  ),
                                ],
                              ),
                              const Gap(20),
                              if (controller.listOffTakerSummary.isNotEmpty)
                                MasonryView(
                                  listOfItem: controller.listOffTakerSummary
                                      .toList(),
                                  numberOfColumn: 2,
                                  itemPadding: 4,
                                  itemRadius: 0,
                                  itemBuilder: (item) {
                                    var data = item as OfftakerSummaryModel;
                                    return Container(
                                      padding: const EdgeInsets.fromLTRB(
                                        14,
                                        14,
                                        14,
                                        20,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: buttonBlueColor.withOpacity(
                                          0.05,
                                        ),
                                        border: Border.all(
                                          width: 1.5,
                                          color: Theme.of(
                                            context,
                                          ).textTheme.bodySmall!.color!,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          BaseText(
                                            label: data.namaOfftaker,
                                            fontWeight: FontWeight.w700,
                                            color: fontBlueString,
                                          ),
                                          const BaseDivider(),
                                          BaseTextSecondary(
                                            label: "Totalizer (Bulan Ini)",
                                          ),
                                          BaseText(
                                            label: formatAngkaIndonesia(
                                              data.totalizerBulanIni!,
                                            ),
                                            fontWeight: FontWeight.w700,
                                          ),
                                          const BaseDivider(),
                                          BaseTextSecondary(
                                            label: "Jumlah Offtaker",
                                          ),
                                          BaseText(
                                            label: formatInteger(
                                              data.countOfftaker!,
                                            ),
                                            fontWeight: FontWeight.w700,
                                          ),
                                          const BaseDivider(),
                                          BaseTextSecondary(
                                            label: "Perkiraan Tagihan",
                                          ),
                                          BaseText(
                                            label:
                                                "Rp ${formatAngkaIndonesia(data.perkiraanTagihan!)}",
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Gap(10),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 2,
                            color: Theme.of(
                              context,
                            ).textTheme.bodySmall!.color!.withOpacity(0.4),
                          ),
                        ),
                        child: Obx(
                          () =>
                              controller.isLoadingWilayah.value == true ||
                                  controller.wilayah.isEmpty
                              ? const BaseProsesLoading()
                              : FlutterMap(
                                  key: mapKey,
                                  options: MapOptions(
                                    backgroundColor: Theme.of(
                                      context,
                                    ).scaffoldBackgroundColor,
                                    initialCenter: LatLng(
                                      -8.409518,
                                      115.188919,
                                    ),
                                    initialZoom: 9,
                                    interactionOptions:
                                        const InteractionOptions(
                                          flags: InteractiveFlag.none,
                                        ),
                                    initialCameraFit: CameraFit.bounds(
                                      bounds: LatLngBounds.fromPoints(
                                        controller.wilayah
                                            .expand(
                                              (p) => p.points,
                                            ) // ambil semua titik dari polygon list
                                            .toList(),
                                      ),
                                      padding: const EdgeInsets.all(
                                        30,
                                      ), // beri jarak dari tepi layar
                                    ),
                                    onTap: (tapPosition, point) {},
                                  ),
                                  children: [
                                    TileLayer(
                                      urlTemplate:
                                          'https://tiles.maphill.com/indonesia/bali/simple-maps/blank-map/no-labels/{z}-{x}-{y}.png',
                                      subdomains: ['a', 'b', 'c', 'd'],
                                      tileProvider:
                                          CancellableNetworkTileProvider(),
                                      userAgentPackageName: 'com.example.app',
                                    ),
                                    PolygonLayer(
                                      polygons: [...controller.wilayah],
                                    ),

                                    // 🧭 marker + popup statis
                                    MarkerLayer(
                                      markers: controller.listSpamSummary
                                          .where((c) => c.latitude != null)
                                          .toList()
                                          .map((m) {
                                            return Marker(
                                              point: LatLng(
                                                m.latitude!,
                                                m.longitude!,
                                              ),
                                              width: 150,
                                              height: 80,
                                              alignment: Alignment.topCenter,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(
                                                        context,
                                                      ).cardColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                      boxShadow: const [
                                                        BoxShadow(
                                                          color: Colors.black26,
                                                          blurRadius: 4,
                                                          offset: Offset(0, 2),
                                                        ),
                                                      ],
                                                    ),
                                                    child: BaseText(
                                                      label: m.namaSPam,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                  const Icon(
                                                    Icons.location_on,
                                                    color: Colors.red,
                                                    size: 24,
                                                  ),
                                                ],
                                              ),
                                            );
                                          })
                                          .toList(),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                    const Gap(10),
                    Container(
                      width: 500,
                      height: double.infinity,
                      padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 2,
                          color: Theme.of(
                            context,
                          ).textTheme.bodySmall!.color!.withOpacity(0.4),
                        ),
                      ),
                      child: Obx(
                        () => SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.info_outline_rounded, size: 20),
                                  const Gap(5),
                                  BaseText(
                                    label: "SPAM SUMMARY",
                                    fontWeight: FontWeight.w700,
                                    size: 16,
                                  ),
                                ],
                              ),
                              const Gap(20),
                              if (controller.listSpamSummary.isNotEmpty)
                                MasonryView(
                                  listOfItem: controller.listSpamSummary
                                      .toList(),
                                  numberOfColumn: 2,
                                  itemPadding: 4,
                                  itemRadius: 0,
                                  itemBuilder: (item) {
                                    var data = item as SpamSummaryModel;
                                    return InkWell(
                                      onTap: () {
                                        context.goNamed("map");
                                      },
                                      child: Container(
                                        width: 220,
                                        padding: const EdgeInsets.fromLTRB(
                                          10,
                                          10,
                                          10,
                                          20,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          color: buttonGreenColor.withOpacity(
                                            0.05,
                                          ),
                                          border: Border.all(
                                            width: 1.5,
                                            color: Theme.of(
                                              context,
                                            ).textTheme.bodySmall!.color!,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            BaseText(
                                              label: data.namaSPam,
                                              fontWeight: FontWeight.w700,
                                              color: fontBlueString,
                                            ),
                                            const Gap(10),

                                            const BaseDivider(),
                                            BaseTextSecondary(
                                              label: "Totalizer (Mingguan)",
                                            ),
                                            BaseText(
                                              label: formatAngkaIndonesia(
                                                data.totalizerMingguIni!,
                                              ),
                                              fontWeight: FontWeight.w700,
                                            ),
                                            const BaseDivider(),
                                            BaseTextSecondary(
                                              label: "Totalizer (Bulanan)",
                                            ),
                                            BaseText(
                                              label: formatAngkaIndonesia(
                                                data.totalizerBulanIni!,
                                              ),
                                              fontWeight: FontWeight.w700,
                                            ),
                                            const BaseDivider(),
                                            BaseTextSecondary(label: "Tekanan"),
                                            BaseText(
                                              label:
                                                  "${formatAngkaIndonesia(data.tekanan!)} Bar",
                                              fontWeight: FontWeight.w700,
                                            ),
                                            if (data.latitude == null)
                                              const Gap(10),
                                            if (data.latitude == null)
                                              Container(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                      10,
                                                      3,
                                                      10,
                                                      3,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.yellow
                                                      .withOpacity(0.2),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: BaseText(
                                                  label:
                                                      "Titik Lokasi Belum Ada",
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
