/* 1. Return a list with the first surname, second surname and first name of all students. The list must
//be sorted alphabetically from lowest to highest by first surname, second surname and first name.  */

SELECT persona.apellido1, persona.apellido2, persona.nombre FROM persona
WHERE persona.tipo = 'alumno'
ORDER BY persona.apellido1 DESC, persona.apellido2 DESC, persona.nombre DESC;


/* 2. Find out the first and last names of students who have not registered their phone number in the
database.     */

SELECT persona.nombre , persona.apellido2, persona.apellido1 FROM persona
WHERE persona.telefono IS NULL AND persona.tipo = 'alumno';



/* 3. Return the list of students born in 1999. */

SELECT * from persona
WHERE persona.fecha_nacimiento IN
(SELECT persona.fecha_nacimiento FROM persona
 WHERE YEAR(persona.fecha_nacimiento) = '1999'
AND persona.tipo = 'alumno');


/* 4. Return the list of teachers who have not registered their phone number in the database
//data and in addition its nif finishes in K.   */

SELECT persona.nombre, persona.apellido1, persona.apellido2, persona.nif FROM persona
WHERE persona.tipo = 'profesor' AND persona.telefono IS null AND persona.nif LIKE '%K';



/* 5. Returns the list of subjects taught in the first semester, in the third
course of the degree held by the identifier 7.    */

SELECT asignatura.nombre as nc FROM asignatura
WHERE asignatura.cuatrimestre = 1 AND asignatura.id_grado = 7 AND asignatura.curso = 3;



/* 6.    Return a list of teachers along with the name of the department they are in
linked. The listing must return four columns, first surname, second surname, first name and first
name of the department. The result will be sorted alphabetically from lowest to highest by last
name and first name. */

SELECT persona.apellido1, persona.apellido2, persona.nombre, departamento.nombre FROM departamento, persona
RIGHT JOIN profesor
ON persona.id = profesor.id_profesor
WHERE departamento.id = profesor.id_departamento
ORDER BY departamento.nombre ASC, persona.apellido1 ASC, persona.apellido2 ASC, persona.nombre ASC;


/* 7.     Returns a list with the name of the subjects, year of beginning and year of end of the school year of
the student with nif 26902806M.*/

SELECT asignatura.nombre, curso_escolar.anyo_inicio, curso_escolar.anyo_fin from asignatura
RIGHT JOIN curso_escolar
ON asignatura.id = curso_escolar.id 
WHERE asignatura.id IN (
SELECT alumno_se_matricula_asignatura.id_asignatura FROM alumno_se_matricula_asignatura
WHERE alumno_se_matricula_asignatura.id_alumno IN
(SELECT alumno_se_matricula_asignatura.id_alumno FROM alumno_se_matricula_asignatura
LEFT JOIN persona
ON alumno_se_matricula_asignatura.id_alumno = persona.id
WHERE persona.id IN (SELECT persona.id FROM persona
                     WHERE persona.nif = '26902806M')))

/* 8.   Return a list with the names of all the departments that have professors who teach a subject in the
Degree in Computer Engineering (Syllabus 2015). */

SELECT departamento.nombre FROM departamento
WHERE departamento.id IN (

SELECT profesor.id_departamento FROM profesor
LEFT JOIN asignatura
ON profesor.id_profesor = asignatura.id_profesor 
WHERE asignatura.id_grado IN (
    
SELECT asignatura.id_grado FROM asignatura
                           LEFT JOIN grado
                           ON asignatura.id_grado = grado.id
                           WHERE grado.nombre = 'Grado en Ingeniería Informática (Plan 2015)'))

/* 9. Returns a list of all students who have enrolled in a subject during the
school year 2018/2019. */

SELECT * FROM persona 
WHERE persona.id IN 
(SELECT alumno_se_matricula_asignatura.id_alumno FROM alumno_se_matricula_asignatura
LEFT JOIN curso_escolar
ON alumno_se_matricula_asignatura.id_curso_escolar = curso_escolar.id
WHERE curso_escolar.anyo_inicio = '2018')


/* **********Solve the following 6 queries using the LEFT JOIN and RIGHT JOIN clauses.****   */
/* 1.   Return a list with the names of all teachers and related departments.
The list should also show those teachers who have no associated department. The list must return
four columns, name of the department, first surname, second surname and name of the teacher.
The result will be sorted alphabetically from lowest to highest by department name, last name, and
first name. */

SELECT dp.nombre AS 'departamento nombre', pr.apellido1, pr.apellido2, pr.nombre, pr.tipo FROM profesor AS pf
RIGHT JOIN persona as pr
ON pf.id_profesor = pr.id
LEFT JOIN departamento AS dp
ON pf.id_departamento = dp.id
WHERE pr.tipo = 'profesor'
ORDER BY dp.nombre, pr.apellido1, pr.apellido2, pr.nombre


/* 2.   Return a list of teachers who are not associated with a department.    */

SELECT * FROM profesor AS pf
RIGHT JOIN persona as pr
ON pf.id_profesor = pr.id
LEFT JOIN departamento AS dp
ON pf.id_departamento = dp.id
WHERE pr.tipo = 'profesor' AND dp.id IS NULL

/* 3.  Return a list of departments that do not have associate professors. */

SELECT departamento.nombre, profesor.id_profesor FROM departamento
LEFT JOIN profesor
ON departamento.id = profesor.id_departamento
WHERE profesor.id_profesor IS NULL


/* 4.  Return a list with teachers who do not teach any subject.    */

SELECT persona.id, persona.apellido1, persona.apellido2, persona.nombre, persona.tipo FROM persona, asignatura
RIGHT JOIN profesor
ON asignatura.id_profesor = profesor.id_profesor
WHERE profesor.id_profesor = persona.id AND asignatura.id_profesor IS NULL

/* 5.  Returns a list of subjects that do not have an assigned teacher.    */

SELECT asignatura.id, asignatura.nombre, asignatura.id_profesor FROM asignatura
LEFT JOIN profesor
ON asignatura.id_profesor = profesor.id_profesor
WHERE asignatura.id_profesor IS NULL

/* 6.   Return a list with all the departments that have not taught subjects in any course
school. */

SELECT * FROM departamento
WHERE departamento.id IN (
SELECT profesor.id_profesor FROM asignatura
RIGHT JOIN profesor
ON asignatura.id_profesor = profesor.id_profesor
WHERE asignatura.id_profesor IS NULL);


/* ************************************************************************** */

/* Summary queries:
1. Return the total number of students there*/

SELECT COUNT(persona.tipo) as 'Number of students' FROM persona
WHERE persona.tipo = 'alumno';

/* 2. Calculate how many students were born in 1999.*/

SELECT COUNT(persona.fecha_nacimiento) as 'Fecha nacimiento' FROM persona
WHERE persona.tipo = 'alumno' AND persona.fecha_nacimiento LIKE '1999%';

/* 3. Calculate how many teachers there are in each department. The result should only show two
columns, one with the name of the department and one with the number of teachers in that
department. The result should only include departments that have associate professors and should
be sorted from highest to lowest by the number of professors. */

SELECT departamento.nombre AS Departamento_nombre, COUNT(profesor.id_departamento) AS Numero_de_profesors from profesor

LEFT JOIN departamento
ON profesor.id_departamento = departamento.id                                              

GROUP BY departamento.nombre
ORDER BY Numero_de_profesors DESC;


/* 4. Return a list with all the departments and the number of teachers in each of them. Please note that
there may be departments that do not have associate professors.
These departments should also be listed. */

SELECT departamento.nombre AS Departamento_nombre, COUNT(profesor.id_departamento) AS Numero_de_profesors from profesor

RIGHT JOIN departamento
ON profesor.id_departamento = departamento.id                                              

GROUP BY departamento.nombre
ORDER BY Numero_de_profesors DESC;


/* 5. Return a list with the names of all the existing degrees in the database and the number of
subjects that each one has. Note that there may be degrees that do not have associated
subjects. These degrees must also appear in the list. The result must be ordered from highest to
lowest by the number of subjects. */

SELECT grado.nombre AS Grado, COUNT(asignatura.id_grado) AS Numero_de_cursos from grado

LEFT JOIN asignatura
ON grado.id = asignatura.id_grado                                          

GROUP BY grado.nombre
ORDER BY Numero_de_cursos DESC;


/* 6. Return a list with the names of all the existing degrees in the database and the number of
subjects that each has, of the degrees that have more than 40 associated subjects.  */


SELECT grado.nombre AS Grado, COUNT(asignatura.id_grado) AS Numero_de_cursos from grado

LEFT JOIN asignatura
ON grado.id = asignatura.id_grado

GROUP BY grado.nombre HAVING COUNT(asignatura.id_grado) > 40
ORDER BY COUNT(asignatura.id_grado) DESC;


/* 7. Returns a list that shows the name of the degrees and the sum of the total number of credits
for each type of subject. The result must have three columns:
name of the degree, type of subject and the sum of the credits of all the subjects of this type.    */

SELECT grado.nombre, asignatura.tipo, SUM(asignatura.tipo) from asignatura
RIGHT JOIN grado
ON asignatura.id_grado = grado.id
GROUP BY grado.nombre;



/* 8. Returns a list showing how many students have enrolled in a subject in
each of the school courses. The result should show two columns, one column with
the year of the start of the school year and another with the number of students enrolled.   */

SELECT DISTINCT curso_escolar.anyo_inicio,  COUNT(alumno_se_matricula_asignatura.id_curso_escolar) FROM curso_escolar

LEFT JOIN alumno_se_matricula_asignatura
ON curso_escolar.id = alumno_se_matricula_asignatura.id_curso_escolar 

GROUP BY alumno_se_matricula_asignatura.id_alumno


/* 9. Return a list with the number of subjects taught by each teacher. The listing must
take into account those teachers who do not teach any subject. The result will show five columns:
id, first name, first last name, second last name and number of subjects. The result will be sorted
from highest to lowest by the number of subjects.   */


SELECT persona.id, persona.nombre, persona.apellido1, persona.apellido2, COUNT(asignatura.curso) AS cn FROM persona, asignatura
RIGHT JOIN profesor
ON asignatura.id_profesor = profesor.id_profesor
WHERE persona.id = profesor.id_profesor
GROUP BY persona.id
ORDER BY cn DESC;


/* 10. Returns all data from the youngest student.    */

SELECT * FROM persona
WHERE persona.fecha_nacimiento IN (SELECT MAX(persona.fecha_nacimiento) FROM persona)
AND persona.tipo = 'alumno';



/* 11. Returns a list of teachers who have an associate department and do not teach
no subject. */


SELECT persona.id, persona.nombre, persona.apellido1, persona.apellido2, persona.tipo FROM persona
WHERE persona.id IN (
SELECT profesor.id_profesor FROM profesor
LEFT JOIN departamento
ON profesor.id_departamento = departamento.id
WHERE profesor.id_profesor
IN (SELECT profesor.id_profesor from profesor
           LEFT JOIN asignatura
           ON profesor.id_profesor = asignatura.id_profesor
            WHERE asignatura.id_profesor IS NULL));










