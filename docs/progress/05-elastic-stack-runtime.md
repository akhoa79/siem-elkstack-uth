# Mốc 05 — Elastic Stack Runtime

**Trạng thái:** Hoàn thành

**Ngày hoàn thành:** 04-11-2026

## 1. Mục tiêu đạt được

- Khởi chạy Elasticsearch, Kibana và Logstash trong Ubuntu SIEM VM bằng Docker
  Compose.
- Xác minh Elasticsearch TLS/authentication bootstrap, Kibana và Logstash đã
  qua health checks.
- Publish đúng ba port Host-only đã thiết kế; Elasticsearch vẫn không có port
  publish ra Windows Host hoặc Lab LAN.

## 2. Bằng chứng runtime

Lệnh kiểm tra:

```bash
sudo docker compose --env-file .env -f docker/compose.yml ps
```

Kết quả xác minh:

| Service | Image | Trạng thái | Port |
| --- | --- | --- | --- |
| `elasticsearch` | `elasticsearch:9.5.6` | `Up (healthy)` | chỉ nội bộ Docker: `9200/tcp`, `9300/tcp` |
| `kibana` | `kibana:9.5.6` | `Up (healthy)` | `192.168.109.10:5601 -> 5601/tcp` |
| `logstash` | `logstash:9.5.6` | `Up (healthy)` | `192.168.109.10:5044/tcp`, `192.168.109.10:5514/udp` |

`setup` và `bootstrap` đã kết thúc thành công theo thiết kế sau khi tạo
certificate nội bộ, mật khẩu service account và Logstash role.

Windows Host cũng đã xác nhận TCP port `5601` (Kibana) và `5044` (Beats TLS)
đang reachable tại `192.168.109.10`.

Kibana web UI đã được mở và đăng nhập thành công từ Windows Host tại
`http://192.168.109.10:5601`. Browser hiển thị `Not secure` vì lớp browser-to-
Kibana hiện dùng HTTP trong VMnet1 Host-only; đây không ảnh hưởng TLS giữa
Logstash và Elasticsearch hoặc Winlogbeat và Logstash. HTTPS cho Kibana sẽ là
một hardening task riêng trước khi dùng ngoài Lab cô lập.

## 3. Kiểm soát bảo mật đã xác minh

- Elasticsearch không publish port host; Kibana và Logstash không thể truy cập
  qua NAT/Internet bằng Compose configuration này.
- Beats input chờ TLS ở `5044/TCP`.
- pfSense Syslog chỉ chờ UDP `5514` trên VMnet1 Host-only.
- CA, certificate private key, Docker data volume và `.env` không được Git theo
  dõi.

## 4. Bước tiếp theo

1. Mở Kibana tại `http://192.168.109.10:5601` từ Windows Host và xác minh login
   bằng tài khoản `elastic` với password cục bộ trong `.env`.
2. Cấu hình Windows Server và Winlogbeat TLS tới `192.168.109.10:5044`.
3. Dựng pfSense, gửi Syslog tới `192.168.109.10:5514/UDP` trên VMnet1.
4. Kiểm chứng index, dashboard và detection rules bằng log thật.
