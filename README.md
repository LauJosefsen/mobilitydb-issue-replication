Procedure:
1. Build mobilitydb docker image `docker build -t mobilitydb:1.1 docker/postgres`
2. Run the postgres container `docker run --rm -d --name mobilitydb -p 5432:5432 -e POSTGRES_PASSWORD=password mobilitydb:1.1`
3. Execute the setup database script `docker exec -it mobilitydb psql -U postgres -h localhost -f /queries/setup-database.sql`
4. Probe with the query using `docker exec -it mobilitydb psql -U postgres -h localhost -d mobilitydb -f /queries/query.sql`

To cleanup just run `docker kill mobilitydb`