# Mốc 02 — Ubuntu SIEM Virtual Machine

**Trạng thái:** Hoàn thành

**Ngày hoàn thành:** 04-11-2026

## 1. Mục tiêu đạt được

- Tạo Ubuntu Server VM phục vụ SIEM Lab trên VMware Workstation.
- Cài Ubuntu Server 24.04.5 LTS từ ISO chính thức đã xác minh SHA-256.
- Chuẩn bị hai network adapter: NAT để quản trị/cập nhật và Host-only để thu thập log Lab.
- Cài OpenSSH Server để sẵn sàng quản trị từ Windows Host.

## 2. Cấu hình thực tế

| Hạng mục | Giá trị |
| --- | --- |
| VM name | `siem-ubuntu` |
| Location | `D:\VirtualMachines\siem-ubuntu` |
| Guest OS | Ubuntu Server 24.04.5 LTS, 64-bit |
| VMware Workstation | 17.5.2 |
| vCPU | 4 (1 processor x 4 cores) |
| Memory | 10 GB |
| Virtual disk | 100 GB, SCSI, thin-provisioned, single VMDK |
| Root logical volume | Khoảng 49 GB ext4; LVM còn khoảng 49 GB để mở rộng |
| NIC 1 | NAT (VMnet8), DHCP `192.168.75.136/24` khi cài đặt |
| NIC 2 | Host-only (VMnet1), static `192.168.109.10/24` |
| Hostname | `siem-ubuntu` |
| Ubuntu user | `siemadmin` |
| Remote administration | OpenSSH Server đã cài |

## 3. Kiểm tra đã có bằng chứng

- Ubuntu boot thành công sau khi tháo ISO cài đặt.
- Login cục bộ thành công với tài khoản `siemadmin`.
- Console xác nhận Ubuntu `24.04.5 LTS`, kernel `6.8.0-147-generic`.
- Network NAT có IPv4 `192.168.75.136` trên `ens33` trong banner đăng nhập.
- Cloud-init hoàn tất, không báo lỗi khởi động.
- Windows Host kiểm tra thành công ICMP và TCP/22 (SSH) tới `192.168.75.136` qua NAT.
- Windows Host kiểm tra thành công ICMP và TCP/22 (SSH) tới `192.168.109.128` qua Host-only.
- Sau khi cấu hình Netplan, `ens34` nhận đúng static IP `192.168.109.10/24`.
- Windows Host kiểm tra lại thành công ICMP và TCP/22 (SSH) tới `192.168.109.10`.

## 4. Quyết định kỹ thuật

- Không dùng Easy Install để không tự động hóa tài khoản/mật khẩu qua VMware.
- Không bật Ubuntu Pro, LUKS encryption hoặc Server Snaps; chúng không cần thiết cho SIEM Lab và tăng độ phức tạp khi demo.
- LVM được giữ lại để có thể mở rộng filesystem khi dữ liệu Elasticsearch tăng.
- NIC Host-only đã được gán IP tĩnh `192.168.109.10/24`; đây là collector IP dành cho Windows Server và pfSense.

## 5. Bước tiếp theo

1. Kiểm tra chi tiết route, DNS, disk và SSH service.
2. Cập nhật Ubuntu và cài Docker Engine/Docker Compose.
3. Triển khai Elastic Stack có TLS và xác thực.

## 6. Ảnh minh chứng cần lưu

Chụp và đưa vào `screenshots/` trước khi báo cáo cuối:

- VMware summary với 4 vCPU, 10 GB RAM, 100 GB disk và hai NIC.
- Ubuntu installer network screen với hai interface.
- Console login thành công sau reboot.
