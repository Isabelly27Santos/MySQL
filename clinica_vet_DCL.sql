-- POPULANDO TABELAS
use clinica_vet;
SET SQL_SAFE_UPDATES = 0;

-- ******************************************************************
-- CRIACAO DE USUÁRIOS
-- Criar o usuário 'usuario_leitura' com uma senha segura
	CREATE USER 'usuario_leitura'@'localhost' IDENTIFIED BY '123456';  
     
-- Criar o usuário 'usuario_leitura' com uma senha segura
	CREATE USER 'usuario_admin'@'localhost' IDENTIFIED BY '123456';
	
-- Criar o usuário 'usuario_leitura' com uma senha segura
	CREATE USER 'usuario_escrita'@'localhost' IDENTIFIED BY '123456';

-- ******************************************************************
-- CRIACAO DE ROLES
	CREATE ROLE leitura, criar, total;
    GRANT ALL PRIVILEGES ON *.* TO total;  -- dá acesso a todos os schemas e todas as tabelas
    GRANT SELECT ON clinica_vet.* TO leitura;
    GRANT INSERT,DELETE,CREATE,UPDATE ON clinica_vet.* TO criar;
    
	FLUSH PRIVILEGES;
    
    GRANT total TO 'usuario_admin'@'localhost';
    GRANT leitura TO 'usuario_leitura'@'localhost';
    GRANT criar TO 'usuario_leitura'@'localhost', 'usuario_escrita'@'localhost';  -- Dá acesso aos roles criados para o user
	FLUSH PRIVILEGES;

-- ******************************************************************
-- CONCESSÃO DE PRIVILÉGIOS
-- usuario_leitura
	-- Conceder privilégios de SELECT em todas as tabelas do esquema 'clinica_vet'
	GRANT SELECT ON clinica_vet.* TO 'usuario_leitura'@'localhost';
    
-- usuario_admin
-- Conceder privilégios completos ao banco de dados
	GRANT ALL PRIVILEGES ON *.* TO 'usuario_admin'@'localhost' WITH GRANT OPTION;   -- *(qualquer banco).*(qualquer tabela), WITH GRANT OPTION permite ele conceder permissões a outros usuários

-- usuario_leitura
-- Conceder privilégios de INSERT, SELECT e DELETE sobre todas as tabelas no esquema 'clinica_vet'
	GRANT INSERT, SELECT, DELETE ON clinica_vet.* TO 'usuario_escrita'@'localhost';

FLUSH PRIVILEGES;  -- atualiza para aplicar os privilégios ao BD

-- ******************************************************************
-- REVOGAR PRIVILEGIOS
-- REVOGAR PRIVILÉGIOS A USUARIO_ADMIN
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'usuario_admin'@'localhost';  -- retira todos os privilégios e não pode conceder mais permissões a outros users
DROP USER 'usuario_admin'@'localhost';  -- apaga user
-- REVOGAR PRIVILEGIO DELETE A USUARIO_ESCRITA
REVOKE DELETE ON clinica_vet.* FROM 'usuario_escrita'@'localhost';

-- ******************************************************************
-- LIMITAR RECURSOS DE USUÁRIOS
	ALTER USER 'usuario_leitura'@'localhost' WITH
		max_queries_per_hour 20       -- limita consultas por hora
        max_connections_per_hour 2    -- limita conexões ao BD por hora
        max_updates_per_hour 10       -- limita updates por hora
        max_user_connections 2;        -- limita conexões simultâneas ao BD

-- ******************************************************************
-- TESTE DE PRIVILÉGIOS PARA USUARIO_LEITURA
SELECT a.nome, a.peso, a.raca, r.nome, r.email FROM animal a
    JOIN tutor r ON (a.id_tutor = r.id);
DELETE FROM Animal;
UPDATE Animal SET nome = "Bolinho";

-- TESTE DE PRIVILÉGIOS PARA USUARIO_ADMIN
UPDATE Animal SET nome = "Bolinho";
SELECT * FROM Animal;
DELETE FROM Consulta;
DELETE FROM Animal;
INSERT INTO Animal (id_resp, nome, peso, raca, especie, cor, sexo, data_nasc) VALUES
(1, 'Frederico', 50.6, 'Pastor Alemão', 'Cachorro', 'Preto e Marrom', 'Macho', '2015-12-05');
    
CREATE TABLE Funcionario (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100)
);
INSERT INTO Funcionario(nome) VALUES ("Sergio"),("Renato"),("Fabiana"),("Marcia");
SELECT * FROM Funcionario;
DROP TABLE Funcionario;

-- TESTE DE PRIVILÉGIOS PARA USUARIO_ESCRITA
INSERT INTO Animal (id_resp, nome, peso, raca, especie, cor, sexo, data_nasc) VALUES
(1, 'Frederico', 50.6, 'Pastor Alemão', 'Cachorro', 'Preto e Marrom', 'Macho', '2015-12-05');

SELECT a.nome, a.peso, a.raca, r.nome, r.email FROM animal a
    JOIN responsavel r ON (a.id_resp = r.id);

SELECT * FROM Animal;
DELETE FROM Animal WHERE especie = "Gato";
