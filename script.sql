-- drop all tables and sequences
DROP TABLE atendimento;
DROP TABLE Fone_medico_requisitante;
DROP TABLE dependente;
DROP TABLE contrata_paciente_convenio;
DROP TABLE fone_paciente;
DROP TABLE paciente;
DROP TABLE requisita_medico_requisitante_exame;
DROP TABLE Prove_exame_convenio;
DROP TABLE exame;
DROP TABLE MedicoRequisitante;
DROP TABLE MedicoElaborador;
DROP TABLE fone_convenio;
DROP TABLE convenio;
DROP TABLE formas_de_pagamento;
DROP SEQUENCE exame_seq;
DROP SEQUENCE formas_de_pagamento_seq;
DROP SEQUENCE atendimento_seq;
DROP SEQUENCE dependente_seq;
DROP SEQUENCE contrata_paciente_convenio_seq;
DROP SEQUENCE medicoreq_seq;
DROP SEQUENCE medicoelb_seq;

-- create Paciente table
CREATE TABLE paciente (
    cpf VARCHAR2(11) PRIMARY KEY,
    email VARCHAR2(100) NOT NULL,
    data_nascimento DATE NOT NULL,
    nome VARCHAR2(100) NOT NULL,
    sexo CHAR(1) NOT NULL,
    rua VARCHAR2(100) NOT NULL,
    numero VARCHAR2(10) NOT NULL,
    bairro VARCHAR2(100) NOT NULL,
    cidade VARCHAR2(100) NOT NULL,
    estado CHAR(2) NOT NULL,
    CEP VARCHAR2(8) NOT NULL
);

CREATE TABLE Fone_paciente (
    cpf VARCHAR2(11),
    numero VARCHAR2(20),
    PRIMARY KEY(cpf, numero),
    FOREIGN KEY (cpf) REFERENCES Paciente(cpf)
);

-- create MedicoElaborador sequence
CREATE SEQUENCE medicoelb_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- create MedicoElaborador table
CREATE TABLE MedicoElaborador (
    codigo NUMBER DEFAULT medicoelb_seq.nextval  PRIMARY KEY,
    cpf VARCHAR2(11) NOT NULL,
    cnpj VARCHAR2(14) NOT NULL,
    CRM_numero VARCHAR2(6) NOT NULL,
    CRM_estado VARCHAR2(2) NOT NULL,
    nome VARCHAR2(100) NOT NULL,
    especialidade VARCHAR2(100) NOT NULL,
    endereco VARCHAR2(200) NOT NULL,
    telefone VARCHAR2(11) NOT NULL,
    salario NUMBER(8, 2) NOT NULL,
    carga_horaria NUMBER NOT NULL,
    data_admissao DATE NOT NULL,
    data_demissao DATE
);

-- create exame sequence
CREATE SEQUENCE exame_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;


-- create Exame table
CREATE TABLE exame (
    codigo NUMBER DEFAULT exame_seq.nextval PRIMARY KEY,
    nome_exame VARCHAR2(200) NOT NULL,
    material_colheita VARCHAR2(200) NOT NULL,
    classe_exame VARCHAR2(200) NOT NULL,
    substancias_usadas VARCHAR2(500) NOT NULL,
    metodo VARCHAR2(200) NOT NULL,
    prazo_exame DATE NOT NULL,
    valores_de_referencia VARCHAR2(200) NOT NULL,
    nota VARCHAR2(500),
    unidade VARCHAR2(200) NOT NULL,
    CONSTRAINT fk_codigo_medico_elaborador FOREIGN KEY (codigo) REFERENCES MedicoElaborador(codigo)
);

-- create Convenio table
CREATE TABLE convenio (
    codigo_ans VARCHAR2(50) PRIMARY KEY,
    codigo_operadora VARCHAR2(50),
    cnpj VARCHAR2(14) NOT NULL,
    nome VARCHAR2(100) NOT NULL,
    endereco VARCHAR2(200) NOT NULL,
    email VARCHAR2(100) NOT NULL
);

CREATE TABLE fone_convenio (
    codigo_ans VARCHAR2(50),
    numero VARCHAR2(11),
    PRIMARY KEY(codigo_ans, numero),
    CONSTRAINT fk_codigo_ans_fone_convenio FOREIGN KEY (codigo_ans) REFERENCES convenio(codigo_ans)
);

-- create MedicoRequisitante sequence
CREATE SEQUENCE medicoreq_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- create MedicoRequisitante table
CREATE TABLE MedicoRequisitante (
    codigo NUMBER DEFAULT medicoreq_seq.nextval PRIMARY KEY,
    cpf VARCHAR2(11) NOT NULL,
    cnpj VARCHAR2(14) NOT NULL,
    CRM_numero VARCHAR2(6) NOT NULL,
    CRM_estado VARCHAR2(2) NOT NULL,
    nome VARCHAR2(100) NOT NULL,
    especialidade VARCHAR2(100) NOT NULL,
    rua VARCHAR2(100) NOT NULL,
    bairro VARCHAR2(100) NOT NULL,
    cidade VARCHAR2(100) NOT NULL,
    estado VARCHAR2(20) NOT NULL,
    cep VARCHAR2(8) NOT NULL
);

-- create FoneMedicoRequisitante table
CREATE TABLE Fone_medico_requisitante (
    codigo NUMBER,
    numero VARCHAR2(11),
    PRIMARY KEY (codigo, numero),
    CONSTRAINT fk_medico_requisitante_fone FOREIGN KEY (codigo) REFERENCES MedicoRequisitante(codigo)
);

-- create RequisitaMedicoRequisitanteExame table
CREATE TABLE Requisita_medico_requisitante_exame (
    codigo NUMBER,
    codigo_exame NUMBER,
    PRIMARY KEY (codigo, codigo_exame),
    FOREIGN KEY (codigo) REFERENCES MedicoRequisitante(codigo),
    FOREIGN KEY (codigo_exame) REFERENCES Exame(codigo)
);

-- create ProveExameConvenio table
CREATE TABLE Prove_exame_convenio (
    codigo NUMBER,
    codigo_ANS VARCHAR2(50),
    preco NUMBER,
    PRIMARY KEY (codigo, codigo_ANS),
    FOREIGN KEY (codigo) REFERENCES Exame(codigo),
    FOREIGN KEY (codigo_ANS) REFERENCES Convenio(codigo_ANS)
);

CREATE SEQUENCE formas_de_pagamento_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE TABLE formas_de_pagamento (
    id NUMBER DEFAULT formas_de_pagamento_seq.nextval PRIMARY KEY,
    forma VARCHAR2(100) NOT NULL
);

-- create atendimento sequence
CREATE SEQUENCE atendimento_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;


-- create Atendimento table
CREATE TABLE atendimento (
    codigo NUMBER DEFAULT atendimento_seq.nextval,
    cpf VARCHAR2(11),
    codigo_medico_requisitante NUMBER,
    codigo_ans VARCHAR2(50),
    PRIMARY KEY (codigo, cpf, codigo_medico_requisitante, codigo_ans),
    CONSTRAINT fk_cpf_paciente FOREIGN KEY (cpf) REFERENCES Paciente(cpf), 
    CONSTRAINT fk_codigo_medico_requisitante FOREIGN KEY (codigo_medico_requisitante) REFERENCES MedicoRequisitante(codigo),
    CONSTRAINT fk_codigo_ans_convenio FOREIGN KEY (codigo_ans) REFERENCES Convenio(codigo_ans),
    hora DATE NOT NULL,
    data_atendimento DATE NOT NULL
);

-- create dependente sequence
CREATE SEQUENCE dependente_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- create Dependente table
CREATE TABLE dependente (
    codigo NUMBER DEFAULT dependente_seq.nextval,
    codigo_medico_elaborador NUMBER,
    PRIMARY KEY (codigo, codigo_medico_elaborador),
    nome VARCHAR2(100) NOT NULL,
    idade INT NOT NULL,
    sexo CHAR(1) NOT NULL,
    CONSTRAINT fk_dep_codigo_medico_elaborador FOREIGN KEY(codigo_medico_elaborador) REFERENCES MedicoElaborador(codigo)
);

-- create contrata_paciente_convenio sequence
CREATE SEQUENCE contrata_paciente_convenio_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE TABLE Contrata_paciente_convenio (
    cpf VARCHAR2(11),
    codigo_ANS VARCHAR2(20),
    PRIMARY KEY (cpf, codigo_ANS),
    data_expiracao DATE NOT NULL,
    numero VARCHAR2(20) NOT NULL,
    FOREIGN KEY (cpf) REFERENCES Paciente(cpf),
    FOREIGN KEY (codigo_ANS) REFERENCES Convenio(codigo_ANS)
);
