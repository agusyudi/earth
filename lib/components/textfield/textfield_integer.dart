import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:number_text_input_formatter/number_text_input_formatter.dart';
import '../text/text.dart';
import '../text/text_secondary.dart';

class BaseTextFieldInteger extends StatelessWidget {
  const BaseTextFieldInteger({
    super.key,
    this.label,
    required this.controller,
    this.hint,
    this.icon,
    this.hiddenText,
    this.onChange,
    this.useobscureText = false,
    this.onObscureFunc,
    this.checkbox,
    this.readOnly = false,
    this.height = 39,
    this.focusNode,
    this.showHint = true,
    this.onEditingComplete,
    this.onTapOutside,
    this.isRequired = false,
    this.maxLine = 1,
  });

  final String? label;
  final TextEditingController controller;
  final String? hint;
  final Icon? icon;
  final bool? useobscureText;
  final bool? hiddenText;
  final Function(dynamic value)? onChange;
  final Function()? onEditingComplete;
  final Function()? onObscureFunc;
  final bool? showHint;
  final Checkbox? checkbox;
  final bool? readOnly;
  final double? height;
  final FocusNode? focusNode;
  final Function(PointerDownEvent)? onTapOutside;
  final bool? isRequired;
  final int? maxLine;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label == null
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        checkbox == null
                            ? const SizedBox()
                            : SizedBox(width: 20, child: checkbox),
                        checkbox == null ? const SizedBox() : const Gap(5),
                        BaseText(label: label!),
                      ],
                    ),
                    isRequired == false
                        ? const SizedBox()
                        : Container(
                            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                            decoration: BoxDecoration(
                              color: const Color(0xffC30C0C),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Center(
                              child: BaseTextSecondary(
                                label: "Wajib diisi",
                                color: "ffffff",
                                size: 11,
                              ),
                            ),
                          ),
                  ],
                ),
              ),
        IgnorePointer(
          ignoring: readOnly == true ? true : false,
          child: SizedBox(
            height: height,
            child: TextFormField(
              focusNode: focusNode ?? FocusNode(),
              maxLines: maxLine,
              textAlign: TextAlign.end,
              onChanged: onChange,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).textTheme.bodyMedium!.color,
              ),
              controller:
                  checkbox != null &&
                      checkbox!.value == false &&
                      showHint == true
                  ? TextEditingController()
                  : controller,
              onEditingComplete: onEditingComplete,
              onTapOutside: onTapOutside,
              obscureText: hiddenText == true ? true : false,
              keyboardType: TextInputType.number,
              inputFormatters: [
                NumberTextInputFormatter(
                  integerDigits: 10,
                  decimalDigits: 0,
                  maxValue: '1000000000.00',
                  allowNegative: false,
                  overrideDecimalPoint: true,
                  insertDecimalPoint: false,
                  insertDecimalDigits: true,
                ),
              ],
              decoration: InputDecoration(
                contentPadding: (maxLine ?? 1) > 1
                    ? const EdgeInsets.fromLTRB(20, 15, 20, 15)
                    : const EdgeInsets.fromLTRB(20, 0, 20, 0),
                fillColor: readOnly == false
                    ? Theme.of(context).focusColor
                    : Theme.of(context).disabledColor,
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  borderSide: BorderSide(
                    width: 1,
                    color: Theme.of(
                      context,
                    ).textTheme.bodySmall!.color!.withOpacity(0.35),
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  borderSide: BorderSide(
                    width: 1,
                    color: Theme.of(
                      context,
                    ).textTheme.bodySmall!.color!.withOpacity(0.35),
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  borderSide: BorderSide(color: Colors.blue, width: 3.5),
                ),
                prefixIcon: icon,
                hintText: showHint == true && label != null
                    ? hint ?? "Masukkan ${label!.toLowerCase()}"
                    : null,
                hintStyle: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.color!.withOpacity(0.3),
                  fontSize: 12,
                ),
                filled: true,
                suffixIcon: useobscureText == false
                    ? null
                    : IconButton(
                        icon: Icon(
                          hiddenText == true
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: onObscureFunc,
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
