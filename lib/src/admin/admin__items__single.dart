import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AdminItemSingleView extends StatefulWidget {
  final String itemId;

  const AdminItemSingleView({super.key, required this.itemId});

  static const routeName = '/admin/items/single';

  @override
  State<AdminItemSingleView> createState() => _AdminItemSingleViewState();
}

class _AdminItemSingleViewState extends State<AdminItemSingleView> {
  late DatabaseReference _itemRef;

  @override
  void initState() {
    super.initState();
    // Initialize DatabaseReference for the specific item
    _itemRef = FirebaseDatabase.instance.ref('Items/${widget.itemId}');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Details'),
        ),
        body: FutureBuilder<DatabaseEvent>(
          future: _fetchItemDetails(),
          builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Text('Data not available');
            } else {
              DataSnapshot itemSnapshot = snapshot.data!.snapshot;
              // Display details for the specific item
              return Card(
                child: ListTile(
                  title:
                      Text(itemSnapshot.child('Description').value.toString()),
                  subtitle: Text("ID: ${itemSnapshot.child('ItemID').value}"),
                  trailing: Text(itemSnapshot.child('Status').value.toString()),
                  // Add more details or widgets as needed
                ),
              );
            }
          },
        ),
      );

  Future<DatabaseEvent> _fetchItemDetails() async {
    return await _itemRef.once();
  }
}
