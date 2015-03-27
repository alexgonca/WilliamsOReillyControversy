# -*- coding: utf-8 -*-
import mediacloud
import ConfigParser
import MySQLdb as myDB

config = ConfigParser.ConfigParser()
config.read('info.config')

mc = mediacloud.api.MediaCloud(config.get('api','key'))
con = myDB.connect(config.get('db','host'), config.get('db','username'),
                   config.get('db','password'), config.get('db','schema'))

with con:
    con.set_character_set('utf8mb4')
    cur = con.cursor()
    cur.execute('SET NAMES utf8mb4;')
    cur.execute('SET CHARACTER SET utf8mb4;')
    cur.execute('SET character_set_connection=utf8mb4;')

    queryDescription = 'WilliamsOReilly'

    stopIteration = False
    lastProcessed_stories_id = 0

    while not stopIteration:
        #stories = mc.storyList('(brian AND williams)',
        #                       '+publish_date:[2015-01-30T00:00:00Z TO 2015-02-18T23:59:59Z]',
        #                       lastProcessed_stories_id, 1000)
        stories = mc.storyList('(brian AND williams) OR (bill AND reilly)',
                               '+publish_date:[2015-02-19T00:00:00Z TO 2015-03-19T23:59:59Z]',
                               lastProcessed_stories_id, 1000)

        if len(stories) == 0:
            stopIteration = True
        else:
            print "============================"
            print "More records: " + str(len(stories))
            print "============================"
            for story in stories:
                print story['processed_stories_id']
                cur.execute('INSERT INTO mediacloud_stories '
                            '(full_text_rss, media_id, media_name, media_url, description, language, url, title, processed_stories_id,'
                            'publish_date, guid, db_row_last_updated, stories_id, collect_date,'
                            'query)'
                            'values (%s, %s, %s, %s, %s, %s, %s, %s, %s, str_to_date(%s, \'%%Y-%%m-%%d %%H:%%i:%%s\'),'
                            '%s, str_to_date(%s, \'%%Y-%%m-%%d %%H:%%i:%%s.%%f\'), %s,'
                            'str_to_date(%s, \'%%Y-%%m-%%d %%H:%%i:%%s.%%f\'), %s)',
                            (story['full_text_rss'], story['media_id'], story['media_name'], story['media_url'], story['description'],
                             story['language'], story['url'], story['title'], story['processed_stories_id'],
                             story['publish_date'], story['guid'], story['db_row_last_updated'][:19],
                             story['stories_id'],
                             story['collect_date'], queryDescription))
                lastProcessed_stories_id = story['processed_stories_id']