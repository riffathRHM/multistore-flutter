import 'package:flutter/material.dart';
import 'package:store_app/controllers/banner_controller.dart';
import 'package:store_app/models/banner_model.dart';

class BannerWidget extends StatefulWidget {
  const BannerWidget({super.key});

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  late Future<List<BannerModel>> futureBanners;
  @override
  void initState() {
    super.initState();
    futureBanners = BannerController().loadBanners();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 170,
        decoration: BoxDecoration(
          color: Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(4),
        ),
        child: FutureBuilder(
            future: futureBanners,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: SizedBox(
                    width: 25,
                    height: 25,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Hass Error ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No Banners'));
              } else {
                final banners = snapshot.data!;
                return PageView.builder(
                    itemCount: banners.length,
                    itemBuilder: (context, index) {
                      final banner = banners[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.network(
                          banner.image,
                          fit: BoxFit.cover,
                        ),
                      );
                    });
              }
            }),
      ),
    );
  }
}
