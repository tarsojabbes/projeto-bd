-- Consulta 1: Crie uma view que lista todos os atendimentos realizados no ano de 2024, assim como as informações do paciente atendido e do médico requisitante.
CREATE VIEW ATENDIMENTOS_2024_VIEW AS
SELECT 
    A.CODIGO AS CODIGO_ATENDIMENTO,
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


/* Consulta 6: Crie uma procedure chamada “remove_exame_paciente”, que recebe o cpf de um paciente e o código de um exame e remove este exame do sistema, 
verificando antes se o exame de fato foi realizado pelo paciente de cpf informado. */
CREATE OR REPLACE PROCEDURE remove_exame_paciente (p_cpf_paciente IN CHAR, p_codigo_exame IN INTEGER)
IS	
    v_exame_encontrado NUMBER := 0;
BEGIN
	SELECT COUNT(*) INTO v_exame_encontrado
    FROM EXAME_REQUERIDO_ATENDIMENTO E, ATENDIMENTO A
    WHERE A.CODIGO = E.CODIGO_ATENDIMENTO AND 
        A.CPF_PACIENTE = p_cpf_paciente AND
	    E.CODIGO_EXAME = p_codigo_exame;

    IF  v_exame_encontrado > 0 THEN

        DELETE FROM EXAME_REQUERIDO_ATENDIMENTO
        WHERE CODIGO_ATENDIMENTO IN (
            SELECT A.CODIGO
            FROM EXAME_REQUERIDO_ATENDIMENTO E, ATENDIMENTO A
            WHERE A.CODIGO = E.CODIGO_ATENDIMENTO AND 
                A.CPF_PACIENTE = p_cpf_paciente AND
                E.CODIGO_EXAME = p_codigo_exame
        );

	    DELETE FROM EXAME
	    WHERE CODIGO = p_codigo_exame;
	
	    DBMS_OUTPUT.PUT_LINE('Exame removido com sucesso.');
    ELSE
       		DBMS_OUTPUT.PUT_LINE('O exame não foi encontrado para o paciente informado.');
   	END IF;
EXCEPTION
        WHEN NO_DATA_FOUND THEN
        		DBMS_OUTPUT.PUT_LINE('O paciente ou o exame não foram encontrados.');
    	WHEN OTHERS THEN
        		DBMS_OUTPUT.PUT_LINE('Ocorreu um erro ao remover o exame.');
END;

-- Consulta 10: Crie um trigger que verifica se o email de um médico elaborador é válido (possui um caractere ‘@’), sempre que um médico elaborador for adicionado.
CREATE TRIGGER verifica_email_medico_elaborador
BEFORE INSERT ON MEDICO_ELABORADOR
FOR EACH ROW
DECLARE
    v_email_valido NUMBER;
BEGIN
    IF :NEW.EMAIL IS NOT NULL THEN
        v_email_valido := INSTR(:NEW.EMAIL, '@');
        IF v_email_valido = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'O email do médico elaborador deve conter o caractere "@".');
        END IF;
    END IF;
END;
/

