up:
	docker-compose up

run: 
	docker exec -i diyou_db psql -U admin -d diyou_db -f /tmp/scripts/${script}.sql 

down:
	docker-compose down