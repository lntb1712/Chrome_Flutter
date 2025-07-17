import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Blocs/LoginBloc/LoginBloc.dart';
import '../../../Blocs/LoginBloc/LoginEvent.dart';
import '../../../Blocs/LoginBloc/LoginState.dart';
import '../../../Blocs/MenuBloc/MenuBloc.dart';
import '../../../Blocs/MenuBloc/MenuEvent.dart';
import '../../../Blocs/MenuBloc/MenuState.dart';
import '../../../Utils/PermissionHandler/PermissionHandler.dart';
import '../../Screens/LoginScreen/LoginScreen.dart';

class SideBarMenu extends StatefulWidget {
  @override
  _SideBarMenuState createState() => _SideBarMenuState();
}

class _SideBarMenuState extends State<SideBarMenu> {
  String getLastInitial(String? fullName) {
    if (fullName == null || fullName.isEmpty) return "?";
    List<String> parts = fullName.trim().split(" ");
    return parts.last[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 230,
      backgroundColor: Colors.grey[100],
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          if (state is Authenticated) {
            final token = state.loginResponseDTO!.Token;
            final parts = token.split('.');
            if (parts.length != 3) {
              return Center(child: Text("Token không hợp lệ"));
            }

            final payload = parts[1];
            final decodedPayload = base64Url.decode(
              base64Url.normalize(payload),
            );
            final decodedJson = jsonDecode(utf8.decode(decodedPayload));
            final permissions = List<String>.from(
              decodedJson['Permission'] ?? [],
            );

            final fullName = state.accountResponseDTO?.FullName ?? "Default";
            final groupName = state.accountResponseDTO?.GroupName ?? "Default";

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.all(40),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black, Colors.white],
                      begin: Alignment.centerLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: Text(
                          getLastInitial(fullName),
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        fullName,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Text(
                        groupName,
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: getMenuOptions(permissions, context),
                  ),
                ),
                Divider(height: 1, color: Colors.grey[400]),
                ListTile(
                  leading: Icon(Icons.logout, color: Colors.red),
                  title: Text("Đăng xuất", style: TextStyle(color: Colors.red)),
                  onTap: () {
                    context.read<LoginBloc>().add(LogoutEvent());
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  List<Widget> getMenuOptions(List<String> permissions, BuildContext context) {
    final menuItems = PermissionHandler.getMenuItems(permissions);

    return List.generate(menuItems.length, (index) {
      return BlocBuilder<MenuBloc, MenuState>(
        builder: (context, state) {
          final isSelected = state.selectedIndex == index;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Material(
              color: isSelected ? Colors.grey[300] : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  context.read<MenuBloc>().add(MenuChangeEvent(index));
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Icon(menuItems[index]['icon'], color: Colors.grey[800]),
                      SizedBox(width: 16),
                      Text(
                        menuItems[index]['title'],
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[900],
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }
}
