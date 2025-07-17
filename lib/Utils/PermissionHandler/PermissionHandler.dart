import 'package:chrome_flutter/Presentation/Screens/DashboardScreen/DashboardScreen.dart';
import 'package:chrome_flutter/Presentation/Screens/StockInScreen/StockInScreen.dart';
import 'package:chrome_flutter/Presentation/Screens/StockTakeScreen/StockTakeScreen.dart';
import 'package:flutter/material.dart';

import '../../Presentation/Screens/ManufacturingOrderScreen/ManufacturingOrderScreen.dart';
import '../../Presentation/Screens/MovementScreen/MovementScreen.dart';
import '../../Presentation/Screens/PutAwayScreen/PutAwayScreen.dart';
import '../../Presentation/Screens/StockOutScreen/StockOutScreen.dart';
import '../../Presentation/Screens/TransferScreen/TransferScreen.dart';

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
    'ucStockOut': {
      'title': 'Xuất kho',
      'icon': Icons.output_sharp,
      'screen': StockOutScreen.new,
    },
    'ucPutAway': {
      'title': 'Cất hàng',
      'icon': Icons.inbox,
      'screen': PutAwayScreen.new,
    },
    'ucTransfer': {
      'title': 'Chuyển kho',
      'icon': Icons.swap_horiz_sharp,
      'screen': TransferScreen.new,
    },
    'ucMovement': {
      'title': 'Chuyển kệ',
      'icon': Icons.shelves,
      'screen': MovementScreen.new,
    },
    'ucStockTake': {
      'title': 'Kiểm đếm',
      'icon': Icons.move_down_sharp,
      'screen': StockTakeScreen.new,
    },
    'ucManufacturingOrder': {
      'title': 'Lệnh sản xuất',
      'icon': Icons.factory,
      'screen': ManufacturingOrderScreen.new,
    },
  };

  static List<Map<String, dynamic>> getMenuItems(List<String> permissions) {
    // Initialize the menu items list with Dashboard
    final menuItems = [
      permissionToMenu['ucDashboard']!, // Always include Dashboard first
    ];

    // Add "Nhập kho" (ucStockIn) if permission exists
    if (permissions.contains('ucStockIn')) {
      menuItems.add(permissionToMenu['ucStockIn']!);
    }

    // Add "Xuất kho" (ucStockOut) if permission exists
    if (permissions.contains('ucStockOut')) {
      menuItems.add(permissionToMenu['ucStockOut']!);
    }

    // Add remaining permitted items, excluding Dashboard, StockIn, and StockOut
    menuItems.addAll(
      permissions
          .where(
            (permission) =>
                permissionToMenu.containsKey(permission) &&
                permission != 'ucDashboard' &&
                permission != 'ucStockIn' &&
                permission != 'ucStockOut',
          )
          .map((permission) => permissionToMenu[permission]!)
          .toList(),
    );

    return menuItems;
  }

  static List getScreens(List<String> permissions) {
    // Initialize the screens list with DashboardScreen
    final screens = [
      permissionToMenu['ucDashboard']!['screen'](),
      // Always include DashboardScreen first
    ];

    // Add StockInScreen if permission exists
    if (permissions.contains('ucStockIn')) {
      screens.add(permissionToMenu['ucStockIn']!['screen']());
    }

    // Add StockOutScreen if permission exists
    if (permissions.contains('ucStockOut')) {
      screens.add(permissionToMenu['ucStockOut']!['screen']());
    }

    // Add remaining permitted screens, excluding Dashboard, StockIn, and StockOut
    screens.addAll(
      permissions
          .where(
            (permission) =>
                permissionToMenu.containsKey(permission) &&
                permission != 'ucDashboard' &&
                permission != 'ucStockIn' &&
                permission != 'ucStockOut',
          )
          .map((permission) => permissionToMenu[permission]!['screen']())
          .toList(),
    );

    return screens;
  }
}
