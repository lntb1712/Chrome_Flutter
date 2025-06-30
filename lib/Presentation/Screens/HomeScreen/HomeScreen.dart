import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../Blocs/MenuBloc/MenuBloc.dart';
import '../../../Blocs/MenuBloc/MenuState.dart';
import '../../../Utils/PermissionHandler/PermissionHandler.dart';
import '../../Widgets/SideBarMenu/SideBarMenu.dart';

class HomeScreen extends StatelessWidget {
  final String token;

  HomeScreen({required this.token});

  @override
  Widget build(BuildContext context) {
    final decodedToken = JwtDecoder.decode(token);
    final permissions = List<String>.from(decodedToken['Permission'] ?? []);
    final screens = PermissionHandler.getScreens(permissions);

    return BlocProvider(
      create: (context) => MenuBloc(),
      child: BlocBuilder<MenuBloc, MenuState>(
        builder: (context, state) {
          return Scaffold(
            body:
                screens.isNotEmpty
                    ? screens[state.selectedIndex]
                    : Container(child: Text("Không có màn hình nào khả dụng")),
            drawer: SideBarMenu(),
          );
        },
      ),
    );
  }
}
