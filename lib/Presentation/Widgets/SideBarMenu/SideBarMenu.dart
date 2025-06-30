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
import 'MenuButton.dart';

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
      width: 250,
      backgroundColor: Colors.grey[200],
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

            return Column(
              children: [
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(color: Colors.grey[900]),
                  accountName: Text(
                    state.accountResponseDTO?.FullName ?? "Default",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  accountEmail: Text(
                    state.accountResponseDTO?.GroupName ?? 'Default',
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20,
                    child: Text(
                      getLastInitial(state.accountResponseDTO?.FullName),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                ...getMenuOptions(permissions, context),
                Spacer(),
                ListTile(
                  leading: Icon(Icons.logout, color: Colors.red),
                  title: Text("Đăng xuất"),
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
          return MenuButton(
            title: menuItems[index]['title'],
            icon: menuItems[index]['icon'],
            isSelected: state.selectedIndex == index,
            onPressed: () {
              context.read<MenuBloc>().add(MenuChangeEvent(index));
              Navigator.pop(context);
            },
          );
        },
      );
    });
  }
}
