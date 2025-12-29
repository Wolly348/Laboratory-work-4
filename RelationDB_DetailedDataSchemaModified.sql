DROP TABLE IF EXISTS detailed_viewing CASCADE;
DROP TABLE IF EXISTS sorting CASCADE;
DROP TABLE IF EXISTS saving CASCADE;
DROP TABLE IF EXISTS keywords CASCADE;
DROP TABLE IF EXISTS detailed_information CASCADE;
DROP TABLE IF EXISTS advice CASCADE;
DROP TABLE IF EXISTS advice_category CASCADE;
DROP TABLE IF EXISTS doctor CASCADE;
DROP TABLE IF EXISTS note CASCADE;
DROP TABLE IF EXISTS important_text CASCADE;
DROP TABLE IF EXISTS document CASCADE;
DROP TABLE IF EXISTS catalogue CASCADE;
DROP TABLE IF EXISTS users CASCADE;

CREATE TABLE users ( -- опис користувача
    user_id SMALLINT, -- N користувача
    full_name VARCHAR(99), -- ім'я користувача
    age SMALLINT, -- вік користувача
    email VARCHAR(99) -- поштова скринька користувача
);

ALTER TABLE users
ADD CONSTRAINT users_pk
PRIMARY KEY (user_id);

ALTER TABLE users
ALTER COLUMN full_name SET NOT NULL;

ALTER TABLE users
ADD CONSTRAINT users_full_name_template
CHECK (full_name ~ '^[A-Za-z]+( [A-Za-z]+)+$');

ALTER TABLE users
ADD CONSTRAINT users_age_constraint
CHECK (age BETWEEN 13 AND 122);

ALTER TABLE users
ALTER COLUMN email SET NOT NULL;

ALTER TABLE users
ADD CONSTRAINT users_email_template
CHECK (
    email ~ '^[A-Za-z0-9][A-Za-z0-9._-]*@[A-Za-z][A-Za-z0-9-]*\.[A-Za-z]{2,}$'
);

ALTER TABLE users
ADD CONSTRAINT users_email_unique
UNIQUE (email);

CREATE TABLE catalogue ( -- опис каталога
    catalogue_id SMALLINT, -- N каталога
    theme VARCHAR(149), -- назва каталога
    date_created DATE, -- дата створення каталога
    user_id SMALLINT -- N користувача
);

ALTER TABLE catalogue
ADD CONSTRAINT catalogue_pk
PRIMARY KEY (catalogue_id);

ALTER TABLE catalogue
ALTER COLUMN theme SET NOT NULL;

ALTER TABLE catalogue
ALTER COLUMN date_created SET NOT NULL;

ALTER TABLE catalogue
ALTER COLUMN user_id SET NOT NULL;

ALTER TABLE catalogue
ADD CONSTRAINT catalogue_users_theme_unique
UNIQUE (user_id, theme);

ALTER TABLE catalogue
ADD CONSTRAINT catalogue_users_fk
FOREIGN KEY (user_id)
REFERENCES users (user_id);

CREATE TABLE document ( -- опис документа
    document_id SMALLINT, -- N документа
    title VARCHAR(149), -- назва документа
    content_text TEXT, -- зміст документа
    date_created DATE, -- дата створення документа
    catalogue_id SMALLINT, -- N каталогу
    user_id SMALLINT -- N користувача
);

ALTER TABLE document
ADD CONSTRAINT document_pk
PRIMARY KEY (document_id);

ALTER TABLE document
ALTER COLUMN title SET NOT NULL;

ALTER TABLE document
ADD CONSTRAINT document_content_constraint
CHECK (octet_length(content_text) < 10 * 1024 * 1024);

ALTER TABLE document
ALTER COLUMN date_created SET NOT NULL;

ALTER TABLE document
ALTER COLUMN catalogue_id SET NOT NULL;

ALTER TABLE document
ALTER COLUMN user_id SET NOT NULL;

ALTER TABLE document
ADD CONSTRAINT document_catalogue_fk
FOREIGN KEY (catalogue_id)
REFERENCES catalogue (catalogue_id);

ALTER TABLE document
ADD CONSTRAINT document_users_fk
FOREIGN KEY (user_id)
REFERENCES users (user_id);

ALTER TABLE document
ADD CONSTRAINT document_catalogue_title_unique
UNIQUE (catalogue_id, title);

CREATE TABLE keywords ( -- опис ключового слова
    keyword_id SMALLINT, -- N ключового слова
    word VARCHAR(99), -- ключове слово
    user_id SMALLINT, -- N користувача
    document_id SMALLINT -- N документа
);

ALTER TABLE keywords
ADD CONSTRAINT keywords_pk
PRIMARY KEY (keyword_id);

ALTER TABLE keywords
ALTER COLUMN word SET NOT NULL;

ALTER TABLE keywords
ALTER COLUMN user_id SET NOT NULL;

ALTER TABLE keywords
ALTER COLUMN document_id SET NOT NULL;

ALTER TABLE keywords
ADD CONSTRAINT keywords_users_fk
FOREIGN KEY (user_id)
REFERENCES users (user_id);

ALTER TABLE keywords
ADD CONSTRAINT keywords_document_fk
FOREIGN KEY (document_id)
REFERENCES document (document_id);

ALTER TABLE keywords
ADD CONSTRAINT keywords_document_word_unique
UNIQUE (document_id, word);

CREATE TABLE important_text ( -- опис виділеного тексту
    text_id SMALLINT, -- N виділеного тексту
    text_part TEXT, -- виділений текст
    user_id SMALLINT, -- N користувача
    document_id SMALLINT -- N документа
);

ALTER TABLE important_text
ADD CONSTRAINT important_text_pk
PRIMARY KEY (text_id);

ALTER TABLE important_text
ALTER COLUMN text_part SET NOT NULL;

ALTER TABLE important_text
ADD CONSTRAINT important_text_text_part_constraint
CHECK (octet_length(text_part) < 5 * 1024 * 1024);

ALTER TABLE important_text
ALTER COLUMN user_id SET NOT NULL;

ALTER TABLE important_text
ALTER COLUMN document_id SET NOT NULL;

ALTER TABLE important_text
ADD CONSTRAINT important_text_users_fk
FOREIGN KEY (user_id)
REFERENCES users (user_id);

ALTER TABLE important_text
ADD CONSTRAINT important_text_document_fk
FOREIGN KEY (document_id)
REFERENCES document (document_id);

ALTER TABLE important_text
ADD CONSTRAINT important_text_document_text_part_unique
UNIQUE (document_id, text_part);

CREATE TABLE note ( -- опис примітки
    note_id SMALLINT, -- N примітки
    title VARCHAR(149), -- назва примітки
    text_part TEXT, -- зміст примітки
    date_created DATE, -- дата створення примітки
    user_id SMALLINT -- N користувача
);

ALTER TABLE note
ADD CONSTRAINT note_pk
PRIMARY KEY (note_id);

ALTER TABLE note
ALTER COLUMN title SET NOT NULL;

ALTER TABLE note
ADD CONSTRAINT note_text_part_constraint
CHECK (octet_length(text_part) < 5 * 1024 * 1024);

ALTER TABLE note
ALTER COLUMN date_created SET NOT NULL;

ALTER TABLE note
ALTER COLUMN user_id SET NOT NULL;

ALTER TABLE note
ADD CONSTRAINT note_users_fk
FOREIGN KEY (user_id)
REFERENCES users (user_id);

ALTER TABLE note
ADD CONSTRAINT note_user_title_unique
UNIQUE (user_id, title);

CREATE TABLE saving ( -- сполучна таблиця між виділеним текстом та приміткою
    note_id SMALLINT, -- N примітки
    text_id SMALLINT -- N виділеного тексту
);

ALTER TABLE saving
ADD CONSTRAINT saving_pk
PRIMARY KEY (note_id, text_id);

ALTER TABLE saving
ADD CONSTRAINT saving_note_fk
FOREIGN KEY (note_id)
REFERENCES note (note_id);

ALTER TABLE saving
ADD CONSTRAINT saving_important_text_fk
FOREIGN KEY (text_id)
REFERENCES important_text (text_id);

CREATE TABLE doctor ( -- опис лікаря
    doctor_id SMALLINT, -- N лікаря
    full_name VARCHAR(99), -- ім'я лікаря
    email VARCHAR(99), -- поштова скринька лікаря
    work_experience SMALLINT, -- стаж роботи лікаря
    workplace VARCHAR(249), -- місце роботи лікаря
    specialization VARCHAR(99) -- спеціальність лікаря
);

ALTER TABLE doctor
ADD CONSTRAINT doctor_pk
PRIMARY KEY (doctor_id);

ALTER TABLE doctor
ALTER COLUMN full_name SET NOT NULL;

ALTER TABLE doctor
ADD CONSTRAINT doctor_full_name_template
CHECK (full_name ~ '^[A-Za-z]+( [A-Za-z]+)+$');

ALTER TABLE doctor
ALTER COLUMN email SET NOT NULL;

ALTER TABLE doctor
ADD CONSTRAINT doctor_email_template
CHECK (
    email ~ '^[A-Za-z0-9][A-Za-z0-9._-]*@[A-Za-z][A-Za-z0-9-]*\.[A-Za-z]{2,}$'
);

ALTER TABLE doctor
ALTER COLUMN work_experience SET NOT NULL;

ALTER TABLE doctor
ADD CONSTRAINT doctor_work_experience_constraint
CHECK (work_experience BETWEEN 1 AND 75);

ALTER TABLE doctor
ALTER COLUMN workplace SET NOT NULL;

ALTER TABLE doctor
ALTER COLUMN specialization SET NOT NULL;

ALTER TABLE doctor
ADD CONSTRAINT doctor_email_unique
UNIQUE (email);

CREATE TABLE advice_category ( -- опис категорії порад
    category_id SMALLINT, -- N категорії
    theme VARCHAR(99) -- назва категорії
);

ALTER TABLE advice_category
ADD CONSTRAINT advice_category_pk
PRIMARY KEY (category_id);

ALTER TABLE advice_category
ALTER COLUMN theme SET NOT NULL;

ALTER TABLE advice_category
ADD CONSTRAINT advice_category_theme_unique
UNIQUE (theme);

CREATE TABLE advice ( -- опис поради
    advice_id SMALLINT, -- N поради
    title VARCHAR(99), -- назва поради
    description VARCHAR(199), -- опис поради
    date_added DATE, -- дата додавання поради
    rating NUMERIC(2, 1), -- середня оцінка користувачів
    doctor_id SMALLINT, -- N лікаря
    category_id SMALLINT -- N категорії
);

ALTER TABLE advice
ADD CONSTRAINT advice_pk
PRIMARY KEY (advice_id);

ALTER TABLE advice
ALTER COLUMN title SET NOT NULL;

ALTER TABLE advice
ALTER COLUMN description SET NOT NULL;

ALTER TABLE advice
ALTER COLUMN date_added SET NOT NULL;

ALTER TABLE advice
ALTER COLUMN rating SET DEFAULT 0.0;

ALTER TABLE advice
ALTER COLUMN rating SET NOT NULL;

ALTER TABLE advice
ADD CONSTRAINT advice_rating_constraint
CHECK (rating BETWEEN 0 AND 5);

ALTER TABLE advice
ALTER COLUMN doctor_id SET NOT NULL;

ALTER TABLE advice
ALTER COLUMN category_id SET NOT NULL;

ALTER TABLE advice
ADD CONSTRAINT advice_doctor_fk
FOREIGN KEY (doctor_id)
REFERENCES doctor (doctor_id);

ALTER TABLE advice
ADD CONSTRAINT advice_advice_category_fk
FOREIGN KEY (category_id)
REFERENCES advice_category (category_id);

CREATE TABLE detailed_information ( -- опис детальної інформації поради
    info_id SMALLINT, -- N детальної інформації поради
    title VARCHAR(99), -- назва поради
    date_added DATE, -- дата додавання поради
    rating NUMERIC(2, 1), -- середня оцінка користувачів
    content_data BYTEA, -- зміст поради
    advice_id SMALLINT -- N поради
);

ALTER TABLE detailed_information
ADD CONSTRAINT detailed_information_pk
PRIMARY KEY (info_id);

ALTER TABLE detailed_information
ALTER COLUMN title SET NOT NULL;

ALTER TABLE detailed_information
ALTER COLUMN date_added SET NOT NULL;

ALTER TABLE detailed_information
ALTER COLUMN rating SET DEFAULT 0.0;

ALTER TABLE detailed_information
ALTER COLUMN rating SET NOT NULL;

ALTER TABLE detailed_information
ADD CONSTRAINT detailed_information_rating_constraint
CHECK (rating BETWEEN 0 AND 5);

ALTER TABLE detailed_information
ALTER COLUMN content_data SET NOT NULL;

ALTER TABLE detailed_information
ADD CONSTRAINT detailed_information_content_constraint
CHECK (octet_length(content_data) < 5 * 1024 * 1024);

ALTER TABLE detailed_information
ALTER COLUMN advice_id SET NOT NULL;

ALTER TABLE detailed_information
ADD CONSTRAINT detailed_information_advice_fk
FOREIGN KEY (advice_id)
REFERENCES advice (advice_id);

ALTER TABLE detailed_information
ADD CONSTRAINT detailed_information_advice_unique
UNIQUE (advice_id);

CREATE TABLE sorting ( -- сполучна таблиця між користувачем та порадою
    user_id SMALLINT, -- N користувача
    advice_id SMALLINT -- N поради
);

ALTER TABLE sorting
ADD CONSTRAINT sorting_pk
PRIMARY KEY (user_id, advice_id);

ALTER TABLE sorting
ADD CONSTRAINT sorting_users_fk
FOREIGN KEY (user_id)
REFERENCES users (user_id);

ALTER TABLE sorting
ADD CONSTRAINT sorting_advice_fk
FOREIGN KEY (advice_id)
REFERENCES advice (advice_id);

-- сполучна таблиця між користувачем та детальною інформацєю поради
CREATE TABLE detailed_viewing (
    user_id SMALLINT, -- N користувача
    info_id SMALLINT -- N детальної інформації поради
);

ALTER TABLE detailed_viewing
ADD CONSTRAINT detailed_viewing_pk
PRIMARY KEY (user_id, info_id);

ALTER TABLE detailed_viewing
ADD CONSTRAINT detailed_viewing_users_fk
FOREIGN KEY (user_id)
REFERENCES users (user_id);

ALTER TABLE detailed_viewing
ADD CONSTRAINT detailed_viewing_detailed_information_fk
FOREIGN KEY (info_id)
REFERENCES detailed_information (info_id);
