--DROPANDO TODAS AS TABELAS
DROP TABLE tb_CATEGORIA CASCADE CONSTRAINT;
DROP TABLE tb_TIPO_CHAMADO CASCADE CONSTRAINT;
DROP TABLE tb_CLIENTE CASCADE CONSTRAINT;
DROP TABLE tb_SEXO CASCADE CONSTRAINT;
DROP TABLE tb_CLIENTE_FISICO CASCADE CONSTRAINT;
DROP TABLE tb_CLIENTE_JURIDICO CASCADE CONSTRAINT;
DROP TABLE tb_DEPARTAMENTO CASCADE CONSTRAINT;
DROP TABLE tb_FUNCIONARIO CASCADE CONSTRAINT;
DROP TABLE tb_STATUS CASCADE CONSTRAINT;
DROP TABLE tb_LOG_CLIENTE CASCADE CONSTRAINT;
DROP TABLE tb_PRODUTO CASCADE CONSTRAINT;
DROP TABLE tb_VIDEO CASCADE CONSTRAINT;
DROP TABLE tb_VISUALIZACAO CASCADE CONSTRAINT;
DROP TABLE tb_CHAMADO CASCADE CONSTRAINT;
DROP TABLE tb_CLASSIFICACAO CASCADE CONSTRAINT;
DROP SEQUENCE "RM551834"."SEQUECE_CD_PRODUTO";
DROP SEQUENCE "RM551834"."SEQUENCE_CD_CATEGORIA";
DROP SEQUENCE "RM551834"."SEQUENCE_CD_CHAMADO";

-- TABELA SEXO
CREATE TABLE tb_sexo(
cd_sexo NUMBER(5) PRIMARY KEY,
dsc_sexo VARCHAR(30) NOT NULL
);

-- TABELA CLIENTE FISICO
CREATE TABLE tb_cliente_fisico (
cd_cliente_fisico NUMBER(5)PRIMARY KEY,
fk_cd_sexo NUMBER(5),
FOREIGN KEY(fk_cd_sexo)
REFERENCES tb_sexo (cd_sexo),
avaliacao_cliente NUMBER(5),
cpf_cliente NUMBER(11) UNIQUE,
nm_cliente VARCHAR(30) NOT NULL,
numero_cliente NUMBER(12)NOT NULL,
dt_nascimento_cliente DATE NOT NULL,
genero_nascimento_cliente VARCHAR(20) NOT NULL,
login_cliente_fisico VARCHAR(20) NOT NULL,
senha_cliente_fisico VARCHAR(80) NOT NULL
);

ALTER TABLE tb_cliente_fisico ADD CONSTRAINT check_genero CHECK(genero_nascimento_cliente in('M', 'F'));

--TABELA CLIENTE JURIDICO
CREATE TABLE tb_cliente_juridico (
cd_cliente_juridico NUMBER(5) PRIMARY KEY,
nm_fantasia VARCHAR(100) NOT NULL,
qtd_estrela NUMBER(2),
telefone_cliente_juridico NUMBER(12) NULL,
dt_fundacao DATE,
cnpj_cliente_juridico NUMBER(14) UNIQUE NULL,
inscricao_cliente_juridico NUMBER(9) NULL,
login_cliente_juridico VARCHAR(20) NOT NULL,
senha_cliente_juridico VARCHAR(80) NOT NULL
);

--TABELA STATUS
CREATE TABLE tb_status (
cd_status NUMBER(5) PRIMARY KEY,
dsc_status VARCHAR(30),
sigla_status CHAR(1)
);

--TABELA CLIENTE
CREATE TABLE tb_cliente (
cd_cliente NUMBER(5) PRIMARY KEY,
fk_cd_cliente_fisico NUMBER(5),
FOREIGN KEY(fk_cd_cliente_fisico)
REFERENCES tb_cliente_fisico (cd_cliente_fisico),
fk_cd_cliente_juridico NUMBER(5),
FOREIGN KEY(fk_cd_cliente_juridico)
REFERENCES tb_cliente_juridico (cd_cliente_juridico),
fk_cd_status NUMBER(5),
FOREIGN KEY(fk_cd_status)
REFERENCES tb_status (cd_status)
);

--TABELA DEPARTAMENTO
CREATE TABLE tb_departamento (
cd_departamento NUMBER(5) PRIMARY KEY,
nm_departamento VARCHAR(20),
sigla_departamento VARCHAR(10)
);

--CRIANDO A SEQUENCIA DO CHAMADO
CREATE SEQUENCE sequence_cd_chamado
START WITH 1
INCREMENT BY 1
MAXVALUE 99999
NOCACHE
CYCLE;

--TABELA TIPO DE CHAMADO
CREATE TABLE tb_tipo_chamado (
cd_tipo_chamado NUMBER(5) PRIMARY KEY,
dsc_chamado VARCHAR(30),
sigla_chamado CHAR(1)
);

--TABELA FUNCIONARIO
CREATE TABLE tb_funcionario (
cd_funcionario NUMBER(5) PRIMARY KEY,
fk_cd_departamento NUMBER(5) NOT NULL,
FOREIGN KEY(fk_cd_departamento)
REFERENCES tb_departamento (cd_departamento),
cpf_funcionario NUMBER(11)UNIQUE NOT NULL,
nm_funcionario VARCHAR(50) NOT NULL,
dt_nascimento_funcionario DATE,
tel_funcionario NUMBER(12) NOT NULL,
email_funcionario VARCHAR(30) NOT NULL
);

--TABELA CHAMADO
CREATE TABLE tb_chamado (
cd_chamado NUMBER(10) PRIMARY KEY,
fk_cd_status NUMBER(1) NOT NULL,
FOREIGN KEY(fk_cd_status)
REFERENCES tb_status (cd_status),
fk_cd_funcionario NUMBER(5) NOT NULL,
FOREIGN KEY(fk_cd_funcionario)
REFERENCES tb_funcionario (cd_funcionario),
fk_cd_cliente NUMBER(5) NOT NULL,
FOREIGN KEY(fk_cd_cliente)
REFERENCES tb_cliente (cd_cliente),
fk_cd_tipo_chamado NUMBER(5),
FOREIGN KEY(fk_cd_tipo_chamado)
REFERENCES tb_tipo_chamado (cd_tipo_chamado),
classificado_chamado VARCHAR(20) NOT NULL,
dsc_chamado VARCHAR(4000),
dt_abertura_chamado TIMESTAMP NOT NULL,
dt_atendimento_chamado TIMESTAMP NULL,
dt_conclusao_antendimento TIMESTAMP NULL,
satisfacao_status NUMBER(2) NOT NULL,
qtq_hrs_atendimento TIMESTAMP NULL
);

ALTER TABLE tb_chamado ADD CONSTRAINT check_chamado CHECK(classificado_chamado in('1 Sugestão', '2 Reclamação'));

--CRIANDO A SEQUENCIA CATEGORIA
CREATE SEQUENCE sequence_cd_categoria
START WITH 1
INCREMENT BY 1
MAXVALUE 99999
NOCACHE
NOCYCLE;

--CRIANDO A TABELA CATEGORIA  
CREATE TABLE tb_categoria (
cd_categoria NUMBER(5) PRIMARY KEY,
cd_status_categoria CHAR(1) NOT NULL,
dsc_categoria VARCHAR(20) UNIQUE NOT NULL,
inicio_categoria DATE NOT NULL,
termino_categoria DATE NULL
);

ALTER TABLE tb_categoria ADD CONSTRAINT check_categoria CHECK(cd_status_categoria in('A', 'I'));

--CRIANDO TABELA CLASSIFICACAO
CREATE TABLE tb_classificacao(
cd_classificacao NUMBER(5) PRIMARY KEY,
nm_classificacao VARCHAR(300)
);

-- CRIANDO TABELA VISUALIZACAO
CREATE TABLE tb_visualizacao (
cd_visualizacao NUMBER(5) PRIMARY KEY,
data_hr_visualizacao TIMESTAMP NOT NULL
);

-- CRIANDO TABELA VIDEO
CREATE TABLE tb_video(
cd_video NUMBER(5) PRIMARY KEY,
fk_cd_visualizacao NUMBER(4),
FOREIGN KEY(fk_cd_visualizacao)
REFERENCES tb_visualizacao (cd_visualizacao),
fk_cd_classificacao NUMBER(5),
FOREIGN KEY(fk_cd_classificacao)
REFERENCES tb_classificacao (cd_classificacao),
cd_status_video CHAR(1), 
dsc_video VARCHAR(50),
link_video BLOB NOT NULL
);

ALTER TABLE tb_video ADD CONSTRAINT check_video CHECK(cd_status_video in('A', 'I'));

--CRIANDO SEQUENCE PRODUTO
CREATE SEQUENCE sequece_cd_produto
START WITH 1
INCREMENT BY 1
MAXVALUE 99999
NOCACHE
CYCLE;

--CRIANDO TABELA PRODUTO
CREATE TABLE tb_produto (
cd_produto NUMBER(5) PRIMARY KEY,
fk_cd_status NUMBER(5),
FOREIGN KEY(fk_cd_status)
REFERENCES tb_status (cd_status),
fk_cd_visualizacao NUMBER(5),
FOREIGN KEY(fk_cd_visualizacao)
REFERENCES tb_visualizacao (cd_visualizacao),
fk_cd_video NUMBER(5),
FOREIGN KEY(fk_cd_video)
REFERENCES tb_video (cd_video),
dsc_normal_produto VARCHAR(20) UNIQUE NOT NULL,
desc_completal_produto VARCHAR(500) NOT NULL,
preco_produto NUMBER(12,2) NOT NULL,
codigo_barras_produto VARCHAR(13) NULL
);


--CRIANDO TABELA LOG CLIENTE
CREATE TABLE tb_log_cliente (
cd_log_cliente NUMBER(5)PRIMARY KEY,
fk_cd_cliente NUMBER(5) NOT NULL,
FOREIGN KEY(fk_cd_cliente)
REFERENCES tb_cliente (cd_cliente),
fk_cd_visualizacao NUMBER(5) NOT NULL,
FOREIGN KEY(fk_cd_visualizacao)
REFERENCES tb_visualizacao (cd_visualizacao),
fk_cd_prdoduto NUMBER(5) NOT NULL,
FOREIGN KEY(fk_cd_prdoduto)
REFERENCES tb_produto(cd_produto),
fk_cd_video NUMBER(5) NOT NULL,
FOREIGN KEY(fk_cd_video)
REFERENCES tb_video(cd_video)
);

--INSERTS TABLES:

--INSERT TB SEXO
INSERT INTO tb_sexo(cd_sexo, dsc_sexo) VALUES(1, 'Masculino');
INSERT INTO tb_sexo(cd_sexo, dsc_sexo) VALUES(2, 'Feminino');
INSERT INTO tb_sexo(cd_sexo, dsc_sexo) VALUES(3, 'Neutro');

--INSERT TB CLIENTE FISICO
INSERT INTO tb_cliente_fisico (cd_cliente_fisico, fk_cd_sexo, cpf_cliente, avaliacao_cliente, nm_cliente, numero_cliente, dt_nascimento_cliente, genero_nascimento_cliente, login_cliente_fisico, senha_cliente_fisico)
VALUES(1, 1, 12345678911, 10, 'FLEIPE', '119545394781','01011995', 'M', 'felipe', '1234');

INSERT INTO tb_cliente_fisico (cd_cliente_fisico, fk_cd_sexo, cpf_cliente, avaliacao_cliente, nm_cliente, numero_cliente, dt_nascimento_cliente, genero_nascimento_cliente, login_cliente_fisico, senha_cliente_fisico)
VALUES(2, 2, 12345678912, 10, 'Marcela', '119545394781','01011995', 'F', 'marcela', '1234');

INSERT INTO tb_cliente_fisico (cd_cliente_fisico, fk_cd_sexo, cpf_cliente, avaliacao_cliente,  nm_cliente, numero_cliente, dt_nascimento_cliente, genero_nascimento_cliente, login_cliente_fisico, senha_cliente_fisico)
VALUES(3, 3, 12345678913, 10, 'Bruno', '119545394781','01011995', 'M', 'bruno', '1234');

--INSERT TB CLIENTE JURIDICO
INSERT INTO tb_cliente_juridico (cd_cliente_juridico, nm_fantasia, qtd_estrela, telefone_cliente_juridico, dt_fundacao, cnpj_cliente_juridico, inscricao_cliente_juridico, login_cliente_juridico, senha_cliente_juridico)
VALUES(1, 'CHURROS', 5, 111234567890, '01011956', 1234567891011, 123456789, 'churros', 'creme');

INSERT INTO tb_cliente_juridico (cd_cliente_juridico, nm_fantasia, qtd_estrela, telefone_cliente_juridico, dt_fundacao, cnpj_cliente_juridico, inscricao_cliente_juridico, login_cliente_juridico, senha_cliente_juridico)
VALUES(2, 'FIAP', 9, 111234567890, '01011990', 2234567891011, 223456789, 'FIAP', 'ON');

INSERT INTO tb_cliente_juridico (cd_cliente_juridico, nm_fantasia, qtd_estrela, telefone_cliente_juridico, dt_fundacao, cnpj_cliente_juridico, inscricao_cliente_juridico, login_cliente_juridico, senha_cliente_juridico)
VALUES(3, 'LITTLE GARGOS', 10, 131234567890, '01012020', 3334567891011, 313456789, 'FELIPE', 'DOG');

--INSERT TB STATUS
INSERT INTO tb_status (cd_status, dsc_status, sigla_status) VALUES (1, 'Ativo', 'A');
INSERT INTO tb_status (cd_status, dsc_status, sigla_status) VALUES (2, 'Inativo', 'I');
INSERT INTO tb_status (cd_status, dsc_status, sigla_status) VALUES (3, 'Excluido', 'E');

--INSERT TB CLIENTE
INSERT INTO tb_cliente (cd_cliente, fk_cd_cliente_fisico, fk_cd_cliente_juridico, fk_cd_status) VALUES (1, 1, 1, 1);
INSERT INTO tb_cliente (cd_cliente, fk_cd_cliente_fisico, fk_cd_cliente_juridico, fk_cd_status) VALUES (2, 2, 2, 2);
INSERT INTO tb_cliente (cd_cliente, fk_cd_cliente_fisico, fk_cd_cliente_juridico, fk_cd_status) VALUES (3, 3, 3, 3);

--INSERT TB DEPARTAMENTO
INSERT INTO tb_departamento (cd_departamento, nm_departamento, sigla_departamento) VALUES (1, 'Administrador', 'ADM');
INSERT INTO tb_departamento (cd_departamento, nm_departamento, sigla_departamento) VALUES (2, 'Financeiro', 'FINAN');
INSERT INTO tb_departamento (cd_departamento, nm_departamento, sigla_departamento) VALUES (3, 'Recursos Humanos', 'RH');

--INSERT TB TIPO DE CHAMADO
INSERT INTO tb_tipo_chamado (cd_tipo_chamado, dsc_chamado, sigla_chamado) VALUES (1, 'Aberto', 'A');
INSERT INTO tb_tipo_chamado (cd_tipo_chamado, dsc_chamado, sigla_chamado) VALUES (2, 'Em atendimento', 'E');
INSERT INTO tb_tipo_chamado (cd_tipo_chamado, dsc_chamado, sigla_chamado) VALUES (3, 'cancelado', 'C');

--INSERT TB FUNCIONARIO
INSERT INTO tb_funcionario (cd_funcionario, fk_cd_departamento, cpf_funcionario, nm_funcionario, dt_nascimento_funcionario, tel_funcionario, email_funcionario) 
VALUES (1, 1, 12345678911, 'Airton', '01011207', 11123456789, 'airton@hotmail.com');

INSERT INTO tb_funcionario (cd_funcionario, fk_cd_departamento, cpf_funcionario, nm_funcionario, dt_nascimento_funcionario, tel_funcionario, email_funcionario) 
VALUES (2, 3, 22345678911, 'Jailson', '01011207', 1123456789, 'jailson@hotmail.com');

INSERT INTO tb_funcionario (cd_funcionario, fk_cd_departamento, cpf_funcionario, nm_funcionario, dt_nascimento_funcionario, tel_funcionario, email_funcionario) 
VALUES (3, 2, 32345678911, 'Jorel', '01011207', 11123456789, 'jorel@hotmail.com');

--INSERT TABELA CHAMADO
INSERT INTO tb_chamado (cd_chamado, fk_cd_status, fk_cd_funcionario, fk_cd_cliente, fk_cd_tipo_chamado, classificado_chamado, dsc_chamado, dt_abertura_chamado, 
dt_atendimento_chamado, dt_conclusao_antendimento, satisfacao_status, qtq_hrs_atendimento) 
VALUES (SEQUENCE_CD_CHAMADO.NEXTVAL, 1, 2, 1, 1, '1 Sugestão', 'KDJAKDJSDKASDJAKSDASDKJASKDasdasdasd1231231234', '01012023', '01012023', '', 10, '');

INSERT INTO tb_chamado (cd_chamado, fk_cd_status, fk_cd_funcionario, fk_cd_cliente, fk_cd_tipo_chamado, classificado_chamado, dsc_chamado, dt_abertura_chamado, 
dt_atendimento_chamado, dt_conclusao_antendimento, satisfacao_status, qtq_hrs_atendimento) 
VALUES (SEQUENCE_CD_CHAMADO.NEXTVAL, 2, 2, 3, 3, '2 Reclamação', 'KDJAKDJSDKASDJAKSDASDKJASKDasdasdasd1231231234', '01012023', '01012023', '', 10, '');

INSERT INTO tb_chamado (cd_chamado, fk_cd_status, fk_cd_funcionario, fk_cd_cliente, fk_cd_tipo_chamado, classificado_chamado, dsc_chamado, dt_abertura_chamado, 
dt_atendimento_chamado, dt_conclusao_antendimento, satisfacao_status, qtq_hrs_atendimento) 
VALUES (SEQUENCE_CD_CHAMADO.NEXTVAL, 3, 2, 3, 3, '1 Sugestão', 'KDJAKDJSDKASDJAKSDASDKJASKDasdasdasd1231231234', '01012023', '01012023', '', 10, '');

--INSERT TABELA CATEGORIA
INSERT INTO tb_categoria (cd_categoria, cd_status_categoria, dsc_categoria, inicio_categoria, termino_categoria) VALUES (SEQUENCE_CD_CATEGORIA.NEXTVAL, 'A', 'Celular', '01011990', '');
INSERT INTO tb_categoria (cd_categoria, cd_status_categoria, dsc_categoria, inicio_categoria, termino_categoria) VALUES (SEQUENCE_CD_CATEGORIA.NEXTVAL, 'A', 'TV', '01011990', '');
INSERT INTO tb_categoria (cd_categoria, cd_status_categoria, dsc_categoria, inicio_categoria, termino_categoria) VALUES (SEQUENCE_CD_CATEGORIA.NEXTVAL, 'A', 'Carro', '01011990', '');

--INSERT TABELA CLASSIFICACAO
INSERT INTO tb_classificacao (cd_classificacao, nm_classificacao) VALUES (1, 'VIDEOS DE GATO');
INSERT INTO tb_classificacao (cd_classificacao, nm_classificacao) VALUES (2, 'VIDEOS DE RATO');
INSERT INTO tb_classificacao (cd_classificacao, nm_classificacao) VALUES (3, 'VIDEOS DE GALINHA');

--INSERT TABELA VISUALIZACAO
INSERT INTO tb_visualizacao (cd_visualizacao, data_hr_visualizacao) VALUES (1, '01011900 00:00:00');
INSERT INTO tb_visualizacao (cd_visualizacao, data_hr_visualizacao) VALUES (2, '01011900 01:00:00');
INSERT INTO tb_visualizacao (cd_visualizacao, data_hr_visualizacao) VALUES (3, '01011900 03:00:00');

--INSERT TABEL VIDEO
INSERT INTO tb_video(cd_video, fk_cd_visualizacao, fk_cd_classificacao, cd_status_video, dsc_video, link_video) 
VALUES (1, 1, 1, 'A', '', '010101010101010101010');

INSERT INTO tb_video(cd_video, fk_cd_visualizacao, fk_cd_classificacao, cd_status_video, dsc_video, link_video) 
VALUES (2, 2, 2, 'I', 'VIDEO ENGRAÇADO', '010101110100101011010101');

INSERT INTO tb_video(cd_video, fk_cd_visualizacao, fk_cd_classificacao, cd_status_video, dsc_video, link_video) 
VALUES (3, 3, 3, 'A', 'VIDEO ENGRAÇADO', '01010010101111001111');

--INSERT TABELA PRODUTOS
INSERT INTO tb_produto (cd_produto,fk_cd_status, fk_cd_visualizacao, fk_cd_video, dsc_normal_produto, desc_completal_produto, preco_produto, codigo_barras_produto)
VALUES (sequece_cd_produto.NEXTVAL, 1, 1, 1, 'QLQPRODUTO1', 'AQUITEM500TÃO', 1111.11, 1234567891234);

INSERT INTO tb_produto (cd_produto,fk_cd_status, fk_cd_visualizacao, fk_cd_video, dsc_normal_produto, desc_completal_produto, preco_produto, codigo_barras_produto)
VALUES (sequece_cd_produto.NEXTVAL, 2, 2, 2, 'QLQPRODUTO2', 'AQUITEM500TÃO', 10000.21, 1234567891234);

INSERT INTO tb_produto (cd_produto,fk_cd_status, fk_cd_visualizacao, fk_cd_video, dsc_normal_produto, desc_completal_produto, preco_produto, codigo_barras_produto)
VALUES (sequece_cd_produto.NEXTVAL, 3, 3, 3, 'QLQPRODUTO3', 'AQUITEM500TÃO', 10203002.20 , '');

--INSERT TABELA LOG CLIENTE
INSERT INTO tb_log_cliente (cd_log_cliente, fk_cd_cliente, fk_cd_visualizacao, fk_cd_prdoduto, fk_cd_video) VALUES (1,1,1,1,1);

INSERT INTO tb_log_cliente (cd_log_cliente, fk_cd_cliente, fk_cd_visualizacao, fk_cd_prdoduto, fk_cd_video) VALUES (2,2,2,2,2);

INSERT INTO tb_log_cliente (cd_log_cliente, fk_cd_cliente, fk_cd_visualizacao, fk_cd_prdoduto, fk_cd_video) VALUES (3,3,3,3,3);