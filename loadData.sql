 INSERT INTO Cities (city_id, city_name, state_name, country_name)
SELECT cities_seq.nextval, city_name, state_name, country_name
FROM (
    SELECT DISTINCT current_city AS city_name, current_state AS state_name, current_country AS country_name FROM public_user_information
    UNION
    SELECT DISTINCT hometown_city AS city_name, hometown_state AS state_name, hometown_country AS country_name FROM public_user_information
    union 
    select distinct  e.event_city AS city_name , e.event_state AS state_name, e.event_country AS country_name from public_event_information e
);
commit;
insert into Programs 
(select program_seq.nextval, institution_name, program_concentration, program_degree from 
(select distinct institution_name, program_concentration, program_degree from public_user_information ));
commit;
insert into users 
(select distinct user_id, first_name, last_name, year_of_birth, month_of_birth, day_of_birth, gender, home_city.city_id, c_ciyt.city_id
from public_user_information p, cities home_city , cities c_ciyt where p.hometown_city = home_city.city_name and p.current_city = c_ciyt.city_name);
commit;
insert into Education   
(select pui.user_id, p.program_id , pui.program_year from public_user_information pui , Programs p  where pui.program_concentration = p.concentration and
 pui.program_degree = p.degree and pui.institution_name = p.institution);
 commit;
insert into Friends 
(select distinct least(user1_id,user2_id) , GREATEST(user2_id, user1_id) from Public_Are_Friends);
commit;
--SET AUTOCOMMIT OFF;

insert into photos(photo_id , photo_caption, photo_created_time, photo_modified_time, photo_link) 
(select distinct photo_id, photo_caption, photo_created_time, photo_modified_time, photo_link from Public_Photo_Information);
commit;
insert into albums(album_id, album_owner_id, album_name, album_created_time, album_modified_time, album_link, album_visibility, cover_photo_id) 
(select distinct album_id, owner_id, album_name, album_created_time, album_modified_time, album_link, album_visibility, cover_photo_id from Public_Photo_Information pp);
commit;

--SET AUTOCOMMIT ON;

UPDATE Photos ph
SET ph.album_id = (
    SELECT ppi.album_id
    FROM Public_Photo_Information ppi
    WHERE ph.photo_id = ppi.photo_id
)
WHERE EXISTS (
    SELECT 1
    FROM Public_Photo_Information pp
    WHERE ph.photo_id = pp.photo_id
);
commit;
insert into tags  (select photo_id, tag_subject_id, tag_created_time, tag_x_coordinate, tag_y_coordinate from Public_Tag_Information);
commit;
insert into events  (select event_id, event_creator_id, event_name, event_tagline, event_description, event_host, event_type, event_subtype, event_address,
 c.city_id ,event_start_time, event_end_time from Public_Event_Information e, cities c where c.city_name = e.event_city );
 commit;