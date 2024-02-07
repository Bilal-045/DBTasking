drop table Participants;
drop table events;
drop table tags;
ALTER TABLE Photos
DROP CONSTRAINT fk_album_id;
alter table albums
drop CONSTRAINT fk_photo_inalbum;
drop table Albums;
drop table photos;
drop  table messages;
drop table Friends;
drop table Education;
drop table Programs;
Alter table users drop CONSTRAINT ht_fk;
Alter table users drop CONSTRAINT cc_fk;
drop table users;
drop table cities;
drop SEQUENCE Cities_seq;
drop SEQUENCE program_seq;
drop SEQUENCE Friends_seq;
drop SEQUENCE Messages_seq;
drop SEQUENCE tags_seq;
commit;