
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

Widget build_Icon() {
  return InkWell(
    onTap: () {
      // Xử lý khi nhấn vào Icon
    },
    child: Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Mô tả hoặc thông tin khác',
            style: TextStyle(fontSize: 12),
          ),
          Image.asset(
            'lib/src/assets/images/pin-yellow-big.png',
            width: 50,
            height: 50,
          ),
        ],
      ),
    ),
  );
}