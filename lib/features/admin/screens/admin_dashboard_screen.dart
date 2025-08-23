import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/admin_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../dto/room/room_create_dto.dart';
import '../dto/voucher/voucher_create_dto.dart';
import '../dto/staff/staff_shift_create_dto.dart';
import '../dto/admin_user_update_dto.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

// Widget tái sử dụng cho stat card
class StatCard extends StatelessWidget {
  final String title;
  final int count;

  const StatCard({super.key, required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(
              count.toString(),
              style: const TextStyle(fontSize: 24, color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget tái sử dụng cho dashboard card
class DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String route;
  final VoidCallback? onAdd;
  final VoidCallback? onDelete;

  const DashboardCard({
    super.key,
    required this.icon,
    required this.title,
    required this.route,
    this.onAdd,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.blue.shade700),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            if (onAdd != null)
              IconButton(icon: const Icon(Icons.add), onPressed: onAdd),
            if (onDelete != null)
              IconButton(icon: const Icon(Icons.delete), onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  void _fetchData() {
    final provider = Provider.of<AdminProvider>(context, listen: false);
    provider.fetchUsers();
    provider.fetchRooms();
    provider.fetchVouchers();
    provider.fetchBookings();
    provider.fetchStaffs(); // Đảm bảo fetch danh sách staff
    // Không cần fetchShifts ở đây, để ShiftManagementScreen xử lý
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchData());
  }

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    if (authProvider.user?.role != 'Admin') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/home');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bảng Điều Khiển Admin'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _fetchData),
        ],
      ),
      body:
          adminProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : adminProvider.errorMessage != null
              ? Center(
                child: Text(
                  adminProvider.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              )
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tóm Tắt:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          StatCard(
                            title: 'Users',
                            count: adminProvider.users.length,
                          ),
                          StatCard(
                            title: 'Rooms',
                            count: adminProvider.rooms.length,
                          ),
                          StatCard(
                            title: 'Vouchers',
                            count: adminProvider.vouchers.length,
                          ),
                          StatCard(
                            title: 'Shifts',
                            count: adminProvider.shifts.length,
                          ),
                          StatCard(
                            title: 'Bookings',
                            count: adminProvider.bookings.length,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1.5,
                            ),
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          final cards = [
                            {
                              'icon': Icons.people,
                              'title': 'Quản Lý User',
                              'route': '/admin/user-management',
                              'onAdd':
                                  () => _showAddUserDialog(
                                    context,
                                    adminProvider,
                                  ),
                              'onDelete':
                                  () => _showDeleteDialog(
                                    context,
                                    adminProvider,
                                    'user',
                                  ),
                            },
                            {
                              'icon': Icons.room,
                              'title': 'Quản Lý Phòng',
                              'route': '/admin/room-management',
                              'onAdd':
                                  () => _showAddRoomDialog(
                                    context,
                                    adminProvider,
                                  ),
                              'onDelete':
                                  () => _showDeleteDialog(
                                    context,
                                    adminProvider,
                                    'room',
                                  ),
                            },
                            {
                              'icon': Icons.local_offer,
                              'title': 'Quản Lý Voucher',
                              'route': '/admin/voucher-management',
                              'onAdd':
                                  () => _showAddVoucherDialog(
                                    context,
                                    adminProvider,
                                  ),
                              'onDelete':
                                  () => _showDeleteDialog(
                                    context,
                                    adminProvider,
                                    'voucher',
                                  ),
                            },
                            {
                              'icon': Icons.schedule,
                              'title': 'Quản Lý Ca Làm',
                              'route': '/admin/shift-management',
                              'onAdd':
                                  () => _showAddShiftDialog(
                                    context,
                                    adminProvider,
                                  ),
                              'onDelete':
                                  () => _showDeleteShiftDialog(
                                    context,
                                    adminProvider,
                                  ),
                            },
                            {
                              'icon': Icons.book_online,
                              'title': 'Quản Lý Booking',
                              'route': '/admin/booking-management',
                              'onAdd': null,
                              'onDelete': null,
                            },
                          ];
                          return DashboardCard(
                            icon: cards[index]['icon'] as IconData,
                            title: cards[index]['title'] as String,
                            route: cards[index]['route'] as String,
                            onAdd: cards[index]['onAdd'] as VoidCallback?,
                            onDelete: cards[index]['onDelete'] as VoidCallback?,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  void _showAddUserDialog(BuildContext context, AdminProvider provider) {
    final _fullNameController = TextEditingController();
    final _emailController = TextEditingController();
    final _phoneController = TextEditingController();
    int _roleId = 2; // Mặc định Customer

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Thêm Người Dùng'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _fullNameController,
                  decoration: const InputDecoration(labelText: 'Họ Tên'),
                ),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Số Điện Thoại'),
                ),
                DropdownButton<int>(
                  value: _roleId,
                  items: const [
                    DropdownMenuItem(value: 1, child: Text('Admin')),
                    DropdownMenuItem(value: 2, child: Text('Customer')),
                    DropdownMenuItem(value: 3, child: Text('Staff')),
                  ],
                  onChanged: (value) => setState(() => _roleId = value!),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () {
                  final dto = AdminUserUpdateDto(
                    userId: 0,
                    roleId: _roleId,
                  ); // Tạm thời, cần API tạo user
                  // Gọi API tạo user nếu backend có endpoint (hiện chưa, có thể thêm sau)
                  Navigator.pop(context);
                },
                child: const Text('Thêm'),
              ),
            ],
          ),
    );
  }

  void _showAddShiftDialog(BuildContext context, AdminProvider provider) {
    final _dateController = TextEditingController();
    String _shiftTime = 'Morning';
    int _staffId = 1; // Mặc định, có thể chọn từ danh sách

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Thêm Ca Làm'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _dateController,
                  decoration: const InputDecoration(
                    labelText: 'Ngày (yyyy-MM-dd)',
                  ),
                ),
                DropdownButton<String>(
                  value: _shiftTime,
                  items: const [
                    DropdownMenuItem(value: 'Morning', child: Text('Sáng')),
                    DropdownMenuItem(value: 'Afternoon', child: Text('Chiều')),
                    DropdownMenuItem(value: 'Night', child: Text('Tối')),
                  ],
                  onChanged: (value) => setState(() => _shiftTime = value!),
                ),
                // Có thể thêm Dropdown cho staffId nếu cần
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () {
                  final dto = StaffShiftCreateDto(
                    staffId: _staffId,
                    shiftDate: DateTime.parse(_dateController.text),
                    shiftTime: _shiftTime,
                  );
                  provider.assignShift(dto);
                  Navigator.pop(context);
                },
                child: const Text('Thêm'),
              ),
            ],
          ),
    );
  }

  void _showAddRoomDialog(BuildContext context, AdminProvider provider) {
    final _roomNumberController = TextEditingController();
    final _priceController = TextEditingController();
    String? _description;
    File? _image;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Thêm Phòng'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _roomNumberController,
                  decoration: const InputDecoration(labelText: 'Số Phòng'),
                ),
                TextField(
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: 'Giá/Đêm'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  onChanged: (value) => _description = value,
                  decoration: const InputDecoration(labelText: 'Mô Tả'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final picker = ImagePicker();
                    final picked = await picker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (picked != null)
                      setState(() => _image = File(picked.path));
                  },
                  child: const Text('Chọn Ảnh'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () {
                  final dto = RoomCreateDto(
                    roomNumber: _roomNumberController.text,
                    pricePerNight: double.parse(_priceController.text),
                    isAvailable: true,
                    description: _description,
                    image: _image,
                  );
                  provider.createRoom(dto);
                  Navigator.pop(context);
                },
                child: const Text('Thêm'),
              ),
            ],
          ),
    );
  }

  void _showAddVoucherDialog(BuildContext context, AdminProvider provider) {
    final _codeController = TextEditingController();
    final _discountController = TextEditingController();
    final _expiryController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Thêm Voucher'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _codeController,
                  decoration: const InputDecoration(labelText: 'Mã Voucher'),
                ),
                TextField(
                  controller: _discountController,
                  decoration: const InputDecoration(labelText: 'Giảm (%)'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _expiryController,
                  decoration: const InputDecoration(
                    labelText: 'Hết hạn (yyyy-MM-dd)',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () {
                  final dto = VoucherCreateDto(
                    code: _codeController.text,
                    discount: int.parse(_discountController.text),
                    expiryDate: DateTime.parse(_expiryController.text),
                  );
                  provider.createVoucher(dto);
                  Navigator.pop(context);
                },
                child: const Text('Thêm'),
              ),
            ],
          ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    AdminProvider provider,
    String type,
  ) {
    final _idController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Xóa Item'),
            content: TextField(
              controller: _idController,
              decoration: const InputDecoration(labelText: 'Nhập ID để xóa'),
              keyboardType: TextInputType.number,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () {
                  final id = int.tryParse(_idController.text);
                  if (id != null) {
                    if (type == 'user') {
                      // Gọi API xóa user nếu có
                    } else if (type == 'room') {
                      provider.deleteRoom(id);
                    } else if (type == 'voucher') {
                      provider.deleteVoucher(id);
                    } else if (type == 'shift') {
                      // Giả định xóa shift, cần staffId
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: const Text('Xác nhận xóa ca'),
                              content: const Text('Nhập Staff ID:'),
                              actions: [
                                TextField(
                                  decoration: const InputDecoration(
                                    labelText: 'Staff ID',
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    final staffId = int.tryParse(value);
                                    if (staffId != null) {
                                      provider.deleteShift(id, staffId);
                                      Navigator.pop(context);
                                    }
                                  },
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Hủy'),
                                ),
                              ],
                            ),
                      );
                    }
                  }
                  Navigator.pop(context);
                },
                child: const Text('Xóa'),
              ),
            ],
          ),
    );
  }

  void _showDeleteShiftDialog(BuildContext context, AdminProvider provider) {
    final _idController = TextEditingController();
    final _staffIdController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Xóa Ca Làm'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _idController,
                  decoration: const InputDecoration(labelText: 'ID Ca Làm'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _staffIdController,
                  decoration: const InputDecoration(labelText: 'Staff ID'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () {
                  final id = int.tryParse(_idController.text);
                  final staffId = int.tryParse(_staffIdController.text);
                  if (id != null && staffId != null) {
                    provider.deleteShift(id, staffId);
                  }
                  Navigator.pop(context);
                },
                child: const Text('Xóa'),
              ),
            ],
          ),
    );
  }
}
