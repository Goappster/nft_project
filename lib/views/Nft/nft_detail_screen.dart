import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NFTDetailController extends GetxController {
  RxInt favorites = 0.obs;
  RxInt owners = 1.obs;
  RxInt editions = 1.obs;
  RxInt visitors = 0.obs;
}

class NFTDetailScreen extends StatelessWidget {
  final item = Get.arguments;
  NFTDetailScreen({super.key});
  final NFTDetailController controller = Get.put(NFTDetailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildNFTImage(),
              _buildNFTInfo(),
            const SizedBox(height: 60,),
              _buildSellButton()
              // _buildStats(),
              // _buildTabs(),
              // _buildSection("About Collection", Icons.info, [_buildCollectionInfo()]),
              // _buildSection("Properties", Icons.category, [
              //   _buildPropertyItem("BACKGROUND", "Sweet Morning", "12%"),
              //   _buildPropertyItem("BODY", "Orange", "15%"),
              //   _buildPropertyItem("CLOTHES", "Shirt Black", "7%"),
              //   _buildPropertyItem("FACE", "Drooling", "5%"),
              //   _buildPropertyItem("HAT", "Brown Dutch", "4%"),
              // ]),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: _buildSellButton(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Get.back()),
      actions: [
        IconButton(icon: const Icon(Icons.favorite_border, color: Colors.black), onPressed: () {}),
        IconButton(icon: const Icon(Icons.share, color: Colors.black), onPressed: () {}),
      ],
    );
  }

  Widget _buildNFTImage() {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(item.imageUrl ,width: double.infinity,  fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildNFTInfo() {
    return Column(
      children: [
        const SizedBox(height: 16),
        Text(item.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        Text(item.id, style: const TextStyle(fontSize: 16, color: Colors.blue)),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStatColumn("Favorites", controller.favorites),
        _buildStatColumn("Owners", controller.owners),
        _buildStatColumn("Editions", controller.editions),
        _buildStatColumn("Visitors", controller.visitors),
      ],
    );
  }

  Widget _buildStatColumn(String title, RxInt value) {
    return Expanded(
      child: Column(
        children: [
          Obx(() => Text("${value.value}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _tabItem("Details", true),
          _tabItem("Offers", false),
          _tabItem("Listings", false),
        ],
      ),
    );
  }

  Widget _tabItem(String title, bool isSelected) {
    return Column(
      children: [
        Text(title, style: TextStyle(fontSize: 16, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
        if (isSelected) Container(height: 2, width: 20, color: Colors.blue),
      ],
    );
  }

  Widget _buildSection(String title, IconData icon, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Icon(icon, color: Colors.blue, size: 20), const SizedBox(width: 8), Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))]),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  Widget _buildCollectionInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(children: [Icon(Icons.verified, color: Colors.blue, size: 18), SizedBox(width: 5), Text("Nekochimin", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))]),
        const SizedBox(height: 8),
        const Text("Nekochimin is a collection of random NFTs on the Ethereum blockchain.", style: TextStyle(fontSize: 14, color: Colors.black87)),
        const SizedBox(height: 10),
        Row(children: [_socialIcon(Icons.link), _socialIcon(Icons.chat), _socialIcon(Icons.send), _socialIcon(Icons.mail)]),
      ],
    );
  }

  Widget _socialIcon(IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Icon(icon, color: Colors.blue, size: 22),
    );
  }

  Widget _buildPropertyItem(String title, String value, String percentage) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)), Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))]),
          Text(percentage, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
        ],
      ),
    );
  }

  Widget _buildSellButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), minimumSize: const Size(double.infinity, 50)),
        onPressed: () {},
        child: const Text("Sell", style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
