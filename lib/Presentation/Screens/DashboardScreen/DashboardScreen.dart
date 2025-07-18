import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Blocs/DashboardBloc/DashboardBloc.dart';
import '../../../Blocs/DashboardBloc/DashboardEvent.dart';
import '../../../Blocs/DashboardBloc/DashboardState.dart';
import '../../../Data/Models/DashboardDTO/HandyDashboardRequestDTO.dart';
import '../../../Data/Models/DashboardDTO/HandyDashboardResponseDTO.dart';
import '../../../Data/Models/DashboardDTO/HandyTaskDTO.dart';
import '../../../Utils/SharedPreferences/ApplicableLocationHelper.dart';
import '../../../Utils/SharedPreferences/UserNameHelper.dart';
import '../../Widgets/SideBarMenu/SideBarMenu.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  int? selectedYear;
  int? selectedMonth;
  int? selectedQuarter;

  @override
  void initState() {
    super.initState();
    selectedYear = DateTime.now().year;
    selectedMonth = DateTime.now().month;
    selectedQuarter = (DateTime.now().month / 3).ceil();
    _fetchDashboardData();
  }

  Future<void> _fetchDashboardData() async {
    final applicableLocation =
        await ApplicableLocationHelper.getApplicableLocation();
    final user = await UserNameHelper.getUserName();
    if (applicableLocation != null && user != null) {
      context.read<DashboardBloc>().add(
        FetchDashboardHandyAsync(
          handyDashboardRequestDTO: HandyDashboardRequestDTO(
            warehouseCodes: applicableLocation.split(','),
            userName: user,
            year: selectedYear,
            month: selectedMonth,
            quarter: selectedQuarter,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Không thể lấy thông tin kho hoặc người dùng'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBarMenu(),
      appBar: AppBar(
        title: const Text(
          'Bảng Điều Khiển',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black, Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 6,
        shadowColor: Colors.black45,
      ),
      body: RefreshIndicator(
        onRefresh: _fetchDashboardData,
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInUp(
                  duration: const Duration(milliseconds: 500),
                  child: _buildSelectionFilters(context),
                ),
                const SizedBox(height: 12),
                BlocBuilder<DashboardBloc, DashboardState>(
                  builder: (context, state) {
                    if (state is DashboardLoading) {
                      return FadeIn(
                        duration: const Duration(milliseconds: 300),
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 3),
                        ),
                      );
                    } else if (state is DashboardLoaded) {
                      return FadeInUp(
                        duration: const Duration(milliseconds: 600),
                        child: _buildDashboardContent(
                          context,
                          state.handyDashboardResponseDTO,
                        ),
                      );
                    } else if (state is DashboardError) {
                      return FadeIn(
                        duration: const Duration(milliseconds: 300),
                        child: _buildErrorContent(context, state.error),
                      );
                    } else {
                      return FadeIn(
                        duration: const Duration(milliseconds: 300),
                        child: const Center(
                          child: Text(
                            'Vui lòng làm mới để tải dữ liệu',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<int> _getMonthsForQuarter(int? quarter) {
    switch (quarter) {
      case 1:
        return [1, 2, 3];
      case 2:
        return [4, 5, 6];
      case 3:
        return [7, 8, 9];
      case 4:
        return [10, 11, 12];
      default:
        return List.generate(12, (index) => index + 1); // fallback
    }
  }

  Widget _buildSelectionFilters(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildDropdown(
              label: 'Năm',
              value: selectedYear,
              items: List.generate(
                5,
                (index) => DateTime.now().year - 2 + index,
              ),
              onChanged: (value) {
                setState(() {
                  selectedYear = value;
                  _fetchDashboardData();
                });
              },
            ),

            _buildDropdown(
              label: 'Quý',
              value: selectedQuarter,
              items: [1, 2, 3, 4],
              onChanged: (value) {
                setState(() {
                  selectedQuarter = value;
                  // Reset tháng nếu tháng không thuộc quý mới
                  final allowedMonths = _getMonthsForQuarter(value);
                  if (!allowedMonths.contains(selectedMonth)) {
                    selectedMonth = null; // hoặc đặt về allowedMonths.first
                  }
                  _fetchDashboardData();
                });
              },
            ),

            _buildDropdown(
              label: 'Tháng',
              value: selectedMonth,
              items: _getMonthsForQuarter(selectedQuarter),
              onChanged: (value) {
                setState(() {
                  selectedMonth = value;
                  _fetchDashboardData();
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required int? value,
    required List<int> items,
    required ValueChanged<int?> onChanged,
  }) {
    return Tooltip(
      message: 'Chọn $label',
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(6),
      ),
      textStyle: const TextStyle(color: Colors.white, fontSize: 12),
      child: Container(
        width: 90,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: Color(0xFF1E1E1E),
              ),
            ),

            DropdownButton<int>(
              value: value,
              items:
                  items.map((item) {
                    return DropdownMenuItem<int>(
                      value: item,
                      child: Text(
                        item.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF424242),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
              onChanged: onChanged,
              isExpanded: true,
              underline: Container(),
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.circular(10),
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Color(0xFF1976D2),
                size: 20,
              ),
              style: const TextStyle(fontSize: 12, color: Color(0xFF424242)),
              itemHeight: 48,
              menuMaxHeight: 200,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardContent(
    BuildContext context,
    HandyDashboardResponseDTO data,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Alerts Section
        if (data.alerts.isNotEmpty) ...[
          FadeInUp(
            duration: const Duration(milliseconds: 1000),
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade200, width: 1),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    colors: [Colors.black, Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.shade100.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Thống Kê Hôm Nay',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.info_outline,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Thông tin thống kê hôm nay'),
                              ),
                            );
                          },
                          tooltip: 'Thông tin chi tiết',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children:
                          data.summaryToday.entries.map((entry) {
                            return _buildSummaryItem(
                              context,
                              entry.key,
                              entry.value.toString(),
                              _getIconForSummary(entry.key),
                            );
                          }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          FadeInUp(
            duration: const Duration(milliseconds: 600),
            child: const Text(
              'Cảnh Báo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A237E),
              ),
            ),
          ),
          const SizedBox(height: 8),
          FadeInUp(
            duration: const Duration(milliseconds: 700),
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade200, width: 1),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children:
                      data.alerts.map((alert) {
                        return ListTile(
                          leading: const Icon(
                            Icons.warning_amber,
                            color: Colors.redAccent,
                            size: 24,
                          ),
                          title: Text(
                            alert,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF1E1E1E),
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                ),
              ),
            ),
          ),
        ],
        // Todo Tasks Card
        FadeInUp(
          duration: const Duration(milliseconds: 800),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade200, width: 1),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nhiệm Vụ Cần Làm',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A237E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  data.todoTasks.isEmpty
                      ? const Center(
                        child: Text(
                          'Không có nhiệm vụ nào',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      )
                      : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: data.todoTasks.length,
                        itemBuilder: (context, index) {
                          final task = data.todoTasks[index];
                          return FadeInUp(
                            duration: Duration(milliseconds: 900 + index * 100),
                            child: _buildTaskItem(context, task),
                          );
                        },
                      ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Summary Today Card
      ],
    );
  }

  Widget _buildSummaryItem(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 28, color: const Color(0xFF1976D2)),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(BuildContext context, HandyTaskDTO task) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          leading: Icon(
            task.status == 'Hoàn thành' ? Icons.check_circle : Icons.pending,
            color:
                task.status == 'Hoàn thành'
                    ? Colors.green.shade600
                    : Colors.orange.shade600,
            size: 20,
          ),
          title: Text(
            task.orderCode,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Color(0xFF1E1E1E),
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 2),
              Text(
                'Loại: ${task.orderType}',
                style: const TextStyle(fontSize: 12),
              ),
              Text(
                'Hạn: ${task.deadline}',
                style: const TextStyle(fontSize: 12),
              ),
              Text(
                'Mã sản phẩm: ${task.productCodes.join(', ')}',
                style: const TextStyle(fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          trailing: Chip(
            label: Text(
              task.status,
              style: TextStyle(
                color:
                    task.status == 'Hoàn thành'
                        ? Colors.green.shade800
                        : Colors.orange.shade800,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            backgroundColor:
                task.status == 'Hoàn thành'
                    ? Colors.green.shade100
                    : Colors.orange.shade100,
            padding: const EdgeInsets.symmetric(horizontal: 8),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorContent(BuildContext context, String error) {
    return FadeIn(
      duration: const Duration(milliseconds: 300),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.redAccent,
                size: 36,
              ),
              const SizedBox(height: 8),
              Text(
                'Lỗi: $error',
                style: const TextStyle(fontSize: 14, color: Color(0xFF1E1E1E)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _fetchDashboardData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1976D2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                child: const Text(
                  'Thử lại',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForSummary(String key) {
    switch (key) {
      case 'Nhập kho':
        return Icons.arrow_downward;
      case 'Xuất kho':
        return Icons.arrow_upward;
      case 'Chuyển kho':
        return Icons.swap_horiz;
      case 'Chuyển kệ':
        return Icons.shelves;
      case 'Sản xuất':
        return Icons.factory;
      default:
        return Icons.info;
    }
  }
}
