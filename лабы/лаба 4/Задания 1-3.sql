use UNIVER

--Задание 1
--Перечень кодов аудиторий и соответствующих им наименований типов аудиторий.
SELECT AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME
FROM AUDITORIUM INNER JOIN AUDITORIUM_TYPE
ON AUDITORIUM.AUDITORIUM_TYPE=AUDITORIUM_TYPE.AUDITORIUM_TYPE

--Задание 2
---Перечень кодов аудиторий и соответствующих им наименований типов аудиторий, содержащих "компьютер"
SELECT AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME
FROM AUDITORIUM INNER JOIN AUDITORIUM_TYPE
ON AUDITORIUM.AUDITORIUM_TYPE=AUDITORIUM_TYPE.AUDITORIUM_TYPE AND
AUDITORIUM_TYPE.AUDITORIUM_TYPENAME Like '%компьютер%'

--Задание 3
--SELECT-запрос, формирующий результирующий набор аналогичный запросу из задания 1, но без применения INNER JOIN
SELECT AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME
FROM AUDITORIUM, AUDITORIUM_TYPE
WHERE AUDITORIUM.AUDITORIUM_TYPE=AUDITORIUM_TYPE.AUDITORIUM_TYPE
--SELECT-запрос, формирующий результирующий набор аналогичный запросу из задания 2, но без применения INNER JOIN
--Псевдонимы au и aut указаны сразу после элемента списка, ключевое слово as опущено
SELECT au.AUDITORIUM, aut.AUDITORIUM_TYPENAME
FROM AUDITORIUM au, AUDITORIUM_TYPE aut
WHERE au.AUDITORIUM_TYPE=aut.AUDITORIUM_TYPE AND
aut.AUDITORIUM_TYPENAME Like '%компьютер%'

