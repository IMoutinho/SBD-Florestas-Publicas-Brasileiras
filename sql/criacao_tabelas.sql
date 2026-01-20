-- Arquivo para criação das tabelas (DDL)
-- Comandos CREATE TABLE

CREATE SCHEMA IF NOT EXISTS florestas_publicas;
SET search_path TO florestas_publicas;

-- TABELAS INDEPENDENTES

-- Tabela: Regulamentacao
CREATE TABLE Regulamentacao (
    ato_legal VARCHAR(255) NOT NULL,
    ano_criacao INTEGER,
    CONSTRAINT pk_regulamentacao PRIMARY KEY (ato_legal)
);

-- Tabela: Categoria_Protecao
CREATE TABLE Categoria_Protecao (
    categoria VARCHAR(100) NOT NULL,
    protecao VARCHAR(100),
    CONSTRAINT pk_categoria_protecao PRIMARY KEY (categoria)
);

-- Tabela: Orgao_Governamental
CREATE TABLE Orgao_Governamental (
    orgao VARCHAR(255) NOT NULL,
    governo VARCHAR(100),
    CONSTRAINT pk_orgao_governamental PRIMARY KEY (orgao)
);

-- Tabela: Metricas_Area
CREATE TABLE Metricas_Area (
    area_ha NUMERIC(15,4) NOT NULL,
    shape_area NUMERIC(20,4),
    CONSTRAINT pk_metricas_area PRIMARY KEY (area_ha)
);

-- Tabela: Territorio
CREATE TABLE Territorio (
    geo_codigo VARCHAR(50) NOT NULL,
    municipio VARCHAR(100),
    uf CHAR(2),
    bioma VARCHAR(100),
    CONSTRAINT pk_territorio PRIMARY KEY (geo_codigo)
);

-- TABELA PRINCIPAL

-- Tabela: Unidade
CREATE TABLE Unidade (
    codigo VARCHAR(50) NOT NULL,
    tipo VARCHAR(50),
    comunitario VARCHAR(10), -- Sim ou Não
    sobreposicao VARCHAR(10), -- Sim ou Não
    estagio VARCHAR(50),
    observacao TEXT,
    shape_leng NUMERIC(20,4),

    -- Chaves estrangeiras
    geo_codigo VARCHAR(50),
    area_ha NUMERIC(15,4),

    CONSTRAINT pk_unidade PRIMARY KEY (codigo),
    -- se deletar uma unidade, não deletar os registros relacionados (RESTRICT)
    CONSTRAINT fk_unidade_territorio FOREIGN KEY (geo_codigo) REFERENCES Territorio(geo_codigo) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_unidade_metricas FOREIGN KEY (area_ha) REFERENCES Metricas_Area(area_ha) ON UPDATE CASCADE ON DELETE RESTRICT    
);

-- TABELA DEPENDENTE (Para atributos multivalorados)

-- Tabela: Classe Unidade
CREATE TABLE Classe_Unidade (
    unidade_codigo VARCHAR(50) NOT NULL,
    classe VARCHAR(100) NOT NULL,
    CONSTRAINT pk_classe_unidade PRIMARY KEY (unidade_codigo, classe),
    -- se deletar uma unidade, deletar os registros relacionados (CASCADE)
    CONSTRAINT fk_classe_unidade_unidade FOREIGN KEY (unidade_codigo) REFERENCES Unidade(codigo) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Tabela: Orgão Unidade
CREATE TABLE Orgao_Unidade (
    unidade_codigo VARCHAR(50) NOT NULL,
    orgao VARCHAR(255) NOT NULL,
    CONSTRAINT pk_orgao_unidade PRIMARY KEY (unidade_codigo, orgao),
    -- se deletar uma unidade, deletar os registros relacionados (CASCADE)
    CONSTRAINT fk_orgao_unidade_unidade FOREIGN KEY (unidade_codigo) REFERENCES Unidade(codigo) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_orgao_unidade_orgao FOREIGN KEY (orgao) REFERENCES Orgao_Governamental(orgao) ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Tabela: Categoria Unidade
CREATE TABLE Categoria_Unidade (
    unidade_codigo VARCHAR(50) NOT NULL,
    categoria VARCHAR(100) NOT NULL,
    CONSTRAINT pk_categoria_unidade PRIMARY KEY (unidade_codigo, categoria),
    -- se deletar uma unidade, deletar os registros relacionados (CASCADE)
    CONSTRAINT fk_categoria_unidade_unidade FOREIGN KEY (unidade_codigo) REFERENCES Unidade(codigo) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_categoria_unidade_categoria FOREIGN KEY (categoria) REFERENCES Categoria_Protecao(categoria) ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Tabela: Ato Legal Unidade
CREATE TABLE Ato_Legal_Unidade (
    unidade_codigo VARCHAR(50) NOT NULL,
    ato_legal VARCHAR(255) NOT NULL,
    CONSTRAINT pk_ato_legal_unidade PRIMARY KEY (unidade_codigo, ato_legal),
    -- se deletar uma unidade, deletar os registros relacionados (CASCADE)
    CONSTRAINT fk_ato_legal_unidade_unidade FOREIGN KEY (unidade_codigo) REFERENCES Unidade(codigo) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_ato_legal_unidade_regulamentacao FOREIGN KEY (ato_legal) REFERENCES Regulamentacao(ato_legal) ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Tabela: Nome Unidade
CREATE TABLE Nome_Unidade (
    unidade_codigo VARCHAR(50) NOT NULL,
    nome VARCHAR(255) NOT NULL,
    CONSTRAINT pk_nome_unidade PRIMARY KEY (unidade_codigo, nome),
    -- se deletar uma unidade, deletar os registros relacionados (CASCADE)
    CONSTRAINT fk_nome_unidade_unidade FOREIGN KEY (unidade_codigo) REFERENCES Unidade(codigo) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Tabela: Data da Criação da Unidade
CREATE TABLE Data_Criacao_Unidade (
    unidade_codigo VARCHAR(50) NOT NULL,
    data_criacao DATE NOT NULL,
    CONSTRAINT pk_data_criacao_unidade PRIMARY KEY (unidade_codigo, data_criacao),
    -- se deletar uma unidade, deletar os registros relacionados (CASCADE)
    CONSTRAINT fk_data_criacao_unidade_unidade FOREIGN KEY (unidade_codigo) REFERENCES Unidade(codigo) ON UPDATE CASCADE ON DELETE CASCADE
);

