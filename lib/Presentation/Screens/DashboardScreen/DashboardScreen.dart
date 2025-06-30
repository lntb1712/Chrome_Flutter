import 'package:flutter/material.dart';

import '../../Widgets/SideBarMenu/SideBarMenu.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  int orderCount = 0; // Trạng thái để lưu số lượng đơn hàng (ví dụ)

  @override
  void initState() {
    super.initState();
    // Khởi tạo dữ liệu ban đầu (có thể gọi API ở đây)
    _fetchDashboardData();
  }

  // Hàm giả lập lấy dữ liệu (thay thế bằng gọi API thực tế nếu cần)
  void _fetchDashboardData() {
    setState(() {
      orderCount = 42; // Giá trị mẫu, thay bằng dữ liệu từ API
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBarMenu(),
      appBar: AppBar(
        title: const Text('Bảng điều khiển'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tổng quan',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Số đơn hàng: $orderCount',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        // Làm mới dữ liệu khi nhấn nút
                        _fetchDashboardData();
                      },
                      child: const Text('Làm mới'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
