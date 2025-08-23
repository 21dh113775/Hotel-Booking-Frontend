# 🏨 Hotel Booking System - Frontend

Ứng dụng Flutter Web cho hệ thống đặt phòng khách sạn với giao diện thân thiện và tính năng đầy đủ.

## 🌟 Tính năng chính

- **🔐 Xác thực người dùng**: Đăng ký, đăng nhập, quản lý hồ sơ
- **🏠 Quản lý phòng**: Xem danh sách phòng, chi tiết phòng, kiểm tra tình trạng
- **📅 Đặt phòng**: Tạo, xem, quản lý đặt phòng với lịch trình linh hoạt  
- **🎫 Voucher**: Quản lý và áp dụng mã giảm giá
- **👥 Quản trị**: Dashboard admin cho quản lý nhân viên và ca làm việc
- **📱 Responsive**: Tối ưu cho web desktop và mobile

## 📂 Repositories

- **Backend** (ASP.NET + SQL Server): [HotelBooking](https://github.com/21dh113775/HotelBooking)
- **Frontend** (Flutter Web): [HotelBooking-Frontend](https://github.com/21dh113775/HotelBooking-Frontend)

## 🏗️ Kiến trúc dự án

Dự án được tổ chức theo **feature-based structure**, phân chia theo các tính năng chính để đảm bảo tính độc lập và dễ bảo trì. Mỗi thư mục tính năng chứa các thành phần liên quan (models, services, providers, screens, widgets).

### 📁 Cấu trúc thư mục

```
lib/
├── main.dart                    # Điểm vào chính, khởi tạo providers và routing
├── core/                       # Thành phần dùng chung toàn dự án
│   ├── constants/              # Hằng số và cấu hình
│   │   ├── api_config.dart     # Base URL, endpoints API
│   │   ├── app_colors.dart     # Màu sắc theme
│   │   ├── app_styles.dart     # Style text, padding, margin
│   │   └── app_routes.dart     # Định nghĩa routes
│   ├── helpers/                # Hàm hỗ trợ dùng chung
│   │   ├── api_helper.dart     # Xử lý lỗi API, format response
│   │   ├── date_formatter.dart # Format ngày giờ cho booking
│   │   └── validator.dart      # Validation form
│   └── widgets/                # Widget dùng chung
│       ├── custom_button.dart
│       ├── custom_text_field.dart
│       ├── loading_spinner.dart
│       └── error_dialog.dart
├── features/                   # Các tính năng chính
│   ├── auth/                   # 🔐 Xác thực người dùng
│   │   ├── models/user.dart
│   │   ├── services/auth_service.dart
│   │   ├── providers/auth_provider.dart
│   │   ├── screens/
│   │   │   ├── login_screen.dart
│   │   │   ├── register_screen.dart
│   │   │   └── profile_screen.dart
│   │   └── widgets/
│   │       ├── login_form.dart
│   │       └── register_form.dart
│   ├── rooms/                  # 🏠 Quản lý phòng
│   │   ├── models/room.dart
│   │   ├── services/room_service.dart
│   │   ├── providers/room_provider.dart
│   │   ├── screens/
│   │   │   ├── room_list_screen.dart
│   │   │   └── room_detail_screen.dart
│   │   └── widgets/
│   │       ├── room_card.dart
│   │       └── availability_indicator.dart
│   ├── bookings/              # 📅 Đặt phòng
│   │   ├── models/booking.dart
│   │   ├── services/booking_service.dart
│   │   ├── providers/booking_provider.dart
│   │   ├── screens/
│   │   │   ├── booking_form_screen.dart
│   │   │   ├── booking_list_screen.dart
│   │   │   └── booking_detail_screen.dart
│   │   └── widgets/
│   │       ├── date_picker.dart
│   │       └── booking_summary.dart
│   ├── vouchers/              # 🎫 Quản lý voucher
│   │   ├── models/voucher.dart
│   │   ├── services/voucher_service.dart
│   │   ├── providers/voucher_provider.dart
│   │   ├── screens/voucher_screen.dart
│   │   └── widgets/voucher_card.dart
│   └── admin/                 # 👥 Quản trị hệ thống
│       ├── models/shift.dart
│       ├── services/admin_service.dart
│       ├── providers/admin_provider.dart
│       ├── screens/
│       │   ├── staff_management_screen.dart
│       │   └── shift_management_screen.dart
│       └── widgets/staff_card.dart
├── models/                    # Models dùng chung
│   └── error_response.dart
├── services/                  # Services dùng chung
│   └── api_client.dart        # HTTP client cơ bản
├── providers/                 # Providers dùng chung
│   └── app_provider.dart      # Provider toàn cục
└── screens/                   # Màn hình chính
    ├── home_screen.dart       # Màn hình chính (bottom navigation)
    └── splash_screen.dart     # Màn hình khởi động
```

## 🚀 Hướng dẫn cài đặt

### Yêu cầu hệ thống

- Flutter SDK >= 3.0.0
- Dart >= 3.0.0
- Web browser hỗ trợ (Chrome, Firefox, Safari, Edge)

### Cài đặt

1. **Clone repository**
   ```bash
   git clone https://github.com/21dh113775/HotelBooking-Frontend.git
   cd HotelBooking-Frontend
   ```

2. **Cài đặt dependencies**
   ```bash
   flutter pub get
   ```

3. **Cấu hình API**
   
   Cập nhật `lib/core/constants/api_config.dart`:
   ```dart
   class ApiConfig {
     static const String baseUrl = 'https://your-backend-url.com';
     // Các endpoints khác...
   }
   ```

4. **Chạy ứng dụng**
   ```bash
   flutter run -d chrome
   ```

5. **Build cho production**
   ```bash
   flutter build web
   ```

## 🛠️ Công nghệ sử dụng

- **Framework**: Flutter Web
- **State Management**: Provider
- **HTTP Client**: Dio/http
- **Routing**: Go Router
- **UI Components**: Material Design 3
- **Date Handling**: intl package
- **Form Validation**: Custom validators

## 📱 Tính năng theo Role

### 👤 Khách hàng (Customer)
- Đăng ký, đăng nhập tài khoản
- Xem danh sách phòng và chi tiết
- Đặt phòng với lịch trình linh hoạt
- Quản lý đặt phòng cá nhân
- Sử dụng voucher giảm giá
- Cập nhật hồ sơ cá nhân

### 🏨 Nhân viên (Staff)
- Quản lý đặt phòng của khách hàng
- Cập nhật trạng thái phòng
- Xử lý check-in/check-out
- Tạo và quản lý voucher

### 👑 Quản trị viên (Admin)
- Quản lý toàn bộ hệ thống
- Quản lý nhân viên và ca làm việc
- Báo cáo thống kê
- Cấu hình hệ thống

## 🎨 Thiết kế UI/UX

- **Design System**: Material Design 3 với custom theme
- **Color Scheme**: Modern và professional
- **Typography**: Readable và consistent
- **Responsive**: Adaptive layouts cho mọi screen size
- **Accessibility**: Tuân thủ accessibility guidelines

## 🔒 Bảo mật

- JWT Token authentication
- Role-based access control
- Input validation và sanitization
- Secure API communication
- Protected routes

## 🧪 Testing

Chạy tests:
```bash
# Unit tests
flutter test

# Widget tests
flutter test test/widget_test

# Integration tests
flutter drive --target=test_driver/app.dart
```

## 📈 Performance

- **Lazy loading** cho danh sách lớn
- **Caching** dữ liệu để giảm API calls
- **Optimized builds** cho production
- **Progressive loading** cho images
- **Efficient state management**

## 🤝 Đóng góp

1. Fork repository
2. Tạo feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push branch (`git push origin feature/AmazingFeature`)
5. Mở Pull Request

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.

## 📞 Liên hệ

- **Developer**: [21dh113775]
- **Project Link**: [https://github.com/21dh113775/HotelBooking-Frontend](https://github.com/21dh113775/HotelBooking-Frontend)
- **Backend Repository**: [https://github.com/21dh113775/HotelBooking](https://github.com/21dh113775/HotelBooking)

---

**⭐ Nếu project hữu ích, hãy star repository để ủng hộ nhé! ⭐**