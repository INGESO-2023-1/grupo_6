import 'package:carousel_slider/carousel_slider.dart';
import 'package:chattify/theme/color.dart';
import 'package:chattify/widgets/group_box.dart';
import 'package:flutter/material.dart';

class GroupSlider extends StatelessWidget {
  const GroupSlider({Key? key, this.onChanged, required this.cant})
      : super(key: key);
  final Function(int, CarouselPageChangedReason)? onChanged;
  final int cant;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 230,
        enlargeCenterPage: true,
        // disableCenter: true,
        viewportFraction: .7,
        onPageChanged: onChanged,
      ),
      items: List.generate(
          cant,
          (index) => GroupBox(
                bgColor: itemColors[index % 10],
                onTap: () {},
              )),
    );
  }
}
