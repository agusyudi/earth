import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/diameter_aksesoris/diameter_aksesoris_page.dart';
import '../features/jenis_aksesoris/jenis_aksesoris_page.dart';
import '../features/jenis_pipa/jenis_pipa_page.dart';
import '../features/kondisi_pipa/kondisi_pipa_page.dart';
import '../features/map/map_page.dart';
import '../features/pipa/pipa_page.dart';
import '../features/status_pipa/status_pipa_page.dart';
import '../features/summary/summary_page.dart';
import '../features/ukuran_pipa/ukuran_pipa_page.dart';
import '../main.dart';

class BaseRouter {
  List<RouteBase> routes = [];
  GoRouter getRouter() {
    return GoRouter(
      navigatorKey: navigatorKey,
      initialLocation: '/summary',
      routerNeglect: false,
      debugLogDiagnostics: true,

      routes: [
        GoRoute(
          path: '/summary',
          name: 'summary',
          pageBuilder: (context, state) {
            return MaterialPage(child: SummaryPage());
          },
        ),
        GoRoute(
          path: '/map',
          name: 'map',
          pageBuilder: (context, state) {
            return MaterialPage(child: MapPage());
          },
        ),
        GoRoute(
          path: '/list-pipa',
          name: 'list-pipa',
          pageBuilder: (context, state) {
            return MaterialPage(child: PipaPage());
          },
        ),
        GoRoute(
          path: '/jenis-pipa',
          name: 'jenis-pipa',
          pageBuilder: (context, state) {
            return MaterialPage(child: JenisPipaPage());
          },
        ),
        GoRoute(
          path: '/kondisi-pipa',
          name: 'kondisi-pipa',
          pageBuilder: (context, state) {
            return MaterialPage(child: KondisiPipaPage());
          },
        ),
        GoRoute(
          path: '/ukuran-pipa',
          name: 'ukuran-pipa',
          pageBuilder: (context, state) {
            return MaterialPage(child: UkuranPipaPage());
          },
        ),
        GoRoute(
          path: '/status-pipa',
          name: 'status-pipa',
          pageBuilder: (context, state) {
            return MaterialPage(child: StatusPipaPage());
          },
        ),
        GoRoute(
          path: '/jenis-aksesoris',
          name: 'jenis-aksesoris',
          pageBuilder: (context, state) {
            return MaterialPage(child: JenisAksesorisPage());
          },
        ),
        GoRoute(
          path: '/diameter-aksesoris',
          name: 'diameter-aksesoris',
          pageBuilder: (context, state) {
            return MaterialPage(child: DiameterAksesorisPage());
          },
        ),
      ],
    );
  }
}
