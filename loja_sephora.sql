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
  id INT NOT NULL ,
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
   id  INT NOT NULL ,
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
   id  INT NOT NULL ,
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
   id  INT NOT NULL ,
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
   id  INT NOT NULL ,
   data_criacao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
   fk_pagamento  INT NOT NULL,
   fk_clientes  INT NOT NULL,
   fk_vendedor  INT NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uk_venda_pagamento (fk_pagamento),
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
   id  INT NOT NULL ,
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
   id  INT NOT NULL auto_increment,
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
(id, cep, rua, numero, cidade, estado, pais, complemento, bairro)
VALUES
(1,'01001-000','Rua das Flores',120,'São Paulo','SP','Brasil',NULL,'Centro'),
(2,'13010-001','Av. Brasil',45,'Campinas','SP','Brasil',NULL,'Jardim'),
(3,'18010-000','Rua XV de Novembro',78,'Sorocaba','SP','Brasil',NULL,'Centro'),
(4,'13300-120','Rua Itália',55,'Itu','SP','Brasil','Apto 12','Centro'),
(5,'13200-100','Rua dos Ipês',210,'Jundiaí','SP','Brasil',NULL,'Anhangabaú'),
(6,'09500-000','Rua Goiás',310,'São Caetano','SP','Brasil',NULL,'Centro'),
(7,'11010-000','Rua do Porto',92,'Santos','SP','Brasil',NULL,'Boqueirão'),
(8,'14010-000','Rua Paraná',88,'Ribeirão Preto','SP','Brasil',NULL,'Centro'),
(9,'15010-000','Rua Amazonas',170,'São José do Rio Preto','SP','Brasil',NULL,'Centro'),
(10,'17010-000','Rua Bahia',44,'Bauru','SP','Brasil',NULL,'Vila Nova'),
(11,'01002-000','Rua A',10,'São Paulo','SP','Brasil',NULL,'Centro'),
(12,'01003-000','Rua B',20,'São Paulo','SP','Brasil',NULL,'Centro'),
(13,'01004-000','Rua C',30,'São Paulo','SP','Brasil',NULL,'Centro'),
(14,'01005-000','Rua D',40,'São Paulo','SP','Brasil',NULL,'Centro'),
(15,'01006-000','Rua E',50,'São Paulo','SP','Brasil',NULL,'Centro'),
(16,'01007-000','Rua F',60,'São Paulo','SP','Brasil',NULL,'Centro'),
(17,'01008-000','Rua G',70,'São Paulo','SP','Brasil',NULL,'Centro'),
(18,'01009-000','Rua H',80,'São Paulo','SP','Brasil',NULL,'Centro'),
(19,'01010-000','Rua I',90,'São Paulo','SP','Brasil',NULL,'Centro'),
(20,'01010-050','Rua Sabiá',150,'São Paulo','SP','Brasil',NULL,'Centro');

INSERT INTO clientes
(id, nome, cpf, fone, email, status_cadastro, fk_endereco)
VALUES
(1,'Ana Silva','11111111111','11999990001','ana@email.com','ativo',1),
(2,'Bruno Costa','11111111112','11999990002','bruno@email.com','ativo',2),
(3,'Carlos Souza','11111111113','11999990003','carlos@email.com','ativo',3),
(4,'Daniela Lima','11111111114','11999990004','daniela@email.com','ativo',4),
(5,'Eduardo Alves','11111111115','11999990005','edu@email.com','ativo',5),
(6,'Fernanda Rocha','11111111116','11999990006','fernanda@email.com','ativo',6),
(7,'Gabriel Santos','11111111117','11999990007','gabriel@email.com','ativo',7),
(8,'Helena Martins','11111111118','11999990008','helena@email.com','ativo',8),
(9,'Igor Oliveira','11111111119','11999990009','igor@email.com','ativo',9),
(10,'Juliana Freitas','11111111120','11999990010','juliana@email.com','ativo',10),
(11,'Karen Gomes','11111111121','11999990011','karen@email.com','ativo',11),
(12,'Lucas Pereira','11111111122','11999990012','lucas@email.com','ativo',12),
(13,'Marina Lopes','11111111123','11999990013','marina@email.com','ativo',13),
(14,'Nicolas Ramos','11111111124','11999990014','nicolas@email.com','inativo',14),
(15,'Olivia Dias','11111111125','11999990015','olivia@email.com','ativo',15);

INSERT INTO vendedor
(id, nome,cpf,telefone,email,status_cadastro,fk_endereco,comissao)
VALUES
(1,'Patrícia Melo','22222222221','11988880001','patricia@sephora.com','ativo',16,5.0),
(2,'Ricardo Lima','22222222222','11988880002','ricardo@sephora.com','ativo',17,4.5),
(3,'Sofia Costa','22222222223','11988880003','sofia@sephora.com','ativo',18,6.0),
(4,'Maria Alice Santos','22222214553','11988882903','mariaalice@sephora.com','inativo',20,6.0),
(5,'Thiago Alves','22222222224','11988880004','thiago@sephora.com','ativo',19,5.5);

INSERT INTO pagamento
(id, valor_total,forma_pagamento,valor_pix,valor_credito,valor_debito,valor_dinheiro,desconto)
VALUES
(1,199.90,'pix',199.90,NULL,NULL,NULL,10),
(2,350.00,'pix,credito',150.00,200.00,NULL,NULL,0),
(3,89.90,'debito',NULL,NULL,89.90,NULL,0),
(4,420.50,'dinheiro',NULL,NULL,NULL,420.50,20),
(5,150.00,'pix',150.00,NULL,NULL,NULL,5),
(6,79.90,'credito,dinheiro',NULL,49.90,NULL,30.00,0),
(7,250.00,'pix',250.00,NULL,NULL,NULL,10),
(8,180.00,'debito',NULL,NULL,180.00,NULL,0),
(9,320.00,'pix,credito',120.00,200.00,NULL,NULL,0),
(10,540.00,'pix',540.00,NULL,NULL,NULL,20),
(11,99.90,'dinheiro',NULL,NULL,NULL,99.90,0),
(12,60.00,'pix',60.00,NULL,NULL,NULL,0),
(13,870.00,'credito,pix',370.00,500.00,NULL,NULL,50),
(14,110.00,'debito',NULL,NULL,110.00,NULL,0),
(15,240.00,'pix',240.00,NULL,NULL,NULL,15),
(16,310.00,'credito,dinheiro',NULL,210.00,NULL,100.00,0),
(17,185.00,'pix',185.00,NULL,NULL,NULL,0),
(18,430.00,'credito,debito',NULL,250.00,180.00,NULL,30),
(19,155.00,'dinheiro',NULL,NULL,NULL,155.00,0),
(20,280.00,'pix',280.00,NULL,NULL,NULL,10),
(21,500.00,'pix,credito,dinheiro',200.00,250.00,NULL,50.00,20),
(22,130.00,'debito',NULL,NULL,130.00,NULL,0),
(23,210.00,'pix',210.00,NULL,NULL,NULL,5),
(24,95.00,'dinheiro,credito',NULL,40.00,NULL,55.00,0),
(25,670.00,'pix,credito',170.00,500.00,NULL,NULL,40);

INSERT INTO produto
(id,nome,marca,categoria,preco,estoque)
VALUES
(1,'Base Matte','Maybelline','maquiagem',89.90,50),
(2,'Corretivo Fit','Maybelline','maquiagem',49.90,40),
(3,'Batom Nude','MAC','maquiagem',119.90,30),
(4,'Máscara Cílios','Ruby Rose','maquiagem',39.90,70),
(5,'Paleta Glow','Mari Maria','maquiagem',149.90,20),
(6,'Perfume Lily','O Boticário','perfume',299.90,25),
(7,'Perfume Egeo','O Boticário','perfume',179.90,40),
(8,'Perfume La Vie','Lancôme','perfume',549.90,10),
(9,'Shampoo Repair','Wella','cabelo',89.90,30),
(10,'Condicionador Repair','Wella','cabelo',94.90,30),
(11,'Máscara Capilar','Lola','cabelo',59.90,35),
(12,'Óleo Capilar','Lola','cabelo',69.90,40),
(13,'Sérum Facial','Principia','pele',79.90,60),
(14,'Hidratante Facial','CeraVe','pele',99.90,45),
(15,'Protetor Solar','La Roche','pele',129.90,25),
(16,'Sabonete Facial','CeraVe','pele',69.90,35),
(17,'Creme Anti-idade','Nivea','pele',59.90,30),
(18,'Esmalte Vermelho','Risqué','unhas',9.90,120),
(19,'Esmalte Rosa','Colorama','unhas',10.90,100),
(20,'Base Fortalecedora','Risqué','unhas',12.90,80),
(21,'Top Coat','Colorama','unhas',14.90,70),
(22,'Removedor','Ideal','unhas',15.90,90),
(23,'Blush','MAC','maquiagem',149.90,18),
(24,'Iluminador','MAC','maquiagem',169.90,15),
(25,'Pó Compacto','Vult','maquiagem',54.90,40),
(26,'Primer','Bruna Tavares','maquiagem',79.90,35),
(27,'Delineador','Vult','maquiagem',39.90,60),
(28,'Gloss','Fenty','maquiagem',199.90,20),
(29,'Perfume Good Girl','Carolina Herrera','perfume',699.90,8),
(30,'Creme Corporal','Nivea','pele',29.90,50);

INSERT INTO venda
(id,fk_pagamento,fk_clientes,fk_vendedor)
VALUES
(1,1,1,1),
(2,2,2,2),
(3,3,3,3),
(4,4,4,4),
(5,5,5,1),
(6,6,6,2),
(7,7,7,3),
(8,8,8,4),
(9,9,9,1),
(10,10,10,2),
(11,11,11,3),
(12,12,12,4),
(13,13,13,1),
(14,14,14,2),
(15,15,15,3),
(16,16,1,4),
(17,17,2,1),
(18,18,3,2),
(19,19,4,3),
(20,20,5,4),
(21,21,6,1),
(22,22,7,2),
(23,23,8,3),
(24,24,9,4),
(25,25,10,1);

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

-- -----------------------------------------------------
-- CONSULTAS DQL
-- -----------------------------------------------------

-- Os 10 produtos mais vendidos
SELECT p.id, p.nome AS Produto,
    SUM(i.quantidade) AS Total_Vendido,
    SUM(i.quantidade*p.preco) AS Lucro
FROM produto p
JOIN item i
    ON p.id = i.fk_produto
GROUP BY p.id, p.nome
ORDER BY Total_Vendido DESC
LIMIT 10;

-- Ganhos totais e total de itens vendidos de cada categoria
SELECT
    p.categoria,
    SUM(i.quantidade) AS 'Unidades Vendidas',
    SUM(i.quantidade * p.preco) AS Faturamento
FROM produto p
JOIN item i
    ON p.id = i.fk_produto
GROUP BY p.categoria
ORDER BY faturamento DESC;

-- Total de comissão que cada vendedor vai receber e total vendido
SELECT
    ve.nome AS vendedor,
    ve.comissao AS percentual_comissao,
    SUM(pa.valor_total) AS total_vendido,
    ROUND (SUM(pa.valor_total * (ve.comissao / 100)),2) AS total_comissao
FROM vendedor ve
INNER JOIN venda v
    ON ve.id = v.fk_vendedor
INNER JOIN pagamento pa
    ON v.fk_pagamento = pa.id
GROUP BY ve.id, ve.nome, ve.comissao
ORDER BY total_vendido DESC;


-- Lista dos 10 compradores que mais gastaram na loja 
SELECT 
	c.id, c.nome,
    SUM(p.valor_total) AS total_comprado
    FROM clientes c
    JOIN venda v
		ON c.id = fk_clientes
    JOIN pagamento p
		ON fk_pagamento = p.id
	GROUP BY c.id, c.nome
	ORDER BY total_comprado DESC
    LIMIT 10;


-- Lista de produtos com estoque abaixo de 15
SELECT 
	p.id, p.nome, p.marca, p.estoque
    FROM produto p
    WHERE p.estoque <15;

-- Total recebido em cada forma de pagamento
SELECT
SUM(p.valor_total) AS total_vendido,
SUM(p.valor_pix) AS total_pix,
SUM(p.valor_credito) AS total_credito,
SUM(p.valor_debito) AS total_debito,
SUM(p.valor_dinheiro) AS total_dinheiro,
SUM(p.desconto) AS total_desconto
FROM pagamento p;

-- Tabela com: cliente, vendedor, produtos vendidos, total pago 
SELECT 
	v.id AS ID_Venda,
    c.nome AS Comprador,
    ve.nome AS Vendedor,
    GROUP_CONCAT(p.nome SEPARATOR ', ') AS Produtos,  -- une em uma coluna os produtos que foram comprados em cada venda
    SUM(p.preco * i.quantidade) AS Total_Pago
FROM clientes c
JOIN venda v
    ON v.fk_clientes = c.id
JOIN vendedor ve
    ON ve.id = v.fk_vendedor
JOIN item i
    ON i.fk_venda = v.id
JOIN produto p
    ON p.id = i.fk_produto
GROUP BY 
    c.nome,
    ve.nome,
    v.id
ORDER BY v.id;


-- Tabela com o total que cada vendedor vendeu e comprador que atendeu

SELECT 
    ve.nome AS Vendedor,
    GROUP_CONCAT(DISTINCT c.nome SEPARATOR ', ') AS Compradores_Atendidos,  -- une em uma coluna os produtos que foram comprados em cada venda
    COUNT(DISTINCT c.id) AS Quant_Compradores,
    SUM(p.preco * i.quantidade) AS Total_Pago
FROM clientes c
JOIN venda v
    ON v.fk_clientes = c.id
JOIN vendedor ve
    ON ve.id = v.fk_vendedor
JOIN item i
    ON i.fk_venda = v.id
JOIN produto p
    ON p.id = i.fk_produto
GROUP BY 
    ve.nome
ORDER BY Total_Pago DESC;


-- Média de preço de produtos e média de valores recebidos por venda

SELECT
    ROUND ((SELECT AVG(preco)
     FROM produto),2) AS Media_Preco_Produtos,   -- calcula a média do preço de todos os produtos e arredonda o resultado para mostrar só 2 casas decimais
    ROUND((SELECT AVG(valor_total)
     FROM pagamento),2) AS Media_Valor_Recebido;
     

-- Quanto a loja receberia se não oferecesse desconto
SELECT
	SUM(valor_total) AS total_com_desconto,
    SUM(desconto) AS desconto,
    SUM(valor_total-desconto)  AS total_sem_desconto
FROM pagamento;
    

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;   -- volta a validar as foreign keys
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
