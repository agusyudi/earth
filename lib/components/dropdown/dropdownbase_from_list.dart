import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../cores/color.dart';
import '../../services/drop_down_service.dart';
import '../text/text.dart';
import '../text/text_hint.dart';
import '../text/text_secondary.dart';

class BaseDropDownFromList extends StatefulWidget {
  const BaseDropDownFromList({
    super.key,
    this.selectedValue,
    this.onChanged,
    required this.data,
    required this.readOnly,
    this.title,
    this.extensionParam,
    this.height = 39,
    this.showDefaultValueSemua = false,
    this.labelDefaultValueSemua = "Semua",
    this.checkbox,
    this.hint,
    this.isRequired = false,
  });

  final String? title;
  final List<DropDownHelperResponse> data;
  final String? selectedValue;
  final Function(DropDownHelperResponse?)? onChanged;
  final bool readOnly;
  final Map<String, dynamic>? extensionParam;
  final double? height;
  final bool? showDefaultValueSemua;
  final String? labelDefaultValueSemua;
  final Checkbox? checkbox;
  final String? hint;
  final bool? isRequired;

  @override
  State<BaseDropDownFromList> createState() => _BaseDropDownFromListState();
}

class _BaseDropDownFromListState extends State<BaseDropDownFromList> {
  var isLoading = false;
  List<DropDownHelperResponse> listData = [];
  var textController = TextEditingController();

  Future get() async {
    setState(() {
      isLoading = true;
    });
    listData = [];

    if (widget.showDefaultValueSemua == true) {
      listData.add(
        DropDownHelperResponse(
          value: "",
          label: widget.labelDefaultValueSemua.toString(),
        ),
      );
    }

    listData.addAll(widget.data);

    isLoading = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.title == null
            ? const SizedBox()
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      widget.checkbox == null
                          ? const SizedBox()
                          : SizedBox(width: 20, child: widget.checkbox),
                      widget.checkbox == null ? const SizedBox() : const Gap(5),
                      BaseText(label: widget.title!),
                      isLoading == true
                          ? Row(
                              children: [
                                const Gap(5),
                                LoadingAnimationWidget.fourRotatingDots(
                                  color: buttonBlueColor,
                                  size: 13,
                                ),
                              ],
                            )
                          : const SizedBox(),
                    ],
                  ),
                  widget.isRequired == false
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
        Row(
          children: [
            Expanded(
              child: IgnorePointer(
                ignoring: widget.readOnly,
                child: SizedBox(
                  height: widget.height,
                  child: DropdownButtonFormField2<DropDownHelperResponse>(
                    value:
                        widget.selectedValue == null ||
                            (widget.checkbox != null &&
                                widget.checkbox!.value == false)
                        ? null
                        : isLoading == true
                        ? null
                        : listData.firstWhere(
                            (c) => c.value == widget.selectedValue,
                          ),
                    isExpanded: true,
                    menuItemStyleData: const MenuItemStyleData(height: 40),
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 300,
                      decoration: BoxDecoration(
                        color: Theme.of(context).focusColor,
                      ),
                      useSafeArea: true,
                    ),
                    barrierColor: Colors.black38,
                    hint: isLoading == true
                        ? null
                        : widget.hint == null
                        ? BaseTextHint(label: "Pilih ${widget.title}")
                        : BaseTextHint(label: "${widget.hint}"),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(0),
                      fillColor: widget.readOnly == false
                          ? Theme.of(context).focusColor
                          : Theme.of(context).disabledColor,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(2),
                        ),
                        borderSide: BorderSide(
                          width: 1,
                          color: Theme.of(
                            context,
                          ).textTheme.bodySmall!.color!.withOpacity(0.35),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(2),
                        ),
                        borderSide: BorderSide(
                          width: 1,
                          color: Theme.of(
                            context,
                          ).textTheme.bodySmall!.color!.withOpacity(0.35),
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(2)),
                        borderSide: BorderSide(color: Colors.blue, width: 3.5),
                      ),
                    ),
                    onChanged: widget.onChanged,
                    items: List.generate(
                      listData.length,
                      (index) => DropdownMenuItem<DropDownHelperResponse>(
                        value: listData[index],
                        child:
                            listData[index].sublabel.toString().trim() != "" &&
                                listData[index].sublabel != null &&
                                listData[index].sublabel !=
                                    listData[index].label
                            ? Row(
                                children: [
                                  BaseText(
                                    fontWeight: FontWeight.w500,
                                    label: listData[index].label.toString(),
                                  ),
                                  const Gap(5),
                                  const Icon(
                                    Icons.keyboard_arrow_right_outlined,
                                    size: 12,
                                  ),
                                  const Gap(5),
                                  BaseTextSecondary(
                                    label: listData[index].sublabel.toString(),
                                  ),
                                ],
                              )
                            : BaseText(
                                fontWeight: FontWeight.w500,
                                label: listData[index].label.toString(),
                              ),
                      ),
                    ),
                    onMenuStateChange: (isOpen) {
                      if (!isOpen) {
                        textController.clear();
                      }
                    },
                    dropdownSearchData: DropdownSearchData(
                      searchController: textController,
                      searchInnerWidgetHeight: 55,
                      searchInnerWidget: Container(
                        height: 55,
                        padding: const EdgeInsets.all(4),
                        child: TextFormField(
                          expands: true,
                          maxLines: null,
                          controller: textController,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            color: Theme.of(
                              context,
                            ).textTheme.bodyMedium!.color,

                            fontSize: 12.5,
                          ),
                          decoration: InputDecoration(
                            isDense: true,
                            fillColor: Theme.of(context).focusColor,
                            filled: true,
                            contentPadding: const EdgeInsets.fromLTRB(
                              8,
                              0,
                              8,
                              0,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(2),
                              ),
                              borderSide: BorderSide(
                                color: Theme.of(context).shadowColor,
                                width: 1,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(2),
                              ),
                              borderSide: BorderSide(
                                color: Theme.of(context).shadowColor,
                                width: 1,
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(2),
                              ),
                              borderSide: BorderSide(
                                color: Colors.blue,
                                width: 3.5,
                              ),
                            ),
                            suffixIcon: const Icon(Icons.search_outlined),
                            hintText: "Cari Data..",
                            hintStyle: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              color: Theme.of(
                                context,
                              ).textTheme.bodyMedium!.color!.withOpacity(0.5),

                              fontSize: 12.5,
                            ),
                          ),
                        ),
                      ),
                      searchMatchFn: (item, searchValue) {
                        var string = "";

                        if (item.value!.sublabel == null) {
                          string = item.value!.label;
                        } else {
                          string =
                              "${item.value!.label} ${item.value!.sublabel}";
                        }

                        return string.toString().toLowerCase().contains(
                          searchValue.toLowerCase(),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            widget.title == null && isLoading == true
                ? Row(
                    children: [
                      const Gap(10),
                      LoadingAnimationWidget.fourRotatingDots(
                        color: buttonBlueColor,
                        size: 18,
                      ),
                    ],
                  )
                : const SizedBox(),
          ],
        ),
      ],
    );
  }
}
