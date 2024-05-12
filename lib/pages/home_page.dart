import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getiks/controllers/assets_controller.dart';
import 'package:getiks/models/tracked_asset.dart';
import 'package:getiks/pages/details_page.dart';
import 'package:getiks/utils.dart';
import 'package:getiks/widgets/add_asset_dialog.dart';
String ppImage = "https://media.licdn.com/dms/image/D4D03AQEyXgQrStzzVQ/profile-displayphoto-shrink_400_400/0/1703358353270?e=1721260800&v=beta&t=_T7Ini3vXluuUA3F50WvzYS0U2dAlArcPX-g2OQJYXo";
class HomePage extends StatelessWidget {
  AssetsController assetscontroller = Get.find();
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _appBar(context),
      body: _buildUI(
        context,
      ),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      centerTitle: false,
      title:  CircleAvatar(
        backgroundImage: NetworkImage(
          ppImage,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            Get.dialog(AddAssetDialog());
          },
        )
      ],
    );
  }

  Widget _buildUI(BuildContext context) {
    return SafeArea(
        child: Obx(
      () => Column(
        children: [_portfolioValue(context), _trackedAssetList(context)],
      ),
    ));
  }

  Widget _portfolioValue(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.sizeOf(context).height * 0.03),
      child: Center(
        child: Text.rich(
          textAlign: TextAlign.center,
          TextSpan(children: [
            const TextSpan(
                text: "\$",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            TextSpan(
                text:
                    "${assetscontroller.getPortFolioValue().toStringAsFixed(1)}",
                style: TextStyle(fontSize: 40)),
          ]),
        ),
      ),
    );
  }

  Widget _trackedAssetList(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.sizeOf(context).width * 0.03),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.05,
              child: const Text(
                "Portfolio",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.w500),
              )),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.60,
            width: MediaQuery.sizeOf(context).width,
            child: ListView.builder(
              itemCount: assetscontroller.trackedAssets.length,
              itemBuilder: (BuildContext context, int index) {
                TrackedAsset trackedAsset =
                    assetscontroller.trackedAssets[index];
                return ListTile(
                  trailing: Text(trackedAsset.amount.toString()),
                  leading: Image.network(getCryptoImageURL(trackedAsset.name!)),
                  subtitle: Text(
                      "USD: ${assetscontroller.getAssetPrice(trackedAsset.name!)!.toStringAsFixed(1)}"),
                  title: Text(trackedAsset.name!),
                  onLongPress: () {
                    assetscontroller.trackedAssets.remove(assetscontroller.trackedAssets.value[index]);
                  },
                  onTap: () => Get.to(() {
                    return DetailsPage(
                        coin:
                            assetscontroller.getCoinData(trackedAsset.name!)!);
                  }),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
