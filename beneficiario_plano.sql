CREATE SCHEMA atividade;
USE atividade;

CREATE TABLE plano (
	id INT PRIMARY KEY AUTO_INCREMENT,
	nome VARCHAR (30) NOT NULL,
	valor DECIMAL(7,2) NOT NULL
    );

CREATE TABLE beneficiario (
	id INT PRIMARY KEY AUTO_INCREMENT,
	nome VARCHAR (30) NOT NULL,
	sobrenome VARCHAR (30) NOT NULL,
	altura DECIMAL (4,2) NOT NULL,
    plano_fk INT,
    FOREIGN KEY (plano_fk) REFERENCES plano(id)
    );
    
CREATE TABLE dependente (
	id INT PRIMARY KEY AUTO_INCREMENT,
	nome VARCHAR (30) NOT NULL,
	sobrenome VARCHAR (30) NOT NULL,
    beneficiario_fk INT,
    FOREIGN KEY (beneficiario_fk) REFERENCES beneficiario(id)
    );
    
insert into plano (nome, valor) values
	('básico',99.9),
    ('clássico',149.9),
    ('premium',299.9);

insert into beneficiario (nome, sobrenome, altura, plano_fk) values
	('Maria', 'Souza', 1.6, 1),
	('Jonas', 'Alves', 1.93, 3),
	('Ana', 'Sampaio', 1.54, 2),
	('Estela', 'Lima', 1.8, 3),
	('Alice', 'Ruda', 1.76, 1);
    
insert into dependente (nome, sobrenome, beneficiario_fk) values
	('Maria', 'Souza', 1),
	('Jonas', 'Alves', 2),
	('Ana', 'Sampaio', 3),
	('Melissa', 'Souza', 1),
	('Soraia', 'Lima', 4);    

SELECT b.nome AS Beneficiário, b.sobrenome, d.nome AS Dependente, d.sobrenome, p.nome AS Plano
FROM beneficiario b
JOIN dependente d
    ON b.id = d.beneficiario_fk
JOIN plano p
    ON b.plano_fk = p.id;

SELECT b.nome AS 'Nome do Beneficiário'
FROM beneficiario b
JOIN dependente d ON (b.id = beneficiario_fk)
WHERE b.nome = d.nome;                           -- mostra os beneficiários que tem o mesmo nome que seu dependente

SELECT b.nome AS 'Nome do Beneficiário'
FROM beneficiario b
WHERE nome IN (
	SELECT nome
    FROM dependente d
	WHERE  b.nome = d.nome);
    
SELECT b.nome AS 'Nome do Beneficiário'
FROM beneficiario b
JOIN dependente d ON (b.id = beneficiario_fk)
WHERE EXISTS (
	SELECT nome FROM dependente WHERE b.nome = d.nome);
    
SELECT b.nome AS 'Nome do Beneficiário'
FROM beneficiario b
JOIN dependente d ON (b.id = beneficiario_fk)
WHERE b.altura = (SELECT MAX(altura) FROM beneficiario);    -- mostra o beneficiário com maior altura
    
SELECT p.nome, COUNT(*) AS quantidade
FROM plano p
JOIN beneficiario b
    ON p.id = b.plano_fk
WHERE b.altura > 1.60                -- mostra os planos que tem mais de um beneficiário com altura maior que 1.60
GROUP BY p.id, p.nome
	HAVING COUNT(*) > 1;
