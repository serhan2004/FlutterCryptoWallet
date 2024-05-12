import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/state_manager.dart';
import 'package:getiks/controllers/assets_controller.dart';
import 'package:getiks/models/api_response.dart';
import 'package:getiks/services/http_service.dart';

class AddAssetDialogController extends GetxController {
  RxDouble assetValue = 0.0.obs;
  RxList assets = <String>[].obs;
  RxBool loading = false.obs;
  RxString selectedAsset = "".obs;
  @override
  void onInit() {
    super.onInit();
    _getassets();
  }

  Future<void> _getassets() async {
    loading.value = true;
    HTTPservice httPservice = Get.find<HTTPservice>();
    var responseData = await httPservice.get("currencies");
    CurrenciesListAPIResponse currenciesListAPIResponse =
        CurrenciesListAPIResponse.fromJson(responseData);
        currenciesListAPIResponse.data?.forEach((coin) { 
          assets.add(
            coin.name
          );
        });
        selectedAsset.value = assets.first;
    loading.value = false;
  }
}

class AddAssetDialog extends StatelessWidget {
  final controller = Get.put(AddAssetDialogController());

  AddAssetDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Center(
        child: Material(
          child: Container(
            height: MediaQuery.sizeOf(context).height * 0.40,
            width: MediaQuery.sizeOf(context).width * 0.80,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: Colors.white),
            child: _buildUI(context),
          ),
        ),
      ),
    );
  }

  Widget _buildUI(BuildContext context) {
    if (controller.loading.isTrue) {
      return const Center(
        child: SizedBox(
          height: 30,
          width: 30,
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return  Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center ,
          children: [
            DropdownButton(
              value: controller.selectedAsset.value,
            onChanged: (value){
              if(value !=null){
                controller.selectedAsset.value = value.toString();
              }
            },
              items: controller.assets.map((asset){
                return DropdownMenuItem(
                  value: asset,
                  child: Text(asset));
              }).toList()),
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  
                  border: OutlineInputBorder()),
                onChanged: (value) {
                  controller.assetValue.value = double.parse(value);
                  }
              ),
              MaterialButton(
                color: Theme.of(context).colorScheme.primary,
                child: Text("Add Asset"),
                onPressed: () {
                  AssetsController assetsController = Get.find();
                  assetsController.addTrackedAsset(controller.selectedAsset.value, controller.assetValue.value);
                  Get.back(closeOverlays: true);
              },)
          ],
        ),
      );
    }
  }
}
