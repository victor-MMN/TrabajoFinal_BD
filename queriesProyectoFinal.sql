-- Seleccionamos base de datos
USE mentalhealth ;


-- Vemos las tablas
SELECT * FROM answer ;  
SELECT * FROM question ;
SELECT * FROM survey ; 
DESCRIBE answer ;
DESCRIBE question ;
DESCRIBE survey ;
SELECT COUNT(*) FROM answer ; -- 236,898 registros
SELECT COUNT(*) FROM question ; -- 105 registros
SELECT COUNT(*) FROM survey ;  -- 5 registros


-- Hacemos un punto de guardado antes de modificar las tablas
SET AUTOCOMMIT = OFF ; -- Desactivamos el guardado automático
COMMIT ; -- Hacemos commit para guardar los cambios pasados, cada vez
		 -- que se quiera guardar cambios se corre esta línea

-- Cambiamos nombres de algunos campos para que el estilo de los nombres
-- de las tablas sea homogéneo
ALTER TABLE question
CHANGE questiontext QuestionText VARCHAR(224) ;
ALTER TABLE question
CHANGE questionid QuestionID VARCHAR(224) ;

-- Creamos un campo como PRIMARY KEY para la tabla answer
ALTER TABLE answer
ADD Idx INT AUTO_INCREMENT PRIMARY KEY FIRST ; 

-- Seleccionamos campos como PRIMARY KEY de las tablas survey y question
ALTER TABLE survey
ADD PRIMARY KEY (SurveyID) ;
ALTER TABLE question
ADD PRIMARY KEY (questionID) ;

-- Relacionamos las tablas con FOREIGN KEY's
ALTER TABLE answer
ADD FOREIGN KEY (SurveyID) 
REFERENCES survey(SurveyID) ;

ALTER TABLE answer
ADD FOREIGN KEY (QuestionID) 
REFERENCES question(QuestionID) ;


-- Terminamos de modificar las tablas

-- Datos interesantes que encontré

-- Número de personas encuestadas cada año
SELECT SurveyID AS "Año de la encuesta", 
	   COUNT(DISTINCT(UserID)) AS "Personas encuestadas" 
FROM answer 
GROUP BY surveyid ;

-- Persona más joven y más vieja encuestada
SELECT MIN(AnswerText) AS "Edad del más joven", 
	   MAX(AnswerText) AS "Edad del más grande"
FROM answer 
WHERE (QuestionID = 1 AND AnswerText > 0);


-- Cantidad de personas entrevistadas por país
SELECT AnswerText AS "Paises", 
       COUNT(AnswerText)  AS "Número de personas entrevistadas"
FROM answer 
WHERE QuestionID = 3 
GROUP BY AnswerText 
ORDER BY COUNT(AnswerText) DESC ;

-- Respuesta a pregunta, has buscado tratamiento para un trastorno de la salud mental con un profesional?
SELECT AnswerText AS "Respuestas",
	   COUNT(AnswerText)  AS "Número de respuestas" 
FROM answer 
WHERE QuestionID = 7  
GROUP BY AnswerText 
ORDER BY COUNT(AnswerText) DESC ;

-- Cantidad de personas que se sienten cómodas discutiendo de salud mental con
-- compañeros y supervisores en cada encuesta

SELECT SurveyID AS "Año de la encuesta",
	   AnswerText AS "¿con compañeros?",
	   COUNT(AnswerText) AS "Número de respuestas"
FROM answer 
WHERE QuestionID = 18 AND AnswerText = "Yes"
GROUP BY SurveyID
ORDER BY AnswerText ASC ;

SELECT SurveyID AS "Año de la encuesta",
	   AnswerText AS "¿con un supervisor?",
	   COUNT(AnswerText) AS "Número de respuestas"
FROM answer 
WHERE QuestionID = 19 AND AnswerText = "Yes"
GROUP BY SurveyID
ORDER BY AnswerText ASC ;

-- Creamos vista con las respuestas a las preguntas 
-- ¿Padeces actualmente algún trastorno de la salud mental? 
-- Por cada encuesta
CREATE VIEW personasConTrastornosMentales AS
SELECT SurveyID AS "Año de la encuesta",
	   AnswerText AS "¿Padeces actualmente algún trastorno de la salud mental?" ,
	   COUNT(AnswerText) AS "Número de Personas"
FROM answer
WHERE QuestionID = 33 
GROUP BY SurveyID, AnswerText
ORDER BY SurveyID ASC ;

SELECT * FROM personasConTrastornosMentales ; 

COMMIT ; -- Guardamos todos los cambios
