import 'package:get/get.dart';
import 'package:getiks/controllers/assets_controller.dart';
import 'package:getiks/services/http_service.dart';

Future<void> registerServices() async{
  Get.put(HTTPservice());
}

Future<void> registerController() async{
  Get.put(AssetsController());
}

String getCryptoImageURL(String name ){
 return "https://raw.githubusercontent.com/ErikThiart/cryptocurrency-icons/master/128/${name.toLowerCase()}.png";
}