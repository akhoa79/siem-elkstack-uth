# Mốc 03 — Elastic Deployment Manifests

**Trạng thái:** Hoàn thành phần cấu hình; chưa khởi chạy container

**Ngày cập nhật:** 04-11-2026

## 1. Kết quả đạt được

- Tạo Docker Compose manifest ghim Elastic Stack `9.5.6` đồng nhất cho
  Elasticsearch, Kibana và Logstash.
- Tạo certificate workflow cục bộ: CA nội bộ và certificate PEM cho ba service
  được sinh bởi `setup` container, lưu ở `config/elasticsearch/certs/` và bị Git
  ignore.
- Bật Elasticsearch TLS cho HTTP và transport; Elasticsearch không publish port
  ra Windows Host hoặc Lab LAN.
- Tạo tài khoản nội bộ `kibana_system` và `logstash_internal`; Logstash có role
  tối thiểu cho index `siem-*`.
- Bind Kibana (`5601`), Beats TLS (`5044`) và pfSense Syslog UDP (`5514`) riêng
  vào `192.168.109.10` của Host-only network.
- Tạo Logstash pipeline ban đầu cho Winlogbeat TLS và pfSense Syslog.

## 2. Kiểm tra đã thực hiện

Lệnh sau chạy thành công trên Windows Host để xác nhận cú pháp và Compose
interpolation, không khởi động hay tải container:

```powershell
docker compose --env-file .env.example -f docker/compose.yml config --quiet
```

Kết quả: `COMPOSE_CONFIG_VALID`.

## 3. Tệp liên quan

- `docker/compose.yml`
- `config/elasticsearch/instances.yml`
- `config/logstash/pipeline/siem.conf`
- `.env.example`
- `docs/04-docker-elastic-deployment.md`

## 4. Việc còn lại trước runtime

1. Cài Docker Engine/Compose plugin trong Ubuntu VM.
2. Cấu hình `vm.max_map_count=262144`.
3. Copy repository sang Ubuntu và tạo `.env` local với secret do chủ dự án tự
   đặt; không gửi các giá trị này qua chat hoặc commit.
4. Khởi chạy Compose, kiểm tra health và lưu screenshot/log làm bằng chứng.
