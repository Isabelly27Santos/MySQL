use clinica_vet;

-- join usando where 
SELECT * FROM tutor, animal
WHERE tutor.id = animal.id_tutor;  -- une todos os dados relacionados por FK da tabela tutor e animal

SELECT t.nome, t.email, a.nome, a.raca 	
	FROM Tutor AS t, animal a	-- o AS é opcional
	WHERE t.id = a.id_tutor;

SELECT t.nome AS NomeTutor, t.email, a.nome AS NomeAnimal, a.raca 	-- o AS NomeTutor e AS NomeAnimal renomeia o nome que aparece na coluna da tabela, AS também opcional
	FROM Tutor t, animal a	
	WHERE t.id = a.id_tutor;
    
-- join
SELECT t.nome AS NomeTutor, t.email, a.nome AS NomeAnimal, a.raca, a.peso 
	FROM Tutor t   -- indica a tabela com a chave primária
    JOIN Animal a ON (t.id = a.id_tutor)   -- indica a tabela com chave estrangeira para uní-las
	WHERE peso > 10;   -- indica a condição separadamente

-- junçao de diversas tabelas
SELECT c.dt 'Data Consulta', c.horario, t.nome AS NomeTutor, t.fone, a.nome AS NomeAnimal, v.nome AS NomeVet, v.especialidade 	
	FROM Consulta c -- tabela que tem a chave primária e relaciona as demais tabelas
	JOIN Animal a ON (a.id = c.id_animal)
    JOIN Veterinario v ON (v.id = c.id_vet)
    JOIN Tutor t ON (t.id = a.id_tutor) 
    WHERE dt > '2024-09-01'
    ORDER BY c.dt DESC;
    
-- joins tipos
-- innner
SELECT t.nome, t.email, a.nome, a.raca 	
	FROM Tutor t    
	INNER JOIN Animal a ON (t.id = a.id_tutor);   -- mostra só os dados que possuem relacionamento fk e pk não nulos, o mesmo que fazer um join sem especificação
-- left
SELECT t.nome, t.email, a.nome, a.raca 	
	FROM Tutor t    
	LEFT JOIN Animal a ON (t.id = a.id_tutor);  -- mostra todos os dados da tabela indicada no FROM (até as NULL), e só as linhas de Animal que possuem relacionamento 
-- right
SELECT t.nome, t.email, a.nome, a.raca 	
	FROM Tutor t    
	RIGHT JOIN Animal a ON (t.id = a.id_tutor);  -- mostra todos os dados da tabela Animal (até as NULL),e só as linhas que tem relacionamento na tabela indicada no FROM 
-- CROSS    
SELECT t.nome, t.email, a.nome, a.raca 	
	FROM Tutor t    
	LEFT JOIN Animal a ON (t.id = a.id_tutor) 
UNION                                           -- o MySQL não suporta a forma CROSS JOIN, por isso unimos dois comandos com o UNION para mostrar todos os dados
SELECT t.nome, t.email, a.nome, a.raca 	        -- o uso do UNION elimina os resultados duplicados entre tabelas, UNION ALL mostra todas com as repetições
	FROM Tutor t    
	RIGHT JOIN Animal a ON (t.id = a.id_tutor);
	
    
-- função de agregação
-- MAX
SELECT MAX(peso) FROM Animal;  -- retorna o maior peso da tabela animal
SELECT raca, peso FROM Animal WHERE peso = (SELECT MAX(peso) FROM Animal);  -- mostra a raça do animal com o maior peso
-- MIN
SELECT MIN(peso) FROM Animal;
SELECT raca, peso FROM Animal WHERE peso = (SELECT MIN(peso) FROM Animal);
-- SUM  
SELECT SUM(peso) FROM Animal;    -- retorna a soma de todos os pesos
-- AVG
SELECT AVG(peso) FROM Animal WHERE raca = 'Poodle';    -- retorna a média da soma de todos os pesos

SELECT * FROM animal WHERE peso > (SELECT AVG(peso) FROM animal);   -- mostra os animais que possuem peso acima da média



-- GROUP BY - COUNT
SELECT raca, COUNT(raca) AS Contagem    -- conta quantas vezes os valores se repetem por raça
FROM Animal GROUP BY raca 
ORDER BY Contagem DESC, raca ASC;

-- HAVING
SELECT raca, COUNT(raca) AS Contagem  
	FROM Animal WHERE peso > 10      --  o WHERE filtra os dados antes de agrupar
	GROUP BY raca 
	HAVING raca != 'Poodle'          -- o HAVING filtra os dados só depois de agrupar
    ORDER BY raca;
