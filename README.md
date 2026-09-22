# TH3 - Ứng dụng dự báo thời tiết

Ứng dụng Flutter thực hiện theo yêu cầu trong đề:
- Màn hình chính có thanh tìm kiếm, nút tìm kiếm và danh sách thành phố nổi bật.
- Có gợi ý thành phố khi nhập chữ cái.
- Chọn thành phố sẽ mở màn hình chi tiết.
- Dữ liệu thời tiết lấy từ OpenWeatherMap API.
- Giao diện, màu sắc và icon có thể tùy chỉnh.

## . Chạy project

Mở Terminal tại thư mục project:

```bash
flutter pub get
flutter run
```

Có thể chạy Android Emulator hoặc điện thoại Android đã bật USB debugging.

## . Chức năng

### Trang chủ
- Tìm kiếm thành phố.
- Gợi ý từ danh sách thành phố Việt Nam.
- Thành phố nổi bật: Hồ Chí Minh, Hà Nội, Đà Nẵng, Cần Thơ, Hải Phòng.
- Bấm vào thành phố để xem chi tiết.

### Trang chi tiết
Hiển thị:
- Tên thành phố và quốc gia.
- Nhiệt độ hiện tại.
- Mô tả thời tiết.
- Cảm giác như.
- Độ ẩm.
- Tốc độ gió.
- Áp suất.
- Tầm nhìn.
- Nhiệt độ cao nhất/thấp nhất.
- Thời gian cập nhật.

## Lưu ý
API key không nên đưa lên GitHub công khai. Project này dùng API trực tiếp để phục vụ bài thực hành.


## Giao diện theo hình đề bài
Màn hình chính đã được chỉnh theo hình mẫu: tiêu đề `MSSV - Dự báo thời tiết`, ô tìm kiếm có nút xanh, mục `Thành phố nổi bật`, 6 thành phố Hà Nội, Thành phố Hồ Chí Minh, Đà Nẵng, Tokyo, Paris và Thành phố New York; mỗi thẻ có icon, mô tả và nhiệt độ màu xanh.


