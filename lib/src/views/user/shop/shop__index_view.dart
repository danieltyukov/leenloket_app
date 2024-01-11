import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'shop__item__single_view.dart';

class SampleItemListView extends StatefulWidget {
  const SampleItemListView({super.key});

  static const routeName = '/item-list';

  @override
  State<SampleItemListView> createState() => _SampleItemListViewState();
}

class _SampleItemListViewState extends State<SampleItemListView> {
  final ref = FirebaseDatabase.instance.ref('Items');
  final lockerRef = FirebaseDatabase.instance.ref('Lockers');
  List<String> lockerLocations = ['All'];
  String selectedLocker = 'All';
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadLockerLocations();
  }

  Future<void> _loadLockerLocations() async {
    DataSnapshot snapshot = await lockerRef.get();
    List<String> lockers = ['All'];
    if (snapshot.exists) {
      Map<dynamic, dynamic> values = snapshot.value as Map;
      values.forEach((key, value) {
        lockers.add(key);
      });
    }
    setState(() {
      lockerLocations = lockers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildFilterOptions(),
          _buildSearchBar(),
          Expanded(
            child: FirebaseAnimatedList(
              padding: const EdgeInsets.all(15),
              query: ref,
              itemBuilder: (context, snapshot, animation, index) {
                final item = snapshot.value as Map<dynamic, dynamic>;
                if (item['Status'] == 'Available' &&
                    (selectedLocker == 'All' ||
                        item['LockerID'] == selectedLocker) &&
                    item['ItemName']
                        .toString()
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase())) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ShopItemSingleView(
                              selectedStartDate: DateTime.now(),
                              selectedEndDate: DateTime.now(),
                              itemId: snapshot.key!)));
                    },
                    child: Card(
                      child: ListTile(
                        leading: _buildItemImage(item['ImageUrl']),
                        title: Text(item['ItemName']),
                        subtitle: Text("€${item['PricePerDay']} per day"),
                      ),
                    ),
                  );
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterOptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedLocker,
              onChanged: (String? newValue) {
                setState(() {
                  selectedLocker = newValue!;
                });
              },
              items:
                  lockerLocations.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: TextField(
        decoration: InputDecoration(
          labelText: 'Search by Name',
          suffixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
        ),
        onChanged: (value) => setState(() => searchQuery = value),
      ),
    );
  }

  Widget _buildItemImage(String imageUrl) {
    return Container(
      width: 80, // Set your desired width
      height: 60, // Set your desired height
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
        fit: BoxFit.cover,
      ),
    );
  }
}
