# 01. Kiến trúc SIEM Lab đề xuất

## 1. Mục tiêu

Mô hình thu thập log Windows Server và pfSense về một Ubuntu Server chạy Elastic Stack, sau đó dùng Kibana để tìm kiếm, trực quan hóa và hiển thị cảnh báo trong môi trường Lab cô lập.

## 2. Trạng thái khảo sát (chỉ đọc, 03-11-2026)

| Hạng mục | Kết quả xác minh |
| --- | --- |
| Windows Host | Windows 10 Pro, version 2009 |
| VMware Workstation | 17.5.2 |
| Docker Desktop Engine | 28.1.1, context `desktop-linux` |
| VMware inventory | Không có VM được liệt kê trong inventory hiện tại |
| VMnet1 host-only | `192.168.109.0/24`, host adapter `192.168.109.1` |
| VMnet8 NAT | `192.168.75.0/24`, NAT gateway `192.168.75.2`, host adapter `192.168.75.1` |

Không có mục nào trong bảng trên đồng nghĩa Ubuntu, Windows Server hoặc pfSense đã được cài. Lệnh `vmrun list` không khởi chạy được, vì vậy kết luận về VM dựa trên VMware inventory rỗng, không phải kiểm chứng runtime.

## 2.1. Cập nhật triển khai (04-11-2026)

Ubuntu SIEM VM hiện đã được triển khai. NIC Host-only `ens34` được gán tĩnh
`192.168.109.10/24`; Windows Host đã kiểm tra được ICMP và SSH/TCP 22 tới địa
chỉ này. NAT management vẫn hoạt động qua `ens33`.

## 3. Topology VMware đề xuất

Topology này tái sử dụng hai mạng đang có và không yêu cầu thay đổi VMware Network Adapter:

```text
                         Windows Host
               Kibana browser via VMnet8 only
                              |
         VMnet8 NAT: 192.168.75.0/24 (management/WAN-like)
                 |                    |
          pfSense WAN              Ubuntu SIEM eth0
                                      |
            VMnet1 host-only: 192.168.109.0/24 (isolated lab LAN)
                 |                    |
          pfSense LAN           Ubuntu SIEM eth1
                 |
           Windows Server
```

Địa chỉ dưới đây là **đề xuất**, chưa được cấu hình:

| Thành phần | Interface | Địa chỉ đề xuất | Mục đích |
| --- | --- | --- | --- |
| pfSense | LAN / VMnet1 | `192.168.109.254/24` | Gateway của Lab LAN |
| Ubuntu SIEM | ens34 / VMnet1 | `192.168.109.10/24` (đã cấu hình) | Nhận Syslog và Beats |
| Windows Server | NIC / VMnet1 | `192.168.109.20/24` | Nguồn Windows Events |
| Ubuntu SIEM | ens33 / VMnet8 | DHCP | Quản trị và cập nhật |
| pfSense | WAN / VMnet8 | DHCP | WAN-like path phục vụ test firewall |

`192.168.109.1` và `192.168.75.1` thuộc adapter của Windows Host; không được gán lại cho VM. Trước khi tạo VM, phải kiểm tra các địa chỉ đề xuất chưa bị sử dụng.

## 4. Luồng log

```text
Windows Security/System/Application
  -> Winlogbeat (TLS, port 5044)
  -> Logstash
  -> Elasticsearch (TLS + authentication)
  -> Kibana

pfSense firewall events
  -> UDP Syslog on VMnet1 (port 5514)
  -> Logstash
  -> Elasticsearch
  -> Kibana
```

Port `5514/UDP` được dùng thay `514/UDP` để Logstash không cần đặc quyền root. pfSense hỗ trợ chỉ định cổng UDP tùy chọn cho remote Syslog. Syslog gốc của pfSense truyền rõ văn bản qua UDP, vì vậy nó chỉ được chấp nhận trên VMnet1 cô lập; không được gửi qua WAN hoặc Internet.

## 5. Kiểm soát bảo mật

- Elasticsearch dùng security mặc định, tài khoản riêng cho Kibana và Logstash, TLS bằng CA nội bộ.
- Winlogbeat xác minh CA của Logstash; không dùng `verification_mode: none`.
- Kibana chỉ truy cập từ Windows Host qua VMnet8 hoặc một adapter quản trị đã được duyệt.
- Elasticsearch không publish ra Internet; Docker port publishing sẽ được giới hạn khi Compose được viết ở giai đoạn kế tiếp.
- Firewall logs chỉ qua VMnet1; nếu sau này cần truyền qua mạng không tin cậy, phải dùng VPN hoặc syslog-ng có mã hóa.

## 6. Phân bổ tài nguyên khởi điểm

| VM | vCPU | RAM | Disk | Ghi chú |
| --- | ---: | ---: | ---: | --- |
| Ubuntu SIEM | 4 | 10 GB | 100 GB thin-provisioned | Có thể tăng lên 12 GB nếu Elastic thiếu bộ nhớ |
| Windows Server | 2 | 6 GB | 60 GB | Dùng cho controlled tests |
| pfSense | 1 | 2 GB | 20 GB | Hai NIC: VMnet8 và VMnet1 |

Không bật cả ba VM khi chưa cần để giữ tài nguyên cho Windows Host.
