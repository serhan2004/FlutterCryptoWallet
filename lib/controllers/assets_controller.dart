import 'dart:convert';

import 'package:get/get.dart';
import 'package:getiks/models/api_response.dart';
import 'package:getiks/models/coin_data.dart';
import 'package:getiks/models/tracked_asset.dart';
import 'package:getiks/services/http_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AssetsController extends GetxController{
  RxList<CoinData>  coindata = <CoinData>[].obs;
  RxBool loading  = false.obs;
  RxList<TrackedAsset> trackedAssets = <TrackedAsset>[].obs;
  @override
  void onInit() {
    super.onInit();
    _getAssets();
    _loadTrackedAssetsFromStorage();
  }
  void addTrackedAsset(String name , double amount)async{
     trackedAssets.add(TrackedAsset(
      name: name,
      amount: amount, 
     ));
      List<String> data = trackedAssets.map((asset) => jsonEncode(asset)).toList();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setStringList("tracked_assets", data);
       
  }

  void _loadTrackedAssetsFromStorage()async{
final SharedPreferences prefs = await SharedPreferences.getInstance();
 List<String>? data =  prefs.getStringList("tracked_assets");
 if(data != null){
  trackedAssets.value = data.map((e) => TrackedAsset.fromJson(jsonDecode(e))).toList();
 }
  }
  double getPortFolioValue(){
    if(coindata.value.isEmpty){
      return 0;
    }
    if(trackedAssets.isEmpty){
      return  0;
    }
    double value = 0;
    for(TrackedAsset asset in trackedAssets ){
      value += getAssetPrice(asset.name!) !* asset.amount!;
    }
    return value;
  }
  Future<void> _getAssets() async{
    loading.value = true;
    HTTPservice httPservice = Get.find();
    var responseData = await httPservice.get("currencies");
    CurrenciesListAPIResponse currenciesListAPIResponse = CurrenciesListAPIResponse.fromJson(responseData);
    coindata.value = currenciesListAPIResponse.data ?? [];
    loading.value = false;
  }
  double? getAssetPrice(String name){
    CoinData? data = getCoinData(name);
    return data?.values?.uSD?.price?.toDouble() ?? 0;
  }
  CoinData? getCoinData(String name){
    return coindata.firstWhereOrNull((element) => element.name == name);;
  } 
}