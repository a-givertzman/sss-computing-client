import 'package:flutter/material.dart';
///
enum FreightContainerPort {
  MURMANSK('MURMANSK', 'RUMMK', Color(0xffE879F9)),
  ST_PETERSBURG('ST_PETERSBURG', 'RULED', Color(0xff34495E)),
  ARKHANGELSK('ARKHANGELSK', 'RUARH', Color(0xffAA00FF)),
  ASTRAKHAN('ASTRAKHAN', 'RUASF', Color(0xff60A917)),
  AZOV('AZOV', 'RUAZO', Color(0xffE74C3C));
  //
  final String name;
  //
  final String code;
  //
  final Color color;
  ///
  const FreightContainerPort(this.name, this.code, this.color);
}
