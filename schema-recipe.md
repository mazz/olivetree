## fwbc 1.3 base schema

### Book

mix phx.gen.schema Book book absolute_id:integer uuid:uuid basename:string

mix phx.gen.schema Chapter chapter absolute_id:integer uuid:uuid basename:string book_id:references:book

mix phx.gen.schema BookTitle booktitle uuid:uuid localizedname:string language_id:string book_id:references:book

book.ex:
      has_many :chapters, FaithfulWord.Chapter
      has_many :booktitles, FaithfulWord.BookTitle

mix phx.gen.schema MediaChapter mediachapter absolute_id:integer uuid:uuid track_number:integer localizedname:string path:string language_id:string presenter_name:string source_material:string chapter_id:references:chapter

chapter.ex:
      has_many :mediachapters, FaithfulWord.MediaChapter

### Gospel

mix phx.gen.schema Gospel gospel absolute_id:integer uuid:uuid basename:string

mix phx.gen.schema MediaGospel mediagospel absolute_id:integer uuid:uuid track_number:integer localizedname:string path:string language_id:string presenter_name:string source_material:string gospel_id:references:gospel

mix phx.gen.schema GospelTitle gospeltitle uuid:uuid localizedname:string language_id:string gospel_id:references:gospel


### Music

mix phx.gen.schema Music music absolute_id:integer uuid:uuid basename:string

mix phx.gen.schema MediaMusic mediamusic absolute_id:integer uuid:uuid track_number:integer localizedname:string path:string language_id:string presenter_name:string source_material:string music_id:references:music

mix phx.gen.schema MusicTitle musictitle uuid:uuid localizedname:string language_id:string music_id:references:music

### LanguageIdentifier

mix phx.gen.schema LanguageIdentifier languageidentifier uuid:uuid identifier:string source_material:string supported:boolean


### PushMessage

mix phx.gen.schema PushMessage pushmessage uuid:uuid created_at:utc_datetime updated_at:utc_datetime title:string message:string sent:boolean

push_message.ex
      field :message, :string, size: 4096

<timestamp>_create_push_message.exs
      add :message, :string, size: 4096


### ClientDevice

mix phx.gen.schema ClientDevice clientdevice uuid:uuid firebase_token:string apns_token:string preferred_language:string user_agent:string


### AppVersion

mix phx.gen.schema AppVersion appversion uuid:uuid version_number:string ios_supported:boolean android_supported:boolean


### Org

mix phx.gen.schema Org orgs uuid:uuid basename:string

CREATE TABLE orgs (
    id integer DEFAULT nextval('org_id_seq'::regclass) PRIMARY KEY,
    uuid uuid,
    basename character varying(128),
    created_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone
);

### Channel

mix phx.gen.schema Channel channels uuid:uuid ordinal:integer basename:string org_id:references:orgs

CREATE TABLE channels (
    id integer DEFAULT nextval('channel_id_seq'::regclass) PRIMARY KEY,
    uuid uuid,
    ordinal integer,
    basename character varying(128),
    created_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    org_id integer REFERENCES orgs(id),
    updated_at timestamp with time zone
);

### Playlist

mix phx.gen.schema Playlist playlists ordinal:integer uuid:uuid localizedname:string language_id:string channel_id:references:channels

CREATE TABLE playlists (
    id integer DEFAULT nextval('playlist_id_seq'::regclass) PRIMARY KEY,
    ordinal integer,
    uuid uuid,
    localizedname character varying(128),
    language_id character varying(16),
    created_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone,
    channel_id integer REFERENCES channels(id)
);

### MediaItem

mix phx.gen.schema MediaItem mediaitems ordinal:integer uuid:uuid track_number:integer medium:string localizedname:string path:string small_thumbnail_path:string large_thumbnail_path:string content_provider_link:string ipfs_link:string language_id:string presenter_name:string source_material:string playlist_id:references:playlists

CREATE TABLE mediaitems (
    id integer DEFAULT nextval('mediaitem_id_seq'::regclass) PRIMARY KEY,
    ordinal integer,
    uuid uuid,
    track_number integer,
    medium character varying(32),
    localizedname character varying(128),
    path character varying(384),
    small_thumbnail_path character varying(384),
    large_thumbnail_path character varying(384),
    content_provider_link character varying(384),
    ipfs_link character varying(384),
    language_id character varying(16),
    presenter_name character varying(80),
    source_material character varying(128),
    created_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone,
    playlist_id integer REFERENCES playlists(id)
);

CREATE TABLE mediaphrases (
    id integer DEFAULT nextval('mediaphrase_id_seq'::regclass) PRIMARY KEY,
    uuid uuid,
    language_id character varying(16),
    body text,
    sermonphrase_id integer REFERENCES sermonphrases(id)
);

### Tag

mix phx.gen.schema Tag tags uuid:uuid basename:string description:string

CREATE TABLE tags (
    id integer DEFAULT nextval('tag_id_seq'::regclass) PRIMARY KEY,
    uuid uuid,
    basename character varying(128),
    description text
);

### MediaItemTag

mix phx.gen.schema MediaItemTag mediaitemtags uuid:uuid tag_id:references:tags mediaitem_id:references:mediaitems

CREATE TABLE mediaitemtag (
    id SERIAL PRIMARY KEY,
    uuid uuid,
    tag_id integer REFERENCES tags(id),
    mediaitem_id integer REFERENCES mediaitems(id)
);


### MusicTitle

mix phx.gen.schema MusicTitle musictitles uuid:uuid localizedname:string language_id:string music_id:references:music

CREATE TABLE musictitles (
    id integer DEFAULT nextval('musictitle_id_seq'::regclass) PRIMARY KEY,
    uuid uuid,
    localizedname character varying(128),
    language_id character varying(16),
    music_id integer REFERENCES music(id)
);



### importing db

"/Applications/Postgres.app/Contents/Versions/10/bin/pg_dump" -p5432 -U postgres --no-owner --no-acl kjvrvg_dev > ~/tmp/kjvrvg-13_dev.pgsql

mix ecto.reset

"/Applications/Postgres.app/Contents/Versions/10/bin/psql"

\c olivetree_dev

SET session_replication_role = replica;

\q

"/Applications/Postgres.app/Contents/Versions/10/bin/psql" olivetree_dev < ~/tmp/kjvrvg-13_dev.pgsql > /dev/null

"/Applications/Postgres.app/Contents/Versions/10/bin/psql"

\c olivetree_dev

SET session_replication_role = DEFAULT;

\q



Ecto.Query.from(t in FaithfulWord.BookTitle, join: b in FaithfulWord.Book, on: t.book_id == b.id, where: t.language_id  == "en", order_by: b.absolute_id, select: {b.uuid, t.language_id, b.basename, t.localizedname}) |> DB.Repo.all








Add the resource to your :api scope in lib/olivetree_api/router.ex:
    resources "/book", BookController, except: [:new, :edit]
    resources "/chapter", ChapterController, except: [:new, :edit]

    resources "/booktitle", BookTitleController, except: [:new, :edit]
    resources "/gospeltitle", GospelTitleController, except: [:new, :edit]
    resources "/mediagospel", MediaGospelController, except: [:new, :edit]
    resources "/gospel", GospelController, except: [:new, :edit]
    resources "/mediachapter", MediaChapterController, except: [:new, :edit]
    resources "/music", MusicController, except: [:new, :edit]
    resources "/mediamusic", MediaMusicController, except: [:new, :edit]
    resources "/musictitle", MusicTitleController, except: [:new, :edit]
    resources "/languageidentifier", LanguageIdentifierController, except: [:new, :edit]
    resources "/pushmessage", PushMessageController, except: [:new, :edit]
    resources "/clientdevice", ClientDeviceController, except: [:new, :edit]
    resources "/appversion", AppVersionController, except: [:new, :edit]

## new tables for 1.3

