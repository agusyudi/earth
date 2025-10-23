import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../cores/color.dart';
import '../text/text.dart';

class BaseDialog {
  final numberFormat = NumberFormat("##,##0", "id_ID");

  Future showAlertDialog(
    BuildContext context,
    String title,
    String message,
  ) async {
    return await showDialog(
      useSafeArea: true,
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black87.withOpacity(0.3),
      builder: (BuildContext context) {
        cancel() async {
          Navigator.of(context).pop();
        }

        return CallbackShortcuts(
          bindings: <ShortcutActivator, VoidCallback>{
            const SingleActivator(LogicalKeyboardKey.escape): () async {
              await cancel();
            },
            const SingleActivator(LogicalKeyboardKey.enter): () async {
              await cancel();
            },
          },
          child: Focus(
            autofocus: true,
            child: AlertDialog(
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: gisColor, width: 0.8),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              scrollable: true,
              titlePadding: const EdgeInsets.all(0),
              contentPadding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
              title: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: gisColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(2),
                    topLeft: Radius.circular(2),
                  ),
                ),
                child: BaseText(
                  label: title,
                  fontWeight: FontWeight.w500,
                  color: "#ffffff",
                ),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Center(
                      child: BaseText(
                        label: message,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Gap(14),
                  ],
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        cancel();
                      },
                      child: Container(
                        height: 35,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).textTheme.bodyMedium!.color!,
                            width: 1.2,
                          ),
                        ),
                        child: const Center(child: BaseText(label: "OK")),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future snackBarWarning(BuildContext context, String message) async {
    return AnimatedSnackBar(
      desktopSnackBarPosition: DesktopSnackBarPosition.topRight,
      duration: const Duration(seconds: 3),
      animationDuration: const Duration(milliseconds: 0),
      builder: ((context) {
        return MaterialAnimatedSnackBar(
          messageText: message,
          type: AnimatedSnackBarType.warning,
          borderRadius: BorderRadius.circular(10),
          messageTextStyle: GoogleFonts.inter(
            fontSize: 12.5,
            color: Colors.white,
          ),
        );
      }),
    ).show(context);
  }

  Future snackBarError(BuildContext context, String message) async {
    return AnimatedSnackBar(
      desktopSnackBarPosition: DesktopSnackBarPosition.topRight,
      duration: const Duration(seconds: 3),
      animationDuration: const Duration(milliseconds: 0),
      builder: ((context) {
        return MaterialAnimatedSnackBar(
          messageText: message,
          type: AnimatedSnackBarType.error,
          borderRadius: BorderRadius.circular(10),
          messageTextStyle: GoogleFonts.inter(
            fontSize: 12.5,
            color: Colors.white,
          ),
        );
      }),
    ).show(context);
  }

  Future snackBarSuccess(BuildContext context, String message) async {
    return AnimatedSnackBar(
      desktopSnackBarPosition: DesktopSnackBarPosition.topRight,
      duration: const Duration(seconds: 3),
      animationDuration: const Duration(milliseconds: 0),
      builder: ((context) {
        return MaterialAnimatedSnackBar(
          messageText: message,
          type: AnimatedSnackBarType.success,
          borderRadius: BorderRadius.circular(10),
          messageTextStyle: GoogleFonts.inter(
            fontSize: 12.5,
            color: Colors.white,
          ),
        );
      }),
    ).show(context);
  }
}
