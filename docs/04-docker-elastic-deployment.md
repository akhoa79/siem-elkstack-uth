# 04. Triển khai Docker và Elastic Stack

Tài liệu này chỉ áp dụng sau khi Ubuntu SIEM đã có địa chỉ Host-only tĩnh
`192.168.109.10/24`. Không chạy stack trên Docker Desktop của Windows Host;
toàn bộ container chạy trong Ubuntu VM.

## 1. Kiến trúc runtime

| Service | Vai trò | Port publish |
| --- | --- | --- |
| Elasticsearch | Lưu trữ, tìm kiếm; TLS và authentication bắt buộc | Không publish ra Host/LAN |
| Kibana | Điều tra và dashboard | `192.168.109.10:5601/TCP` |
| Logstash Beats | Nhận Winlogbeat với TLS | `192.168.109.10:5044/TCP` |
| Logstash Syslog | Nhận pfSense trong LAN cô lập | `192.168.109.10:5514/UDP` |

Compose cố ý bind mọi cổng collector/UI vào NIC Host-only. Elasticsearch chỉ
nghe trong Docker network, nên không thể truy cập trực tiếp từ Windows/pfSense
hoặc Internet.

## 2. Prerequisites của Ubuntu

Trước khi chạy stack cần:

1. Docker Engine và Docker Compose plugin từ Docker APT repository chính thức.
2. `vm.max_map_count=262144` để Elasticsearch vượt bootstrap check.
3. File `.env` cục bộ, có mật khẩu mạnh và khóa Kibana tối thiểu 32 ký tự.

Các thao tác này thay đổi hệ thống Ubuntu nên thực hiện trong phiên SSH của
`siemadmin` với `sudo`, sau khi người dùng duyệt lệnh.

### 2.1. Cài Docker Engine và kernel setting

Ubuntu VM mới chưa có Docker, nên dùng Docker APT repository chính thức. Dán
khối lệnh sau trong SSH session; không dùng Docker Desktop trong guest.

```bash
sudo apt update
sudo apt install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
printf '%s\n' \
  'Types: deb' \
  'URIs: https://download.docker.com/linux/ubuntu' \
  'Suites: noble' \
  'Components: stable' \
  'Architectures: amd64' \
  'Signed-By: /etc/apt/keyrings/docker.asc' | sudo tee /etc/apt/sources.list.d/docker.sources >/dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable --now docker
sudo sysctl -w vm.max_map_count=262144
printf 'vm.max_map_count=262144\n' | sudo tee /etc/sysctl.d/99-elasticsearch.conf >/dev/null
sudo docker run --rm hello-world
```

Sau khi lệnh kết thúc, kiểm tra:

```bash
docker --version
sudo docker compose version
sysctl vm.max_map_count
```

Không thêm `siemadmin` vào Docker group trong mốc này vì thành viên Docker group
có quyền tương đương root. Các lệnh Docker của Lab sẽ dùng `sudo docker` rõ ràng.

## 3. Chuẩn bị secret cục bộ

Tại thư mục root repository trên Ubuntu:

```bash
cp .env.example .env
chmod 600 .env
nano .env
```

Thay thế cả bốn placeholder password/key bằng bốn giá trị riêng biệt. Dùng
`openssl rand -hex 32` để tạo từng giá trị sẽ tránh ký tự gây lỗi Compose và vẫn
đủ mạnh. Không gửi file này vào chat, ảnh chụp, Git, hay GitHub.

Để tạo tự động, thay vì điền tay, chạy từ root repository:

```bash
bash scripts/create-local-env.sh
```

Script chỉ thay thế `.env` khi file chưa tồn tại hoặc còn nguyên bốn placeholder;
nó từ chối ghi đè secret có sẵn và không in secret ra terminal.

## 4. Khởi động và xác minh

```bash
sudo docker compose --env-file .env -f docker/compose.yml config --quiet
sudo docker compose --env-file .env -f docker/compose.yml up -d
sudo docker compose --env-file .env -f docker/compose.yml ps
```

Sau khi `kibana` và `logstash` có trạng thái healthy, mở từ Windows Host:

```text
http://192.168.109.10:5601
```

Đăng nhập bằng username `elastic` và giá trị `ELASTIC_PASSWORD` trong `.env`.

## 5. Kiểm chứng tối thiểu

```bash
sudo docker compose --env-file .env -f docker/compose.yml logs --tail=100 elasticsearch
sudo docker compose --env-file .env -f docker/compose.yml logs --tail=100 logstash
curl --cacert config/elasticsearch/certs/ca/ca.crt \
  -u elastic https://localhost:9200/_cluster/health
```

Kết quả cluster health màu `yellow` là chấp nhận được ở single-node lab, do
replica không thể phân bổ cho chính node đó. Không tắt security/TLS chỉ để đổi
health thành `green`.

## 6. Nguồn kỹ thuật

- [Docker Engine on Ubuntu](https://docs.docker.com/engine/install/ubuntu/)
- [Elastic Stack version compatibility](https://www.elastic.co/docs/deploy-manage/deploy/self-managed/installing-elasticsearch)
- [Elasticsearch in Docker](https://www.elastic.co/docs/deploy-manage/deploy/self-managed/install-elasticsearch-docker-basic)
- [Logstash Docker configuration](https://www.elastic.co/docs/reference/logstash/docker-config)
