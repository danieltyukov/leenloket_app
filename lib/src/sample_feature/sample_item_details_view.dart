import 'package:fan_carousel_image_slider/fan_carousel_image_slider.dart';
import 'package:flutter/material.dart';

/// Displays detailed information about a SampleItem.
class SampleItemDetailsView extends StatelessWidget {
  const SampleItemDetailsView({super.key});

  static const routeName = '/sample_item';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Item Details'),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
              child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 350,
                          width: MediaQuery.of(context).size.width,
                          child: FanCarouselImageSlider(
                              sliderHeight: 300,
                              autoPlay: true,
                              imagesLink: const [
                                'assets/images/drill.jpg',
                                'assets/images/drill.jpg',
                                'assets/images/drill.jpg'
                              ],
                              isAssets: true),
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 30),
                                Text("Drill",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: 5),
                                Text("Tools",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w500))
                              ],
                            ),
                            Text("€15",
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red))
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                "A nice drill to drill holes in your wall. It is very good and it is very cheap. You can use it for many things. It is very good and it is very cheap. You can use it for many things. It is very good and it is very cheap. You can use it for many things. It is very good and it is very cheap. You can use it for many things. It is very good and it is very cheap. You can use it for many things. It is very good and it is very cheap. You can use it for many things. It is very good and it is very cheap. You can use it for many things. It is very good and it is very cheap. You can use it for many things.",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w400))),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ElevatedButton(
                              child: Text("Rent this item"),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.red,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                              ),
                              onPressed: () {},
                            )
                          ],
                        )
                      ]))),
        ));
  }
}
