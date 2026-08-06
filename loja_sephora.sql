SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;  -- desativa a validação de ordem para criar fk temporariamente
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';  
SET SQL_SAFE_UPDATES = 0; -- permite edições e exclusões sem restrição

CREATE SCHEMA IF NOT EXISTS  loja_sephora  DEFAULT CHARACTER SET utf8 ;
USE  loja_sephora  ;

-- -----------------------------------------------------
-- TABELA ENDERECO
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS loja_sephora.endereco (
  id INT NOT NULL AUTO_INCREMENT,
  cep VARCHAR(45) NOT NULL,
  rua VARCHAR(45) NOT NULL,
  numero INT NOT NULL,
  cidade VARCHAR(45) NOT NULL,
  estado VARCHAR(45) NOT NULL,
  pais VARCHAR(45) NOT NULL,
  complemento VARCHAR(45) NULL,
  bairro VARCHAR(45) NOT NULL,
  PRIMARY KEY (id))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- TABELA CLIENTES
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS  loja_sephora.clientes  (
   id  INT NOT NULL AUTO_INCREMENT,
   nome  VARCHAR(45) NOT NULL,
   cpf  VARCHAR(45) NOT NULL UNIQUE,
   fone  VARCHAR(45) NOT NULL,
   email  VARCHAR(45) NOT NULL UNIQUE,
   data_criacao  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,  -- define a data e hora de cadastro automaticamente com o tempo real de criação
   status_cadastro ENUM('ativo', 'inativo') NOT NULL,
   fk_endereco  INT NOT NULL,
  PRIMARY KEY ( id ),
  INDEX  fk_cliente_endereco_idx  ( fk_endereco  ASC) VISIBLE,  -- ele melhora o desempenho das consultas na tabela endereco
  CONSTRAINT  fk_cliente_endereco 
    FOREIGN KEY (fk_endereco)
    REFERENCES  loja_sephora.endereco(id)
    )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- TABELA PAGAMENTO
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS  loja_sephora.pagamento  (
   id  INT NOT NULL AUTO_INCREMENT,
   valor_total  DECIMAL(30,2) NOT NULL,
   forma_pagamento  SET('pix', 'debito', 'credito', 'dinheiro') NOT NULL,
   valor_pix  DECIMAL(30,2) NULL,
   valor_credito  DECIMAL(30,2) NULL,
   valor_debito  DECIMAL(30,2) NULL,
   valor_dinheiro  DECIMAL(30,2) NULL,
   desconto  DECIMAL(30,2) NULL,
  PRIMARY KEY (id))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- TABELA VENDEDOR
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS  loja_sephora.vendedor  (
   id  INT NOT NULL AUTO_INCREMENT,
   nome  VARCHAR(45) NOT NULL,
   cpf  VARCHAR(45) NOT NULL,
   telefone  VARCHAR(45) NOT NULL,
   email  VARCHAR(45) NOT NULL,
   data_criacao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
   status_cadastro  ENUM('ativo', 'inativo') NOT NULL,
   fk_endereco  INT NOT NULL,
   comissao  DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (id),
  INDEX  fk_vendedor_endereco_idx  (fk_endereco ASC) VISIBLE,
  CONSTRAINT  fk_vendedor_endereco 
    FOREIGN KEY (fk_endereco)
    REFERENCES loja_sephora.endereco (id)
    )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- TABELA VENDA
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS  loja_sephora.venda  (
   id  INT NOT NULL AUTO_INCREMENT,
   data_criacao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
   fk_pagamento  INT NOT NULL,
   fk_clientes  INT NOT NULL,
   fk_vendedor  INT NOT NULL,
  PRIMARY KEY (id),
  INDEX  fk_venda_pagamento_idx  ( fk_pagamento  ASC) VISIBLE,
  INDEX  fk_venda_clientes_idx  ( fk_clientes  ASC) VISIBLE,
  INDEX  fk_venda_vendedor_idx  ( fk_vendedor  ASC) VISIBLE,
  CONSTRAINT  fk_venda_pagamento 
    FOREIGN KEY (fk_pagamento)
    REFERENCES  loja_sephora.pagamento (id),
  CONSTRAINT  fk_venda_clientes 
    FOREIGN KEY (fk_clientes)
    REFERENCES  loja_sephora.clientes (id),
  CONSTRAINT  fk_venda_vendedor 
    FOREIGN KEY (fk_vendedor)
    REFERENCES  loja_sephora.vendedor (id)
	)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- TABELA PRODUTO
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS  loja_sephora.produto  (
   id  INT NOT NULL AUTO_INCREMENT,
   nome  VARCHAR(45) NOT NULL UNIQUE,
   marca  VARCHAR(45) NOT NULL,
   categoria  ENUM('perfume', 'cabelo', 'pele', 'unhas', 'maquiagem') NOT NULL,
   preco  DECIMAL(8,2) NOT NULL,
   estoque  INT NULL,
   data_criacao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
  )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- TABELA ITEM 
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS  loja_sephora.item  (
   id  INT NOT NULL AUTO_INCREMENT,
   quantidade  INT NOT NULL,
   fk_venda  INT NOT NULL,
   fk_produto  INT NOT NULL,
  PRIMARY KEY (id),
  INDEX  fk_item_venda_idx  ( fk_venda  ASC) VISIBLE,
  INDEX  fk_item_produto_idx  ( fk_produto  ASC) VISIBLE,
  CONSTRAINT  fk_item_venda 
    FOREIGN KEY (fk_venda)
    REFERENCES  loja_sephora.venda (id),
  CONSTRAINT  fk_item_produto 
    FOREIGN KEY (fk_produto)
    REFERENCES  loja_sephora.produto  (id)
	)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- INSERÇÃO DE DADOS
-- -----------------------------------------------------

INSERT INTO endereco
(cep, rua, numero, cidade, estado, pais, complemento, bairro)
VALUES
('01001-000','Rua das Flores',120,'São Paulo','SP','Brasil',NULL,'Centro'),
('13010-001','Av. Brasil',45,'Campinas','SP','Brasil',NULL,'Jardim'),
('18010-000','Rua XV de Novembro',78,'Sorocaba','SP','Brasil',NULL,'Centro'),
('13300-120','Rua Itália',55,'Itu','SP','Brasil','Apto 12','Centro'),
('13200-100','Rua dos Ipês',210,'Jundiaí','SP','Brasil',NULL,'Anhangabaú'),
('09500-000','Rua Goiás',310,'São Caetano','SP','Brasil',NULL,'Centro'),
('11010-000','Rua do Porto',92,'Santos','SP','Brasil',NULL,'Boqueirão'),
('14010-000','Rua Paraná',88,'Ribeirão Preto','SP','Brasil',NULL,'Centro'),
('15010-000','Rua Amazonas',170,'São José do Rio Preto','SP','Brasil',NULL,'Centro'),
('17010-000','Rua Bahia',44,'Bauru','SP','Brasil',NULL,'Vila Nova'),
('01002-000','Rua A',10,'São Paulo','SP','Brasil',NULL,'Centro'),
('01003-000','Rua B',20,'São Paulo','SP','Brasil',NULL,'Centro'),
('01004-000','Rua C',30,'São Paulo','SP','Brasil',NULL,'Centro'),
('01005-000','Rua D',40,'São Paulo','SP','Brasil',NULL,'Centro'),
('01006-000','Rua E',50,'São Paulo','SP','Brasil',NULL,'Centro'),
('01007-000','Rua F',60,'São Paulo','SP','Brasil',NULL,'Centro'),
('01008-000','Rua G',70,'São Paulo','SP','Brasil',NULL,'Centro'),
('01009-000','Rua H',80,'São Paulo','SP','Brasil',NULL,'Centro'),
('01010-000','Rua I',90,'São Paulo','SP','Brasil',NULL,'Centro'),
('01010-050','Rua Sabiá',150,'São Paulo','SP','Brasil',NULL,'Centro');

INSERT INTO clientes
(nome, cpf, fone, email, status_cadastro, fk_endereco)
VALUES
('Ana Silva','11111111111','11999990001','ana@email.com','ativo',1),
('Bruno Costa','11111111112','11999990002','bruno@email.com','ativo',2),
('Carlos Souza','11111111113','11999990003','carlos@email.com','ativo',3),
('Daniela Lima','11111111114','11999990004','daniela@email.com','ativo',4),
('Eduardo Alves','11111111115','11999990005','edu@email.com','ativo',5),
('Fernanda Rocha','11111111116','11999990006','fernanda@email.com','ativo',6),
('Gabriel Santos','11111111117','11999990007','gabriel@email.com','ativo',7),
('Helena Martins','11111111118','11999990008','helena@email.com','ativo',8),
('Igor Oliveira','11111111119','11999990009','igor@email.com','ativo',9),
('Juliana Freitas','11111111120','11999990010','juliana@email.com','ativo',10),
('Karen Gomes','11111111121','11999990011','karen@email.com','ativo',11),
('Lucas Pereira','11111111122','11999990012','lucas@email.com','ativo',12),
('Marina Lopes','11111111123','11999990013','marina@email.com','ativo',13),
('Nicolas Ramos','11111111124','11999990014','nicolas@email.com','inativo',14),
('Olivia Dias','11111111125','11999990015','olivia@email.com','ativo',15);

INSERT INTO vendedor
(nome,cpf,telefone,email,status_cadastro,fk_endereco,comissao)
VALUES
('Patrícia Melo','22222222221','11988880001','patricia@sephora.com','ativo',16,5.0),
('Ricardo Lima','22222222222','11988880002','ricardo@sephora.com','ativo',17,4.5),
('Sofia Costa','22222222223','11988880003','sofia@sephora.com','ativo',18,6.0),
('Maria Alice Santos','22222214553','11988882903','mariaalice@sephora.com','inativo',20,6.0),
('Thiago Alves','22222222224','11988880004','thiago@sephora.com','ativo',19,5.5);

INSERT INTO pagamento
(valor_total,forma_pagamento,valor_pix,valor_credito,valor_debito,valor_dinheiro,desconto)
VALUES
(199.90,'pix',199.90,NULL,NULL,NULL,10),
(350.00,'credito',NULL,350.00,NULL,NULL,0),
(89.90,'debito',NULL,NULL,89.90,NULL,0),
(420.50,'dinheiro',NULL,NULL,NULL,420.50,20),
(150.00,'pix',150,NULL,NULL,NULL,5),
(79.90,'credito',NULL,79.90,NULL,NULL,0),
(250.00,'pix',250,NULL,NULL,NULL,10),
(180.00,'debito',NULL,NULL,180,NULL,0),
(320.00,'credito',NULL,320,NULL,NULL,0),
(540.00,'pix',540,NULL,NULL,NULL,20),
(99.90,'dinheiro',NULL,NULL,NULL,99.90,0),
(60.00,'pix',60,NULL,NULL,NULL,0),
(870.00,'credito',NULL,870,NULL,NULL,50),
(110.00,'debito',NULL,NULL,110,NULL,0),
(240.00,'pix',240,NULL,NULL,NULL,15),
(310.00,'credito',NULL,310,NULL,NULL,0),
(185.00,'pix',185,NULL,NULL,NULL,0),
(430.00,'credito',NULL,430,NULL,NULL,30),
(155.00,'dinheiro',NULL,NULL,NULL,155,0),
(280.00,'pix',280,NULL,NULL,NULL,10),
(500.00,'credito',NULL,500,NULL,NULL,20),
(130.00,'debito',NULL,NULL,130,NULL,0),
(210.00,'pix',210,NULL,NULL,NULL,5),
(95.00,'dinheiro',NULL,NULL,NULL,95,0),
(670.00,'credito',NULL,670,NULL,NULL,40);

INSERT INTO produto
(nome,marca,categoria,preco,estoque)
VALUES
('Base Matte','Maybelline','maquiagem',89.90,50),
('Corretivo Fit','Maybelline','maquiagem',49.90,40),
('Batom Nude','MAC','maquiagem',119.90,30),
('Máscara Cílios','Ruby Rose','maquiagem',39.90,70),
('Paleta Glow','Mari Maria','maquiagem',149.90,20),
('Perfume Lily','O Boticário','perfume',299.90,25),
('Perfume Egeo','O Boticário','perfume',179.90,40),
('Perfume La Vie','Lancôme','perfume',549.90,10),
('Shampoo Repair','Wella','cabelo',89.90,30),
('Condicionador Repair','Wella','cabelo',94.90,30),
('Máscara Capilar','Lola','cabelo',59.90,35),
('Óleo Capilar','Lola','cabelo',69.90,40),
('Sérum Facial','Principia','pele',79.90,60),
('Hidratante Facial','CeraVe','pele',99.90,45),
('Protetor Solar','La Roche','pele',129.90,25),
('Sabonete Facial','CeraVe','pele',69.90,35),
('Creme Anti-idade','Nivea','pele',59.90,30),
('Esmalte Vermelho','Risqué','unhas',9.90,120),
('Esmalte Rosa','Colorama','unhas',10.90,100),
('Base Fortalecedora','Risqué','unhas',12.90,80),
('Top Coat','Colorama','unhas',14.90,70),
('Removedor','Ideal','unhas',15.90,90),
('Blush','MAC','maquiagem',149.90,18),
('Iluminador','MAC','maquiagem',169.90,15),
('Pó Compacto','Vult','maquiagem',54.90,40),
('Primer','Bruna Tavares','maquiagem',79.90,35),
('Delineador','Vult','maquiagem',39.90,60),
('Gloss','Fenty','maquiagem',199.90,20),
('Perfume Good Girl','Carolina Herrera','perfume',699.90,8),
('Creme Corporal','Nivea','pele',29.90,50);

INSERT INTO venda
(fk_pagamento,fk_clientes,fk_vendedor)
VALUES
(1,1,1),(2,2,2),(3,3,3),(4,4,4),(5,5,1),
(6,6,2),(7,7,3),(8,8,4),(9,9,1),(10,10,2),
(11,11,3),(12,12,4),(13,13,1),(14,14,2),(15,15,3),
(16,1,4),(17,2,1),(18,3,2),(19,4,3),(20,5,4),
(21,6,1),(22,7,2),(23,8,3),(24,9,4),(25,10,1),(1,11,2),
(2,12,3),(3,13,4),(4,14,1),(5,15,2),(6,1,3),(7,2,4),
(8,3,1),(9,4,2),(10,5,3),(11,6,4),(12,7,1),(13,8,2),
(14,9,3),(15,10,4),(16,11,1),(17,12,2),(18,13,3),(19,14,4),
(20,15,1),(21,1,2),(22,2,3),(23,3,4),(24,4,1),(25,5,2);

INSERT INTO item
(quantidade,fk_venda,fk_produto)
VALUES
(1,1,1),(2,1,6),(1,2,3),(1,2,13),(2,3,18),(1,3,19),
(1,4,29),(1,4,30),(3,5,9),(1,5,10),(1,6,5),(2,6,22),
(1,7,2),(1,7,24),(2,8,15),(1,8,16),(1,9,7),(1,9,8),
(2,10,25),(1,10,26),(1,11,17),(3,11,18),(1,12,12),(2,12,14),
(1,13,28),(1,13,23),(1,14,20),(2,14,21),(1,15,27),(1,15,30),
(2,16,4),(1,16,9),(1,17,11),(2,17,13),(1,18,6),(1,18,3),
(2,19,24),(1,19,29),(1,20,1),(1,20,15),(2,21,5),(1,21,30),
(1,22,14),(2,22,18),(1,23,26),(1,23,7),(2,24,12),(1,24,2),
(1,25,29),(1,25,6),(1,26,5),(2,26,12),(1,26,27),(1,27,3),
(2,27,18),(1,27,30),(1,28,7),(1,28,14),(2,28,20),(1,28,25),
(2,29,1),(1,29,6),(1,30,9),(1,30,15),(2,30,24),(1,31,2),
(2,31,11),(1,31,29),(3,32,13),(1,32,22),(1,33,8),(1,33,17),
(2,33,28),(1,34,4),(2,34,19),(1,34,30),(1,35,10),(1,35,12),
(1,35,16),(2,35,23),(2,36,5),(1,36,14),(1,37,21),(2,37,7),
(1,37,25),(1,38,9),(1,38,18),(2,39,3),(1,39,20),(1,39,30),
(1,40,11),(1,40,24),(2,40,29),(1,41,1),(2,41,13),(1,42,6),
(1,42,15),(2,42,22),(1,42,27),(2,43,2),(1,43,19),(1,44,4),
(2,44,8),(1,44,23),(1,45,5),(2,45,12),(1,45,18),(1,45,30),
(1,46,7),(2,46,10),(1,47,9),(1,47,11),(2,47,17),(1,48,3),
(2,48,14),(1,48,24),(1,49,2),(1,49,6),(2,49,13),(1,49,21),
(1,50,1),(2,50,5),(1,50,9),(1,50,12),(1,26,2),(1,27,4),
(1,28,6),(1,29,8),(1,30,10),(1,31,12),(1,32,14),(1,33,16),
(1,34,18),(1,35,20),(1,36,22),(1,37,24),(1,38,26),(1,39,28),
(1,40,30),(1,41,3),(1,42,5),(1,43,7),(1,44,9),(1,45,11),
(1,46,13),(1,47,15),(1,48,17),(1,49,19),(1,50,21),(2,26,23),
(2,27,25),(2,28,27),(2,29,29),(2,30,2),(2,31,4),(2,32,6),
(2,33,8),(2,34,10),(2,35,12),(2,36,14),(2,37,16),(2,38,18),
(2,39,20),(2,40,22);

SELECT * FROM vendedor;
SELECT * FROM clientes;
SELECT * FROM produto;
SELECT * FROM venda;
SELECT * FROM pagamento;
SELECT * FROM endereco;
SELECT * FROM item;

UPDATE vendedor SET fk_endereco = 20 WHERE status_cadastro = 'inativo';

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;   -- volta a validar as foreign keys
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
