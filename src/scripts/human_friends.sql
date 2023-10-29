DROP DATABASE IF EXISTS human_friends;
CREATE DATABASE human_friends;
USE human_friends;

-- Pets
DROP TABLE IF EXISTS pets;
CREATE TABLE pets (
	id SERIAL PRIMARY KEY, -- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
    name VARCHAR(50),
    type VARCHAR(50) COMMENT 'type of animal',
    birthDate DATE,
    commands VARCHAR(250)
);

-- Pack Animals
DROP TABLE IF EXISTS pack_animals;
CREATE TABLE pack_animals (
	id SERIAL PRIMARY KEY, -- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
    name VARCHAR(50),
    type VARCHAR(50) COMMENT 'type of animal',
    birthDate DATE,
    commands VARCHAR(250)
);

-- заполнение таблицы домашних животных даными
INSERT INTO pets (id, name, type, birthDate, commands) VALUES
(1, 'Fido', 'Dog', '2020-01-01', 'Sit, Stay, Fetch'),
(2, 'Whiskers', 'Cat', '2019-05-15', 'Sit, Pounce'),
(3, 'Hammy', 'Hamster', '2021-03-10', 'Roll, Hide'),
(4, 'Buddy', 'Dog', '2018-12-10', 'Sit, Paw, Bark'),
(5, 'Smudge', 'Cat', '2020-02-20', 'Sit, Pounce, Scratch'),
(6, 'Peanut', 'Hamster', '2021-08-01', 'Roll, Spin'),
(7, 'Bella', 'Dog', '2019-11-11', 'Sit, Stay, Roll'),
(8, 'Oliver', 'Cat', '2020-06-30', 'Meow, Scratch, Jump');

-- заполнение таблицы вьючных животных данными
INSERT INTO pack_animals (id, name, type, birthDate, commands) VALUES
(1, 'Thunder', 'Horse', '2015-07-21', 'Trot, Canter, Gallop'),
(2, 'Sandy', 'Camel', '2016-11-03', 'Walk, Carry Load'),
(3, 'Eeyore', 'Donkey', '2017-09-18', 'Walk, Carry Load, Bray'),
(4, 'Storm', 'Horse', '2014-05-05', 'Trot, Canter'),
(5, 'Dune', 'Camel', '2018-12-12', 'Walk ,Sit'),
(6, 'Burro', 'Donkey', '2019-01-23', 'Walk, Bray, Kick'),
(7, 'Blaze', 'Horse', '2016-02-29', 'Trot, Jump, Gallop'),
(8, 'Sahara', 'Camel', '2015-08-14', 'Walk, Run');

-- удаление записи о верблюдах
DELETE FROM animals WHERE type = 'Camel';

-- объединие таблицы лошадей и ослов.
SELECT *  FROM pack_animals WHERE type = 'Horse'
UNION
SELECT * FROM pack_animals WHERE type = 'Donkey';

-- Создание новой таблицы для животных в возрасте от 1 до 3 лет и вычислить их возраст с точностью до месяца.
DROP TABLE IF EXISTS pets_age;
CREATE TABLE pets_age (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100),
  birthDate DATE,
  age_in_months INT,
  type VARCHAR(50) COMMENT 'type of animal',
  commands VARCHAR(250)
);

DROP TABLE IF EXISTS pack_animals_age;
CREATE TABLE pack_animals_age (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100),
  birthDate DATE,
  age_in_months INT,
  type VARCHAR(50) COMMENT 'type of animal',
  commands VARCHAR(250)
);

INSERT INTO pets_age (name, birthDate, commands, type, age_in_months)
SELECT name, birthDate, commands, type, TIMESTAMPDIFF(MONTH, birthDate, NOW()) AS age_in_months
FROM pets
WHERE TIMESTAMPDIFF(YEAR, birthDate, NOW());

INSERT INTO pack_animals_age (name, birthDate, commands, type, age_in_months)
SELECT name, birthDate, commands, type, TIMESTAMPDIFF(MONTH, birthDate, NOW()) AS age_in_months
FROM pack_animals
WHERE TIMESTAMPDIFF(YEAR, birthDate, NOW());

SELECT * FROM pets_age WHERE TIMESTAMPDIFF(YEAR, birthDate, NOW()) BETWEEN 1 AND 3
UNION
SELECT * FROM pack_animals_age WHERE TIMESTAMPDIFF(YEAR, birthDate, NOW()) BETWEEN 1 AND 3;

-- - Объединить все созданные таблицы в одну, сохраняя информацию о принадлежности к исходным таблицам.
DROP TABLE IF EXISTS all_animals;
CREATE TABLE all_animals (
	id SERIAL PRIMARY KEY, -- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
	name VARCHAR(50),
    type VARCHAR(50) COMMENT 'type of animal',
    birthDate DATE,
    commands VARCHAR(250),
	age_in_months INT,
	table_name VARCHAR(100)
);

INSERT INTO all_animals (name, birthDate, commands, type, age_in_months, table_name)
SELECT name, birthDate, commands, type, age_in_months, 'Pets' AS table_name
FROM pets_age
UNION ALL
SELECT name, birthDate, commands, type, age_in_months, 'Pack_animals' AS table_name
FROM pack_animals_age;