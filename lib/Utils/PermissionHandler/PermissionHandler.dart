import 'package:chrome_flutter/Presentation/Screens/DashboardScreen/DashboardScreen.dart';
import 'package:chrome_flutter/Presentation/Screens/StockInScreen/StockInScreen.dart';
import 'package:flutter/material.dart';

import '../../Presentation/Screens/PutAwayScreen/PutAwayScreen.dart';

class PermissionHandler {
  static Map<String, Map<String, dynamic>> permissionToMenu = {
    // Mục Dashboard không yêu cầu quyền cụ thể
    'ucDashboard': {
      'title': 'Bảng điều khiển',
      'icon': Icons.dashboard_sharp,
      'screen': DashboardScreen.new,
    },
    // Các mục khác vẫn yêu cầu quyền
    'ucStockIn': {
      'title': 'Nhập kho',
      'icon': Icons.input_sharp,
      'screen': StockInScreen.new,
    },
    // 'ucStockOut': {
    //   'title': 'Xuất kho',
    //   'icon': Icons.output_sharp,
    //   'screen': StockOutScreen.new,
    // },
    'ucPutAway': {
      'title': 'Cất hàng',
      'icon': Icons.add_business_outlined,
      'screen': PutAwayScreen.new,
    },
    // 'ucTransfer': {
    //   'title': 'Chuyển kho',
    //   'icon': Icons.swap_horiz_sharp,
    //   'screen': TransferScreen.new,
    // },
    // 'ucProductionOrder': {
    //   'title': 'Lệnh sản xuất',
    //   'icon': Icons.production_quantity_limits_sharp,
    //   'screen': ProductionOrderScreen.new,
    // },
  };

  static List<Map<String, dynamic>> getMenuItems(List<String> permissions) {
    // Luôn bao gồm Dashboard, sau đó thêm các mục khác dựa trên permissions
    final menuItems = [
      permissionToMenu['ucDashboard']!, // Luôn thêm Dashboard
      ...permissions
          .where(
            (permission) =>
                permissionToMenu.containsKey(permission) &&
                permission != 'ucDashboard',
          ) // Tránh lặp lại Dashboard
          .map((permission) => permissionToMenu[permission]!)
          .toList(),
    ];
    return menuItems;
  }

  static List getScreens(List<String> permissions) {
    // Luôn bao gồm DashboardScreen, sau đó thêm các màn hình khác dựa trên permissions
    final screens = [
      permissionToMenu['ucDashboard']?['screen'](), // Luôn thêm DashboardScreen
      ...permissions
          .where(
            (permission) =>
                permissionToMenu.containsKey(permission) &&
                permission != 'ucDashboard',
          ) // Tránh lặp lại Dashboard
          .map((permission) => permissionToMenu[permission]!['screen']())
          .toList(),
    ];
    return screens;
  }
}
