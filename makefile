# Last Update: 2025.02.18

# Yeniden Başlat
restart:
	chmod 600 volumes/certbot/cloudflare.ini
	docker compose down -v --remove-orphans
	docker compose up mailserver -d --build
	docker logs mailserver -f

# Build
build:
	docker compose build


# stat -c '%a' volumes/postfix/main.cf
# 644


# Başlat
up:
	chmod 600 volumes/certbot/cloudflare.ini
	docker compose up mailserver -d

# Kapat
down:
	docker compose down -v --remove-orphans

# Temizle
clean:
	docker system prune -a

# Log
log:
	docker logs mailserver -f

# Container Durumu
ps:
	docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" -a
	watch -n 2 'docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Size}}\t{{.Ports}}" | grep mailserver'

# Düzeltme
fix:
	chmod 600 volumes/certbot/cloudflare.ini
	docker network create --driver bridge proxy

# E-posta Gönder
sendmail:
	docker-compose run --rm email-sender

# sudo docker cp mailserver:/etc/postfix/main.cf ./volumes/postfix/main.cf
# Postfix yapılandırmasını güncelle sonra make restart yapın
postfix-config:
	docker cp volumes/postfix/main.cf mailserver:/etc/postfix/main.cf
	docker exec mailserver chown root:root /etc/postfix/main.cf
	docker exec mailserver chmod 644 /etc/postfix/main.cf