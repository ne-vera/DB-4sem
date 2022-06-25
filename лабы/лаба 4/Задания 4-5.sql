use UNIVER
 
--Задание 4
--На основе таблиц PRORGESS, STUDENT, GROUPS, SUBJECT, PULPIT и FACULTY сформировать перечень студентов, получивших экзаменационные оценки (столбец PROGRESS.NOTE) от 6 до 8. 
--Результирующий набор должен содержать столбцы: Факультет, Кафедра, Специальность, Дисциплина, Имя Студента, Оценка. В столбце Оценка должны быть записаны экзаменационные оценки прописью: шесть, семь, восемь. 
--Результирующий набор отсортировать в порядке возрастания по столбцам FACULTY.FACULTY, PULPIT.PULPIT, PROFESSION.PROFESSION, STUDENT. STUDENT_NAME и в порядке убывания по столбцу PROGRESS.NOTE.
-- использовать соединение INNER JOIN, предикат BETWEEN и выражение CASE.

SELECT PROGRESS.NOTE, STUDENT.NAME,GROUPS.IDGROUP, SUBJECT.SUBJECT,PULPIT.PULPIT,FACULTY.FACULTY,
Case
when (PROGRESS.NOTE = 6) then 'шесть'
when (PROGRESS.NOTE = 7) then 'семь'
when (PROGRESS.NOTE = 8) then 'восемь'
end [Оценка]
FROM PROGRESS inner join STUDENT 
ON PROGRESS.IDSTUDENT=STUDENT.IDSTUDENT AND PROGRESS.NOTE BETWEEN 6 AND 8
INNER JOIN GROUPS ON STUDENT.IDGROUP =GROUPS.IDGROUP 
INNER JOIN SUBJECT ON PROGRESS.SUBJECT=SUBJECT.SUBJECT
INNER JOIN FACULTY ON GROUPS.FACULTY= FACULTY.FACULTY
INNER JOIN PULPIT ON SUBJECT.PULPIT= PULPIT.PULPIT
ORDER BY PROGRESS.NOTE desc, FACULTY.FACULTY, PULPIT.PULPIT, STUDENT.NAME

--Задание 5
--сортировка по экзаменационным оценкам была следующей: сначала выводились стро-ки с оценкой 7, затем строки с оценкой 8 и далее строки с оценкой 6
SELECT PROGRESS.NOTE, STUDENT.NAME,GROUPS.IDGROUP, SUBJECT.SUBJECT,PULPIT.PULPIT,FACULTY.FACULTY,
Case
when (PROGRESS.NOTE = 6) then 'шесть'
when (PROGRESS.NOTE = 7) then 'семь'
when (PROGRESS.NOTE = 8) then 'восемь'
end [Оценка]
FROM PROGRESS inner join STUDENT
ON PROGRESS.IDSTUDENT=STUDENT.IDSTUDENT AND PROGRESS.NOTE BETWEEN 6 AND 8
INNER JOIN GROUPS ON STUDENT.IDGROUP =GROUPS.IDGROUP 
INNER JOIN SUBJECT ON PROGRESS.SUBJECT=SUBJECT.SUBJECT
INNER JOIN FACULTY ON GROUPS.FACULTY= FACULTY.FACULTY
INNER JOIN PULPIT ON SUBJECT.PULPIT= PULPIT.PULPIT
ORDER BY (case
when (PROGRESS.NOTE =6) then 3
when (PROGRESS.NOTE =7) then 1
when (PROGRESS.NOTE =8) then 2
end)
