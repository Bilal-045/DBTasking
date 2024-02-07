CREATE TABLE Cities (
    city_id INTEGER PRIMARY KEY,
    city_name VARCHAR2(100) NOT NULL,
    state_name VARCHAR2(100) NOT NULL,
    country_name VARCHAR2(100) NOT NULL
);
CREATE TABLE Users (
    user_id INTEGER PRIMARY KEY,
    first_name VARCHAR2(100) NOT NULL,
    last_name VARCHAR2(100) NOT NULL,
    year_of_birth INTEGER,
    month_of_birth INTEGER,
    day_of_birth INTEGER,
    gender VARCHAR2(100),
    hometown INTEGER,
    Curreny_City INTEGER
);
Alter table users add CONSTRAINT ht_fk FOREIGN KEY (hometown) REFERENCES Cities(city_id);
Alter table users add CONSTRAINT cc_fk FOREIGN KEY (Curreny_City) REFERENCES Cities(city_id);
CREATE TABLE Programs (
    program_id INTEGER PRIMARY KEY,
    institution VARCHAR2(100) NOT NULL,
    concentration VARCHAR2(100) NOT NULL,
    degree VARCHAR2(100) NOT NULL
);
CREATE TABLE Education (
    user_id INTEGER NOT NULL,
    program_id INTEGER NOT NULL,
    program_year INTEGER NOT NULL,
    PRIMARY KEY (user_id, program_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (program_id) REFERENCES Programs(program_id)
);

CREATE TABLE Friends (
    user1_id INTEGER NOT NULL,
    user2_id INTEGER NOT NULL,
    PRIMARY KEY (user1_id, user2_id),
    FOREIGN KEY (user1_id) REFERENCES Users(user_id),
    FOREIGN KEY (user2_id) REFERENCES Users(user_id)
);
CREATE TRIGGER Order_Friend_Pairs
    BEFORE INSERT ON Friends
    FOR EACH ROW
        DECLARE temp INTEGER;
        BEGIN
            IF :NEW.user1_id > :NEW.user2_id THEN
                temp := :NEW.user2_id;
                :NEW.user2_id := :NEW.user1_id;
                :NEW.user1_id := temp;
            END IF;
        END;
/

CREATE TABLE Messages (
    message_id INTEGER PRIMARY KEY,
    sender_id INTEGER NOT NULL,
    receiver_id INTEGER NOT NULL,
    message_content VARCHAR2(2000) NOT NULL,
    sent_time TIMESTAMP NOT NULL,
    FOREIGN KEY (sender_id) REFERENCES Users(user_id),
    FOREIGN KEY (receiver_id) REFERENCES Users(user_id)
);
CREATE TABLE Photos (
    photo_id INTEGER PRIMARY KEY,
    album_id INTEGER,
    photo_caption VARCHAR2(2000),
    photo_created_time TIMESTAMP NOT NULL,
    photo_modified_time TIMESTAMP,
    photo_link VARCHAR2(2000) NOT NULL
    );
CREATE TABLE Albums (
    album_id INTEGER PRIMARY KEY,
    album_owner_id INTEGER NOT NULL,
    album_name VARCHAR2(100) NOT NULL,
    album_created_time TIMESTAMP NOT NULL,
    album_modified_time TIMESTAMP,
    album_link VARCHAR2(2000) NOT NULL,
    album_visibility VARCHAR2(100) NOT NULL,
    cover_photo_id INTEGER NOT NULL,
    FOREIGN KEY (album_owner_id) REFERENCES Users(user_id)
);
ALTER TABLE Photos
ADD CONSTRAINT fk_album_id FOREIGN KEY (album_id) REFERENCES Albums(album_id) INITIALLY DEFERRED DEFERRABLE;
ALTER TABLE Albums
ADD CONSTRAINT fk_photo_inalbum FOREIGN KEY (cover_photo_id) REFERENCES Photos(photo_id) INITIALLY DEFERRED DEFERRABLE;
Alter Table Albums
Add CONSTRAINT album_Vis Check (album_visibility IN ('Everyone', 'Friends', 'Friends_Of_Friends', 'Myself'));
CREATE TABLE Tags (
    tag_photo_id INTEGER NOT NULL,
    tag_subject_id INTEGER NOT NULL,
    tag_created_time TIMESTAMP NOT NULL,
    tag_x NUMBER NOT NULL,
    tag_y NUMBER NOT NULL,
    PRIMARY KEY (tag_photo_id, tag_subject_id),
    FOREIGN KEY (tag_photo_id) REFERENCES Photos(photo_id),
    FOREIGN KEY (tag_subject_id) REFERENCES Users(user_id)
);
CREATE TABLE Events (
    event_id INTEGER PRIMARY KEY,
    event_creator_id INTEGER NOT NULL,
    event_name VARCHAR2(100) NOT NULL,
    event_tagline VARCHAR2(100),
    event_description VARCHAR2(100),
    event_host VARCHAR2(100),
    event_type VARCHAR2(100),
    event_subtype VARCHAR2(100),
    event_address VARCHAR2(2000),
    event_city_id INTEGER NOT NULL,
    event_start_time TIMESTAMP,
    event_end_time TIMESTAMP,
    FOREIGN KEY (event_creator_id) REFERENCES Users(user_id),
    FOREIGN KEY (event_city_id) REFERENCES Cities(city_id)
);
CREATE TABLE Participants (
    event_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    confirmation VARCHAR2(100) NOT NULL,
    PRIMARY KEY (event_id, user_id),
    FOREIGN KEY (event_id) REFERENCES Events(event_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    CONSTRAINT chk_confirmation CHECK (confirmation IN ('Attending', 'Unsure', 'Declines', 'Not_Replied'))
);
    CREATE SEQUENCE Cities_seq
    INCREMENT BY 1
    START WITH 1
    NOMAXVALUE
    NOCYCLE
    NOCACHE;
    CREATE SEQUENCE program_seq
    INCREMENT BY 1
    START WITH 1
    NOMAXVALUE
    NOCYCLE
    NOCACHE;
    CREATE SEQUENCE Friends_seq
    INCREMENT BY 1
    START WITH 1
    NOMAXVALUE
    NOCYCLE
    NOCACHE;
    CREATE SEQUENCE Messages_seq
    INCREMENT BY 1
    START WITH 1
    NOMAXVALUE
    NOCYCLE
    NOCACHE;
    CREATE SEQUENCE tags_seq
    INCREMENT BY 1
    START WITH 1
    NOMAXVALUE
    NOCYCLE
    NOCACHE;
    COMMIT;