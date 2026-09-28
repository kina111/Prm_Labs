import 'package:flutter/material.dart';

class CommonLayoutFixesScreen extends StatefulWidget {
  const CommonLayoutFixesScreen({super.key});

  @override
  State<CommonLayoutFixesScreen> createState() => _CommonLayoutFixesScreenState();
}

class _CommonLayoutFixesScreenState extends State<CommonLayoutFixesScreen> {
  // Biến state lưu ngày được chọn
  DateTime? _selectedDate;

  // Task 4: Dùng context hợp lệ (từ builder hoặc widget con nằm dưới Scaffold)
  // để mở DatePicker an toàn, tránh lỗi BuildContext không gắn với Navigator/MaterialLocalizations.
  Future<void> _pickDate(BuildContext validContext) async {
    final DateTime? picked = await showDatePicker(
      context: validContext,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null && picked != _selectedDate) {
      // Task 3: Bắt buộc dùng setState() để trigger framework build lại UI với giá trị mới
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Common Flutter Fixes'),
        centerTitle: true,
      ),
      // Task 2: Bọc bằng SingleChildScrollView để chống lỗi "A RenderFlex overflowed..."
      // khi bàn phím ảo bật lên hoặc chạy trên màn hình quá ngắn (small screens).
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Text(
                'Demo khắc phục 4 lỗi layout & logic thường gặp',
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16.0),

            // Task 4 + Task 3: Khu vực chọn ngày & cập nhật State
            Builder(
              // Dùng Builder để tạo ra một BuildContext con hoàn toàn hợp lệ,
              // nằm bên dưới MaterialApp và Scaffold
              builder: (BuildContext innerContext) {
                return OutlinedButton.icon(
                  onPressed: () => _pickDate(innerContext),
                  icon: const Icon(Icons.calendar_today),
                  label: Text(
                    _selectedDate == null
                        ? 'Chọn ngày (DatePicker)'
                        : 'Ngày đã chọn: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                  ),
                );
              },
            ),
            const SizedBox(height: 16.0),

            const Text(
              'Danh sách dữ liệu (ListView lồng trong Column):',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8.0),

            // Task 1: Xử lý lỗi "Vertical viewport was given unbounded height"
            // Khi đặt ListView bên trong SingleChildScrollView + Column:
            // - Dùng SizedBox cố định chiều cao kèm Expanded bên trong (nếu Column toàn màn hình).
            // - Hoặc bọc ListView trong SizedBox với chiều cao xác định để phân vùng cuộn riêng.
            SizedBox(
              height: 250, // Cung cấp bounded height cho Column bên ngoài
              child: Column(
                children: [
                  Expanded(
                    // Task 1 cốt lõi: Bọc ListView trong Expanded để nó lấp đầy
                    // chính xác khoảng không gian dọc được cấp phát, không tràn vô tận.
                    child: ListView.builder(
                      itemCount: 15,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4.0),
                          child: ListTile(
                            dense: true,
                            leading: CircleAvatar(child: Text('${index + 1}')),
                            title: Text('Dữ liệu mục số ${index + 1}'),
                            subtitle: const Text('Cuộn độc lập, không gây crash'),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),

            // Mô phỏng các form input dễ gây tràn màn hình khi bật bàn phím
            const TextField(
              decoration: InputDecoration(
                labelText: 'Test bàn phím ảo (Gõ để kiểm tra SingleChildScrollView)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Xác nhận thông tin'),
            ),
          ],
        ),
      ),
    );
  }
}