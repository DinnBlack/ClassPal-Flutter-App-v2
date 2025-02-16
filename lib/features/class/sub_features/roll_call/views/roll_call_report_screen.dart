import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../../../../core/config/app_constants.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../bloc/roll_call_bloc.dart';
import '../models/roll_call_entry_model.dart';

class RollCallReportScreen extends StatefulWidget {
  const RollCallReportScreen({super.key});

  @override
  _RollCallReportScreenState createState() => _RollCallReportScreenState();
}

class _RollCallReportScreenState extends State<RollCallReportScreen> {
  DateTime _selectedDate = DateTime.now();
  late DateTime _startOfWeek;
  List<RollCallEntryModel> _allEntries = [];

  @override
  void initState() {
    super.initState();
    _startOfWeek = _getStartOfWeek(DateTime.now());
    _fetchRollCallForWeek();
  }

  DateTime _getStartOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  void _fetchRollCallForWeek() {
    DateTime endOfWeek = _startOfWeek.add(const Duration(days: 6));
    context.read<RollCallBloc>().add(
          RollCallFetchByDateRangeStarted(
            startDate: DateFormat('yyyy-MM-dd').format(_startOfWeek),
            endDate: DateFormat('yyyy-MM-dd').format(endOfWeek),
          ),
        );
  }

  void _previousWeek() {
    setState(() {
      _startOfWeek = _startOfWeek.subtract(const Duration(days: 7));
    });
    _fetchRollCallForWeek();
  }

  void _nextWeek() {
    setState(() {
      _startOfWeek = _startOfWeek.add(const Duration(days: 7));
    });
    _fetchRollCallForWeek();
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  String _getWeekLabel() {
    DateTime endOfWeek = _startOfWeek.add(const Duration(days: 6));
    return "${DateFormat('dd/MM/yyyy').format(_startOfWeek)} - ${DateFormat('dd/MM/yyyy').format(endOfWeek)}";
  }

  List<RollCallEntryModel> _getEntriesForSelectedDate() {
    return _allEntries.where((entry) {
      return DateUtils.isSameDay(entry.createdAt, _selectedDate);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> weekDays =
        List.generate(7, (index) => _startOfWeek.add(Duration(days: index)));

    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          _buildWeekHeader(),
          _buildWeekSelector(weekDays),
          const SizedBox(height: 20),
          Expanded(
            child: BlocBuilder<RollCallBloc, RollCallState>(
              builder: (context, state) {
                if (state is RollCallFetchByDateRangeInProgress) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is RollCallFetchByDateRangeSuccess) {
                  _allEntries = state.rollCallEntries;
                  List<RollCallEntryModel> entriesForDay =
                      _getEntriesForSelectedDate();

                  return entriesForDay.isEmpty
                      ? const Center(child: Text("Không có dữ liệu điểm danh."))
                      : ListView.builder(
                          itemCount: entriesForDay.length,
                          itemBuilder: (context, index) {
                            return _buildRollCallItem(entriesForDay[index]);
                          },
                        );
                } else if (state is RollCallFetchByDateRangeFailure) {
                  return Center(child: Text(state.error));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildArrowButton(Icons.arrow_back, _previousWeek),
          Text(
            _getWeekLabel(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          _buildArrowButton(Icons.arrow_forward, _nextWeek),
        ],
      ),
    );
  }

  Widget _buildWeekSelector(List<DateTime> weekDays) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 3))
        ],
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          childAspectRatio: 0.8,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemCount: weekDays.length,
        itemBuilder: (context, index) => _buildDayItem(weekDays[index]),
      ),
    );
  }

  Widget _buildDayItem(DateTime date) {
    bool isToday = DateUtils.isSameDay(date, DateTime.now());
    bool isSelected = DateUtils.isSameDay(date, _selectedDate);

    return GestureDetector(
      onTap: () => _selectDate(date),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.blueAccent
              : (isToday ? Colors.lightBlue.shade100 : Colors.white),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              DateFormat('EEE', 'vi').format(date),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              DateFormat('dd').format(date),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRollCallItem(RollCallEntryModel entry) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar + trạng thái
            CircleAvatar(
              radius: 28,
              backgroundColor: _getStatusColor(entry.status).withOpacity(0.2),
              child: Icon(
                _getStatusIcon(entry.status),
                color: _getStatusColor(entry.status),
                size: 30,
              ),
            ),
            const SizedBox(width: 12),

            // Thông tin học sinh
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.studentName ?? "Chưa rõ tên",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('HH:mm, dd/MM/yyyy').format(entry.createdAt),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Trạng thái (hiển thị bằng Chip)
            Chip(
              label: Text(
                _getStatusText(entry.status),
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: _getStatusColor(entry.status),
            ),
          ],
        ),
      ),
    );
  }


  // Hàm lấy biểu tượng theo trạng thái
  IconData _getStatusIcon(RollCallStatus status) {
    switch (status) {
      case RollCallStatus.present:
        return Icons.check_circle;
      case RollCallStatus.absent:
        return Icons.cancel;
      case RollCallStatus.late:
        return Icons.access_time;
      case RollCallStatus.excused:
        return Icons.info;
    }
  }

  // Hàm lấy màu sắc theo trạng thái
  Color _getStatusColor(RollCallStatus status) {
    switch (status) {
      case RollCallStatus.present:
        return Colors.green;
      case RollCallStatus.absent:
        return Colors.red;
      case RollCallStatus.late:
        return Colors.orange;
      case RollCallStatus.excused:
        return Colors.blue;
    }
  }

  // Hàm lấy text trạng thái
  String _getStatusText(RollCallStatus status) {
    switch (status) {
      case RollCallStatus.present:
        return "Có mặt";
      case RollCallStatus.absent:
        return "Vắng";
      case RollCallStatus.late:
        return "Trễ";
      case RollCallStatus.excused:
        return "Có phép";
    }
  }

  CustomAppBar _buildAppBar(BuildContext context) {
    return CustomAppBar(
      backgroundColor: kWhiteColor,
      title: 'Dữ liệu điểm danh',
      leftWidget: InkWell(
        child: const Icon(FontAwesomeIcons.arrowLeft),
        onTap: () async {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildArrowButton(IconData icon, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(icon, color: Colors.blueAccent, size: 30),
      onPressed: onPressed,
    );
  }
}
