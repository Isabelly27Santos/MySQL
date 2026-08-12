SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE=ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION;

-- -----------------------------------------------------
-- Schema MAPA
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS MAPA DEFAULT CHARACTER SET utf8 ;
USE MAPA;

-- -----------------------------------------------------
-- TABELA CLIENTE
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS MAPA.cliente (
  id INT NOT NULL,
  nome VARCHAR(45) NOT NULL,
  cpf VARCHAR(45) NOT NULL UNIQUE,
  email VARCHAR(45) NOT NULL UNIQUE,
  telefone VARCHAR(45) NOT NULL,
  data_cadastro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  login VARCHAR(45) NOT NULL UNIQUE,
  PRIMARY KEY (id))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- TABELA COMPRA
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS MAPA.compra (
  id INT NOT NULL,
  fk_cliente INT NOT NULL,
  data_compra DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status_compra ENUM('Aprovado', 'Cancelado', 'Processando') NOT NULL,
  status_pag ENUM('Aprovado', 'Cancelado', 'Processando') NOT NULL,
  forma_pag ENUM('Débito', 'Crédito', 'PIX','Boleto') NOT NULL,
  data_pag DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX fk_compra_cliente_idx (fk_cliente ASC) VISIBLE,
  CONSTRAINT fk_compra_cliente
    FOREIGN KEY (fk_cliente)
    REFERENCES MAPA.cliente (id))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- TABELA JOGO
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS MAPA.jogo (
  id INT NOT NULL,
  nome VARCHAR(45) NOT NULL,
  descricao VARCHAR(200) NOT NULL,
  desenvolvedor VARCHAR(45) NOT NULL,
  publicadora VARCHAR(45) NOT NULL,
  data_lancamento DATE NOT NULL,
  preco FLOAT(6,2) NOT NULL,
  categoria VARCHAR(45) NOT NULL,
  class_indicativa INT NOT NULL,
  link VARCHAR(150) NOT NULL,
  PRIMARY KEY (id))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- TABELA BIBLIOTECA
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS MAPA.biblioteca (
  fk_jogo INT NOT NULL,
  fk_cliente INT NOT NULL,
  data_aquisicao DATETIME NOT NULL,
  INDEX fk_biblioteca_jogo_idx (fk_jogo ASC) VISIBLE,
  PRIMARY KEY (fk_jogo, fk_cliente),
  INDEX fk_biblioteca_cliente_idx (fk_cliente ASC) VISIBLE,
  CONSTRAINT fk_biblioteca_jogo
    FOREIGN KEY (fk_jogo)
    REFERENCES MAPA.jogo (id),
  CONSTRAINT fk_biblioteca_cliente
    FOREIGN KEY (fk_cliente)
    REFERENCES MAPA.cliente (id))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- TABELA ITEM
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS MAPA.item (
  id INT NOT NULL AUTO_INCREMENT,
  fk_compra INT NOT NULL,
  fk_jogo INT NOT NULL,
  preco FLOAT(6,2) NOT NULL,
  PRIMARY KEY (id),
  INDEX fk_item_compra_idx (fk_compra ASC) VISIBLE,
  INDEX fk_item_jogo_idx (fk_jogo ASC) VISIBLE,
  CONSTRAINT fk_item_compra
    FOREIGN KEY (fk_compra)
    REFERENCES MAPA.compra (id),
  CONSTRAINT fk_item_jogo
    FOREIGN KEY (fk_jogo)
    REFERENCES MAPA.jogo (id))
ENGINE = InnoDB;

INSERT INTO cliente
(id, nome, cpf, email, telefone, login)
VALUES
(1,'Ana Souza','11111111101','ana@gmail.com','11988880001','anasouza'),
(2,'Bruno Lima','11111111102','bruno@gmail.com','11988880002','brunolima'),
(3,'Carlos Oliveira','11111111103','carlos@gmail.com','11988880003','carlosoliveira'),
(4,'Daniela Santos','11111111104','daniela@gmail.com','11988880004','danielasantos'),
(5,'Eduardo Costa','11111111105','eduardo@gmail.com','11988880005','eduardocosta'),
(6,'Fernanda Alves','11111111106','fernanda@gmail.com','11988880006','fernandaalves'),
(7,'Gabriel Martins','11111111107','gabriel@gmail.com','11988880007','gabrielmartins'),
(8,'Helena Rocha','11111111108','helena@gmail.com','11988880008','helenarocha'),
(9,'Igor Ferreira','11111111109','igor@gmail.com','11988880009','igorferreira'),
(10,'Juliana Mendes','11111111110','juliana@gmail.com','11988880010','julianamendes'),
(11,'Lucas Ribeiro','11111111111','lucas@gmail.com','11988880011','lucasribeiro'),
(12,'Mariana Gomes','11111111112','mariana@gmail.com','11988880012','marianagomes'),
(13,'Nicolas Barbosa','11111111113','nicolas@gmail.com','11988880013','nicolasbarbosa'),
(14,'Patricia Teixeira','11111111114','patricia@gmail.com','11988880014','patriciateixeira'),
(15,'Rafael Moreira','11111111115','rafael@gmail.com','11988880015','rafaelmoreira');


INSERT INTO jogo
(id, nome, descricao, desenvolvedor, publicadora, data_lancamento, preco, categoria, class_indicativa, link)
VALUES
(1,'Cyber Legends','RPG futurista em mundo aberto','Nova Games','Future Play','2024-03-15',149.90,'RPG',16,'https://download.com/jogo1'),
(2,'Shadow Warrior','Jogo de ação com combates intensos','Dark Studio','Game World','2023-08-20',99.90,'Acao',18,'https://download.com/jogo2'),
(3,'Mystic Lands','Aventura em um mundo mágico','DreamWorks','Fantasy Games','2022-05-10',79.90,'Aventura',12,'https://download.com/jogo3'),
(4,'Speed Revolution','Corridas de alta velocidade','Turbo Studio','Racing Corp','2024-01-18',119.90,'Corrida',10,'https://download.com/jogo4'),
(5,'Galaxy War','Batalhas espaciais entre planetas','Star Games','Galaxy Corp','2023-11-05',139.90,'Acao',14,'https://download.com/jogo5'),
(6,'Kingdom Builder','Construa e administre seu reino','Empire Studio','Strategy Games','2021-09-12',89.90,'Estrategia',10,'https://download.com/jogo6'),
(7,'Football Stars','Simulador de futebol','Sports Studio','Sports Games','2024-09-20',199.90,'Esportes',10,'https://download.com/jogo7'),
(8,'Haunted House','Explore uma casa cheia de mistérios','Dark Moon','Horror Games','2022-10-31',69.90,'Terror',16,'https://download.com/jogo8'),
(9,'Ocean Adventure','Explore os oceanos em busca de tesouros','Blue Studio','Adventure Corp','2023-04-17',109.90,'Aventura',10,'https://download.com/jogo9'),
(10,'Dragon Quest','Enfrente dragões e monstros','Fantasy Studio','Dragon Games','2020-07-25',129.90,'RPG',12,'https://download.com/jogo10'),
(11,'Street Racing','Corridas urbanas e personalização de carros','Urban Games','Racing Corp','2023-02-14',94.90,'Corrida',12,'https://download.com/jogo11'),
(12,'Zombie Attack','Sobreviva a uma invasão de zumbis','Dead Studio','Horror Games','2024-06-08',84.90,'Terror',18,'https://download.com/jogo12'),
(13,'World Soccer','Campeonato mundial de futebol','Sports Studio','Sports Games','2023-10-01',179.90,'Esportes',1,'https://download.com/jogo13'),
(14,'Civilization Rise','Construa uma grande civilização','Strategy Studio','Empire Games','2022-03-11',149.90,'Estrategia',10,'https://download.com/jogo14'),
(15,'Magic Academy','Aprenda magia e explore a academia','Magic Studio','Fantasy Games','2024-02-22',119.90,'RPG',10,'https://download.com/jogo15'),
(16,'Ninja Shadow','Combate furtivo entre ninjas','Ninja Studio','Action Games','2021-11-19',74.90,'Acao',14,'https://download.com/jogo16'),
(17,'Lost Island','Sobreviva em uma ilha misteriosa','Island Games','Adventure Corp','2023-07-13',89.90,'Aventura',12,'https://download.com/jogo17'),
(18,'Battle Arena','Arena competitiva de batalhas','Battle Studio','Game World','2024-05-30',109.90,'Acao',14,'https://download.com/jogo18'),
(19,'Rally Extreme','Rally em pistas extremas','Extreme Studio','Racing Corp','2022-12-05',99.90,'Corrida',10,'https://download.com/jogo19'),
(20,'Space Explorer','Explore galáxias desconhecidas','Space Studio','Galaxy Corp','2024-08-15',159.90,'Aventura',10,'https://download.com/jogo20');

INSERT INTO compra
(id, fk_cliente, status_compra, status_pag, forma_pag)
VALUES
(1,1,'Aprovado','Aprovado','PIX'),
(2,2,'Aprovado','Aprovado','Crédito'),
(3,3,'Aprovado','Aprovado','Boleto'),
(4,4,'Processando','Processando','PIX'),
(5,5,'Aprovado','Aprovado','Débito'),
(6,6,'Aprovado','Aprovado','Crédito'),
(7,7,'Cancelado','Cancelado','PIX'),
(8,8,'Aprovado','Aprovado','Boleto'),
(9,9,'Aprovado','Aprovado','Crédito'),
(10,10,'Aprovado','Aprovado','PIX'),
(11,11,'Processando','Processando','Débito'),
(12,12,'Aprovado','Aprovado','Crédito'),
(13,13,'Aprovado','Aprovado','PIX'),
(14,14,'Aprovado','Aprovado','Boleto'),
(15,15,'Aprovado','Aprovado','Crédito'),
(16,1,'Aprovado','Aprovado','PIX'),
(17,2,'Aprovado','Aprovado','Débito'),
(18,3,'Aprovado','Aprovado','Crédito'),
(19,4,'Aprovado','Aprovado','PIX'),
(20,5,'Aprovado','Aprovado','Boleto'),
(21,6,'Processando','Processando','Crédito'),
(22,7,'Aprovado','Aprovado','PIX'),
(23,8,'Aprovado','Aprovado','Débito'),
(24,9,'Aprovado','Aprovado','Crédito'),
(25,10,'Aprovado','Aprovado','PIX'),
(26,11,'Aprovado','Aprovado','Boleto'),
(27,12,'Cancelado','Cancelado','Crédito'),
(28,13,'Aprovado','Aprovado','PIX'),
(29,14,'Aprovado','Aprovado','Débito'),
(30,15,'Aprovado','Aprovado','Crédito'),
(31,1,'Aprovado','Aprovado','PIX'),
(32,3,'Aprovado','Aprovado','Boleto'),
(33,5,'Aprovado','Aprovado','Crédito'),
(34,8,'Aprovado','Aprovado','PIX'),
(35,12,'Aprovado','Aprovado','Débito');

INSERT INTO item
(fk_compra, fk_jogo, preco)
VALUES
(1,1,149.90),(1,5,139.90),
(2,3,79.90),(2,10,129.90),
(3,7,199.90),(3,11,94.90),
(4,8,69.90),(4,12,84.90),
(5,2,99.90),(5,14,149.90),
(6,6,89.90),(6,15,119.90),
(7,4,119.90),(7,19,99.90),
(8,9,109.90),(8,17,89.90),
(9,10,129.90),(9,20,159.90),
(10,1,149.90),(10,16,74.90),
(11,12,84.90),(11,18,109.90),
(12,5,139.90),(12,13,179.90),
(13,3,79.90),(13,15,119.90),
(14,7,199.90),(14,19,99.90),
(15,2,99.90),(15,20,159.90),
(16,4,119.90),(16,8,69.90),
(17,6,89.90),(17,14,149.90),
(18,9,109.90),(18,18,109.90),
(19,1,149.90),(19,17,89.90),
(20,10,129.90),(20,12,84.90),
(21,5,139.90),(21,16,74.90),
(22,3,79.90),(22,20,159.90),
(23,7,199.90),(23,11,94.90),
(24,2,99.90),(24,15,119.90),
(25,8,69.90),(25,13,179.90),
(26,4,119.90),(26,18,109.90),
(27,6,89.90),(27,19,99.90),
(28,1,149.90),(28,14,149.90),
(29,9,109.90),(29,16,74.90),
(30,5,139.90),(30,20,159.90),
(31,3,79.90),(31,12,84.90),
(32,7,199.90),(32,17,89.90),
(33,2,99.90),(33,10,129.90),
(34,15,119.90),(34,18,109.90),
(35,6,89.90),(35,13,179.90);


SELECT * FROM cliente;
SELECT * FROM compra;
SELECT * FROM biblioteca;
SELECT * FROM jogo;
SELECT * FROM item;

INSERT INTO biblioteca
(fk_jogo, fk_cliente, data_aquisicao)
SELECT DISTINCT
    i.fk_jogo,
    c.fk_cliente,
    c.data_compra
FROM item i
INNER JOIN compra c
    ON i.fk_compra = c.id
ORDER BY c.fk_cliente;

SELECT * FROM biblioteca;
    
CREATE TABLE dados (
	fk_cliente INT NOT NULL,
    PRIMARY KEY (fk_cliente),
      INDEX fk_dados_cliente_idx (fk_cliente ASC) VISIBLE,
  CONSTRAINT fk_dados_cliente
    FOREIGN KEY (fk_cliente)
    REFERENCES MAPA.cliente (id),
	nome VARCHAR(45) NOT NULL,
    jogos VARCHAR(200) NOT NULL);
 
INSERT INTO dados
(fk_cliente, nome, jogos) 
SELECT c.id, c.nome AS Cliente,
	GROUP_CONCAT(DISTINCT j.nome SEPARATOR ', ') AS Jogos
    FROM cliente c
    JOIN compra cp
		ON fk_cliente = c.id
	JOIN item i 
		ON fk_compra = cp.id
	JOIN jogo j
		ON fk_jogo = j.id
	GROUP BY c.id, c.nome;

SELECT * FROM dados;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
