# 02. Kế hoạch triển khai và quyết định công nghệ

## 1. Phiên bản được đề xuất

| Thành phần | Phiên bản/lựa chọn | Lý do |
| --- | --- | --- |
| Ubuntu Server | 24.04 LTS | Được Elastic hỗ trợ cho Stack 9.5.x; LTS phù hợp Lab dài hạn. |
| Docker Desktop/Engine | 28.1.1 đã phát hiện trên Host | Cao hơn mức Docker 20.10.10 tối thiểu Elastic nêu cho Stack 8.16+; phải kiểm tra lại trong Ubuntu guest trước khi deploy. |
| Elasticsearch, Logstash, Kibana | 9.5.6, ghim cùng phiên bản | Bản phát hành Elastic Stack hiện hành khi khảo sát; Elastic yêu cầu dùng cùng phiên bản giữa các thành phần. |
| Windows collector | Winlogbeat 9.5.6 | Thu thập trực tiếp Windows Event Log và gửi được đến Logstash. |
| Firewall | pfSense CE (phiên bản sẽ chốt theo ISO có sẵn) | Có remote Syslog UDP và phù hợp yêu cầu đề tài. |

Chưa có thành phần nào trong bảng được cài trong Lab. Phiên bản sẽ được kiểm tra lại ngay trước khi tải ISO/image và được ghi vào Docker Compose, không dùng tag `latest`.

## 2. Lựa chọn Winlogbeat

Winlogbeat là lựa chọn đầu tiên vì phạm vi đề tài hẹp, đường đi dữ liệu rõ ràng và không cần dựng Fleet Server ở giai đoạn log collection. Nó đọc Event Log qua Windows APIs, lưu vị trí đã đọc để tiếp tục sau restart, và hỗ trợ output Logstash. Cấu hình ban đầu sẽ thu Security, System và Application; Security sẽ giữ các event ID quan trọng như 4624, 4625 và 4720.

Elastic Agent/Fleet là phương án mở rộng sau này nếu cần quản lý nhiều endpoint tập trung. Không triển khai cả hai collector trên cùng Windows Server.

## 3. Phương án pfSense Syslog

pfSense remote logging gửi được đến tối đa ba server và cho phép chỉ định UDP port. Logstash `syslog` input sẽ lắng nghe UDP `5514` trên VMnet1 và gắn metadata nguồn. Sau khi nhận log thật, pipeline sẽ được điều chỉnh theo raw filter log format của đúng phiên bản pfSense đang dùng; không đoán trước grok pattern.

## 4. Alert miễn phí phù hợp đề tài

Sử dụng Kibana rule dạng Elasticsearch query/threshold thay vì Machine Learning anomaly detection. Các rule miễn phí dự kiến:

1. Cùng tài khoản có từ năm Event ID 4625 trong hai phút.
2. Event ID 4624 để điều tra đăng nhập hợp lệ, ban đầu chỉ dashboard chứ không mặc định alert.
3. Event ID 4720 hoặc thay đổi tài khoản/quyền quản trị.
4. Event dịch vụ Windows có mức lỗi phù hợp.
5. Firewall event bị block/reject.
6. Rule kiểm tra tình trạng ingest theo source với mô tả rõ là “không có log mới”, không kết luận thiết bị mất kết nối.

Kibana alerting/rules có trong Basic miễn phí, nhưng một số loại rule (ví dụ ML anomaly detection) là tính năng subscription. Kết quả alert sẽ hiển thị/lưu trong Kibana; kết nối email, Slack hoặc dịch vụ ngoài chỉ được quyết định sau khi xác minh entitlement thực tế.

## 5. Các giai đoạn thực hiện

| Giai đoạn | Kết quả cần kiểm chứng |
| --- | --- |
| 1A — hoàn tất | Survey, repository baseline, kiến trúc và hướng dẫn VM |
| 1B | Ubuntu VM, dual-NIC networking và Docker Engine/Compose đã hoàn tất; Elastic Stack runtime đang chờ triển khai |
| 1C | Elasticsearch, Logstash và Kibana đang chạy; TLS/authentication và health checks đã có bằng chứng |
| 2 | Winlogbeat và pfSense gửi log thật vào Elasticsearch |
| 3 | Dashboard, detection rules, alert history |
| 4 | Sáu test case, số liệu thực nghiệm, screenshots, demo runbook |

## 6. Nguồn kiểm chứng

- [Elastic Support Matrix](https://www.elastic.co/support/matrix)
- [Elastic Stack release notes](https://www.elastic.co/docs/release-notes)
- [Elastic Stack versioning](https://www.elastic.co/docs/get-started/versioning-availability)
- [Winlogbeat documentation](https://www.elastic.co/docs/reference/beats/winlogbeat)
- [Kibana rule types](https://www.elastic.co/docs/explore-analyze/alerting/alerts/rule-types)
- [Elastic subscriptions](https://www.elastic.co/subscriptions)
- [pfSense remote Syslog documentation](https://docs.netgate.com/pfsense/en/latest/monitoring/logs/remote.html)
