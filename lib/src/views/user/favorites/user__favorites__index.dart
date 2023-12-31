import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class UserFavoriteItems extends StatefulWidget {
  const UserFavoriteItems({super.key});

  static const routeName = '/admin/lockers/index';

  @override
  State<UserFavoriteItems> createState() => _UserFavoriteItemsState();
}

class _UserFavoriteItemsState extends State<UserFavoriteItems> {
  @override
  Widget build(BuildContext context) => Scaffold(
          body: SizedBox(
        height: 30,
      ));
}
