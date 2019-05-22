#!/usr/bin/env python

import argparse
import sys
# import http.client
import json
import os
import subprocess
import psycopg2
import psycopg2.extras
from psycopg2 import sql
import uuid
import datetime

k_media_category = {"bible": 0,
    "gospel": 1,
    "livestream": 2,
    "motivation": 3,
    "movie": 4,
    "music": 5,
    "podcast": 6,
    "preaching": 7,
    "testimony": 8,
    "tutorial": 9,
    "conference": 10
    }

k_channel_id = {"preaching": 1,
    "music": 2,
    "gospel": 3,
    "movies": 4
    }

class Dbimport(object):
    def __init__(self):
        parser = argparse.ArgumentParser(
            description='stream a file to a streaming service',
            usage='''dev|prod <pgsql file> <dbname>

''')
        parser.add_argument('command', help='Subcommand to run')
        # parse_args defaults to [1:] for args, but you need to
        # exclude the rest of the args too, or validation will fail
        args = parser.parse_args(sys.argv[1:2])
        if not hasattr(self, args.command):
            print('Unrecognized command')
            parser.print_help()
            exit(1)
        # use dispatch pattern to invoke method with same name
        getattr(self, args.command)()

    def export_db(self):
        parser = argparse.ArgumentParser(description='binary pg_dump export', usage='''dbimport.py export_db <dbname> <sqlfileout> 
''')
        # prefixing the argument with -- means it's optional
        parser.add_argument('dbname')
        parser.add_argument('sqlfileout')
        # parser.add_argument('livestream_url')
        # now that we're inside a subcommand, ignore the first
        # TWO argvs, ie the command (git) and the subcommand (commit)
        args = parser.parse_args(sys.argv[2:])
        print('sqlfileout: {}'.format(repr(args.sqlfileout)))

        os.system('\"/Applications/Postgres.app/Contents/Versions/11/bin/pg_dump\" -U postgres --no-owner --no-acl -W -Fc -C -d {0} > {1}'.format(args.dbname, args.sqlfileout))
            
    def migratefromwebsauna(self):
        parser = argparse.ArgumentParser(
            description='dbimport v1.3 pgsql file')
        # prefixing the argument with -- means it's optional
        parser.add_argument('pgfile')
        parser.add_argument('dbname')
        # parser.add_argument('livestream_url')
        # now that we're inside a subcommand, ignore the first
        # TWO argvs, ie the command (git) and the subcommand (commit)
        args = parser.parse_args(sys.argv[2:])
        print('pgfile: {}'.format(repr(args.pgfile)))
        # psql -c "SELECT * FROM my_table"
        # mix ecto.drop; mix ecto.create ; mix ecto.migrate
        subprocess.call(['mix', 'ecto.drop'])
        subprocess.call(['mix', 'ecto.create'])
        subprocess.call(['mix', 'ecto.migrate'])

        subprocess.call(['/Applications/Postgres.app/Contents/Versions/11/bin/psql', '-c', 'SET session_replication_role = replica;'])

        # os.system("psql -U postgres -d {0} -f {1}".format('olivetree_dev', args.pgfile) )

        #import db
        os.system('\"/Applications/Postgres.app/Contents/Versions/11/bin/pg_restore\" -U postgres --clean --dbname={0} {1}'.format(args.dbname, args.pgfile) )

        subprocess.call(['/Applications/Postgres.app/Contents/Versions/11/bin/psql', '-c', 'SET session_replication_role = DEFAULT;'])

        # os.system('\"/Applications/Postgres.app/Contents/Versions/11/bin/psql\" -U postgres -d {0} -c {1}'.format('olivetree_dev', '\"INSERT INTO musictitles (uuid, localizedname, language_id, music_id) SELECT md5(random()::text || clock_timestamp()::text)::uuid, basename, \'en\', id from music;\"'))

        subprocess.call(['mix', 'ecto.migrate'])

        self.addorgrows()

    def addorgrows(self):
        # parser = argparse.ArgumentParser(
        #     description='create orgs table and add rows')
        # parser.add_argument('dbname')
        # args = parser.parse_args(sys.argv[2:])

        orgs = [
            {'basename': 'olivetreeapp', 'shortname': 'olivetreeapp'},
            {'basename': 'Faithful Word Baptist Church, Tempe, AZ', 'shortname': 'fwbc'},
            {'basename': 'Verity Baptist Church, Sacramento, CA', 'shortname': 'vbc'},
            {'basename': 'Word of Truth Baptist Church', 'shortname': 'wotbc'},
            {'basename': 'Faith Baptist Church', 'shortname': 'fbc'},
            {'basename': 'Liberty Baptist Church', 'shortname': 'lbc'},
            {'basename': 'Faithful Word Baptist Church LA', 'shortname': 'fwbcla'},
            {'basename': 'Temple Baptist Church', 'shortname': 'tbc'},
            {'basename': 'Verity Baptist Vancouver', 'shortname': 'vbcv'},
            {'basename': 'Pillar Baptist Church', 'shortname': 'pbc'},
            {'basename': 'Mountain Baptist Church, Fairmont, WV', 'shortname': 'mbc'},
            {'basename': 'Old Paths Baptist Church, El Paso, TX', 'shortname': 'opbc'},
            {'basename': 'All Scripture Baptist Church, Knoxville, TN', 'shortname': 'asbc'},
            {'basename': 'ibsa, USA', 'shortname': 'ibsa'},
            {'basename': 'Stedfast Baptist Church Houston, TX', 'shortname': 'sbc'}
        ]
        # generate ORGs and make a 'main' channel
        sourceconn = psycopg2.connect("host=localhost dbname={} user=postgres".format('olivetree_dev'))
        with sourceconn.cursor() as cur:
            for org in orgs:
                cur.execute(sql.SQL("insert into orgs(uuid, basename, shortname, updated_at, inserted_at) values (%s, %s, %s, %s, %s)"), 
                [str(uuid.uuid4()), 
                org['basename'], 
                org['shortname'],
                datetime.datetime.now(),
                datetime.datetime.now()
                ])

                sourceconn.commit()
        
        # add olivetreeapp to all pushmessages

        with sourceconn.cursor() as cur:
            cur.execute(sql.SQL("UPDATE pushmessages SET org_id = %s"), [1])


        # add a 'Preaching', 'Music', 'Gospel' channel for each org
        with sourceconn.cursor() as cur:
            # get array of org ids
            orgquery = 'select id from orgs'
            cur.execute(orgquery)
            org_ids = []
            for row in cur:
                org_ids.extend(row)
            print('org_ids: {}'.format(org_ids))

            for org_id in org_ids:
                for channel_name in ['Preaching', 'Music', 'Gospel', 'Movies']: # 1-based index, not 0
                    cur.execute(sql.SQL("INSERT INTO channels (uuid, basename, updated_at, inserted_at, org_id) VALUES (%s, %s, %s, %s, %s)"), 
                    [str(uuid.uuid4()), 
                    channel_name, 
                    datetime.datetime.now(),
                    datetime.datetime.now(),
                    org_id
                    ])

                    sourceconn.commit()

            # add Bible to olivetreeapp
            cur.execute(sql.SQL("INSERT INTO channels (uuid, basename, updated_at, inserted_at, org_id) VALUES (%s, %s, %s, %s, %s)"), 
            [str(uuid.uuid4()), 
            'Bible', 
            datetime.datetime.now(),
            datetime.datetime.now(),
            1
            ])

            sourceconn.commit()

    def convertv12gospeltoplaylists(self):
        parser = argparse.ArgumentParser(
            description='add v1.2 playlists')
        # prefixing the argument with -- means it's optional
        parser.add_argument('dbname')
        # parser.add_argument('livestream_url')
        # now that we're inside a subcommand, ignore the first
        # TWO argvs, ie the command (git) and the subcommand (commit)
        args = parser.parse_args(sys.argv[2:])

        sourceconn = psycopg2.connect("host=localhost dbname={} user=postgres".format(args.dbname))

        # get all the gospel categories because they contain the 
        # preaching categories
        with sourceconn.cursor(cursor_factory=psycopg2.extras.DictCursor) as cur:
        # with sourceconn(cursor_factory=psycopg2.extras.DictCursor) as cur:

            joinedgospelquery = 'select * from gospel'
            cur.execute(joinedgospelquery)
            for gospel in cur:
                print('gospel: {}'.format(gospel))
                # print('basename: {}'.format(gospel['basename']))
                playlists = []
                playlisttitles = []

                with sourceconn.cursor(cursor_factory=psycopg2.extras.DictCursor) as gospeltitlecur:
                # with sourceconn(cursor_factory=psycopg2.extras.DictCursor) as cur:

                    gospeltitlequery = 'select * from gospeltitles where gospeltitles.gospel_id = {}'.format(gospel['id'])
                    gospeltitlecur.execute(gospeltitlequery)
                    for gospeltitle in gospeltitlecur:
                        print('gospeltitle; {}'.format(gospeltitle))
                        playlisttitledict = {
                            'uuid': str(uuid.uuid4()),
                            # 'playlist_id': gospeltitle['']
                            'localizedname': gospeltitle['localizedname'],
                            'language_id': gospeltitle['language_id'],
                            'inserted_at': datetime.datetime.now(),
                            'updated_at': datetime.datetime.now()
                            }

                        playlisttitles.append(playlisttitledict)

                # set the channel id based on basename title

                channel_id = None
                media_category = None
                if gospel['basename'] == 'Soul-winning Motivation':
                    channel_id = k_channel_id["gospel"]
                    media_category = k_media_category["motivation"]
                elif gospel['basename'] == 'Soul-winning Tutorials':
                    channel_id = k_channel_id["gospel"]
                    media_category = k_media_category["tutorial"]
                elif gospel['basename'] == 'Plan of Salvation' or gospel['basename'] == 'Soul-winning Sermons' or gospel['basename'] == 'आत्मिक जीत स्पष्टीकरण':
                    channel_id = k_channel_id["gospel"]
                    media_category = k_media_category["gospel"]
                elif gospel['basename'] == 'Word of Truth Baptist Church Sermons' or gospel['basename'] == 'FWBC Sermons' or gospel['basename'] == 'Faith Baptist Church Louisiana Sermons' or gospel['basename'] == 'Verity Baptist Church Sermons' or gospel['basename'] == 'Old Path Baptist Church Sermons' or gospel['basename'] == 'Liberty Baptist Church Sermons' or gospel['basename'] == 'Faithful Word Baptist Church LA' or gospel['basename'] == 'Temple Baptist Church Sermons' or gospel['basename'] == 'Sean Jolley Spanish' or gospel['basename'] == 'ASBC' or gospel['basename'] == 'Entire Bible Preached Project' or gospel['basename'] == 'Pillar Baptist Church' or gospel['basename'] == 'Iglesia Bautista de Santa Ana' or gospel['basename'] == 'FWBC Espanol' or gospel['basename'] == 'Win Your Wife\'s Heart by Jack Hyles' or gospel['basename'] == 'Justice by Jack Hyles' or gospel['basename'] == 'Verity Baptist Vancouver (Preaching)' or gospel['basename'] == 'Stedfast Baptist Church' or gospel['basename'] == 'Post Trib Bible Prophecy Conference' or gospel['basename'] == 'Mountain Baptist Church':
                        channel_id = k_channel_id["preaching"]
                        media_category = k_media_category["preaching"]
                elif gospel['basename'] == 'Documentaries':
                    channel_id = k_channel_id["movies"]
                    media_category = k_media_category["movie"]

                    
                if channel_id != None:
                    playlistdict = {
                        'ordinal': gospel['absolute_id'],
                        'uuid': str(uuid.uuid4()),
                        'basename': gospel['basename'],
                        'media_category': media_category,
                        # 'language_id': gospel['language_id'],
                        'small_thumbnail_path': None,
                        'med_thumbnail_path': None,
                        'large_thumbnail_path': None,
                        'banner_path': None,
                        'channel_id': channel_id,
                        'updated_at': datetime.datetime.now(),
                        'inserted_at': datetime.datetime.now()
                    }

                    # add playlist to corresponding channel
                    print('playlistdict: {}'.format(playlistdict))
    
                    playlists.append(playlistdict)

                    # store this playlist along with all its titles

                    # store the playlist
                    playlistuuid = str(uuid.uuid4())
                    with sourceconn.cursor() as storeplaylistcur:
                        storeplaylistcur.execute(sql.SQL("insert into playlists(ordinal, uuid, basename, media_category, small_thumbnail_path, med_thumbnail_path, large_thumbnail_path, banner_path, channel_id, inserted_at, updated_at) values (%s, %s, %s, %s, %s, %s, %s ,%s ,%s ,%s ,%s)"), 
                        [playlistdict['ordinal'],
                        playlistuuid, 
                        playlistdict['basename'],
                        playlistdict['media_category'],
                        # playlistdict['language_id'],
                        playlistdict['small_thumbnail_path'],
                        playlistdict['med_thumbnail_path'],
                        playlistdict['large_thumbnail_path'],
                        playlistdict['banner_path'],
                        playlistdict['channel_id'],
                        datetime.datetime.now(),
                        datetime.datetime.now()
                        ])

                        sourceconn.commit()

                    # find the playlist we just added and add the playlisttitles to it by uuid

                    with sourceconn.cursor(cursor_factory=psycopg2.extras.DictCursor) as findplaylistcur:
                        findplaylistquery = 'select * from playlists where uuid = \'{}\''.format(playlistuuid)
                        findplaylistcur.execute(findplaylistquery)
                        for playlist in findplaylistcur:
                            print('playlist: {}'.format(playlist))
                            for playlisttitle in playlisttitles:
                                playlisttitle['playlist_id'] = playlist['id']

                    # store the playlisttitles with the playlist_id we found
                    with sourceconn.cursor() as storeplaylisttitlecur:
                        for playlisttitle in playlisttitles:
                            print('playlisttitle: {}'.format(playlisttitle))
                            storeplaylisttitlecur.execute(sql.SQL("insert into playlist_titles(uuid, localizedname, language_id, playlist_id, inserted_at, updated_at) values (%s, %s, %s, %s, %s, %s)"), 
                            [playlisttitle['uuid'], 
                            playlisttitle['localizedname'],
                            playlisttitle['language_id'],
                            # playlisttitle['language_id'],
                            playlisttitle['playlist_id'],
                            datetime.datetime.now(),
                            datetime.datetime.now()
                            ])

                            sourceconn.commit()

    def convertv12musictoplaylists(self):
        parser = argparse.ArgumentParser(
            description='add v1.2 playlists')
        # prefixing the argument with -- means it's optional
        parser.add_argument('dbname')
        # parser.add_argument('livestream_url')
        # now that we're inside a subcommand, ignore the first
        # TWO argvs, ie the command (git) and the subcommand (commit)
        args = parser.parse_args(sys.argv[2:])

        sourceconn = psycopg2.connect("host=localhost dbname={} user=postgres".format(args.dbname))

        # get all the music categories because they contain the 
        # preaching categories
        with sourceconn.cursor(cursor_factory=psycopg2.extras.DictCursor) as cur:
        # with sourceconn(cursor_factory=psycopg2.extras.DictCursor) as cur:

            joinedmusicquery = 'select * from music'
            cur.execute(joinedmusicquery)
            for music in cur:
                print('music: {}'.format(music))
                # print('basename: {}'.format(music['basename']))
                playlists = []
                playlisttitles = []

                with sourceconn.cursor(cursor_factory=psycopg2.extras.DictCursor) as musictitlecur:
                # with sourceconn(cursor_factory=psycopg2.extras.DictCursor) as cur:

                    musictitlequery = 'select * from musictitles where musictitles.music_id = {}'.format(music['id'])
                    musictitlecur.execute(musictitlequery)
                    for musictitle in musictitlecur:
                        print('musictitle; {}'.format(musictitle))
                        playlisttitledict = {
                            'uuid': str(uuid.uuid4()),
                            # 'playlist_id': musictitle['']
                            'localizedname': musictitle['localizedname'],
                            'language_id': musictitle['language_id'],
                            'inserted_at': datetime.datetime.now(),
                            'updated_at': datetime.datetime.now()
                            }

                        playlisttitles.append(playlisttitledict)

                # set the channel id based on basename title

                channel_id = 2
                media_category = k_media_category["music"]

                playlistdict = {
                    'ordinal': music['absolute_id'],
                    'uuid': str(uuid.uuid4()),
                    'basename': music['basename'],
                    'media_category': media_category,
                    # 'language_id': music['language_id'],
                    'small_thumbnail_path': None,
                    'med_thumbnail_path': None,
                    'large_thumbnail_path': None,
                    'banner_path': None,
                    'channel_id': channel_id,
                    'updated_at': datetime.datetime.now(),
                    'inserted_at': datetime.datetime.now()
                }

                # add playlist to corresponding channel
                print('music playlistdict: {}'.format(playlistdict))

                playlists.append(playlistdict)

                # store this playlist along with all its titles

                # store the playlist
                playlistuuid = str(uuid.uuid4())
                with sourceconn.cursor() as storeplaylistcur:
                    storeplaylistcur.execute(sql.SQL("insert into playlists(ordinal, uuid, basename, media_category, small_thumbnail_path, med_thumbnail_path, large_thumbnail_path, banner_path, channel_id, inserted_at, updated_at) values (%s, %s, %s, %s, %s, %s, %s ,%s ,%s ,%s ,%s)"), 
                    [playlistdict['ordinal'],
                    playlistuuid, 
                    playlistdict['basename'],
                    playlistdict['media_category'],
                    # playlistdict['language_id'],
                    playlistdict['small_thumbnail_path'],
                    playlistdict['med_thumbnail_path'],
                    playlistdict['large_thumbnail_path'],
                    playlistdict['banner_path'],
                    playlistdict['channel_id'],
                    datetime.datetime.now(),
                    datetime.datetime.now()
                    ])

                    sourceconn.commit()

                # find the playlist we just added and add the playlisttitles to it by uuid

                with sourceconn.cursor(cursor_factory=psycopg2.extras.DictCursor) as findplaylistcur:
                    findplaylistquery = 'select * from playlists where uuid = \'{}\''.format(playlistuuid)
                    findplaylistcur.execute(findplaylistquery)
                    for playlist in findplaylistcur:
                        print('playlist: {}'.format(playlist))
                        for playlisttitle in playlisttitles:
                            playlisttitle['playlist_id'] = playlist['id']

                # store the playlisttitles with the playlist_id we found
                with sourceconn.cursor() as storeplaylisttitlecur:
                    for playlisttitle in playlisttitles:
                        print('playlisttitle: {}'.format(playlisttitle))
                        storeplaylisttitlecur.execute(sql.SQL("insert into playlist_titles(uuid, localizedname, language_id, playlist_id, inserted_at, updated_at) values (%s, %s, %s, %s, %s, %s)"), 
                        [playlisttitle['uuid'], 
                        playlisttitle['localizedname'],
                        playlisttitle['language_id'],
                        # playlisttitle['language_id'],
                        playlisttitle['playlist_id'],
                        datetime.datetime.now(),
                        datetime.datetime.now()
                        ])

                        sourceconn.commit()


    def convertv12bibletoplaylists(self):
        parser = argparse.ArgumentParser(
            description='add v1.2 playlists')
        # prefixing the argument with -- means it's optional
        parser.add_argument('dbname')
        # parser.add_argument('livestream_url')
        # now that we're inside a subcommand, ignore the first
        # TWO argvs, ie the command (git) and the subcommand (commit)
        args = parser.parse_args(sys.argv[2:])

        sourceconn = psycopg2.connect("host=localhost dbname={} user=postgres".format(args.dbname))


        with sourceconn.cursor() as cur:
            # get array of org ids
            cur.execute(sql.SQL('SELECT id from channels where basename = %s'), ['Bible'])
            biblechannelid = cur.fetchone()

            if biblechannelid != None:
                # get all the music categories because they contain the 
                # preaching categories
                with sourceconn.cursor(cursor_factory=psycopg2.extras.DictCursor) as cur:
                # with sourceconn(cursor_factory=psycopg2.extras.DictCursor) as cur:

                    booksquery = 'select * from books'
                    cur.execute(booksquery)
                    for book in cur:
                        print('book: {}'.format(book))
                        # print('basename: {}'.format(book['basename']))
                        playlists = []
                        playlisttitles = []

                        with sourceconn.cursor(cursor_factory=psycopg2.extras.DictCursor) as booktitlecur:
                        # with sourceconn(cursor_factory=psycopg2.extras.DictCursor) as cur:

                            booktitlequery = 'select * from booktitles where booktitles.book_id = {}'.format(book['id'])
                            booktitlecur.execute(booktitlequery)
                            for booktitle in booktitlecur:
                                print('booktitle; {}'.format(booktitle))
                                playlisttitledict = {
                                    'uuid': str(uuid.uuid4()),
                                    # 'playlist_id': booktitle['']
                                    'localizedname': booktitle['localizedname'],
                                    'language_id': booktitle['language_id'],
                                    'inserted_at': datetime.datetime.now(),
                                    'updated_at': datetime.datetime.now()
                                    }

                                playlisttitles.append(playlisttitledict)

                        channel_id = biblechannelid
                        media_category = k_media_category["bible"]

                        playlistdict = {
                            'ordinal': book['absolute_id'] * 100,
                            'uuid': str(uuid.uuid4()),
                            'basename': book['basename'],
                            'media_category': media_category,
                            # 'language_id': book['language_id'],
                            'small_thumbnail_path': None,
                            'med_thumbnail_path': None,
                            'large_thumbnail_path': None,
                            'banner_path': None,
                            'channel_id': channel_id,
                            'updated_at': datetime.datetime.now(),
                            'inserted_at': datetime.datetime.now()
                        }

                        # add playlist to corresponding channel
                        print('playlistdict: {}'.format(playlistdict))

                        playlists.append(playlistdict)

                        # store this playlist along with all its titles

                        # store the playlist
                        playlistuuid = str(uuid.uuid4())
                        with sourceconn.cursor() as storeplaylistcur:
                            storeplaylistcur.execute(sql.SQL("insert into playlists(ordinal, uuid, basename, media_category, small_thumbnail_path, med_thumbnail_path, large_thumbnail_path, banner_path, channel_id, inserted_at, updated_at) values (%s, %s, %s, %s, %s, %s, %s ,%s ,%s ,%s ,%s)"), 
                            [playlistdict['ordinal'],
                            playlistuuid, 
                            playlistdict['basename'],
                            playlistdict['media_category'],
                            # playlistdict['language_id'],
                            playlistdict['small_thumbnail_path'],
                            playlistdict['med_thumbnail_path'],
                            playlistdict['large_thumbnail_path'],
                            playlistdict['banner_path'],
                            playlistdict['channel_id'],
                            datetime.datetime.now(),
                            datetime.datetime.now()
                            ])

                            sourceconn.commit()

                        # find the playlist we just added and add the playlisttitles to it by uuid

                        with sourceconn.cursor(cursor_factory=psycopg2.extras.DictCursor) as findplaylistcur:
                            findplaylistquery = 'select * from playlists where uuid = \'{}\''.format(playlistuuid)
                            findplaylistcur.execute(findplaylistquery)
                            for playlist in findplaylistcur:
                                print('playlist: {}'.format(playlist))
                                for playlisttitle in playlisttitles:
                                    playlisttitle['playlist_id'] = playlist['id']

                        # store the playlisttitles with the playlist_id we found
                        with sourceconn.cursor() as storeplaylisttitlecur:
                            for playlisttitle in playlisttitles:
                                print('playlisttitle: {}'.format(playlisttitle))
                                storeplaylisttitlecur.execute(sql.SQL("insert into playlist_titles(uuid, localizedname, language_id, playlist_id, inserted_at, updated_at) values (%s, %s, %s, %s, %s, %s)"), 
                                [playlisttitle['uuid'], 
                                playlisttitle['localizedname'],
                                playlisttitle['language_id'],
                                # playlisttitle['language_id'],
                                playlisttitle['playlist_id'],
                                datetime.datetime.now(),
                                datetime.datetime.now()
                                ])

                                sourceconn.commit()


    def normalizebible(self):
        parser = argparse.ArgumentParser(
            description='dbimport v1.3 pgsql file')
        # prefixing the argument with -- means it's optional

        parser.add_argument('dbname')
        args = parser.parse_args(sys.argv[2:])
        print('dbname: {}'.format(repr(args.dbname)))
        # print('tablename: {}'.format(repr(args.tablename)))

        sourceconn = psycopg2.connect("host=localhost dbname={} user=postgres".format(args.dbname))
        # sourcecur = sourceconn.cursor()
        with sourceconn.cursor(cursor_factory=psycopg2.extras.DictCursor) as cur:
        # with sourceconn(cursor_factory=psycopg2.extras.DictCursor) as cur:     
        
        
            self._insertmediaitemrows(self._biblerows(1, 'Matthew', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(2, 'Mark', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(3, 'Luke', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(4, 'John', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(5, 'Acts', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(6, 'Romans', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(7, '1 Corinthians', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(8, '2 Corinthians', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(9, 'Galatians', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(10, 'Ephesians', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(11, 'Philippians', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(12, 'Colossians', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(13, '1 Thessalonians', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(14, '2 Thessalonians', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(15, '1 Timothy', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(16, '2 Timothy', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(17, 'Titus', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(18, 'Philemon', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(19, 'Hebrews', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(20, 'James', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(21, '1 Peter', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(22, '2 Peter', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(23, '1 John', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(24, '2 John', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(25, '3 John', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(26, 'Jude', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(27, 'Revelation', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(28, 'Plan of Salvation', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(29, 'Psalms', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(30, 'Proverbs', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(31, 'Isaiah', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(32, 'Jeremiah', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(33, 'Genesis', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(34, 'New Testament', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(35, 'Obadiah', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(36, 'Old Testament', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(37, 'Exodus', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(38, 'Leviticus', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(39, 'Numbers', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(40, 'Deuteronomy', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(41, 'Joshua', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(42, 'Judges', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(43, 'Ruth', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(44, '1 Samuel', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(45, '2 Samuel', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(46, '1 Kings', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(47, '2 Kings', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(48, '1 Chronicles', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(49, '2 Chronicles', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(50, 'Ezra', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(51, 'Nehemiah', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(52, 'Esther', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(53, 'Job', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(55, 'Ecclesiastes', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(56, 'Song of Solomon', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(57, 'Lamentations', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(58, 'Ezekiel', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(59, 'Daniel', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(60, 'Hosea', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(61, 'Joel', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(62, 'Amos', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(63, 'Jonah', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(64, 'Micah', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(65, 'Nahum', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(66, 'Habakkuk', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(67, 'Zephaniah', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(68, 'Haggai', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(69, 'Zechariah', args.dbname), k_media_category["bible"], args.dbname)
            self._insertmediaitemrows(self._biblerows(70, 'Malachi', args.dbname), k_media_category["bible"], args.dbname)


    def _biblerows(self, bookid, playlistname, dbname):
        sourceconn = psycopg2.connect("host=localhost dbname={} user=postgres".format(dbname))
        # sourcecur = sourceconn.cursor()

        result = []
        with sourceconn.cursor(cursor_factory=psycopg2.extras.DictCursor) as cur:
            with sourceconn.cursor(cursor_factory=psycopg2.extras.DictCursor) as playlistcur:
                found_playlist_id = False
                playlist_id = None
                playlistcur.execute(sql.SQL('SELECT * from playlists where basename = %s'), [playlistname])
                # playlistquery = 'SELECT * from playlists where basename = \'{}\''.format(playlistname)
                # if playlistquery != None: 

                # playlistcur.execute(playlistquery)
                playlist = playlistcur.fetchone()
                if playlist is not None:
                    print('found basename: {} playlist: {}'.format(playlist['basename'], playlist))
                    playlist_id = playlist['id']
                    found_playlist_id = True

                    chapterquerystring = '''select mediachapters.uuid as mcuuid, 
                        mediachapters.track_number as mctrack_number,
                        mediachapters.localizedname as mclocalizedname,
                        mediachapters.path as mcpath,
                        mediachapters.small_thumbnail_path as mcsmall_thumbnail_path,
                        mediachapters.large_thumbnail_path as mclarge_thumbnail_path,
                        mediachapters.language_id as mclanguage_id,
                        mediachapters.presenter_name as mcpresenter_name,
                        mediachapters.source_material as mcsource_material,
                        mediachapters.med_thumbnail_path as mcmed_thumbnail_path,
                        mediachapters.absolute_id as mcabsolute_id
                        from mediachapters inner join chapters on mediachapters.chapter_id = chapters.id inner join books on chapters.book_id = %s inner join playlists on books.basename = playlists.basename where books.basename = %s'''

                    cur.execute(sql.SQL(chapterquerystring), [bookid, playlist['basename']])

                    for row in cur:
                        # records.append(row)
                        print('row: {}'.format(row))

                        path_split = row['mcpath'].split('/')
                        if path_split[0] == 'bible':
                            rowdict = {
                                'uuid': row['mcuuid'],
                                'track_number': row['mctrack_number'],
                                'ordinal': row['mctrack_number'],
                                'medium': 'audio',
                                'localizedname': row['mclocalizedname'],
                                'path': row['mcpath'],
                                'small_thumbnail_path': row['mcsmall_thumbnail_path'],
                                'large_thumbnail_path': row['mclarge_thumbnail_path'],
                                'content_provider_link': None,
                                'ipfs_link': None,
                                'language_id': row['mclanguage_id'],
                                'presenter_name': row['mcpresenter_name'],
                                'source_material': row['mcsource_material'],
                                'updated_at': datetime.datetime.now(),
                                'playlist_id': playlist_id if found_playlist_id else None,
                                'med_thumbnail_path': row['mcmed_thumbnail_path'],
                                'tags': [],
                                'inserted_at': datetime.datetime.now(),
                                'media_category': 0,
                                'presented_at': None,
                                'org_id': 1,
                                'ordinal': row['mcabsolute_id']
                            }
                            print("rowdict: {}".format(rowdict))
                            result.append(rowdict)

        with sourceconn.cursor(cursor_factory=psycopg2.extras.DictCursor) as cur:
            cur.execute(sql.SQL('select * from mediachapters'), [bookid, playlist['basename']])

            for row in cur:
                # records.append(row)
                print('row: {}'.format(row))
        return result

    # normalizepreaching must be called AFTER addorgrows because orgs need to be present
    # 
    # GETTING STARTED:
    # get preaching file paths with:
    # ./dbimport.py migratefromwebsauna ./2019-04-02-media-item-bin.pgsql olivetree_dev
    # ./dbimport.py addorgrows olivetree_dev
    # ./dbimport.py normalizepreaching olivetree_dev mediagospel

    def normalizepreaching(self):
        parser = argparse.ArgumentParser(
            description='dbimport v1.3 pgsql file')
        # prefixing the argument with -- means it's optional

        parser.add_argument('dbname')
        args = parser.parse_args(sys.argv[2:])
        print('dbname: {}'.format(repr(args.dbname)))
        # print('tablename: {}'.format(repr(args.tablename)))

        sourceconn = psycopg2.connect("host=localhost dbname={} user=postgres".format(args.dbname))
        # sourcecur = sourceconn.cursor()
        with sourceconn.cursor(cursor_factory=psycopg2.extras.DictCursor) as cur:
        # with sourceconn(cursor_factory=psycopg2.extras.DictCursor) as cur:

            # delete items with null paths
            # deletequery = 'delete FROM mediagospel where path is NULL'
            # cur.execute(deletequery)

            # get array of org shortnames

            orgquery = 'select shortname from orgs'
            cur.execute(orgquery)
            orgs = []
            for row in cur:
                orgs.extend(row)
            print('orgs: {}'.format(orgs))        

        self._insertmediaitemrows(self._preachingrows(5, 'Soul-winning Sermons', args.dbname), k_media_category["preaching"], args.dbname)
        self._insertmediaitemrows(self._preachingrows(6, 'FWBC Sermons', args.dbname), k_media_category["preaching"], args.dbname)
        self._insertmediaitemrows(self._preachingrows(7, 'Verity Baptist Church Sermons', args.dbname), k_media_category["preaching"], args.dbname)
        self._insertmediaitemrows(self._preachingrows(9, 'Word of Truth Baptist Church Sermons', args.dbname), k_media_category["preaching"], args.dbname)
        self._insertmediaitemrows(self._preachingrows(10, 'Faith Baptist Church Louisiana Sermons', args.dbname), k_media_category["preaching"], args.dbname)
        self._insertmediaitemrows(self._preachingrows(12, 'Old Path Baptist Church Sermons', args.dbname), k_media_category["preaching"], args.dbname)
        self._insertmediaitemrows(self._preachingrows(14, 'Liberty Baptist Church Sermons', args.dbname), k_media_category["preaching"], args.dbname)
        self._insertmediaitemrows(self._preachingrows(15, 'Faithful Word Baptist Church LA', args.dbname), k_media_category["preaching"], args.dbname)
        self._insertmediaitemrows(self._preachingrows(17, 'Temple Baptist Church Sermons', args.dbname), k_media_category["preaching"], args.dbname)
        self._insertmediaitemrows(self._preachingrows(19, 'Verity Baptist Vancouver (Preaching)', args.dbname), k_media_category["preaching"], args.dbname)
        self._insertmediaitemrows(self._preachingrows(21, 'Sean Jolley Spanish', args.dbname), k_media_category["preaching"], args.dbname)
        self._insertmediaitemrows(self._preachingrows(22, 'FWBC Espanol', args.dbname), k_media_category["preaching"], args.dbname)
        self._insertmediaitemrows(self._preachingrows(23, 'Documentaries', args.dbname), k_media_category["movie"], args.dbname)
        self._insertmediaitemrows(self._preachingrows(24, 'Post Trib Bible Prophecy Conference', args.dbname), k_media_category["conference"], args.dbname)
        self._insertmediaitemrows(self._preachingrows(25, 'आत्मिक जीत स्पष्टीकरण', args.dbname), k_media_category["gospel"], args.dbname)
        self._insertmediaitemrows(self._preachingrows(26, 'ASBC', args.dbname), k_media_category["preaching"], args.dbname)
        self._insertmediaitemrows(self._preachingrows(27, 'Entire Bible Preached Project', args.dbname), k_media_category["preaching"], args.dbname)
        self._insertmediaitemrows(self._preachingrows(28, 'Iglesia Bautista de Santa Ana', args.dbname), k_media_category["preaching"], args.dbname)
        self._insertmediaitemrows(self._preachingrows(29, 'Pillar Baptist Church', args.dbname), k_media_category["preaching"], args.dbname)
        self._insertmediaitemrows(self._preachingrows(30, 'Mountain Baptist Church', args.dbname), k_media_category["preaching"], args.dbname)
        self._insertmediaitemrows(self._preachingrows(31, 'Win Your Wife\'s Heart by Jack Hyles', args.dbname), k_media_category["preaching"], args.dbname)
        self._insertmediaitemrows(self._preachingrows(32, 'Justice by Jack Hyles', args.dbname), k_media_category["preaching"], args.dbname)
        self._insertmediaitemrows(self._preachingrows(33, 'Stedfast Baptist Church', args.dbname), k_media_category["preaching"], args.dbname)
        self._insertmediaitemrows(self._preachingrows(23, 'Documentaries', args.dbname), k_media_category["movie"], args.dbname)

    def _preachingrows(self, gospelid, playlistname, dbname):
        sourceconn = psycopg2.connect("host=localhost dbname={} user=postgres".format(dbname))
        # sourcecur = sourceconn.cursor()

        result = []
        preaching_date = None
        with sourceconn.cursor(cursor_factory=psycopg2.extras.DictCursor) as cur:
        # with sourceconn(cursor_factory=psycopg2.extras.DictCursor) as cur:

            # delete items with null paths
            # deletequery = 'delete FROM mediagospel where path is NULL'
            # cur.execute(deletequery)

            # # get array of org shortnames

            orgquery = 'select shortname from orgs'
            cur.execute(orgquery)
            orgs = []
            for row in cur:
                orgs.extend(row)
            print('orgs: {}'.format(orgs))

            with sourceconn.cursor(cursor_factory=psycopg2.extras.DictCursor) as playlistcur:
                found_playlist_id = False
                playlist_id = None
                playlistcur.execute(sql.SQL('SELECT * from playlists where basename = %s'), [playlistname])
                # playlistquery = 'SELECT * from playlists where basename = \'{}\''.format(playlistname)
                # if playlistquery != None: 

                # playlistcur.execute(playlistquery)
                playlist = playlistcur.fetchone()
                if playlist is not None:
                    print('found basename: {} playlist: {}'.format(playlist['basename'], playlist))
                    playlist_id = playlist['id']
                    found_playlist_id = True

                    sourcequery = 'SELECT * FROM mediagospel where gospel_id = {}'.format(gospelid)
                    cur.execute(sourcequery)
                    for row in cur:
                        # records.append(row)
                        print('row: {}'.format(row))

                        path_split = row['path'].split('/')
                        if path_split[0] == 'preaching':
                            # print('path_split: {}'.format(path_split))
                            # with sourceconn.cursor(cursor_factory=psycopg2.extras.DictCursor) as playlistcur:
                                # found_playlist_id = False
                                # playlist_id = None

                                ## [2] is the filename leaf node
                            filename = path_split[2]
                            filename_split = filename.split('-')
                                # print('filename_split: {}'.format(filename_split))

                                # playlistquery = 'SELECT * from playlists where basename = \'{}\''.format(playlistname)
                                # if playlistquery != None: 
                                #     playlistcur.execute(playlistquery)
                                #     playlist = playlistcur.fetchone()
                                #     if playlist is not None:
                                #         print('found basename: {} playlist: {}'.format(playlist['basename'], playlist))
                                #         playlist_id = playlist['id']
                                #         found_playlist_id = True
                            org = filename_split[0].lower()
                            if org in orgs:
                                # if AM -> 10:00, if PM -> 19:00
                                assigned_time = '10:00' if filename_split[4] == 'AM' else '19:00'
                                preaching_date = datetime.datetime.strptime( '{}-{}-{} {}'.format(filename_split[1], filename_split[2], filename_split[3], assigned_time) , '%Y-%m-%d %H:%M')
                            # print('preaching_date: {}'.format(preaching_date))
                            else:
                                preaching_date = datetime.datetime.now() - datetime.timedelta(days=3*365)
                            # if playlistquery != None: 
                            #     playlistcur.execute(playlistquery)
                            #     playlist = playlistcur.fetchone()
                            #     if playlist is not None:
                            #         print('found basename: {} playlist: {}'.format(playlist['basename'], playlist))
                            #         playlist_id = playlist['id']
                            #         found_playlist_id = True
                        rowdict = {
                            'uuid': row['uuid'],
                            'track_number': row['track_number'],
                            'medium': 'audio',
                            'localizedname': row['localizedname'],
                            'path': row['path'],
                            'small_thumbnail_path': row['small_thumbnail_path'],
                            'large_thumbnail_path': row['large_thumbnail_path'],
                            'content_provider_link': None,
                            'ipfs_link': None,
                            'language_id': row['language_id'],
                            'presenter_name': row['presenter_name'],
                            'source_material': row['source_material'],
                            'updated_at': datetime.datetime.now(),
                            'playlist_id': playlist_id if found_playlist_id else None,
                            'med_thumbnail_path': row['med_thumbnail_path'],
                            'tags': [],
                            'inserted_at': datetime.datetime.now(),
                            'media_category': 7,
                            'presented_at': datetime.datetime.now() - datetime.timedelta(days=3*365) if preaching_date is None else preaching_date,
                            'org_id': 1
                        }
                        print("rowdict: {}".format(rowdict))
                        result.append(rowdict)
        return result

    def _insertmediaitemrows(self, rows, media_category, dbname):
        sourceconn = psycopg2.connect("host=localhost dbname={} user=postgres".format(dbname))

        with sourceconn.cursor() as cur:
            for row in rows:
                cur.execute(sql.SQL("insert into mediaitems(uuid, track_number, medium, localizedname, path, small_thumbnail_path, large_thumbnail_path, content_provider_link, ipfs_link, language_id, presenter_name, source_material, updated_at, playlist_id, med_thumbnail_path, tags, inserted_at, media_category, presented_at, org_id) values (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"), 
                [row['uuid'], 
                row['track_number'], 
                row['medium'],
                row['localizedname'],
                row['path'],
                row['small_thumbnail_path'],
                row['large_thumbnail_path'],
                row['content_provider_link'],
                row['ipfs_link'],
                row['language_id'],
                row['presenter_name'],
                row['source_material'],
                row['updated_at'],
                row['playlist_id'],
                row['med_thumbnail_path'],
                row['tags'],
                row['inserted_at'],
                media_category,
                row['presented_at'],
                row['org_id']
                ])
                # cur.execute("insert into mediaitems(uuid, track_number, medium) values ({}, {}, {})".format(row['uuid'], row['track_number'], row['medium']))
            sourceconn.commit()

    def normalizegospel(self):
        parser = argparse.ArgumentParser(
            description='dbimport v1.3 pgsql file')
        # prefixing the argument with -- means it's optional

        parser.add_argument('dbname')

        args = parser.parse_args(sys.argv[2:])
        print('dbname: {}'.format(repr(args.dbname)))

        planofsalvation = []
        soulwinningmotivation = []
        soulwinningtutorials = []
        # documentaries = []

        sourceconn = psycopg2.connect("host=localhost dbname={} user=postgres".format(args.dbname))
        with sourceconn.cursor(cursor_factory=psycopg2.extras.DictCursor) as cur:
            # delete items with null paths
            deletequery = 'delete FROM mediagospel where path is NULL'
            cur.execute(deletequery)

            sourcequery = 'SELECT * FROM mediagospel'
            cur.execute(sourcequery)
            # result = cur.fetchall()
            # print("result: {}".format(result))

            for row in cur:
                # print('row: {}'.format(row))
                path_split = row['path'].split('/')
                if path_split[0] == 'gospel':
                    print('path_split: {}'.format(path_split))
                    with sourceconn.cursor(cursor_factory=psycopg2.extras.DictCursor) as playlistcur:
                        found_playlist_id = False
                        playlist_id = None

                        ## [2] is the filename leaf node
                        filename = path_split[2]
                        filename_split = filename.split('-')
                        print('filename_split: {}'.format(filename_split))

                        if filename_split[0] == 'BibleWayToHeaven':

                            playlistquery = 'SELECT * from playlists where basename = \'Plan of Salvation\''

                            playlistcur.execute(playlistquery)
                            playlist = playlistcur.fetchone()
                            if playlist is not None:
                                print('playlist: {}'.format(playlist))
                                playlist_id = playlist['id']
                                found_playlist_id = True

                                rowdict = {
                                    'uuid': str(uuid.uuid4()),
                                    'track_number': row['track_number'],
                                    'medium': 'audio',
                                    'localizedname': row['localizedname'],
                                    'path': row['path'],
                                    'small_thumbnail_path': row['small_thumbnail_path'],
                                    'large_thumbnail_path': row['large_thumbnail_path'],
                                    'content_provider_link': None,
                                    'ipfs_link': None,
                                    'language_id': row['language_id'],
                                    'presenter_name': row['presenter_name'],
                                    'source_material': row['source_material'],
                                    'updated_at': datetime.datetime.now(),
                                    'playlist_id': playlist_id if found_playlist_id else None,
                                    'med_thumbnail_path': row['med_thumbnail_path'],
                                    'tags': [],
                                    'inserted_at': datetime.datetime.now(),
                                    'media_category': 1,
                                    'presented_at': None,
                                    'org_id': 1
                                }
                                planofsalvation.append(rowdict)

                elif path_split[0] == 'motivation':
                    print('path_split: {}'.format(path_split))
                    with sourceconn.cursor(cursor_factory=psycopg2.extras.DictCursor) as playlistcur:
                        found_playlist_id = False
                        playlist_id = None

                        playlistquery = 'SELECT * from playlists where basename = \'Soul-winning Motivation\''

                        playlistcur.execute(playlistquery)
                        playlist = playlistcur.fetchone()
                        if playlist is not None:
                            print('playlist: {}'.format(playlist))
                            playlist_id = playlist['id']
                            found_playlist_id = True

                            rowdict = {
                                'uuid': str(uuid.uuid4()),
                                'track_number': row['track_number'],
                                'medium': 'audio',
                                'localizedname': row['localizedname'],
                                'path': row['path'],
                                'small_thumbnail_path': row['small_thumbnail_path'],
                                'large_thumbnail_path': row['large_thumbnail_path'],
                                'content_provider_link': None,
                                'ipfs_link': None,
                                'language_id': row['language_id'],
                                'presenter_name': row['presenter_name'],
                                'source_material': row['source_material'],
                                'updated_at': datetime.datetime.now(),
                                'playlist_id': playlist_id if found_playlist_id else None,
                                'med_thumbnail_path': row['med_thumbnail_path'],
                                'tags': [],
                                'inserted_at': datetime.datetime.now(),
                                'media_category': 1,
                                'presented_at': None,
                                'org_id': 1
                            }
                            soulwinningmotivation.append(rowdict)

                elif path_split[0] == 'tutorials':
                    print('path_split: {}'.format(path_split))
                    with sourceconn.cursor(cursor_factory=psycopg2.extras.DictCursor) as playlistcur:
                        found_playlist_id = False
                        playlist_id = None

                        playlistquery = 'SELECT * from playlists where basename = \'Soul-winning Tutorials\''

                        playlistcur.execute(playlistquery)
                        playlist = playlistcur.fetchone()
                        if playlist is not None:
                            print('playlist: {}'.format(playlist))
                            playlist_id = playlist['id']
                            found_playlist_id = True

                            rowdict = {
                                'uuid': str(uuid.uuid4()),
                                'track_number': row['track_number'],
                                'medium': 'audio',
                                'localizedname': row['localizedname'],
                                'path': row['path'],
                                'small_thumbnail_path': row['small_thumbnail_path'],
                                'large_thumbnail_path': row['large_thumbnail_path'],
                                'content_provider_link': None,
                                'ipfs_link': None,
                                'language_id': row['language_id'],
                                'presenter_name': row['presenter_name'],
                                'source_material': row['source_material'],
                                'updated_at': datetime.datetime.now(),
                                'playlist_id': playlist_id if found_playlist_id else None,
                                'med_thumbnail_path': row['med_thumbnail_path'],
                                'tags': [],
                                'inserted_at': datetime.datetime.now(),
                                'media_category': 1,
                                'presented_at': None,
                                'org_id': 1
                            }
                            soulwinningtutorials.append(rowdict)
            cur.close()

        with sourceconn.cursor() as cur:
            for row in planofsalvation:
                cur.execute(sql.SQL("insert into mediaitems(uuid, track_number, medium, localizedname, path, small_thumbnail_path, large_thumbnail_path, content_provider_link, ipfs_link, language_id, presenter_name, source_material, updated_at, playlist_id, med_thumbnail_path, tags, inserted_at, media_category, presented_at, org_id) values (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"), 
                [row['uuid'], 
                row['track_number'], 
                row['medium'],
                row['localizedname'],
                row['path'],
                row['small_thumbnail_path'],
                row['large_thumbnail_path'],
                row['content_provider_link'],
                row['ipfs_link'],
                row['language_id'],
                row['presenter_name'],
                row['source_material'],
                row['updated_at'],
                row['playlist_id'],
                row['med_thumbnail_path'],
                row['tags'],
                row['inserted_at'],
                row['media_category'],
                row['presented_at'],
                row['org_id']
                ])
                # cur.execute("insert into mediaitems(uuid, track_number, medium) values ({}, {}, {})".format(row['uuid'], row['track_number'], row['medium']))
            sourceconn.commit()
        with sourceconn.cursor() as cur:
            for row in soulwinningmotivation:
                cur.execute(sql.SQL("insert into mediaitems(uuid, track_number, medium, localizedname, path, small_thumbnail_path, large_thumbnail_path, content_provider_link, ipfs_link, language_id, presenter_name, source_material, updated_at, playlist_id, med_thumbnail_path, tags, inserted_at, media_category, presented_at, org_id) values (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"), 
                [row['uuid'], 
                row['track_number'], 
                row['medium'],
                row['localizedname'],
                row['path'],
                row['small_thumbnail_path'],
                row['large_thumbnail_path'],
                row['content_provider_link'],
                row['ipfs_link'],
                row['language_id'],
                row['presenter_name'],
                row['source_material'],
                row['updated_at'],
                row['playlist_id'],
                row['med_thumbnail_path'],
                row['tags'],
                row['inserted_at'],
                row['media_category'],
                row['presented_at'],
                row['org_id']
                ])
                # cur.execute("insert into mediaitems(uuid, track_number, medium) values ({}, {}, {})".format(row['uuid'], row['track_number'], row['medium']))
            sourceconn.commit()  
        with sourceconn.cursor() as cur:
            for row in soulwinningtutorials:
                cur.execute(sql.SQL("insert into mediaitems(uuid, track_number, medium, localizedname, path, small_thumbnail_path, large_thumbnail_path, content_provider_link, ipfs_link, language_id, presenter_name, source_material, updated_at, playlist_id, med_thumbnail_path, tags, inserted_at, media_category, presented_at, org_id) values (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"), 
                [row['uuid'], 
                row['track_number'], 
                row['medium'],
                row['localizedname'],
                row['path'],
                row['small_thumbnail_path'],
                row['large_thumbnail_path'],
                row['content_provider_link'],
                row['ipfs_link'],
                row['language_id'],
                row['presenter_name'],
                row['source_material'],
                row['updated_at'],
                row['playlist_id'],
                row['med_thumbnail_path'],
                row['tags'],
                row['inserted_at'],
                row['media_category'],
                row['presented_at'],
                row['org_id']
                ])
                # cur.execute("insert into mediaitems(uuid, track_number, medium) values ({}, {}, {})".format(row['uuid'], row['track_number'], row['medium']))
            sourceconn.commit()  
 
    # normalizepreaching must be called AFTER addorgrows because orgs need to be present
    # 
    # GETTING STARTED:
    # get preaching file paths with:
    # ./dbimport.py migratefromwebsauna ./2019-04-02-media-item-bin.pgsql olivetree_dev
    # ./dbimport.py addorgrows olivetree_dev
    # ./dbimport.py normalizepreaching olivetree_dev mediagospel

    def normalizemusic(self):
        parser = argparse.ArgumentParser(
            description='dbimport v1.3 pgsql file')
        # prefixing the argument with -- means it's optional

        parser.add_argument('dbname')
        args = parser.parse_args(sys.argv[2:])
        print('dbname: {}'.format(repr(args.dbname)))
        # print('tablename: {}'.format(repr(args.tablename)))

        sourceconn = psycopg2.connect("host=localhost dbname={} user=postgres".format(args.dbname))
        # sourcecur = sourceconn.cursor()
        with sourceconn.cursor(cursor_factory=psycopg2.extras.DictCursor) as cur:
        # with sourceconn(cursor_factory=psycopg2.extras.DictCursor) as cur:

            # delete items with null paths
            deletequery = 'delete FROM mediagospel where path is NULL'
            cur.execute(deletequery)

            # get array of org shortnames

            orgquery = 'select shortname from orgs'
            cur.execute(orgquery)
            orgs = []
            for row in cur:
                orgs.extend(row)
            print('orgs: {}'.format(orgs))        
        
        self._insertmediaitemrows(self._musicrows(8, 'FWBC Hymns Volume 5 - Peace & Security', args.dbname), k_media_category["music"], args.dbname)
        self._insertmediaitemrows(self._musicrows(7, 'FWBC Hymns Volume 4 - Comfort and Encouragement', args.dbname), k_media_category["music"], args.dbname)
        self._insertmediaitemrows(self._musicrows(3, 'FWBC Navajo Hymns', args.dbname), k_media_category["music"], args.dbname)
        self._insertmediaitemrows(self._musicrows(6, 'FWBC Hymns Volume 3 - The Second Coming', args.dbname), k_media_category["music"], args.dbname)
        self._insertmediaitemrows(self._musicrows(5, 'FWBC Hymns Volume 2 - The Resurrection', args.dbname), k_media_category["music"], args.dbname)
        self._insertmediaitemrows(self._musicrows(4, 'FWBC Hymns Volume 1 - The Cross', args.dbname), k_media_category["music"], args.dbname)
        self._insertmediaitemrows(self._musicrows(12, 'FWBC Christmas Hymns 2016', args.dbname), k_media_category["music"], args.dbname)
        self._insertmediaitemrows(self._musicrows(10, 'VBC Spanish Hymns', args.dbname), k_media_category["music"], args.dbname)
        self._insertmediaitemrows(self._musicrows(16, 'FWBC Hymns Christmas 2017', args.dbname), k_media_category["music"], args.dbname)
        self._insertmediaitemrows(self._musicrows(20, 'Collin Schneide', args.dbname), k_media_category["music"], args.dbname)
        self._insertmediaitemrows(self._musicrows(21, 'Sing the KJV', args.dbname), k_media_category["music"], args.dbname)
        self._insertmediaitemrows(self._musicrows(22, 'Clint Anderson', args.dbname), k_media_category["music"], args.dbname)
        self._insertmediaitemrows(self._musicrows(23, 'Stedfast Baptist Music', args.dbname), k_media_category["music"], args.dbname)
        self._insertmediaitemrows(self._musicrows(24, 'FWBC Hymns Volume 6 - The Storm and Seas', args.dbname), k_media_category["music"], args.dbname)
        self._insertmediaitemrows(self._musicrows(25, 'Mr. and Mrs. Ventura', args.dbname), k_media_category["music"], args.dbname)
        self._insertmediaitemrows(self._musicrows(26, 'Entire Psalter Sung', args.dbname), k_media_category["music"], args.dbname)
        self._insertmediaitemrows(self._musicrows(27, 'FWBC Hymns Volume 7 - Love and Praises', args.dbname), k_media_category["music"], args.dbname)
        self._insertmediaitemrows(self._musicrows(29, 'FWBC Hymns Volume 8 - Joy and Singing', args.dbname), k_media_category["music"], args.dbname)
        self._insertmediaitemrows(self._musicrows(30, 'Pastor Joe Major', args.dbname), k_media_category["music"], args.dbname)
        self._insertmediaitemrows(self._musicrows(31, 'VBC Instrumental Hymns', args.dbname), k_media_category["music"], args.dbname)
        self._insertmediaitemrows(self._musicrows(32, 'FWBC Spanish Christmas Hymns 2018', args.dbname), k_media_category["music"], args.dbname)
        self._insertmediaitemrows(self._musicrows(28, 'FWBC Psalms', args.dbname), k_media_category["music"], args.dbname)
        self._insertmediaitemrows(self._musicrows(33, 'FWBC Hymns Volume 9 - Testimony', args.dbname), k_media_category["music"], args.dbname)

    def _musicrows(self, musicid, playlistname, dbname):
        sourceconn = psycopg2.connect("host=localhost dbname={} user=postgres".format(dbname))
        # sourcecur = sourceconn.cursor()

        result = []
        # presented_at = None
        with sourceconn.cursor(cursor_factory=psycopg2.extras.DictCursor) as cur:
        # with sourceconn(cursor_factory=psycopg2.extras.DictCursor) as cur:

            # delete items with null paths
            # deletequery = 'delete FROM mediagospel where path is NULL'
            # cur.execute(deletequery)

            # # get array of org shortnames

            orgquery = 'select shortname from orgs'
            cur.execute(orgquery)
            orgs = []
            for row in cur:
                orgs.extend(row)
            print('orgs: {}'.format(orgs))

            with sourceconn.cursor(cursor_factory=psycopg2.extras.DictCursor) as playlistcur:
                found_playlist_id = False
                playlist_id = None
                playlistcur.execute(sql.SQL('SELECT * from playlists where basename = %s'), [playlistname])
                # playlistquery = 'SELECT * from playlists where basename = \'{}\''.format(playlistname)
                # if playlistquery != None: 

                # playlistcur.execute(playlistquery)
                playlist = playlistcur.fetchone()
                if playlist is not None:
                    print('found basename: {} playlist: {}'.format(playlist['basename'], playlist))
                    playlist_id = playlist['id']
                    found_playlist_id = True

                    sourcequery = 'SELECT * FROM mediamusic where music_id = {}'.format(musicid)
                    cur.execute(sourcequery)
                    for row in cur:
                        # records.append(row)
                        print('row: {}'.format(row))

                        path_split = row['path'].split('/')
                        if path_split[0] == 'music':
                            rowdict = {
                                'uuid': row['uuid'],
                                'track_number': row['track_number'],
                                'ordinal': row['track_number'],
                                'medium': 'audio',
                                'localizedname': row['localizedname'],
                                'path': row['path'],
                                'small_thumbnail_path': row['small_thumbnail_path'],
                                'large_thumbnail_path': row['large_thumbnail_path'],
                                'content_provider_link': None,
                                'ipfs_link': None,
                                'language_id': row['language_id'],
                                'presenter_name': row['presenter_name'],
                                'source_material': row['source_material'],
                                'updated_at': datetime.datetime.now(),
                                'playlist_id': playlist_id if found_playlist_id else None,
                                'med_thumbnail_path': row['med_thumbnail_path'],
                                'tags': [],
                                'inserted_at': datetime.datetime.now(),
                                'media_category': 3,
                                'presented_at': None,
                                'org_id': 1
                            }
                            print("rowdict: {}".format(rowdict))
                            result.append(rowdict)
        return result

    def misccleanup(self):
        parser = argparse.ArgumentParser(
            description='misccleanup')
        # prefixing the argument with -- means it's optional
        parser.add_argument('dbname')
        # parser.add_argument('livestream_url')
        # now that we're inside a subcommand, ignore the first
        # TWO argvs, ie the command (git) and the subcommand (commit)
        args = parser.parse_args(sys.argv[2:])
        print('misccleanup numbered: {}'.format(repr(args.dbname)))

        sourceconn = psycopg2.connect("host=localhost dbname={} user=postgres".format(args.dbname))
        # sourcecur = sourceconn.cursor()
        with sourceconn.cursor(cursor_factory=psycopg2.extras.DictCursor) as cur:
        # with sourceconn(cursor_factory=psycopg2.extras.DictCursor) as cur:

            # cur.execute(sql.SQL("insert into orgs(uuid, basename, shortname, updated_at, inserted_at) values (%s, %s, %s, %s, %s)"), 

            # delete items with null paths
            query1 = 'delete FROM mediagospel where path is NULL'
            cur.execute(query1)
            sourceconn.commit()

            miscquery = """
            UPDATE mediaitems SET source_material = \'Plan of Salvation\' WHERE path LIKE \'gospel/%\';
            UPDATE mediaitems SET source_material = \'Soul-winning Motivation\' WHERE path LIKE \'motivation/%\';
            UPDATE mediaitems SET source_material = \'Soul-winning Tutorial\' WHERE path LIKE \'tutorials/VerityBaptistChurch/%\';

            UPDATE mediaitems SET source_material = \'A Conversation with Pastor Jimenez\' WHERE uuid = \'0920cad6-1a3d-40e2-b75a-9d574ba4a3bc\';

            UPDATE mediaitems SET source_material = \'Faithful Word Baptist Church\' WHERE path LIKE \'preaching/fwbc%\';
            UPDATE mediaitems SET source_material = \'Verity Baptist Church\' WHERE path LIKE \'preaching/vbc%\';
            UPDATE mediaitems SET source_material = \'Verity Baptist Church\' WHERE presenter_name = \'Brother Joe Jones\';
            UPDATE mediaitems SET source_material = \'Verity Baptist Church\' WHERE presenter_name = \'Brother Jared Pozarnsky\';

            UPDATE mediaitems SET source_material = \'Old Path Baptist Church\' WHERE presenter_name = \'Pastor Manly Perry\';
            UPDATE mediaitems SET source_material = \'Faithful Word Baptist Church\' WHERE presenter_name = \'Brother Jonathan Shelley\';

            UPDATE mediaitems SET source_material = \'Verity Baptist Church\' WHERE presenter_name = \'Brother Matthew Stucky\';
            UPDATE mediaitems SET source_material = \'Mountain Baptist Church\' WHERE presenter_name = \'Pastor Jason Robinson\';
            UPDATE mediaitems SET source_material = \'Liberty Baptist Church\' WHERE presenter_name = \'Pastor Tommy McMurtry\';

            UPDATE mediaitems SET source_material = \'All Scripture Baptist Church\' WHERE presenter_name = \'Pastor Grayson Fritts\';
            UPDATE mediaitems SET source_material = \'Faith Baptist Church\' WHERE presenter_name = \'Pastor Joe Major\';

            UPDATE mediaitems SET presenter_name = \'Pastor Tommy McMurtry\' WHERE  presenter_name = \'Pastor McMurtry\';
            UPDATE mediaitems SET source_material = \'Verity Baptist Church\' WHERE presenter_name = \'Brother Matthew Stucky\';
            UPDATE mediaitems SET source_material = \'Word of Truth Baptist Church\' WHERE presenter_name = \'Pastor David Berzins\';
            UPDATE mediaitems SET source_material = \'Verity Baptist Church\' WHERE presenter_name = \'Pastor Roger Jimenez\';
            UPDATE mediaitems SET source_material = \'Faithful Word Baptist Church\' WHERE presenter_name = \'Pastor Steven Anderson\';
            UPDATE mediaitems SET presenter_name = \'Brother Aaron Thompson\' WHERE uuid = \'87c66fa7-c695-4f51-aa30-b0d5334ed652\';
            UPDATE mediaitems SET presenter_name = \'Brother Aaron Thompson\' WHERE uuid = \'07a3b451-9ca3-42ea-bf86-f4e5fb2e0135\';

            UPDATE mediaitems SET source_material = \'Hindi Plan of Salvation\' WHERE uuid = \'72239e97-9c03-4130-8207-e3d54e2ab5fb\';
            UPDATE mediaitems SET presenter_name = \'Unknown\' WHERE uuid = \'72239e97-9c03-4130-8207-e3d54e2ab5fb\';


            UPDATE mediaitems SET presenter_name = \'Pastor Steven Anderson\' WHERE localizedname = \'Jeremiah 30\';
            UPDATE mediaitems SET presenter_name = \'Pastor Steven Anderson\' WHERE localizedname = \'Singles, Dating, and Marriage\';
            UPDATE mediaitems SET presenter_name = \'Pastor Steven Anderson\' WHERE localizedname = \'Generation Snowflake\';
            UPDATE mediaitems SET presenter_name = \'Pastor Steven Anderson\' WHERE localizedname = \'I Praise You Not\';
            """
            cur.execute(miscquery)
            sourceconn.commit()  

            cur.execute(sql.SQL("insert into appversions(uuid, version_number, android_supported, ios_supported, web_supported) values (%s, %s, %s, %s, %s)"), 
                [str(uuid.uuid4()), 
                '1.3', 
                True,
                True,
                True
                ])
            sourceconn.commit()

if __name__ == '__main__':
    Dbimport()


