-- Consultas SQL
use clinica_vet;
SET SQL_SAFE_UPDATES = 0;
DESCRIBE consulta;      -- Mostra a estrutura da tabela consulta do BD

-- *** DQL - DATA QUERY LANGUAGE 
-- select simples
SELECT * FROM Animal;
SELECT * FROM Tutor;
 
-- seleção
SELECT * FROM Animal WHERE raca != 'pincher' AND data_nasc > '2020-01-01' AND peso >10;   -- cria um filtro para mostrar animais. O símbolo diferente pode ser != ou <>

-- projeção
SELECT nome, raca, peso FROM Animal;

-- like
SELECT * FROM Animal WHERE nome LIKE 'b%';       -- filtra os nomes que começam com ‘b’
SELECT * FROM Animal WHERE nome LIKE '%bb%';     --  filtra nomes que possui o texto ‘bo’ em qualquer parte da palavra.	
SELECT * FROM Animal WHERE nome LIKE '_a%';      -- mostra só nomes com ‘a’ no meio da palavra

-- distinct
SELECT DISTINCT raca FROM Animal;  -- apresenta todas as raças sem repetição delas

-- order by
SELECT nome, raca, peso FROM Animal ORDER BY raca, peso;  -- organiza os dados por raça e depois pelo peso, em ordem alfabética crescente (mesmo sem colocar ASC)
SELECT nome, raca, peso FROM Animal WHERE raca = 'Poodle' ORDER BY raca, peso DESC;
SELECT nome, cpf FROM Tutor ORDER BY nome;

-- limit
SELECT * FROM Veterinario LIMIT 0,3 ;   -- mostra as 3 primeiras tuplas da tabela
SELECT * FROM Veterinario LIMIT 5,3 ;   -- pula os 5 primeiros e mostra os próximos 3
SELECT especialidade, nome FROM Veterinario ORDER BY nome LIMIT 3,6 ;   -- exibe primeiro resultado do nome em ordem decrescente (forma de conseguir o último valor da lista alfabética)


    
