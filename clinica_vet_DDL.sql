USE clinica_vet;

ALTER TABLE tutor ADD data_nascimento DATE;    -- insere uma coluna para data de nascimento na tabela tutor
ALTER TABLE tutor DROP data_nascimento;        -- exclui a coluna data de nascimento da tabela tutor

ALTER TABLE tutor ADD data_nascimento DATE DEFAULT ('2003-03-03');   -- adiciona coluna com um valor definido em casos de NULL
ALTER TABLE tutor ADD data_cadastro DATE DEFAULT (curdate());    -- salva a data atual ao criar um novo tutor

ALTER TABLE tutor MODIFY COLUMN cpf VARCHAR(14);   -- MODIFY atualiza as características da coluna cpf

ALTER TABLE tutor CHANGE COLUMN fone telefone VARCHAR(16);  -- CHANGE renomeia o nome da coluna

ALTER TABLE tutor ADD CONSTRAINT unique_fone UNIQUE (fone);  -- adiciona uma restrição em telefone para não aceitar valores repetidos

CREATE TABLE medicamentos (
	id INT,
    medicamento VARCHAR(200) NOT NULL,
    validade DATE NOT NULL,
    fabricacao DATE NOT NULL,
    especie SET ('gato', 'cachorro') NOT NULL,
    PRIMARY KEY (id)
);

ALTER TABLE consulta ADD COLUMN fk_medicacao INT;

ALTER TABLE consulta RENAME COLUMN fk_medicacao TO fk_medicamentos;    -- renomeia a coluna

ALTER TABLE consulta 
	ADD CONSTRAINT fk_medicamentos_consulta 
	FOREIGN KEY (fk_medicamentos)
	REFERENCES medicamentos(id);
    
    SELECT * FROM consulta;

INSERT INTO medicamentos
(id, medicamento, validade, fabricacao, especie)
VALUES
(1, 'Meloxicam Veterinario', '2027-05-15', '2025-05-15', 'cachorro'),
(2, 'Doxiciclina Veterinaria', '2027-08-20', '2025-08-20', 'gato'),
(3, 'Amoxicilina Veterinaria', '2027-03-10', '2025-03-10', 'gato,cachorro'),
(4, 'Prednisolona Veterinaria', '2026-11-25', '2024-11-25', 'gato,cachorro'),
(5, 'Omeprazol Veterinario', '2027-01-30', '2025-01-30', 'cachorro'),
(6, 'Dipirona Veterinaria', '2026-09-12', '2024-09-12', 'gato,cachorro'),
(7, 'Enrofloxacina Veterinaria', '2027-06-18', '2025-06-18', 'cachorro'),
(8, 'Cefalexina Veterinaria', '2026-12-05', '2024-12-05', 'gato,cachorro'),
(9, 'Metronidazol Veterinario', '2027-04-22', '2025-04-22', 'cachorro'),
(10, 'Cetoconazol Veterinario', '2027-07-14', '2025-07-14', 'gato,cachorro'),
(11, 'Carprofen Veterinario', '2026-10-08', '2024-10-08', 'cachorro'),
(12, 'Furosemida Veterinaria', '2027-02-28', '2025-02-28', 'gato,cachorro'),
(13, 'Tramadol Veterinario', '2026-08-16', '2024-08-16', 'cachorro'),
(14, 'Maropitant Veterinario', '2027-09-30', '2025-09-30', 'gato,cachorro'),
(15, 'Clindamicina Veterinaria', '2026-06-11', '2024-06-11', 'gato'),
(16, 'Amitraz Veterinario', '2027-03-25', '2025-03-25', 'cachorro'),
(17, 'Ivermectina Veterinaria', '2026-07-19', '2024-07-19', 'gato,cachorro'),
(18, 'Albendazol Veterinario', '2027-11-10', '2025-11-10', 'gato,cachorro'),
(19, 'Pirantel Veterinario', '2026-05-27', '2024-05-27', 'gato'),
(20, 'Sulfadimetoxina Veterinaria', '2027-08-08', '2025-08-08', 'cachorro');

TRUNCATE TABLE consulta;  -- exlui todos os dados da tabela consulta

INSERT INTO Consulta
(id_vet, id_animal, dt, horario, fk_medicamentos)
VALUES
(1, 1, '2024-05-10', '10:00:00', 1),
(2, 2, '2024-05-12', '14:00:00', 2),
(3, 3, '2024-05-15', '09:00:00', 3),
(4, 4, '2024-05-18', '11:30:00', NULL),
(5, 5, '2024-05-20', '16:00:00', 5),
(6, 6, '2024-05-22', '10:00:00', 7),
(7, 7, '2024-05-25', '14:00:00', NULL),
(8, 8, '2024-05-27', '09:00:00', 8),
(9, 9, '2024-05-29', '11:30:00', 10),
(10, 10, '2024-05-31', '16:00:00', 11),

(1, 3, '2024-06-01', '10:00:00', 13),
(2, 4, '2024-06-05', '14:00:00', 15),
(3, 1, '2024-06-08', '09:00:00', NULL),
(4, 5, '2024-06-10', '11:30:00', 16),
(5, 2, '2024-06-12', '16:00:00', 12),
(6, 6, '2024-06-15', '10:00:00', 17),
(7, 7, '2024-06-18', '14:00:00', NULL),
(8, 8, '2024-06-20', '09:00:00', 18),
(9, 9, '2024-06-22', '11:30:00', 19),
(10, 10, '2024-06-25', '16:00:00', 20),

(1, 5, '2024-06-27', '10:00:00', 1),
(2, 6, '2024-06-28', '14:00:00', 3),
(3, 7, '2024-06-29', '09:00:00', NULL),
(4, 8, '2024-06-30', '11:30:00', 7),
(5, 9, '2024-07-01', '16:00:00', 4),
(6, 10, '2024-07-02', '10:00:00', 9),
(7, 1, '2024-07-03', '14:00:00', 11),
(8, 2, '2024-07-04', '09:00:00', NULL),
(9, 3, '2024-07-05', '11:30:00', 14),
(10, 4, '2024-07-06', '16:00:00', 8),

(1, 6, '2024-07-07', '10:00:00', 5),
(2, 7, '2024-07-08', '14:00:00', NULL),
(3, 8, '2024-07-09', '09:00:00', 6),
(4, 9, '2024-07-10', '11:30:00', 10),
(5, 10, '2024-07-11', '16:00:00', 13),
(6, 1, '2024-07-12', '10:00:00', NULL),
(7, 2, '2024-07-13', '14:00:00', 15),
(8, 3, '2024-07-14', '09:00:00', 16),
(9, 4, '2024-07-15', '11:30:00', 17),
(10, 5, '2024-07-16', '16:00:00', 18),

(1, 7, '2024-07-17', '10:00:00', 20),
(2, 8, '2024-07-18', '14:00:00', NULL),
(3, 9, '2024-07-19', '09:00:00', 2),
(4, 10, '2024-07-20', '11:30:00', 1),
(5, 1, '2024-07-21', '16:00:00', 3),
(6, 2, '2024-07-22', '10:00:00', 4),
(7, 3, '2024-07-23', '14:00:00', NULL),
(8, 4, '2024-07-24', '09:00:00', 8),
(9, 5, '2024-07-25', '11:30:00', 11),
(10, 6, '2024-07-26', '16:00:00', 12),

(1, 8, '2024-07-27', '10:00:00', 14),
(2, 9, '2024-07-28', '14:00:00', NULL),
(3, 10, '2024-07-29', '09:00:00', 16),
(4, 1, '2024-07-30', '11:30:00', 17),
(5, 2, '2024-07-31', '16:00:00', 19),
(6, 3, '2024-08-01', '10:00:00', 20),
(7, 4, '2024-08-02', '14:00:00', 2),
(8, 5, '2024-08-03', '09:00:00', NULL),
(9, 6, '2024-08-04', '11:30:00', 5),
(10, 7, '2024-08-05', '16:00:00', 7),

(1, 9, '2024-08-06', '10:00:00', 10),
(2, 10, '2024-08-07', '14:00:00', 13),
(3, 1, '2024-08-08', '09:00:00', NULL),
(4, 2, '2024-08-09', '11:30:00', 15),
(5, 3, '2024-08-10', '16:00:00', 18),
(6, 4, '2024-08-11', '10:00:00', 6),
(7, 5, '2024-08-12', '14:00:00', 11),
(8, 6, '2024-08-13', '09:00:00', NULL),
(9, 7, '2024-08-14', '11:30:00', 14),
(10, 8, '2024-08-15', '16:00:00', 16),

(1, 10, '2024-08-16', '10:00:00', 1),
(2, 1, '2024-08-17', '14:00:00', NULL),
(3, 2, '2024-08-18', '09:00:00', 12),
(4, 3, '2024-08-19', '11:30:00', 17),
(5, 4, '2024-08-20', '16:00:00', 19),
(6, 5, '2024-08-21', '10:00:00', 3),
(7, 6, '2024-08-22', '14:00:00', 5),
(8, 7, '2024-08-23', '09:00:00', NULL),
(9, 8, '2024-08-24', '11:30:00', 9),
(10, 9, '2024-08-25', '16:00:00', 4),

(1, 2, '2024-08-26', '10:00:00', 10),
(2, 3, '2024-08-27', '14:00:00', 13),
(3, 4, '2024-08-28', '09:00:00', NULL),
(4, 5, '2024-08-29', '11:30:00', 18),
(5, 6, '2024-08-30', '16:00:00', 20),
(6, 7, '2024-08-31', '10:00:00', 1),
(7, 8, '2024-09-01', '14:00:00', 7),
(8, 9, '2024-09-02', '09:00:00', 15),
(9, 10, '2024-09-03', '11:30:00', NULL),
(10, 1, '2024-09-04', '16:00:00', 11);

SELECT c.id, a.nome AS Animal, a.especie AS Espécie, v.nome AS Veterinário, v.especialidade AS Especialidade, c.dt AS 'Data', c.horario AS Horário, 
m.medicamento AS Medicamento, m.especie AS Tipo
	FROM animal a
	JOIN consulta c
		ON c.id_animal = a.id
	JOIN veterinario v
		ON c.id_vet = v.id
	LEFT JOIN medicamentos m           -- Mostra as consultas que não tem medicamento associado
		ON c.fk_medicamentos = m.id
	ORDER BY a.nome, 'Data', horario;

    
CREATE TABLE teste (
	id INT,
    num INT);
    
ALTER TABLE teste DROP id;

ALTER TABLE teste ADD COLUMN id INT;

ALTER TABLE teste ADD CONSTRAINT
	id
    PRIMARY KEY (id);
    
DROP TABLE teste;
