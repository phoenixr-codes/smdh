import 'dart:io';
import 'dart:typed_data';
import 'package:smdh/smdh.dart';

void main() async {
  final data = await File('pixel_city.smdh').readAsBytes();
  final smdh = Smdh.parse(ByteData.sublistView(data));
  print(smdh);
}
