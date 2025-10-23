import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import '../../cores/constant.dart';
import '../../cores/decoration.dart';
import '../../cores/theme/theme_service.dart';
import '../text/text.dart';
import '../text/text_secondary.dart';

class BasePage extends StatefulWidget {
  const BasePage({
    super.key,
    required this.page,
    this.backgroundcolor,
    this.rigthPanel,
    this.centerPanel,
    this.centerPanelUseBorder = true,
    this.centerPanelFree,
    this.enableLayoutBuilder = true,
  });

  final String page;
  final Color? backgroundcolor;
  final Widget? centerPanel;
  final bool? centerPanelUseBorder;
  final Widget? rigthPanel;
  final Widget? centerPanelFree;
  final bool? enableLayoutBuilder;

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.enableLayoutBuilder == true
        ? LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth <= 1000) {
                if (constraints.maxHeight <= 600) {
                  return SafeArea(
                    child: Scaffold(
                      backgroundColor:
                          widget.backgroundcolor ??
                          Theme.of(context).scaffoldBackgroundColor,
                      resizeToAvoidBottomInset: true,
                      body: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: 1200,
                            height: 600,
                            child: body,
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return SafeArea(
                  child: Scaffold(
                    backgroundColor:
                        widget.backgroundcolor ??
                        Theme.of(context).scaffoldBackgroundColor,
                    resizeToAvoidBottomInset: true,
                    body: ListView(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      children: [SizedBox(width: 1200, child: body)],
                    ),
                  ),
                );
              } else {
                return SafeArea(
                  child: Scaffold(
                    backgroundColor:
                        widget.backgroundcolor ??
                        Theme.of(context).scaffoldBackgroundColor,
                    resizeToAvoidBottomInset: true,
                    body: body,
                  ),
                );
              }
            },
          )
        : SafeArea(
            child: Scaffold(
              backgroundColor:
                  widget.backgroundcolor ??
                  Theme.of(context).scaffoldBackgroundColor,
              resizeToAvoidBottomInset: true,
              body: body,
            ),
          );
  }

  Row get body {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [leftPanel, widget.centerPanelFree ?? centerPanel, rightPanel],
    );
  }

  Container get leftPanel {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          right: BorderSide(
            color: Theme.of(
              context,
            ).textTheme.bodyMedium!.color!.withOpacity(0.1),
            width: 1,
          ),
        ),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 60,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Container(
                //   margin: const EdgeInsets.only(right: 8),
                //   child: const Image(
                //     image: AssetImage('assets/images/loket_logo.png'),
                //     height: 60,
                //   ),
                // ),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BaseText(label: "Dashboard", size: 12),
                    BaseText(
                      label: "GIS",
                      fontWeight: FontWeight.w700,
                      size: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Gap(10),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      context.goNamed('summary');
                    },
                    child: Container(
                      height: 28,
                      decoration: widget.page == "summary"
                          ? selectedMenuDecoration(context)
                          : null,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 45,
                            height: 20,
                            child: SvgPicture.asset(
                              "assets/images/map.svg",
                              color: widget.page == "summary"
                                  ? Colors.white
                                  : Theme.of(
                                      context,
                                    ).textTheme.bodySmall!.color,
                            ),
                          ),
                          BaseText(
                            label: "Summary",
                            color: widget.page == "summary" ? "#ffffff" : "",
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Gap(10),
                  InkWell(
                    onTap: () {
                      context.goNamed('map');
                    },
                    child: Container(
                      height: 28,
                      decoration: widget.page == "map"
                          ? selectedMenuDecoration(context)
                          : null,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 45,
                            height: 20,
                            child: SvgPicture.asset(
                              "assets/images/map.svg",
                              color: widget.page == "map"
                                  ? Colors.white
                                  : Theme.of(
                                      context,
                                    ).textTheme.bodySmall!.color,
                            ),
                          ),
                          BaseText(
                            label: "Peta",
                            color: widget.page == "map" ? "#ffffff" : "",
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Gap(10),
                  ExpansionTile(
                    shape: LinearBorder.none,
                    tilePadding: const EdgeInsets.all(0),
                    childrenPadding: const EdgeInsets.all(0),
                    minTileHeight: 0,
                    initiallyExpanded:
                        widget.page == "list-pipa" ||
                            widget.page == "jenis-pipa" ||
                            widget.page == "kondisi-pipa" ||
                            widget.page == "ukuran-pipa" ||
                            widget.page == "status-pipa"
                        ? true
                        : false,
                    title: SizedBox(
                      height: 20,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 45,
                            height: 20,
                            child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: SvgPicture.asset(
                                "assets/images/pipa.svg",
                                color: Theme.of(
                                  context,
                                ).textTheme.bodySmall!.color,
                              ),
                            ),
                          ),
                          const BaseText(label: "Pipa"),
                        ],
                      ),
                    ),
                    children: [
                      InkWell(
                        onTap: () {
                          context.goNamed('list-pipa');
                        },
                        child: Container(
                          height: 28,
                          decoration: widget.page == "list-pipa"
                              ? selectedMenuDecoration(context)
                              : null,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 45,
                                child: SvgPicture.asset(
                                  "assets/images/right-arrow.svg",
                                  color: widget.page == "list-pipa"
                                      ? Colors.white
                                      : Theme.of(
                                          context,
                                        ).textTheme.bodySmall!.color,
                                ),
                              ),
                              BaseText(
                                label: "Daftar Pipa",
                                color: widget.page == "list-pipa"
                                    ? "#ffffff"
                                    : "",
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Gap(10),
                      InkWell(
                        onTap: () {
                          context.goNamed('jenis-pipa');
                        },
                        child: Container(
                          height: 28,
                          decoration: widget.page == "jenis-pipa"
                              ? selectedMenuDecoration(context)
                              : null,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 45,
                                child: SvgPicture.asset(
                                  "assets/images/right-arrow.svg",
                                  color: widget.page == "jenis-pipa"
                                      ? Colors.white
                                      : Theme.of(
                                          context,
                                        ).textTheme.bodySmall!.color,
                                ),
                              ),
                              BaseText(
                                label: "Jenis Pipa",
                                color: widget.page == "jenis-pipa"
                                    ? "#ffffff"
                                    : "",
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Gap(10),
                      InkWell(
                        onTap: () {
                          context.goNamed('kondisi-pipa');
                        },
                        child: Container(
                          height: 28,
                          decoration: widget.page == "kondisi-pipa"
                              ? selectedMenuDecoration(context)
                              : null,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 45,
                                child: SvgPicture.asset(
                                  "assets/images/right-arrow.svg",
                                  color: widget.page == "kondisi-pipa"
                                      ? Colors.white
                                      : Theme.of(
                                          context,
                                        ).textTheme.bodySmall!.color,
                                ),
                              ),
                              BaseText(
                                label: "Kondisi Pipa",
                                color: widget.page == "kondisi-pipa"
                                    ? "#ffffff"
                                    : "",
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Gap(10),
                      InkWell(
                        onTap: () {
                          context.goNamed('ukuran-pipa');
                        },
                        child: Container(
                          height: 28,
                          decoration: widget.page == "ukuran-pipa"
                              ? selectedMenuDecoration(context)
                              : null,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 45,
                                child: SvgPicture.asset(
                                  "assets/images/right-arrow.svg",
                                  color: widget.page == "ukuran-pipa"
                                      ? Colors.white
                                      : Theme.of(
                                          context,
                                        ).textTheme.bodySmall!.color,
                                ),
                              ),
                              BaseText(
                                label: "Ukuran Pipa",
                                color: widget.page == "ukuran-pipa"
                                    ? "#ffffff"
                                    : "",
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Gap(10),
                      InkWell(
                        onTap: () {
                          context.goNamed('status-pipa');
                        },
                        child: Container(
                          height: 28,
                          decoration: widget.page == "status-pipa"
                              ? selectedMenuDecoration(context)
                              : null,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 45,
                                child: SvgPicture.asset(
                                  "assets/images/right-arrow.svg",
                                  color: widget.page == "status-pipa"
                                      ? Colors.white
                                      : Theme.of(
                                          context,
                                        ).textTheme.bodySmall!.color,
                                ),
                              ),
                              BaseText(
                                label: "Status Pipa",
                                color: widget.page == "status-pipa"
                                    ? "#ffffff"
                                    : "",
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Gap(10),
                    ],
                  ),
                  const Gap(10),
                  ExpansionTile(
                    shape: LinearBorder.none,
                    tilePadding: const EdgeInsets.all(0),
                    childrenPadding: const EdgeInsets.all(0),
                    minTileHeight: 0,
                    initiallyExpanded:
                        widget.page == "list-aksesoris" ||
                            widget.page == "jenis-aksesoris" ||
                            widget.page == "diameter-aksesoris"
                        ? true
                        : false,
                    title: SizedBox(
                      height: 20,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 45,
                            height: 20,
                            child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: SvgPicture.asset(
                                "assets/images/pin-acc.svg",
                                color: Theme.of(
                                  context,
                                ).textTheme.bodySmall!.color,
                              ),
                            ),
                          ),
                          const BaseText(label: "Aksesoris"),
                        ],
                      ),
                    ),
                    children: [
                      InkWell(
                        onTap: () {
                          context.goNamed('list-aksesoris');
                        },
                        child: Container(
                          height: 28,
                          decoration: widget.page == "list-aksesoris"
                              ? selectedMenuDecoration(context)
                              : null,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 45,
                                child: SvgPicture.asset(
                                  "assets/images/right-arrow.svg",
                                  color: widget.page == "list-aksesoris"
                                      ? Colors.white
                                      : Theme.of(
                                          context,
                                        ).textTheme.bodySmall!.color,
                                ),
                              ),
                              BaseText(
                                label: "Daftar Aksesoris",
                                color: widget.page == "list-aksesoris"
                                    ? "#ffffff"
                                    : "",
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Gap(10),
                      InkWell(
                        onTap: () {
                          context.goNamed('jenis-aksesoris');
                        },
                        child: Container(
                          height: 28,
                          decoration: widget.page == "jenis-aksesoris"
                              ? selectedMenuDecoration(context)
                              : null,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 45,
                                child: SvgPicture.asset(
                                  "assets/images/right-arrow.svg",
                                  color: widget.page == "jenis-aksesoris"
                                      ? Colors.white
                                      : Theme.of(
                                          context,
                                        ).textTheme.bodySmall!.color,
                                ),
                              ),
                              BaseText(
                                label: "Jenis Aksesoris",
                                color: widget.page == "jenis-aksesoris"
                                    ? "#ffffff"
                                    : "",
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Gap(10),
                      InkWell(
                        onTap: () {
                          context.goNamed('diameter-aksesoris');
                        },
                        child: Container(
                          height: 28,
                          decoration: widget.page == "diameter-aksesoris"
                              ? selectedMenuDecoration(context)
                              : null,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 45,
                                child: SvgPicture.asset(
                                  "assets/images/right-arrow.svg",
                                  color: widget.page == "diameter-aksesoris"
                                      ? Colors.white
                                      : Theme.of(
                                          context,
                                        ).textTheme.bodySmall!.color,
                                ),
                              ),
                              BaseText(
                                label: "Diameter Aksesoris",
                                color: widget.page == "diameter-aksesoris"
                                    ? "#ffffff"
                                    : "",
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Gap(10),
                    ],
                  ),
                ],
              ),
            ),
          ),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        themeService.isDarkMode == true
                            ? Icons.dark_mode
                            : Icons.light_mode,
                        color: Theme.of(context).textTheme.bodyMedium!.color!,
                        size: 15,
                      ),
                      BaseText(
                        label: themeService.isDarkMode == true
                            ? "Tema Gelap "
                            : "Tema Terang",
                      ),
                      SizedBox(
                        height: 20,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Switch(
                            trackOutlineColor: WidgetStatePropertyAll(
                              Theme.of(context).shadowColor.withOpacity(0.3),
                            ),
                            value: themeService.isDarkMode == true,
                            onChanged: (value) => themeService.toggleTheme(),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const Gap(10),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return BaseTextSecondary(
                  size: 11,
                  useEllipsis: false,
                  label:
                      "Versi Aplikasi ${snapshot.data!.version} ${env.toLowerCase() == "production" ? "" : env.capitalizeFirst}",
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget get rightPanel {
    return widget.rigthPanel == null
        ? const SizedBox()
        : Container(margin: const EdgeInsets.all(8), child: widget.rigthPanel);
  }

  Expanded get centerPanel {
    return Expanded(
      child: Container(
        decoration: widget.centerPanelUseBorder == true
            ? BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(2),
              )
            : null,
        child: Column(
          children: [
            Expanded(
              child: SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: widget.centerPanel,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
