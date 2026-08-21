USE clinica_vet;

-- subconsulta não correlacionada (query interna executada só uma vez - permite criar uma tabela só com a query interna)
SELECT nome, raca, peso
FROM animal
WHERE peso >(
	SELECT AVG(peso)  -- seleciona animais que possuem peso acima da média
    FROM animal
);

-- subconsulta correlacionada (cria o laço de repetição em que a consulta interna repete várias vezes com as informações da query externa) Subconsulta de tabela
SELECT t.nome
FROM tutor t
WHERE EXISTS (SELECT 1   -- 1 é numero padrão do comando para validar se existe relação entre tabelas (se mudar o número não muda o resultado)
	FROM animal a   -- retorna os nomes de tutores que possuem relacionamento com animal
    WHERE a.id_tutor = t.id
);

SELECT v.nome, resumo.qtd_consultas
FROM (
	SELECT id_vet, COUNT(*) AS qtd_consultas   -- soma a quantidade de consultas que cada veterinário atende
    FROM consulta
    GROUP BY id_vet
    ) AS resumo  -- cria uma tabela temporária chamada resumo para salvar o resultado da subconsulta
	JOIN veterinario v ON v.id = resumo.id_vet
	WHERE resumo.qtd_consultas >5     -- Mostra o nome do veterinário e quantidade de consultas, para os que tem mais de 5 consultas agendadas
	ORDER BY resumo.qtd_consultas DESC;

-- Subconsulta escalar (retorna uma linha e uma coluna - valor único)
SELECT nome
FROM animal
WHERE peso = (
	SELECT MAX(peso) FROM animal
);

-- Subconsulta de Linha (retorna uma linha com várias colunas)
SELECT nome, crmv, especialidade, fone, email
FROM veterinario
WHERE (id,crmv) = (	
	SELECT id, crmv
    FROM veterinario
    ORDER BY id ASC
    LIMIT 1
);

-- Subconsulta de Coluna (retorna uma coluna com várias linhas)
SELECT a.nome
FROM animal a
WHERE a.id_tutor IN (
	SELECT te.id_tutor
	FROM tutor_endereco te
    WHERE te.cidade = 'Salvador'   -- subquerie que retorna o animal que possui um tutor que mora em Salvador
);

SELECT nome, peso
FROM animal
WHERE peso > ALL(
	SELECT peso
	FROM animal
    WHERE raca = 'Poodle');   -- retorna o nome e peso de todos os animais que possuem um peso maior que todos os animais da raça poodle

SELECT nome
FROM veterinario
WHERE id = ANY(
	SELECT id_vet
    FROM consulta
    WHERE dt < '2025-07-07');  -- retorna o nome dos veterinarios que tiveram ao menos uma consulta anterior a data 2025-07-07  (similar ao EXISTS)
