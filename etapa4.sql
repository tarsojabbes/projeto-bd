-- Consulta 1: Crie uma view que lista todos os atendimentos realizados no ano de 2024, assim como as informações do paciente atendido e do médico requisitante.
CREATE VIEW ATENDIMENTOS_2024_VIEW AS
SELECT 
    A.CODIGO AS CODIGO_ATENDIMENTO,
    A.CODIGO_ANS,
    A.DATA_ATENDIMENTO,
    A.CPF_PACIENTE,
    P.NOME AS NOME_PACIENTE,
    P.EMAIL AS EMAIL_PACIENTE,
    P.SEXO AS SEXO_PACIENTE,
    P.DATA_NASCIMENTO AS DATA_NASCIMENTO_PACIENTE,
    P.END_CEP AS END_CEP_PACIENTE,
    P.END_ESTADO AS END_ESTADO_PACIENTE,
    P.END_CIDADE AS END_CIDADE_PACIENTE,
    P.END_BAIRRO AS END_BAIRRO_PACIENTE,
    P.END_NUMERO AS END_NUMERO_PACIENTE,
    P.END_RUA AS END_RUA_PACIENTE,
    A.CODIGO_MEDICO_REQUISITANTE,
    M.NOME AS NOME_MEDICO_REQUISITANTE,
    M.CPF AS CPF_MEDICO_REQUISITANTE,
    M.CNPJ AS CNPJ_MEDICO_REQUISITANTE,
    M.CRM_NUMERO AS CRM_NUMERO_MEDICO_REQUISITANTE,
    M.CRM_ESTADO AS CRM_ESTADO_MEDICO_REQUISITANTE,
    M.ESPECIALIDADE AS ESPECIALIDADE_MEDICO_REQUISITANTE,
    M.END_RUA AS END_RUA_MEDICO_REQUISITANTE,
    M.END_BAIRRO AS END_BAIRRO_MEDICO_REQUISITANTE,
    M.END_CIDADE AS END_CIDADE_MEDICO_REQUISITANTE,
    M.END_ESTADO AS END_ESTADO_MEDICO_REQUISITANTE,
    M.END_CEP AS END_CEP_MEDICO_REQUISITANTE
FROM 
    ATENDIMENTO A
JOIN 
    PACIENTE P ON A.CPF_PACIENTE = P.CPF
JOIN 
    MEDICO_REQUISITANTE M ON A.CODIGO_MEDICO_REQUISITANTE = M.CODIGO
WHERE 
    EXTRACT(YEAR FROM A.DATA_ATENDIMENTO) = 2024;

-- Consulta 2: Crie uma view que liste todos os pacientes que realizaram atendimentos com médicos requisitantes especialistas em ortopedia
CREATE VIEW PACIENTES_ORTOPEDIA_VIEW AS
SELECT DISTINCT P.*
FROM PACIENTE P
JOIN ATENDIMENTO A ON P.CPF = A.CPF_PACIENTE
JOIN MEDICO_REQUISITANTE MR ON A.CODIGO_MEDICO_REQUISITANTE = MR.CODIGO
WHERE MR.ESPECIALIDADE = 'Ortopedia';


-- Consulta 3: Crie uma view que liste todos os médicos elaboradores que possuem CRM no estado de São Paulo, bem como a quantidade de exames que cada um deles realizou, agrupados por especialidade
CREATE VIEW MEDICOS_SAO_PAULO_EXAMES AS
SELECT
    ME.CODIGO AS CODIGO_MEDICO,
    ME.NOME AS NOME_MEDICO,
    ME.ESPECIALIDADE,
    COUNT(EX.CODIGO) AS QUANTIDADE_EXAMES_REALIZADOS
FROM
    MEDICO_ELABORADOR ME,
    EXAME EX
WHERE
    ME.CODIGO = EX.CODIGO_MEDICO_ELABORADOR
    AND ME.CRM_ESTADO = 'São Paulo'
GROUP BY
    ME.CODIGO, ME.NOME, ME.ESPECIALIDADE;

-- Consulta 4: Crie uma view que liste o código e nome dos médicos elaboradores que realizaram exames de método digital, bem como a classe dos exames realizados.
CREATE VIEW MEDICOS_EXAMES_DIGITAIS_VIEW AS
SELECT ME.CODIGO AS CODIGO_MEDICO,
       ME.NOME AS NOME_MEDICO,
       E.CLASSE_EXAME
FROM MEDICO_ELABORADOR ME
JOIN EXAME E ON ME.CODIGO = E.CODIGO_MEDICO_ELABORADOR
WHERE E.METODO = 'Digital';


-- Consulta 5: Crie uma procedure que transfere todos os atendimentos de determinado paciente de um médico requisitante para outro, recebendo o cpf de um paciente, o código de seu médico requisitante atual e o código de seu novo médico.
CREATE OR REPLACE PROCEDURE TRANSFERE_ATENDIMENTOS(
    p_cpf_paciente IN ATENDIMENTO.CPF_PACIENTE%TYPE,
    p_codigo_medico_atual IN INTEGER,
    p_codigo_novo_medico IN INTEGER
)
IS
BEGIN
    UPDATE ATENDIMENTO
    SET CODIGO_MEDICO_REQUISITANTE = p_codigo_novo_medico
    WHERE CPF_PACIENTE = p_cpf_paciente
    AND CODIGO_MEDICO_REQUISITANTE = p_codigo_medico_atual;
END

-- Consulta 6: Crie uma procedure chamada “remove_exame_paciente”, que recebe o cpf de um paciente e o código de um exame e remove este exame do sistema, verificando antes se o exame de fato foi realizado pelo paciente de cpf informado.
CREATE OR REPLACE PROCEDURE remove_exame_paciente (cpfPaciente IN CHAR, codigoExame IN INTEGER)
IS	
    exame_encontrado NUMBER := 0;
BEGIN
	SELECT COUNT(*) INTO exame_encontrado
    FROM EXAME_REQUERIDO_ATENDIMENTO E, ATENDIMENTO A
    WHERE A.CODIGO = E.CODIGO_ATENDIMENTO AND 
        A.CPF_PACIENTE = cpfPaciente AND
	    E.CODIGO_EXAME = codigoExame;

    IF  exame_encontrado > 0 THEN
        DELETE FROM EXAME_REQUERIDO_ATENDIMENTO
        WHERE CODIGO_ATENDIMENTO IN (
            SELECT A.CODIGO
            FROM EXAME_REQUERIDO_ATENDIMENTO E, ATENDIMENTO A
            WHERE A.CODIGO = E.CODIGO_ATENDIMENTO AND 
                A.CPF_PACIENTE = cpfPaciente AND
                E.CODIGO_EXAME = codigoExame
        );
    ELSE
       		RAISE_APPLICATION_ERROR(-20001,'Não encontramos o exame para o paciente informado');
   	END IF;
END;

-- Consulta 7: Crie uma função que receba a data de nascimento de um paciente e calcule a sua idade, considerando a data corrente.
CREATE OR REPLACE FUNCTION CALCULA_IDADE (
    data_nascimento IN DATE
) RETURN NUMBER IS
    idade NUMBER;
BEGIN
    SELECT TRUNC(MONTHS_BETWEEN(SYSDATE, data_nascimento) / 12) INTO idade FROM DUAL;
    RETURN idade;
END;

-- Consulta 8: Crie um trigger que registra a data de admissão sempre que um novo médico elaborador é adicionado no sistema
CREATE OR REPLACE TRIGGER trigger_registrar_data_admissao
BEFORE INSERT ON MEDICO_ELABORADOR
FOR EACH ROW
BEGIN
    :NEW.DATA_ADMISSAO := CURRENT_DATE;
END;


-- Consulta 9: Crie um trigger que verifica se o salário de um médico elaborador é positivo após inserção de um novo médico e de atualização do seu salário.
CREATE OR REPLACE TRIGGER trigger_verifica_salario_medico_elaborador
AFTER INSERT OR UPDATE ON MEDICO_ELABORADOR
FOR EACH ROW
BEGIN
    IF :NEW.SALARIO < 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'O salário precisa ter um valor positivo.');
    END IF;
END;


-- Consulta 10: Crie um trigger que verifica se um médico requisitante está tentando requisitar um exame para um paciente que não está registrado no mesmo convênio que o médico
CREATE TRIGGER verifica_convenio_medico_paciente
BEFORE INSERT ON EXAME_REQUERIDO_ATENDIMENTO
FOR EACH ROW
DECLARE
    TYPE convenios_medicos IS TABLE OF CONVENIO_MEDICO_REQUISITANTE.CODIGO_ANS%TYPE;
    TYPE convenios_paciente IS TABLE OF PACIENTE_CONVENIO.CODIGO_ANS%TYPE;

    conv_medico convenios_medicos;
    conv_paciente convenios_paciente;
    intersecao BOOLEAN := FALSE;
BEGIN

    SELECT CODIGO_ANS BULK COLLECT INTO conv_medico
    FROM CONVENIO_MEDICO_REQUISITANTE CMR
    WHERE CMR.CODIGO_MEDICO_REQUISITANTE = (
        SELECT CODIGO_MEDICO_REQUISITANTE
        FROM ATENDIMENTO
        WHERE CODIGO = :NEW.CODIGO_ATENDIMENTO
    );

    SELECT CODIGO_ANS BULK COLLECT INTO conv_paciente
    FROM PACIENTE_CONVENIO PC
    WHERE PC.CPF_PACIENTE = (
        SELECT CPF_PACIENTE
        FROM ATENDIMENTO
        WHERE CODIGO = :NEW.CODIGO_ATENDIMENTO
    );

    FOR i IN 1..conv_medico.COUNT LOOP
        FOR j IN 1..conv_paciente.COUNT LOOP
            IF conv_medico(i) = conv_paciente(j) THEN
                intersecao := TRUE;
                EXIT;
            END IF;
        END LOOP;
        IF intersecao THEN
            EXIT;
        END IF;
    END LOOP;

    IF NOT intersecao THEN
        RAISE_APPLICATION_ERROR(-20001, 'Médico e Paciente não são do mesmo convênio');
    END IF;
END;
