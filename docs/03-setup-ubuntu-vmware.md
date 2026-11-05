# 03. Hướng dẫn chuẩn bị Ubuntu Server trên VMware

Tài liệu này là runbook cho Giai đoạn 1B. Chưa thực hiện các bước trong tài liệu khi chưa có xác nhận riêng vì chúng tạo VM và thay đổi hệ thống bên ngoài repository.

## 1. Chuẩn bị

1. Tải Ubuntu Server 24.04 LTS ISO từ trang chính thức và kiểm tra checksum SHA256 do Ubuntu công bố.
2. Bảo đảm Windows Host còn đủ khoảng 100 GB trống và không có VM quan trọng đang chạy.
3. Mở VMware Workstation 17.5.2 và kiểm tra lại VMnet1/VMnet8; không chỉnh Network Editor trong giai đoạn này.

## 2. Cấu hình VM đề xuất

| Thuộc tính | Giá trị |
| --- | --- |
| Tên | `siem-ubuntu` |
| Guest OS | Ubuntu 64-bit |
| CPU | 4 vCPU |
| RAM | 10 GB ban đầu |
| Disk | 100 GB, single file hoặc split file theo lựa chọn VMware |
| NIC 1 | VMnet8 NAT, quản trị/cập nhật |
| NIC 2 | VMnet1 Host-only, thu thập log trong Lab |

Không bật bridge mode. Không publish Elasticsearch ra Windows Host hay Internet.

## 3. Cài hệ điều hành

1. Chọn installation tối thiểu của Ubuntu Server 24.04 LTS.
2. Tạo tài khoản quản trị Lab riêng; sử dụng mật khẩu mạnh và lưu ngoài repository.
3. Chỉ bật OpenSSH Server nếu cần quản trị từ Windows Host. Khi bật, giới hạn truy cập trong mạng Lab/VMnet8.
4. Cập nhật hệ điều hành sau khi VM có kết nối quản trị và xác nhận được DNS/NTP.
5. Đặt hostname `siem-ubuntu` và timezone `Asia/Bangkok`.

## 4. Kiểm tra trước Docker

Thực hiện trên Ubuntu sau khi cài, ghi lại kết quả để làm bằng chứng:

```bash
hostnamectl
ip -brief address
ip route
timedatectl
free -h
df -h /
```

Xác minh NIC VMnet1 mang địa chỉ tĩnh đề xuất `192.168.109.10/24` và NIC VMnet8 có route mặc định. Chỉ áp dụng địa chỉ sau khi xác nhận không trùng với host/VM khác.

## 5. Điều kiện kết thúc Giai đoạn 1B

- Ubuntu khởi động được.
- Windows Host mở được SSH (nếu đã được duyệt) hoặc console VMware hoạt động.
- Ubuntu có đường quản trị qua VMnet8 nhưng mạng Lab qua VMnet1 vẫn cô lập.
- Chưa coi ELK đã chạy ở giai đoạn này; Docker/Compose là bước tiếp theo.
