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
    CONSTRAINT pk_cpf_paciente PRIMARY KEY(cpf)
);

CREATE TABLE Fone_paciente (
    cpf VARCHAR2(11),
    numero VARCHAR2(20),
    CONSTRAINT pk_fone_paciente PRIMARY KEY(cpf, numero),
    CONSTRAINT fk_fone_paciente FOREIGN KEY (cpf) REFERENCES Paciente(cpf)
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
    CONSTRAINT pk_codigo_elaborador PRIMARY KEY(codigo)
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
    CONSTRAINT pk_codigo_exame PRIMARY KEY(codigo)
);

-- create Convenio table
CREATE TABLE convenio (
    codigo_ans VARCHAR2(50) NOT NULL,
    codigo_operadora VARCHAR2(50) NOT NULL,
    cnpj VARCHAR2(14) NOT NULL,
    nome VARCHAR2(100) NOT NULL,
    endereco VARCHAR2(200) NOT NULL,
    email VARCHAR2(100) NOT NULL,
    CONSTRAINT pk_codigo_ans_convenio PRIMARY KEY(codigo_ans)
);

CREATE TABLE fone_convenio (
    codigo_ans VARCHAR2(50),
    numero VARCHAR2(11),
    CONSTRAINT pk_fone_convenio PRIMARY KEY(codigo_ans, numero),
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
    CONSTRAINT pk_codigo_requisitante PRIMARY KEY(codigo)
);

-- create FoneMedicoRequisitante table
CREATE TABLE Fone_medico_requisitante (
    codigo NUMBER,
    numero VARCHAR2(11),
    CONSTRAINT pk_fone_medico_requisitante PRIMARY KEY (codigo, numero),
    CONSTRAINT fk_fone_medico_requisitante FOREIGN KEY (codigo) REFERENCES MedicoRequisitante(codigo)
);

-- create RequisitaMedicoRequisitanteExame table
CREATE TABLE Requisita_medico_requisitante_exame (
    codigo NUMBER,
    codigo_exame NUMBER,
    CONSTRAINT pk_requisita_medico PRIMARY KEY (codigo, codigo_exame),
    CONSTRAINT fk_requisita_medico_codigo_medico FOREIGN KEY (codigo) REFERENCES MedicoRequisitante(codigo),
    CONSTRAINT fk_requisita_medico_codigo_exame FOREIGN KEY (codigo_exame) REFERENCES Exame(codigo)
);

-- create ProveExameConvenio table
CREATE TABLE Prove_exame_convenio (
    codigo NUMBER,
    codigo_ANS VARCHAR2(50),
    preco NUMBER,
    CONSTRAINT pk_prove_exame_convenio PRIMARY KEY (codigo, codigo_ANS),
    CONSTRAINT fk_prove_exame_codigo FOREIGN KEY (codigo) REFERENCES Exame(codigo),
    CONSTRAINT fk_prove_convenio_codigo FOREIGN KEY (codigo_ANS) REFERENCES Convenio(codigo_ANS)
);

CREATE SEQUENCE formas_de_pagamento_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE TABLE formas_de_pagamento (
    id NUMBER DEFAULT formas_de_pagamento_seq.nextval,
    forma VARCHAR2(100) NOT NULL,
    CONSTRAINT pk_id_formas_de_pagamento PRIMARY KEY (id)
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
    CONSTRAINT pk_atendimento PRIMARY KEY (codigo),
    CONSTRAINT fk_atendimento_cpf_paciente FOREIGN KEY (cpf) REFERENCES Paciente(cpf), 
    CONSTRAINT fk_atendimento_codigo_medico_requisitante FOREIGN KEY (codigo_medico_requisitante) REFERENCES MedicoRequisitante(codigo),
    CONSTRAINT fk_atendimento_codigo_ans_convenio FOREIGN KEY (codigo_ans) REFERENCES Convenio(codigo_ans),
    hora DATE NOT NULL,
    data_atendimento DATE NOT NULL
);

--create RequereAtendimentoExame table
CREATE TABLE requere_atendimento_exame (
    codigo_atendimento NUMBER,
    codigo_exame NUMBER,
    resultado VARCHAR2(500) NOT NULL,
    timestamp_coleta TIMESTAMP NOT NULL,
    timestamp_liberacao TIMESTAMP NOT NULL,
    preco NUMBER NOT NULL,
    CONSTRAINT pk_requerimento PRIMARY KEY (codigo_atendimento, codigo_exame),
    CONSTRAINT fk_codigo_atendimento_requerimento FOREIGN KEY (codigo_atendimento) REFERENCES Atendimento(codigo),
    CONSTRAINT fk_codigo_exame_requerimento FOREIGN KEY (codigo_exame) REFERENCES Exame(codigo)
);

--create AtendeMedicoRequisitanteConvenio table
CREATE TABLE atende_medico_requisitante_convenio (
    codigo_medico_req NUMBER,
    codigo_ans VARCHAR2(50),
    CONSTRAINT pk_atendimento_medico_convenio PRIMARY KEY (codigo_medico_req, codigo_ans),
    CONSTRAINT fk_codigo_ans_convenio_atendimento FOREIGN KEY (codigo_ans) REFERENCES Convenio(codigo_ans),
    CONSTRAINT fk_codigo_medico_requisitante_atendimento FOREIGN KEY (codigo_medico_req) REFERENCES MedicoRequisitante(codigo)
);

--create EstaAtendimentoFormasPagamento table
CREATE TABLE esta_atendimento_formas_pagamento (
    codigo_atendimento NUMBER,
    id_formas_pagamento NUMBER, 
    valor NUMBER NOT NULL,
    CONSTRAINT pk_atendimento_formas_pagamento PRIMARY KEY (codigo_atendimento, id_formas_pagamento),
    CONSTRAINT fk_codigo_atendimento_valor FOREIGN KEY (codigo_atendimento) REFERENCES Atendimento(codigo),
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
    CONSTRAINT pk_dependente PRIMARY KEY (codigo, codigo_medico_elaborador),
    nome VARCHAR2(100) NOT NULL,
    idade INT NOT NULL,
    sexo CHAR(1) NOT NULL,
    CONSTRAINT fk_dependente_codigo_medico_elaborador FOREIGN KEY(codigo_medico_elaborador) REFERENCES MedicoElaborador(codigo)
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
    CONSTRAINT pk_contrato_paciente_convenio PRIMARY KEY (cpf, codigo_ANS),
    data_expiracao DATE NOT NULL,
    numero VARCHAR2(20) NOT NULL,
    CONSTRAINT fk_contrato_cpf_paciente FOREIGN KEY (cpf) REFERENCES Paciente(cpf),
    CONSTRAINT fk_contrato_codigo_ans_convenio FOREIGN KEY (codigo_ANS) REFERENCES Convenio(codigo_ANS)
);

-- drop all tables and sequences
ALTER TABLE requere_atendimento_exame DROP CONSTRAINT pk_requerimento;
ALTER TABLE requere_atendimento_exame DROP CONSTRAINT fk_codigo_atendimento_requerimento;
ALTER TABLE requere_atendimento_exame DROP CONSTRAINT fk_codigo_exame_requerimento;
ALTER TABLE esta_atendimento_formas_pagamento DROP CONSTRAINT pk_atendimento_formas_pagamento;
ALTER TABLE esta_atendimento_formas_pagamento DROP CONSTRAINT fk_codigo_atendimento_valor;
ALTER TABLE esta_atendimento_formas_pagamento DROP CONSTRAINT fk_codigo_formas_pagamento_atendimento;

ALTER TABLE atendimento DROP CONSTRAINT pk_atendimento;
ALTER TABLE atendimento DROP CONSTRAINT fk_atendimento_cpf_paciente;
ALTER TABLE atendimento DROP CONSTRAINT fk_atendimento_codigo_medico_requisitante;
ALTER TABLE atendimento DROP CONSTRAINT fk_atendimento_codigo_ans_convenio;
ALTER TABLE Fone_medico_requisitante DROP CONSTRAINT pk_fone_medico_requisitante;
ALTER TABLE Fone_medico_requisitante DROP CONSTRAINT fk_fone_medico_requisitante;
ALTER TABLE dependente DROP CONSTRAINT pk_dependente;
ALTER TABLE dependente DROP CONSTRAINT fk_dependente_codigo_medico_elaborador;
ALTER TABLE Contrata_paciente_convenio DROP CONSTRAINT pk_contrato_paciente_convenio;
ALTER TABLE Contrata_paciente_convenio DROP CONSTRAINT fk_contrato_cpf_paciente;
ALTER TABLE contrata_paciente_convenio DROP CONSTRAINT fk_contrato_codigo_ans_convenio;
ALTER TABLE Fone_paciente DROP CONSTRAINT pk_fone_paciente;
ALTER TABLE Fone_paciente DROP CONSTRAINT fk_fone_paciente;
ALTER TABLE Paciente DROP CONSTRAINT pk_cpf_paciente;
ALTER TABLE Requisita_medico_requisitante_exame DROP CONSTRAINT pk_requisita_medico;
ALTER TABLE Requisita_medico_requisitante_exame DROP CONSTRAINT fk_requisita_medico_codigo_medico;
ALTER TABLE Requisita_medico_requisitante_exame DROP CONSTRAINT fk_requisita_medico_codigo_exame;
ALTER TABLE Prove_exame_convenio DROP CONSTRAINT pk_prove_exame_convenio;
ALTER TABLE Prove_exame_convenio DROP CONSTRAINT fk_prove_exame_codigo;
ALTER TABLE Prove_exame_convenio DROP CONSTRAINT fk_prove_convenio_codigo;
ALTER TABLE exame DROP CONSTRAINT fk_codigo_medico_elaborador;
ALTER TABLE exame DROP CONSTRAINT pk_codigo_exame;
ALTER TABLE atende_medico_requisitante_convenio DROP CONSTRAINT pk_atendimento_medico_convenio;
ALTER TABLE atende_medico_requisitante_convenio DROP CONSTRAINT fk_codigo_ans_convenio_atendimento;
ALTER TABLE atende_medico_requisitante_convenio DROP CONSTRAINT fk_codigo_medico_requisitante_atendimento;
ALTER TABLE MedicoRequisitante DROP CONSTRAINT pk_codigo_requisitante;
ALTER TABLE MedicoElaborador DROP CONSTRAINT pk_codigo_elaborador;
ALTER TABLE fone_convenio DROP CONSTRAINT pk_fone_convenio;
ALTER TABLE fone_convenio DROP CONSTRAINT fk_codigo_ans_convenio;
ALTER TABLE convenio DROP CONSTRAINT pk_codigo_ans_convenio;
ALTER TABLE formas_de_pagamento DROP CONSTRAINT pk_id_formas_de_pagamento;
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
