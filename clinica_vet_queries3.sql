USE clinica_vet;
SET SQL_SAFE_UPDATES = 0;

-- ---------------------------------------------------------- CONSULTAS USANDO STRINGS ---------------------------------------------------------------

SELECT LPAD (id, 6, '0') AS Veterinário_id, nome, especialidade   -- LEFT PAD adiciona à esquerda de id, 6 dígitos de '0', RPAD adiciona à direita
FROM veterinario;

UPDATE veterinario 
SET email = REPLACE (email, '.com','.com.br')  -- Atualiza os emails que termina com .com para .com.br
	WHERE email LIKE '%.com'
    AND email NOT LIKE '%.com.br';  -- impede que o código altere pra .com.br.br 
SELECT * from veterinario;

SELECT CONCAT (id, ': ', nome, ' -> ', email) AS informações_veterinário   -- une colunas da tabelas, pode colocar textos no meio
FROM veterinario;

UPDATE veterinario
SET nome = REPLACE(REPLACE(nome,'Dra.', ''),'Dr', '');  -- tira o Dra. e Dr do nome
SELECT nome FROM veterinario;

SELECT id, nome, CHAR_LENGTH(nome) AS comprimento_nome  -- CHAR_LENGTH conta o número de caracteres
FROM tutor
	WHERE CHAR_LENGTH(nome) = (
    SELECT MAX(CHAR_LENGTH(nome))    -- mostra o nome de tutor com maior número de caracteres
    FROM tutor
    ); 
    
SELECT LPAD(c.id, 6, '0') as id, 
	CONCAT_WS('/', LPAD(DAY(dt),2,'0'), LPAD(MONTH(dt),2,'0'),YEAR(dt)) AS data_consulta, -- CONCAT_WS separa cada item com uma '/'
    DATE_FORMAT(c.horario, '%H:%ih') AS horario,   -- altera a visualização de hora para formato 00:00h
	v.nome AS veterinario,
    a.nome AS animal
FROM consulta c
	JOIN veterinario v ON c.id_vet = v.id
    JOIN animal a ON a.id = c.id_animal
ORDER BY dt;

UPDATE veterinario
SET nome = UPPER(nome);  -- coloca string em caixa alta
SELECT nome FROM veterinario;

UPDATE veterinario
SET nome = LOWER(nome);  -- coloca string em caixa baixa
SELECT nome FROM veterinario;

SELECT nome,
       UPPER(SUBSTRING(nome, 1, 1)) AS primeira_letra,  -- Seleciona a primeira letra do nome e coloca em maiúsculo
       LOWER(SUBSTRING(nome, 2)) AS restante,  -- seleciona a partir da 2º letra do nome e coloca em minusculo
       CONCAT(
           UPPER(SUBSTRING(nome, 1, 1)),
           LOWER(SUBSTRING(nome, 2))
       ) AS nome_corrigido
FROM tutor;

UPDATE tutor
SET nome = LOWER(nome);  

SELECT CONCAT(
    UPPER(SUBSTRING(nome, 1, 1)),
    LOWER(SUBSTRING(nome, 2, LOCATE(' ', nome) - 1)),  -- procura o espaço -1 do nome para deixar a primeira letra maiúscula e o resto minúscula
    UPPER(SUBSTRING(nome, LOCATE(' ', nome) + 1, 1)), -- procura o espaço +1 do nome para deixar a primeira letra maiúscula e o resto minúscula
    LOWER(SUBSTRING(nome, LOCATE(' ', nome) +2))
) AS nome
FROM tutor;

SELECT nome from tutor;

UPDATE tutor
SET nome = SUBSTRING(nome, 2);  -- salva em nome somente apartir do 2º caractere (apaga a primeira letra)

ALTER TABLE animal
ADD apelido VARCHAR(100);

UPDATE animal
SET apelido = LEFT(nome,3);  -- adiciona as 3 primeiras letras à esquerda de nome na coluna apelido
SELECT apelido FROM animal;

-- ---------------------------------------------------------- CONSULTAS USANDO DATA E HORA ---------------------------------------------------------------

SELECT * FROM consulta
WHERE dt = CURDATE()    -- Mostra as consultas do dia atual
AND horario BETWEEN '14:00:00' AND '17:00:00'   -- mostra só consultas entre 14h e 17h
ORDER BY horario;

SELECT * FROM consulta
WHERE dt BETWEEN curdate() AND DATE_ADD(curdate(),INTERVAL 6 DAY);  -- mostra consultas que estão nos próximos 6 dias a partir da data atual

SELECT c.id, c.dt, c.horario,v.nome AS Veterinário,a.nome AS animal  FROM consulta c
JOIN veterinario v
	ON c.id_vet = v.id
	JOIN animal a
    ON c.id_animal = a.id
	WHERE WEEK (c.dt, 1) = WEEK (CURDATE(), 1)  -- retorna o número da semana que está aquela data no ano, considerando que a semana começa pela segunda 1, se fosse começando no domingo seria 0
	AND DAYOFWEEK(c.dt) IN (2,3,6);  -- Filtra só as datas de segunda 2, terça 3 e sexta 6

SELECT * FROM consulta WHERE dt = '2025-06-09';

SELECT * FROM consulta
WHERE DATE_FORMAT(dt,'%Y-%m') = '2024-08'  -- busca consultas só do ano e mês 2024-08
AND DAY(dt) BETWEEN 1 AND 10; 

SELECT *, DATE_FORMAT(dt,'%m-%Y') AS 'Data' FROM consulta;  -- altera formatação da data
