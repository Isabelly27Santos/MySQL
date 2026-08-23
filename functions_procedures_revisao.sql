/*
============================================================
1. BANCO DE DADOS E TABELAS
============================================================
*/

CREATE DATABASE IF NOT EXISTS populacao;
USE populacao;
SET SQL_SAFE_UPDATES = 0;

DROP TABLE IF EXISTS estado_populacao;
CREATE TABLE IF NOT EXISTS estado_populacao (
    estado VARCHAR(100),
    populacao INT
);

INSERT INTO estado_populacao VALUES ('New York', 19299981);
INSERT INTO estado_populacao VALUES ('Texas', 29730311);
INSERT INTO estado_populacao VALUES ('California', 39613493);
INSERT INTO estado_populacao VALUES ('Florida', 21944577);
INSERT INTO estado_populacao VALUES ('New Jersey', 9267130);
INSERT INTO estado_populacao VALUES ('Massachusetts', 6893000);
INSERT INTO estado_populacao VALUES ('Rhode Island', 1097379);

DROP TABLE IF EXISTS condado_populacao;
CREATE TABLE condado_populacao (
    estado VARCHAR(50),
    condado VARCHAR(100),
    populacao INT
);

INSERT INTO condado_populacao VALUES
('New York', 'Kings', 2736074),
('New York', 'Queens', 2405464),
('New York', 'New York County', 1694251),
('New Jersey', 'Bergen', 955732),
('New Jersey', 'Middlesex', 863162);

/*
============================================================
2. FUNCTION
============================================================
*/

DROP FUNCTION IF EXISTS f_get_estado_populacao;
DELIMITER //
CREATE FUNCTION f_get_estado_populacao(
    estado_param VARCHAR(100)
)
RETURNS INT
DETERMINISTIC
READS SQL DATA -- Indica que a função pode consultar dados com SELECT, mas não deve modificar os dados.
BEGIN
    DECLARE populacao_var INT;
    SELECT populacao
    INTO populacao_var
    FROM estado_populacao
    WHERE estado = estado_param;  -- Recebe o nome do estado e retorna o número da sua população
    RETURN populacao_var;
END //
DELIMITER ;

SELECT f_get_estado_populacao('New York');

SELECT *
FROM estado_populacao
WHERE populacao > f_get_estado_populacao('New York');

/*
============================================================
3. FUNCTION SIMPLES
============================================================
*/

DROP FUNCTION IF EXISTS f_get_mundo_populacao;
DELIMITER //
CREATE FUNCTION f_get_mundo_populacao()
RETURNS BIGINT
DETERMINISTIC
NO SQL
BEGIN
    RETURN 7978759141;
END //
DELIMITER ;

SELECT f_get_mundo_populacao();

/*
============================================================
5. PROCEDURE
============================================================
*/

DROP PROCEDURE IF EXISTS p_set_estado_populacao;
DELIMITER //
CREATE PROCEDURE p_set_estado_populacao(
    IN estado_param VARCHAR(100)
)
BEGIN
    DELETE FROM estado_populacao
    WHERE estado = estado_param;
    INSERT INTO estado_populacao (estado,populacao)
    SELECT
        estado,
        SUM(populacao)
    FROM condado_populacao
    WHERE estado = estado_param
    GROUP BY estado;

END //
DELIMITER ;

CALL p_set_estado_populacao('New York');

/*
============================================================
5. VARIÁVEIS LOCAIS
============================================================
DECLARE: Declara uma variável local dentro de uma FUNCTION, PROCEDURE ou bloco BEGIN/END.
@variavel: É uma variável de usuário da sessão. Ela é diferente de uma variável local DECLARE.
*/

DROP PROCEDURE IF EXISTS p_set_and_show_estado_populacao;
DELIMITER //
CREATE PROCEDURE p_set_and_show_estado_populacao(
    IN estado_param VARCHAR(100)
)
BEGIN
    DECLARE populacao_var INT;
    SELECT SUM(populacao)
    INTO populacao_var
    FROM condado_populacao
    WHERE estado = estado_param;  -- Soma a população dos condados que estão no estado recebido pelo parâmetro
    SELECT CONCAT(
        'População de ',
        estado_param,
        ': ',
        populacao_var
    ) AS resultado;
END //
DELIMITER ;

CALL p_set_and_show_estado_populacao('New York');


/*
============================================================
6. IF / ELSE
============================================================
*/

DROP PROCEDURE IF EXISTS p_compare_populacao;
DELIMITER //
CREATE PROCEDURE p_compare_populacao(
    IN estado_param VARCHAR(100)
)
BEGIN
    DECLARE v_pop_estado INT;
    DECLARE v_pop_condados INT;
    SELECT populacao
    INTO v_pop_estado
    FROM estado_populacao
    WHERE estado = estado_param;
    SELECT SUM(populacao)
    INTO v_pop_condados
    FROM condado_populacao
    WHERE estado = estado_param;
    IF v_pop_estado = v_pop_condados THEN
        SELECT 'As populações são iguais.' AS mensagem;
    ELSE
        SELECT 'As populações são diferentes.' AS mensagem;
    END IF;
END //
DELIMITER ;

CALL p_compare_populacao('New York');

/*
============================================================
7. CASE
============================================================
*/

DROP PROCEDURE IF EXISTS p_populacao_grupo;
DELIMITER //
CREATE PROCEDURE p_populacao_grupo(
    IN estado_param VARCHAR(100)
)
BEGIN
    DECLARE v_populacao INT;
    SELECT populacao
    INTO v_populacao
    FROM estado_populacao
    WHERE estado = estado_param;
    CASE
        WHEN v_populacao > 30000000 THEN
            SELECT 'População acima de 30 milhões' AS grupo;
        WHEN v_populacao > 10000000 THEN
            SELECT 'População entre 10 e 30 milhões' AS grupo;
        ELSE
            SELECT 'População abaixo de 10 milhões' AS grupo;
    END CASE;
END //
DELIMITER ;

CALL p_populacao_grupo('California');
CALL p_populacao_grupo('New York');
CALL p_populacao_grupo('Rhode Island');


/*
============================================================
8. LOOP
============================================================
*/

DROP PROCEDURE IF EXISTS p_loop;
DELIMITER //
CREATE PROCEDURE p_loop()
BEGIN
    DECLARE v_contador INT DEFAULT 1;
    meu_loop: LOOP
        SELECT v_contador AS contador;
        IF v_contador >= 10 THEN
            LEAVE meu_loop;
        END IF;
        SET v_contador = v_contador + 1;
    END LOOP meu_loop;
END //
DELIMITER ;

CALL p_loop();


/*
============================================================
9. REPEAT
============================================================
*/

DROP PROCEDURE IF EXISTS p_repeat;
DELIMITER //
CREATE PROCEDURE p_repeat()
BEGIN
    DECLARE v_contador INT DEFAULT 1;
    REPEAT
        SELECT v_contador AS contador;
        SET v_contador = v_contador + 1;
    UNTIL v_contador > 10
    END REPEAT;
END //
DELIMITER ;

CALL p_repeat();

/*
============================================================
10. WHILE
============================================================
*/

DROP PROCEDURE IF EXISTS p_while;
DELIMITER //
CREATE PROCEDURE p_while()
BEGIN
    DECLARE v_contador INT DEFAULT 1;
    WHILE v_contador <= 10 DO
        SELECT v_contador AS contador;
        SET v_contador = v_contador + 1;
    END WHILE;
END //
DELIMITER ;

CALL p_while();

/*
============================================================
11. SELECT DENTRO DE PROCEDURE
============================================================
*/

DROP PROCEDURE IF EXISTS p_get_condado_populacao;
DELIMITER //
CREATE PROCEDURE p_get_condado_populacao(
    IN estado_param VARCHAR(100)
)
BEGIN
    SELECT condado,
        FORMAT(populacao, 0) AS populacao  -- (separa o número por vírgulas nas casas e deixa 0 casas decimais)
    FROM condado_populacao
    WHERE estado = estado_param
    ORDER BY populacao DESC;
END //
DELIMITER ;

CALL p_get_condado_populacao('New York');

/*
============================================================
12. CURSOR
============================================================

CURSOR: Permite percorrer o resultado de uma consulta linha por linha dentro de uma rotina.

Etapas principais:
1. DECLARE CURSOR
2. DECLARE HANDLER
3. OPEN
4. FETCH
5. PROCESSAMENTO
6. CLOSE
*/

DROP PROCEDURE IF EXISTS p_cursor_exemplo;
DELIMITER //
CREATE PROCEDURE p_cursor_exemplo()
BEGIN
    DECLARE v_estado VARCHAR(100);
    DECLARE v_populacao INT;
    DECLARE v_fim BOOLEAN DEFAULT FALSE; -- valida se o cursor chegou ao final
    DECLARE cur_estados CURSOR FOR
        SELECT estado, populacao   -- define que cur_estados será um cursor para percorrer estado e população
        FROM estado_populacao;
    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET v_fim = TRUE;  -- altera v_fim para true se o FETCH não encontra mais registros
    OPEN cur_estados; -- inicia o cursor
    leitura: LOOP
        FETCH cur_estados --  Pega a próxima linha do CURSOR e coloca os valores nas variáveis declaradas.
        INTO v_estado, v_populacao;
        IF v_fim THEN
            LEAVE leitura;
        END IF;
        SELECT
            v_estado AS estado,
            v_populacao AS populacao;
    END LOOP leitura;
    CLOSE cur_estados;
END //
DELIMITER ;

CALL p_cursor_exemplo();  -- gera uma tabela para cada linha do resultado do select estado e população


/*
============================================================
13. PARÂMETRO OUT
============================================================
OUT: Permite que uma Procedure devolva um valor por meio de um parâmetro.

IN  → entrada
OUT → saída
INOUT → entrada e saída
*/

DROP PROCEDURE IF EXISTS p_return_estado_populacao;
DELIMITER //
CREATE PROCEDURE p_return_estado_populacao(
    IN estado_param VARCHAR(100),
    OUT current_pop_param INT
)
BEGIN
    SELECT populacao
    INTO current_pop_param
    FROM estado_populacao
    WHERE estado = estado_param;
END //
DELIMITER ;


CALL p_return_estado_populacao('New York',@pop_ny); -- Como usamos @pop_ny, podemos consultar o valor depois da execução da Procedure.
SELECT @pop_ny;


/*
============================================================
14. PARÂMETRO INOUT
============================================================
*/

DROP PROCEDURE IF EXISTS p_inout_exemplo;
DELIMITER //
CREATE PROCEDURE p_inout_exemplo(
    INOUT p_valor INT
)
BEGIN
    SET p_valor = p_valor + 10;
END //
DELIMITER ;

SET @numero = 5;
CALL p_inout_exemplo(@numero);
SELECT @numero;

/*
============================================================
15. PROCEDURE CHAMANDO OUTRA PROCEDURE
============================================================
*/

DROP PROCEDURE IF EXISTS p_populacao_caller;
DELIMITER //
CREATE PROCEDURE p_populacao_caller()
BEGIN
    DECLARE v_ny INT;
    DECLARE v_nj INT;
    CALL p_return_estado_populacao(  -- vai retornar o valor da população através de outra function criada
        'New York',
        v_ny
    );
    CALL p_return_estado_populacao(
        'New Jersey',
        v_nj
    );
    SELECT
        v_ny + v_nj AS populacao_total;
END //

DELIMITER ;

CALL p_populacao_caller();

/*
============================================================
16. HANDLER — TRATAMENTO DE ERROS
============================================================

HANDLER: Permite definir o que deve acontecer quando uma condição ou erro ocorre durante a execução.

Alguns exemplos úteis no MySQL:
1062 → Duplicate entry ou Valor duplicado em PRIMARY KEY ou UNIQUE.

1329 / NOT FOUND → Nenhum dado encontrado em determinadas operações.

1365 → Division by 0.

1452 → Violação de chave estrangeira ao inserir/alterar um registro filho.

1146 → Tabela não existe.

1054 → Coluna desconhecida.
*/

DROP TABLE IF EXISTS aluno;
CREATE TABLE aluno (
    ra INT PRIMARY KEY,
    nome VARCHAR(30)
);

INSERT INTO aluno
VALUES (1, 'Maria Alice');

DROP PROCEDURE IF EXISTS p_cadastrar_aluno;
DELIMITER //
CREATE PROCEDURE p_cadastrar_aluno(
    IN p_ra INT,
    IN p_nome VARCHAR(30)
)
BEGIN
    DECLARE CONTINUE HANDLER FOR 1062  -- Quando ocorrer o erro 1062, o HANDLER será executado.
    BEGIN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'RA de aluno já existe';  -- Se p_ra já existir, o INSERT gera o erro 1062. O HANDLER captura esse erro.
    END;
    INSERT INTO aluno (ra, nome)
    VALUES (p_ra, p_nome);
END //
DELIMITER ;

CALL p_cadastrar_aluno(1, 'Maria Alice');


/*
============================================================
17. EXEMPLO FINAL — COMBINANDO OS CONCEITOS
============================================================
*/

DROP TABLE IF EXISTS circulo;
CREATE TABLE circulo (
    raio INT,
    area DECIMAL(10,2)
);

DROP PROCEDURE IF EXISTS p_calcula_areas;
DELIMITER //

CREATE PROCEDURE p_calcula_areas()
BEGIN
    DECLARE v_raio INT DEFAULT 1;
    DECLARE v_area DECIMAL(10,2);

    calcula: LOOP

        SET v_area = PI() * (v_raio * v_raio);

        INSERT INTO circulo (raio, area)
        VALUES (v_raio, v_area);
        IF v_raio = 10 THEN
            LEAVE calcula;
        END IF;
        SET v_raio = v_raio + 1;
    END LOOP calcula;

    SELECT *
    FROM circulo;

END //

DELIMITER ;

CALL p_calcula_areas();
