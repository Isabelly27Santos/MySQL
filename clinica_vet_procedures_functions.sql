use clinica_vet;
SET SQL_SAFE_UPDATES = 0;

-- PROCEDIMENTOS: FUNCTIONS

DROP FUNCTION IF EXISTS calculaIdadeAnimal;
DELIMITER //  -- padrão em funções no MySQL para trocar o delimitador para // e não bugar o código
CREATE FUNCTION calculaIdadeAnimal (data_nascimento DATE)    -- Cria uma função que recebe um parâmetro e retorna um valor
RETURNS INT 
DETERMINISTIC -- precisa definir se a função é DETERMINISTIC ou NOT DETERMINISTIC
COMMENT 'Retorna a idade em anos de um animal, calculando a diferença entre a data de nascimento e data atual)'
BEGIN 
	-- Declaração de variável
    DECLARE idade int;
    SET idade = TIMESTAMPDIFF(YEAR, data_nascimento,CURDATE());  -- calcula a diferença em anos de data_nascimento e data atual
    RETURN idade; -- retorna a idade
END //
DELIMITER ; -- retorna o delimitador para ; novamente

SELECT calculaIdadeAnimal ('2023-05-13');  -- chama a função criada

SELECT nome, raca, peso, calculaIdadeAnimal(data_nasc) AS Idade  -- Usando funções dentro do SELECT
FROM animal ORDER BY idade DESC; 


DELIMITER //
DROP FUNCTION IF EXISTS animalTemConsultaRecenteNMeses;
CREATE FUNCTION animalTemConsultaRecenteNMeses (p_idAnimal INT, p_meses INT)
RETURNS BOOLEAN
DETERMINISTIC
COMMENT 'Retorna TRUE se o animal teve consulta nos últimos N meses'
BEGIN
	DECLARE existe_consulta BOOLEAN;
    SELECT EXISTS (
		SELECT 1 FROM consulta
        WHERE id = p_idAnimal
        AND dt >= DATE_SUB(CURDATE(), INTERVAL p_meses MONTH)  
	)
INTO existe_consulta;  -- registra o resultado da subconsulta no booleano existe_consulta
RETURN existe_consulta;
END //
DELIMITER ;

SELECT id, nome,
    CASE 
        WHEN animalTemConsultaRecenteNMeses(id, 6) = 1 THEN 'Sim'
        WHEN animalTemConsultaRecenteNMeses(id, 6) = 0 THEN 'Não'
    END AS 'Consultou até 6 meses'
FROM animal;

DROP FUNCTION IF EXISTS insereTutor;
DELIMITER //
CREATE FUNCTION insereTutor(
	p_nome VARCHAR(100),
	p_cpf VARCHAR(15),
    p_email VARCHAR(100),
    p_fone VARCHAR(30)
)
RETURNS INT
DETERMINISTIC
COMMENT 'Insere um novo tutor e retorna o id gerado'
BEGIN
	DECLARE p_idGerado INT;
	INSERT INTO Tutor (nome,cpf, email, fone) 
		VALUES (p_nome,p_cpf, p_email, p_fone); 
        SET p_idGerado = LAST_INSERT_ID();
        RETURN p_idGerado;
END //
DELIMITER ;

SELECT insereTutor('Roberto Carlos Souza', '083952147895', 'robertocarlos@gmail.com','11998844658');

-- PROCEDIMENTOS: PROCEDURES
DROP PROCEDURE IF EXISTS estatisticas_clinica;
DELIMITER //
CREATE PROCEDURE estatisticas_clinica()  -- poderia receber parâmetros
COMMENT 'Mostra os totais de tutores, animais, veterinários e consultas'
BEGIN
	SELECT   -- retorna o último select por padrão
		(SELECT COUNT(*) FROM tutor) AS total_tutores,
        (SELECT COUNT(*) FROM animal) AS total_animais,
		(SELECT COUNT(*) FROM veterinario) AS total_veterinários,
        (SELECT COUNT(*) FROM consulta) AS total_consultas;
END //
DELIMITER ;

CALL estatisticas_clinica();

DROP PROCEDURE IF EXISTS agendarConsulta;
DELIMITER //
CREATE PROCEDURE agendarConsulta(
	IN p_idVet INT,
    IN p_idAnimal INT,
    IN p_data DATE,
    IN p_horario TIME
)  
COMMENT 'Agenda uma nova consulta e previne conflitos para o mesmo horário'
BEGIN
	IF EXISTS (
		SELECT 1 FROM consulta
        WHERE id_animal = p_idAnimal
        AND dt = p_data
        AND horario = p_horario
        )
        THEN -- Se o resultado de if exists for verdadeiro faça:
        SIGNAL SQLSTATE '45000'  -- padrão de erro
			SET MESSAGE_TEXT = 'Já existe uma consulta agendada para esse animal no mesmo horário';  -- retorna uma mensagem no output
		ELSE
			INSERT INTO Consulta(id_vet, id_animal, dt, horario)
				VALUES (p_idVET, p_idAnimal, p_data, p_horario);
				SELECT CONCAT('Consulta agendada para id ',p_idAnimal, ' na data ', p_data, ' às ',p_horario) AS mensagem;
		END IF; 
END //
DELIMITER ;

CALL agendarConsulta (2,7,'2026-08-13','15:30:00');
CALL agendarConsulta (3,2,'2026-09-18','10:20:00');
CALL agendarConsulta (3,2,'2026-09-18','10:20:00'); -- retorna erro

-- DETERMINISTIC: Significa que a função sempre retornará o mesmo valor, dado os mesmos argumentos e o mesmo estado do BD. 

