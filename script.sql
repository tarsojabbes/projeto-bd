-- create Paciente table
CREATE TABLE paciente (
    cpf VARCHAR2(11) NOT NULL,
    email VARCHAR2(100) NOT NULL,
    data_nascimento DATE NOT NULL,
    nome VARCHAR2(100) NOT NULL,
    sexo CHAR(1) NOT NULL,
    rua VARCHAR2(100) NOT NULL,
    numero VARCHAR2(10) NOT NULL,
    bairro VARCHAR2(100) NOT NULL,
    cidade VARCHAR2(100) NOT NULL,
    estado CHAR(2) NOT NULL,
    CEP VARCHAR2(8) NOT NULL,
    CONSTRAINT PRIMARY KEY(cpf)
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
    codigo NUMBER DEFAULT medicoelb_seq.nextval,
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
    data_demissao DATE,
    CONSTRAINT PRIMARY KEY(codigo)
);

-- create exame sequence
CREATE SEQUENCE exame_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;


-- create Exame table
CREATE TABLE exame (
    codigo NUMBER DEFAULT exame_seq.nextval,
    nome_exame VARCHAR2(200) NOT NULL,
    material_colheita VARCHAR2(200) NOT NULL,
    classe_exame VARCHAR2(200) NOT NULL,
    substancias_usadas VARCHAR2(500) NOT NULL,
    metodo VARCHAR2(200) NOT NULL,
    prazo_exame DATE NOT NULL,
    valores_de_referencia VARCHAR2(200) NOT NULL,
    nota VARCHAR2(500),
    unidade VARCHAR2(200) NOT NULL,
    CONSTRAINT fk_codigo_medico_elaborador FOREIGN KEY (codigo) REFERENCES MedicoElaborador(codigo),
    CONSTRAINT PRIMARY KEY(codigo)
);

-- create Convenio table
CREATE TABLE convenio (
    codigo_ans VARCHAR2(50) NOT NULL,
    codigo_operadora VARCHAR2(50) NOT NULL,
    cnpj VARCHAR2(14) NOT NULL,
    nome VARCHAR2(100) NOT NULL,
    endereco VARCHAR2(200) NOT NULL,
    email VARCHAR2(100) NOT NULL,
    CONSTRAINT PRIMARY KEY(codigo_ans)
);

CREATE TABLE fone_convenio (
    codigo_ans VARCHAR2(50),
    numero VARCHAR2(11),
    CONSTRAINT PRIMARY KEY(codigo_ans, numero),
    CONSTRAINT fk_codigo_ans_convenio FOREIGN KEY (codigo_ans) REFERENCES convenio(codigo_ans)
);

-- create MedicoRequisitante sequence
CREATE SEQUENCE medicoreq_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- create MedicoRequisitante table
CREATE TABLE MedicoRequisitante (
    codigo NUMBER DEFAULT medicoreq_seq.nextval,
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
    cep VARCHAR2(8) NOT NULL,
    CONSTRAINT PRIMARY KEY(codigo)
);

-- create FoneMedicoRequisitante table
CREATE TABLE Fone_medico_requisitante (
    codigo NUMBER,
    numero VARCHAR2(11),
    CONSTRAINT PRIMARY KEY (codigo, numero),
    CONSTRAINT fk_fone_medico_requisitante FOREIGN KEY (codigo) REFERENCES MedicoRequisitante(codigo)
);

-- create RequisitaMedicoRequisitanteExame table
CREATE TABLE Requisita_medico_requisitante_exame (
    codigo NUMBER,
    codigo_exame NUMBER,
    CONSTRAINT PRIMARY KEY (codigo, codigo_exame),
    CONSTRAINT FOREIGN KEY (codigo) REFERENCES MedicoRequisitante(codigo),
    CONSTRAINT FOREIGN KEY (codigo_exame) REFERENCES Exame(codigo)
);

-- create ProveExameConvenio table
CREATE TABLE Prove_exame_convenio (
    codigo NUMBER,
    codigo_ANS VARCHAR2(50),
    preco NUMBER,
    CONSTRAINT PRIMARY KEY (codigo, codigo_ANS),
    CONSTRAINT FOREIGN KEY (codigo) REFERENCES Exame(codigo),
    CONSTRAINT FOREIGN KEY (codigo_ANS) REFERENCES Convenio(codigo_ANS)
);

CREATE SEQUENCE formas_de_pagamento_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE TABLE formas_de_pagamento (
    id NUMBER DEFAULT formas_de_pagamento_seq.nextval,
    forma VARCHAR2(100) NOT NULL,
    CONSTRAINT PRIMARY KEY (id),
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
    CONSTRAINT PRIMARY KEY (codigo),
    CONSTRAINT fk_cpf_paciente FOREIGN KEY (cpf) REFERENCES Paciente(cpf), 
    CONSTRAINT fk_codigo_medico_requisitante FOREIGN KEY (codigo_medico_requisitante) REFERENCES MedicoRequisitante(codigo),
    CONSTRAINT fk_codigo_ans_convenio FOREIGN KEY (codigo_ans) REFERENCES Convenio(codigo_ans),
    hora DATE NOT NULL,
    data_atendimento DATE NOT NULL
);

--create RequereAtendimentoExame table
CREATE TABLE requere_atendimento_exame (
    codigo_atendimento NUMBER,
    codigo_exame NUMBER,
    resultado VARCHAR2(100),
    timestamp_coleta TIMESTAMP,
    timestamp_liberacao TIMESTAMP,
    preco NUMBER,
    CONSTRAINT PRIMARY KEY (codigo_atendimento, codigo_exame),
    CONSTRAINT fk_codigo_atendimento_requerimento FOREIGN KEY (codigo_atendimento) REFERENCES Atendimento(codigo),
    CONSTRAINT fk_codigo_exame_requerimento FOREIGN KEY (codigo_exame) REFERENCES Exame(codigo)
);

--create AtendeMedicoRequisitanteConvenio table
CREATE TABLE atende_medico_requisitante_convenio (
    codigo NUMBER,
    codigo_ans VARCHAR2(50),
    CONSTRAINT PRIMARY KEY (codigo, codigo_ans),
    CONSTRAINT fk_codigo_ans_convenio_atendimento FOREIGN KEY (codigo_ans) REFERENCES Convenio(codigo_ans),
    CONSTRAINT fk_codigo_medico_requisitante_atendimento FOREIGN KEY (codigo) REFERENCES MedicoRequisitante(codigo)
);

--create EstaAtendimentoFormasPagamento table
CREATE TABLE esta_atendimento_formas_pagamento (
    codigo NUMBER,
    id_formas_pagamento NUMBER, 
    valor NUMBER,
    CONSTRAINT PRIMARY KEY (codigo, id_formas_pagamento),
    CONSTRAINT fk_codigo_atendimento_valor FOREIGN KEY (codigo) REFERENCES Atendimento(codigo),
    CONSTRAINT fk_codigo_formas_pagamento_atendimento FOREIGN KEY (id_formas_pagamento) REFERENCES formas_de_pagamento(id)
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
    CONSTRAINT PRIMARY KEY (codigo, codigo_medico_elaborador),
    nome VARCHAR2(100) NOT NULL,
    idade INT NOT NULL,
    sexo CHAR(1) NOT NULL,
    CONSTRAINT fk_codigo_medico_elaborador FOREIGN KEY(codigo_medico_elaborador) REFERENCES MedicoElaborador(codigo)
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
    CONSTRAINT PRIMARY KEY (cpf, codigo_ANS),
    data_expiracao DATE NOT NULL,
    numero VARCHAR2(20) NOT NULL,
    CONSTRAINT fk_cpf_paciente FOREIGN KEY (cpf) REFERENCES Paciente(cpf),
    CONSTRAINT fk_codigo_ans_convenio FOREIGN KEY (codigo_ANS) REFERENCES Convenio(codigo_ANS)
);

-- drop all tables and sequences
DROP TABLE requere_atendimento_exame;
DROP TABLE esta_atendimento_formas_pagamento;
DROP TABLE atendimento;
DROP TABLE Fone_medico_requisitante;
DROP TABLE dependente;
DROP TABLE contrata_paciente_convenio;
DROP TABLE fone_paciente;
DROP TABLE paciente;
DROP TABLE requisita_medico_requisitante_exame;
DROP TABLE Prove_exame_convenio;
DROP TABLE exame;
DROP TABLE atende_medico_requisitante_convenio;
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
