#cloud-config
write_files:
  - content: |
      user  nginx;
      worker_processes  auto;

      pid        /var/run/nginx.pid;

      events {
        worker_connections  1024;
      }
      stream {
        log_format basic '$remote_addr [$time_local] '
        '$protocol $status $bytes_sent $bytes_received '
        '$session_time';

        access_log  /dev/stdout   basic;
        error_log   /dev/stderr   debug;

        upstream consul {
          server ${consul_lb_ip}:443;
        }
        upstream grafana {
          server ${grafana_lb_ip}:443;
        }

        map $ssl_preread_server_name $targetBackend {
          consul.apatsev.org.ru   consul;
          grafana.apatsev.org.ru  grafana;
        }

        server {
          listen 443;

          proxy_connect_timeout 1s;
          proxy_timeout 3s;
          resolver ns1.yandexcloud.net;

          proxy_pass $targetBackend;
          ssl_preread on;
        }
      }
    path: /nginx.conf
