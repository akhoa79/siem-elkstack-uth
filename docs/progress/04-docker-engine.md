# Mốc 04 — Docker Engine trên Ubuntu SIEM

**Trạng thái:** Hoàn thành

**Ngày hoàn thành:** 04-11-2026

## 1. Mục tiêu đạt được

- Cài Docker Engine từ Docker APT repository chính thức trên Ubuntu 24.04.
- Cài Docker Compose plugin và Buildx plugin.
- Bật Docker service khởi động cùng hệ điều hành.
- Thiết lập `vm.max_map_count=262144`, đáp ứng bootstrap check của Elasticsearch.

## 2. Cấu hình và phiên bản đã xác minh

| Hạng mục | Giá trị |
| --- | --- |
| Docker Engine | `29.9.3` |
| containerd.io | `2.4.2` |
| Docker Buildx plugin | `0.38.1` |
| Docker Compose plugin | `5.7.0` |
| Docker service | enabled và started |
| Elasticsearch kernel setting | `vm.max_map_count = 262144` |

## 3. Bằng chứng kiểm tra

Lệnh `sudo docker run --rm hello-world` đã hoàn thành và in `Hello from Docker!`.
Điều này xác nhận Docker client liên lạc được daemon, có thể pull image từ
Docker Hub, tạo container và chạy workload tối thiểu.

## 4. Ghi chú an toàn

- Không thêm `siemadmin` vào Docker group; Docker commands của Lab tiếp tục dùng
  `sudo` vì Docker group có quyền tương đương root.
- Cấu hình Docker APT source được ký bằng Docker official GPG key.
- Ubuntu hiện báo 27 package có thể nâng cấp. Cần cập nhật có kiểm soát trước
  hoặc ngay sau khi stack baseline chạy, rồi lưu bằng chứng phiên bản.

## 5. Bước tiếp theo

1. Copy repository đã commit từ Windows Host sang `/home/siemadmin/` trong VM.
2. Tạo `.env` local với bốn secret riêng; không commit hoặc chụp màn hình.
3. Validate Compose trên Ubuntu, pull image và khởi chạy Elastic Stack.
4. Kiểm chứng Elasticsearch, Kibana và Logstash health.
