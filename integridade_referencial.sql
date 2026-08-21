-- **********************************************
-- EXEMPLO COM UMA RESTRIÇÃO DE CHAVE ESTRANGEIRA
-- Exemplo de SQL para criar as tabelas com ON UPDATE CASCADE e ON DELETE CASCADE:

SET FOREIGN_KEY_CHECKS = 0; -- desativa validação de associações de chaves estrangeiras pra atualizar/deletar

-- CRIAÇÃO DE ESQUEMA E TABELAS
CREATE SCHEMA restricoes;
USE restricoes;

-- Criação das tabelas
CREATE TABLE Clientes (
    ID_Cliente INT PRIMARY KEY,
    Nome VARCHAR(100),
    Endereco VARCHAR(100)
);

-- DROP TABLE Pedidos;
CREATE TABLE Pedidos (
    ID_Pedido INT PRIMARY KEY,
    ID_Cliente INT,
    DataPedido DATE,
    Total DECIMAL(10, 2),
    FOREIGN KEY (ID_Cliente) REFERENCES Clientes(ID_Cliente)
    ON UPDATE SET NULL   -- Se o ID do cliente for alterado, o ID nos pedidos relacionados vira NULL
    ON DELETE SET NULL   -- Se o cliente for excluído, o ID nos pedidos relacionados vira NULL
);

-- Demonstração do Comportamento:
-- Inserindo Dados:
SELECT * FROM Clientes;
INSERT INTO Clientes (ID_Cliente, Nome, Endereco) 
	VALUES 	(1, 'João Silva', 'Rua Exemplo, 123'),
			(2, 'Mauro Carvalho', 'Rua Exemplo, 456');
            
INSERT INTO Pedidos (ID_Pedido, ID_Cliente, DataPedido, Total) 
	VALUES 	(101, 1, '2022-01-01', 100.00),
			(102, 2, '2022-01-01', 100.00);
SELECT * FROM Pedidos;

SELECT * 
	FROM Clientes C JOIN Pedidos P ON P.ID_Cliente = C.ID_Cliente;
	
-- Testando ON UPDATE CASCADE:
UPDATE Clientes SET ID_Cliente = 3 WHERE ID_Cliente = 1;
SELECT * FROM Pedidos;

-- Testado ON DELETE CASCADE:
DELETE FROM Clientes WHERE ID_Cliente = 2;
SELECT * FROM Pedidos;


-- DROP SCHEMA restricoes;
CREATE SCHEMA restricoes;
use restricoes;
-- ***********************************************
-- EXEMPLO COM DUAS RESTRIÇÃO DE CHAVE ESTRANGEIRA
-- Criando tabelas
CREATE TABLE Professores (
    ID_Professor INT PRIMARY KEY,
    Nome VARCHAR(100)
);

CREATE TABLE Cursos (
    ID_Curso INT PRIMARY KEY,
    Nome VARCHAR(100)
);

CREATE TABLE ProfessoresCursos (
    ID_Professor INT,
    ID_Curso INT,
    FOREIGN KEY (ID_Professor) REFERENCES Professores(ID_Professor) ON UPDATE CASCADE ON DELETE CASCADE,   -- se alterar/ excluir a tabela com chave pk, a tabela com chave fk altera também
    FOREIGN KEY (ID_Curso) REFERENCES Cursos(ID_Curso) ON DELETE RESTRICT ON UPDATE RESTRICT,  -- impede de apagar/atualizar se tiver tabelas associadas
    PRIMARY KEY (ID_Professor, ID_Curso)
);

SHOW CREATE TABLE ProfessoresCursos; -- mostra regras de integridade referencial

-- Inserindo dados na tabela Professores
INSERT INTO Professores (ID_Professor, Nome) VALUES (1, 'Prof. Alice');
INSERT INTO Professores (ID_Professor, Nome) VALUES (2, 'Prof. Bob');
SELECT * FROM Professores;

-- Inserindo dados na tabela Cursos
INSERT INTO Cursos (ID_Curso, Nome) VALUES (101, 'Matemática'),(102, 'Física');
SELECT * FROM Cursos;

-- Associando professores aos cursos
INSERT INTO ProfessoresCursos (ID_Professor, ID_Curso) VALUES (1, 101),(1, 102),(2, 101); -- Prof. Bob também ensina Matemática

SELECT * 
	FROM ProfessoresCursos PC 
		JOIN Cursos C ON PC.ID_Curso = C.ID_Curso
		JOIN Professores P ON P.ID_Professor = PC.Id_Professor;

-- ON UPDATE CASCADE: Atualização na Tabela Professores:
UPDATE Professores SET ID_Professor = 10 WHERE ID_Professor = 1;

-- ON DELETE CASCADE: Exclusão na Tabela Cursos:
DELETE FROM Cursos WHERE ID_Curso = 101;

SET FOREIGN_KEY_CHECKS = 1;  -- reativa verificação de chave estrangeira
