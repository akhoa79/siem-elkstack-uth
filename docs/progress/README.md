# Nhật ký hoàn thành dự án

Thư mục này lưu các mốc hoàn thành đã được kiểm chứng của dự án. Mỗi phần quan trọng chỉ được tạo một file mới khi công việc đã có bằng chứng; không thay thế bằng nhận định hoặc kết quả dự kiến.

## Quy ước đặt tên

```text
NN-ten-giai-doan.md
```

Ví dụ: `03-elk-deployment.md` chỉ được tạo sau khi Elasticsearch, Logstash và Kibana đã chạy và được kiểm tra thực tế.

## Nội dung bắt buộc của một completion record

1. Mục tiêu và phạm vi đã thực hiện.
2. Cấu hình hoặc quyết định kỹ thuật thực tế.
3. Các lệnh/kiểm tra đã chạy và kết quả.
4. Bằng chứng: ảnh, log đã lọc dữ liệu nhạy cảm, hoặc liên kết dashboard.
5. Vấn đề gặp phải và cách khắc phục.
6. Hạn chế còn lại và bước kế tiếp.

## Các mốc dự kiến

| File | Mốc | Điều kiện tạo |
| --- | --- | --- |
| `01-repository-and-design.md` | Repository và thiết kế | Đã khảo sát và commit tài liệu |
| `02-ubuntu-vm.md` | Ubuntu SIEM VM | VM được tạo, boot và network được kiểm tra |
| `07-pfsense-syslog.md` | Firewall collection | pfSense Syslog được parse từ dữ liệu thực tế |
| `08-security-dashboard.md` | Security dashboard | Dashboard có bằng chứng runtime từ Windows và pfSense |
| `09-detection-rules.md` | Detection rules | Rule có bằng chứng runtime |
| `10-testing-and-evaluation.md` | Kiểm thử và đánh giá | Sáu kịch bản và số liệu thực nghiệm hoàn tất |

## Mốc đã hoàn thành

| File | Mốc | Bằng chứng chính |
| --- | --- | --- |
| `01-repository-and-design.md` | Repository và thiết kế | Thiết kế, phạm vi và Git baseline đã được ghi nhận |
| `02-ubuntu-vm.md` | Ubuntu SIEM VM | VM, hai network interface và SSH đã kiểm tra |
| `03-elastic-deployment-manifests.md` | Elastic deployment manifests | Compose, TLS và cấu hình service đã hoàn tất |
| `04-docker-engine.md` | Docker Engine | Docker Engine và Docker Compose đã sẵn sàng trên Ubuntu |
| `05-elastic-stack-runtime.md` | Elastic Stack runtime | Elasticsearch, Kibana và Logstash healthy |
| `06-windows-winlogbeat.md` | Windows log collection | Winlogbeat TLS gửi sự kiện thực tế và Kibana Discover hiển thị 29 documents |
| `07-pfsense-syslog.md` | pfSense Syslog collection | pfSense gửi DHCP và Firewall `filterlog` thực tế qua UDP, Kibana Discover hiển thị dữ liệu |
| `08-security-dashboard.md` | Security dashboard | Dashboard Kibana hiển thị pfSense firewall block và Windows failed logon thực tế |

Các file này là nguồn dữ liệu cho báo cáo Word và slide, không phải bản báo cáo cuối cùng.
