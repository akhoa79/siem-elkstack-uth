# Mốc 01 — Repository và thiết kế SIEM Lab

**Trạng thái:** Hoàn thành

**Ngày hoàn thành:** 03-11-2026

## 1. Mục tiêu đạt được

- Tiếp nhận repository `siem-elkstack-uth` và xác minh trạng thái Git.
- Khảo sát read-only Windows Host, VMware Workstation, Docker Desktop và mạng VMware hiện hữu.
- Thiết lập baseline tài liệu, cấu trúc thư mục và template biến môi trường an toàn.
- Chốt kiến trúc Lab đề xuất để làm đầu vào cho giai đoạn tạo VM.

## 2. Kết quả thực tế

| Hạng mục | Kết quả |
| --- | --- |
| Git branch | `main`, không push thay đổi mới lên GitHub |
| Windows Host | Windows 10 Pro, version 2009 |
| VMware Workstation | 17.5.2 |
| Docker Desktop Engine | 28.1.1, context `desktop-linux` |
| VM inventory | Không có VM được liệt kê trong VMware inventory |
| VMnet1 | Host-only `192.168.109.0/24` |
| VMnet8 | NAT `192.168.75.0/24` |
| Elastic Stack đề xuất | 9.5.6, ghim cùng phiên bản khi triển khai |
| Ubuntu đề xuất | Ubuntu Server 24.04 LTS |

Lệnh `vmrun list` không khởi chạy được trên Windows Host. Kết luận về VM inventory chỉ dựa trên file inventory của VMware, không phải kiểm chứng runtime.

## 3. Cấu hình/tài liệu đã tạo

- [README dự án](../../README.md)
- [Kiến trúc SIEM Lab](../01-architecture.md)
- [Kế hoạch triển khai](../02-implementation-plan.md)
- [Runbook Ubuntu trên VMware](../03-setup-ubuntu-vmware.md)
- [Template biến môi trường](../../.env.example)
- [Quy tắc Git ignore](../../.gitignore)

Các thư mục `config/`, `docker/`, `scripts/` và `screenshots/` đã được tạo skeleton. Chưa có Docker Compose, certificate, VM hoặc service runtime.

## 4. Kiểm tra đã thực hiện

| Kiểm tra | Kết quả |
| --- | --- |
| `git status --short --branch` | Working tree sạch sau commit; nhánh local ahead remote 5 commit |
| `git diff --check HEAD~5 HEAD` | Không có lỗi whitespace |
| Kiểm tra `.env.example` | Có đủ biến yêu cầu, password là placeholder |
| Kiểm tra tài liệu | Các file tài liệu nội bộ tồn tại |

## 5. Commit liên quan

| Hash | Message |
| --- | --- |
| `51b357d` | `chore(git): configure repository ignore rules` |
| `e42c709` | `chore(config): add environment template and project directories` |
| `968867f` | `docs(architecture): document SIEM lab topology` |
| `c3cf6d6` | `docs(setup): add Ubuntu Server preparation guide` |
| `923aaf3` | `docs(readme): document project overview` |

## 6. Hạn chế và bước tiếp theo

Chưa thể kiểm thử runtime vì Ubuntu SIEM VM chưa được tạo. Mốc tiếp theo là `02-ubuntu-vm.md`, chỉ được tạo sau khi VM Ubuntu boot thành công, hai NIC được kiểm tra và thông tin thực tế được ghi nhận.
