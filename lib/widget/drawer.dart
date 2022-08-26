import 'package:flutter/material.dart';

Widget drawer_widget() {
  return Drawer(
    // Add a ListView to the drawer. This ensures the user can scroll
    // through the options in the drawer if there isn't enough vertical
    // space to fit everything.
    child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          child: Image(
            fit: BoxFit.fitWidth,
            image: AssetImage("assets/logo.png")),
         
        ),
        ListTile(
          title: const Text('Home'),
          onTap: () async{
          
          },
        ),
        ListTile(
          title: const Text('Become A Seller'),
          onTap: () {
            // Update the state of the app.
            // ...
          },
        ),
        ListTile(title: const Text("User Login"), onTap: () {}),
        ListTile(
          title: const Text('All Categories'),
          onTap: () {
            // Update the state of the app.
            // ...
          },
        ),
        ListTile(title: const Text("Register As Customer"), onTap: () {}),
        ListTile(
            title: const Text("Cart"),
            
            onTap: () {}),
      ],
    ),
  );
}
