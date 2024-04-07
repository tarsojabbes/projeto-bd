CREATE SEQUENCE paciente_seq
 START WITH     10
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;



CREATE TABLE paciente (
    cpf VARCHAR2(11) PRIMARY KEY,
    email VARCHAR2(100),
    data_nascimento DATE,
    nome VARCHAR2(100),
    sexo CHAR(1),
    rua VARCHAR2(100),
    numero VARCHAR2(10),
    bairro VARCHAR2(100),
    cidade VARCHAR2(100),
    estado CHAR(2),
    CEP VARCHAR2(8)
);