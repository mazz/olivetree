# rename elixir project

git grep -l 'old_name' | xargs sed -i '' -e 's/old_name/new_name/g'
git grep -l 'OldName' | xargs sed -i '' -e 's/OldName/NewName/g'
mv ./lib/old_name ./lib/new_name
mv ./lib/old_name.ex ./lib/new_name.ex
If you have a similar folder structure in the tests folder, you probably also need:
mv ./test/old_name ./test/new_name
mv ./lib/old_name_web ./lib/new_name_web
mv ./lib/old_name_web.ex ./lib/new_name_web.ex

# docker logs
docker logs <container-id>

https://www.shanesveller.com/blog/2018/11/13/kubernetes-native-phoenix-apps-part-2/

docker-compose pull
docker-compose build --pull olivetree
## OR build and restart olivetree only -- use IFF there was no db schema change!
docker-compose up --detach --build olivetree 

docker-compose up --build -d postgres

docker cp ./2019-05-04-media-item-seeded-not-materialized.pgsql olivetree-phx_postgres_1:/2019-05-04-media-item-seeded-not-materialized.pgsql

docker exec -ti olivetree-phx_postgres_1 bash

psql -U olivetree
<!-- drop database olivetree;
create database olivetree; -->
SET session_replication_role = replica;
\q

pg_restore -U olivetree --clean --dbname=olivetree 2019-05-04-media-item-seeded-not-materialized.pgsql
psql -U olivetree
SET session_replication_role = DEFAULT;
exit

docker-compose run --rm olivetree seed
docker-compose run --rm olivetree generate_hash_ids

refresh materialized view media_items_search;

Booting the application in Docker-Compose

docker-compose up --build olivetree

You can then browse the application by visiting http://localhost:4000 as normal, and should see the typical (production-style) log output in the shell session that’s running the above docker-compose command.

Note that this running container will not pick up any new file changes, perform live-reload behavior, and is generally not useful for development purposes. It’s primary value is ensuring that your release is properly configured via Distillery, and that your Dockerfile remains viable.
Cleaning Up

If you’d like to reset the database, or otherwise clean up after the Docker-Compose environment, you can use the down subcommand, optionally including a flag to clear the data volume as well. Without the flag, it will still remove the containers and Docker-specific network that was created for you.

`docker-compose down --volume`

## docker cleanup
docker ps -a
docker rmi 
docker image ls
docker rm 

# Delete all containers
docker rm $(docker ps -a -q)
# Delete all images
docker rmi $(docker images -q)

## use psql

docker exec -ti olivetree-phx_postgres_1 psql -p 5432 -U olivetree

## restore database

docker exec -ti olivetree-phx_postgres_1 psql -p 5432 -U olivetree

drop database olivetree;
create database olivetree;
SET session_replication_role = replica;
\q
docker exec -i olivetree-phx_postgres_1 psql -p 5432 -U olivetree < 2018-11-18-fw-saved-1.3-base.pgsql
docker exec -ti olivetree-phx_postgres_1 psql -p 5432 -U olivetree
SET session_replication_role = DEFAULT;

docker exec -ti add-12-api_postgres_1 psql -p 5432 -U olivetree

## export normalized db

/Applications/Postgres.app/Contents/Versions/11/bin/pg_dump -U postgres --no-owner --no-acl -W -Fc -C -d olivetree_dev > 2019-02-22-add-v12-api-bin-export.sql

tar -czvf 2019-02-22-add-v12-api-bin-export.sql.gz 2019-02-22-add-v12-api-bin-export.sql

## docker migrate works:

docker cp ./2019-01-27-plurals-10-bin.sql add-12-api_postgres_1:/2019-01-27-plurals-10-bin.sql
docker exec -ti add-12-api_postgres_1 bash
docker exec -ti add-12-api_olivetree_1 bash
psql -U olivetree
drop database olivetree;
create database olivetree;
SET session_replication_role = replica;
\q

pg_restore -U olivetree --clean --dbname=olivetree 2019-01-27-plurals-10-bin.sql
psql -U olivetree
SET session_replication_role = DEFAULT;


## loader.io
Target Verification: olivetree.app

    Verify over HTTP

Place this verification token in a file:

loaderio-aceec519d8ce807bcc175e37c2731776

Upload the file to your server so it is accessible at one of the following URLs:

    http://olivetree.app/loaderio-aceec519d8ce807bcc175e37c2731776/
    http://olivetree.app/loaderio-aceec519d8ce807bcc175e37c2731776.html
    http://olivetree.app/loaderio-aceec519d8ce807bcc175e37c2731776.txt


mix deps.get ; mix deps.compile
mix ecto.drop; mix ecto.create ; mix ecto.migrate
mix run apps/db/priv/repo/seeds.exs

git clone https://github.com/FaithfulAudio/olivetree-phx.git -b upload-ui upload-ui

# export binary db file

"/Applications/Postgres.app/Contents/Versions/11/bin/pg_dump" -U postgres --no-owner --no-acl -W -Fc -C -d kjvrvg_dev > 2019-01-22-media-item-1.3-base-bin.sql

# import 1.3 database

./dbimport.py migratefromwebsauna ./2019-05-04-media-item-bin.pgsql olivetree_dev ; ./dbimport.py convertv12bibletoplaylists olivetree_dev ; ./dbimport.py convertv12gospeltoplaylists olivetree_dev ; ./dbimport.py convertv12musictoplaylists olivetree_dev ; ./dbimport.py normalizemusic olivetree_dev ; ./dbimport.py normalizegospel olivetree_dev ; ./dbimport.py normalizepreaching olivetree_dev ; ./dbimport.py normalizebible olivetree_dev ; ./dbimport.py misccleanup olivetree_dev ; mix run apps/db/priv/repo/seeds.exs ; mix run apps/db/priv/repo/hash_ids.exs


## design notes

channels can contain playlists and channels
playlists can only contain mediaitems


## rich notifications
{
  "to" : "devicekey OR /topics/sometopic",
  "mutable_content": true,
  "data": {
    "mymediavideo": "https://myserver.com/myvideo.mp4"
  },
  "notification": {
    "title": "my title",
    "subtitle": "my subtitle",
    "body": "some body"
  }
}

 msg = %{ "to" => "/fwbcapp/mediaitem/playlist/23-23-423-42-34234", "mutable_content" => true, "data" => %{ "mediaitem" => "uuid-of-media-item", "resource-type" => "uuid"}, "notification" => %{ "title" => "push note title", "subtitle" => "push note subtitle", "body" => "push note body" } }

  msg = %{ "to" => "/fwbcapp/mediaitem/playlist/23-23-423-42-34234", "mutable_content" => true }

msg = %{ "to" => "/fwbcapp/mediaitem/playlist/23-23-423-42-34234", "mutable_content" => true, "data" => %{ "mediaitem" => "uuid-of-media-item", "resource-type" => "uuid"} }

 msg = %{ "data" => %{ "mediaitem" => "uuid-of-media-item", "resource-type" => "uuid"}, "to" => "/fwbcapp/mediaitem/playlist/23-23-423-42-34234", "mutable_content" => true, "title" => "push note title", "subtitle" => "push note subtitle", "body" => "push note body" }


  notification = %{"body" => "your message"}
  data = %{ "mediaitem" => "uuid-of-media-item", "resource-type" => "uuid"}
  Pigeon.FCM.Notification.new("registration ID", notification, data)



  n = Pigeon.FCM.Notification.new("dcu92ujVPf4:APA91bEaZOL75G1-zWWFGjkNM_l5QW17lmi27veyILTLz7eNeU2hwLNv_17_9Hx_GU8FUWtC82IAGNT8ibqsPGbPH9zOD7N7oRg8seaeDOY3v23pMuuo5wyvuApdEaBFIV3rek4L3c8t", notification, data)

notification = %{"body" => "your message"}
data = %{ "mediaitem" => "uuid-of-media-item", "resource-type" => "uuid"}
n = Pigeon.FCM.Notification.new("dcu92ujVPf4:APA91bEaZOL75G1-zWWFGjkNM_l5QW17lmi27veyILTLz7eNeU2hwLNv_17_9Hx_GU8FUWtC82IAGNT8ibqsPGbPH9zOD7N7oRg8seaeDOY3v23pMuuo5wyvuApdEaBFIV3rek4L3c8t", notification, data)
