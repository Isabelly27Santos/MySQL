-- EXERCÍCIOS COM TRIGGERS

USE clinica_vet;
SET SQL_SAFE_UPDATES = 0;

-- TRIGGER AFTER INSERT
-- Registra automaticamente em uma tabela de auditoria todas as novas consultas realizadas na clínica.

CREATE TABLE IF NOT EXISTS consulta_auditoria (
	data_hora DATETIME,
    usuario VARCHAR(100),
    alteracao VARCHAR(500)
    );
    
DROP TRIGGER IF EXISTS trg_consulta_apos_insercao;
DELIMITER //
CREATE TRIGGER trg_consulta_apos_insercao
AFTER INSERT ON consulta  -- aplica a trigger a cada nova consulta inserida
FOR EACH ROW
BEGIN 
	INSERT INTO consulta_auditoria (data_hora, usuario, alteracao)
		VALUES(
        NOW(),
        USER(), -- retorna o nome de usuário atual
        CONCAT(
			'Nova consulta inserida. ID: ', NEW.id, 
            ', ID Animal: ', NEW.id_animal,
            ', ID Veterinário: ', NEW.id_vet,
            ', Data: ', NEW.dt,
            ', Horário: ', NEW.horario
            )
		);
END //
DELIMITER ;

INSERT INTO consulta (id_vet, id_animal, dt, horario) VALUES (1,1,'2024-10-03','15:00:00');
SELECT * FROM consulta_auditoria;



-- TRIGGER AFTER DELETE
-- Registra automaticamente em uma tabela de auditoria todas os animais excluídos.
    
DROP TRIGGER IF EXISTS trg_animal_apos_exclusao;
DELIMITER //
CREATE TRIGGER trg_animal_apos_exclusao
AFTER DELETE ON animal 
FOR EACH ROW
BEGIN 
	INSERT INTO auditoria (data_hora, usuario, alteracao)
		VALUES(
        NOW(),
        USER(), -- retorna o nome de usuário atual
        CONCAT(
			'Novo animal excluído. ID: ', OLD.id, 
            ', Nome: ', OLD.nome,
            ', Raça: ', OLD.raca,
            ', ID tutor: ', IFNULL (OLD.id_tutor, 'Sem tutor')  -- Coloca sem tutor se id_tutor é null
            )
		);
END //
DELIMITER ;

INSERT INTO animal (id_tutor, nome, peso, raca, especie, cor, sexo, data_nasc) VALUES (1,'TesteExclusão', 5.0,'SRD', 'Cachorro', 'Preto', 'MACHO', '2020-01-01');
SELECT id FROM animal WHERE nome = 'TesteExclusão';
DELETE FROM animal WHERE nome = 'TesteExclusão';
SELECT * FROM auditoria;


-- TRIGGER BEFORE INSERT
-- Corrige automaticamente o nome dos animais para iniciar com letra maiúscula.

DROP TRIGGER IF EXISTS trg_animal_antes_insercao;
DELIMITER //
CREATE TRIGGER trg_animal_antes_insercao
BEFORE INSERT ON animal 
FOR EACH ROW
BEGIN 
	SET NEW.nome = CONCAT(UPPER(SUBSTRING(NEW.nome, 1,1)),LOWER(SUBSTRING(NEW.nome, 2)));
END //
DELIMITER ;

INSERT INTO animal (id_tutor, nome, peso, raca, especie, cor, sexo, data_nasc) VALUES (2,'bElinha', 3.5,'Pinscher', 'Cachorro', 'Preto', 'FEMEA', '2021-05-10');
SELECT nome FROM animal WHERE nome LIKE 'b%';


-- TRIGGER BEFORE UPDATE
-- Impede que o campo crmv de um veterinário seja alterado após inserção.

DROP TRIGGER IF EXISTS trg_vet_antes_update_crmv;
DELIMITER //
CREATE TRIGGER trg_vet_antes_update_crmv
BEFORE UPDATE ON veterinario 
FOR EACH ROW
BEGIN 
	IF OLD.crmv <> NEW.crmv THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'O campo crmv não pode ser alterado após o cadastro.';
    END IF;
END //
DELIMITER ;

UPDATE veterinario SET crmv = 'crmv-99999' WHERE id = 1;



-- TRIGGER BEFORE INSERT
-- Impede que um veterinário seja agendado para mais de uma consulta no mesmo dia.

DROP TRIGGER IF EXISTS trg_consulta_antes_insercao_agenda;
DELIMITER //
CREATE TRIGGER trg_consulta_antes_insercao_agenda
BEFORE INSERT ON consulta 
FOR EACH ROW
BEGIN 
	DECLARE qtd INT;
    
    SELECT COUNT(*) INTO qtd
    FROM consulta
    WHERE id_vet = NEW.id_vet AND dt = NEW.dt AND horario = NEW.horario; 
    
    IF qtd > 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Horário de consulta já ocupado para este veterinário';
    END IF;
END //
DELIMITER ;

INSERT INTO consulta (id_vet, id_animal, dt, horario) VALUES (3,4, '2026-05-10','14:00:00');

-- TRIGGER BEFORE INSERT
-- Registra automaticamente em uma tabela de auditoria todos os endereços de veterinário após atualização.

CREATE TABLE IF NOT EXISTS auditoria (
	data_hora DATETIME,
    usuario VARCHAR(100),
    alteracao VARCHAR(500)
    );

DROP TRIGGER IF EXISTS trg_endereco_vet_apos_atualizacao;
DELIMITER //
CREATE TRIGGER trg_endereco_vet_apos_atualizacao
AFTER UPDATE ON veterinario_endereco 
FOR EACH ROW
BEGIN 
	DECLARE msg VARCHAR(500);
    SET msg = CONCAT('Endereço atualizado para veterinário ID: ', OLD.id_vet);
    IF OLD.rua <> NEW.rua THEN
		SET msg = CONCAT(msg,' Rua: ',OLD.rua, '-> ',NEW.rua);
	END IF;
	IF OLD.numero <> NEW.numero THEN
		SET msg = CONCAT(msg,' Número: ',OLD.numero, '-> ',NEW.numero);    
	END IF;
	IF OLD.cidade <> NEW.cidade THEN
		SET msg = CONCAT(msg,' Cidade: ',OLD.cidade, '-> ',NEW.cidade);
	END IF;
    INSERT INTO auditoria (data_hora, usuario, alteracao)
	VALUES (NOW(), USER(), msg);
END //
DELIMITER ;

SELECT * FROM auditoria;
UPDATE veterinario_endereco SET rua = 'Rua Nova', numero = 123, cidade = 'Cidade Nova' WHERE id = 2; 

