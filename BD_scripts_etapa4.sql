
-- Consulta 9
-- tentando alterar o salário para negativo de um médico já existente
UPDATE MEDICO_ELABORADOR
SET SALARIO = -1.0000
WHERE CODIGO = 81 -- código do médico

-- tentando adicionar um médico com salário negativo
DECLARE
    v_medico_id NUMBER;
BEGIN
    FOR i IN 1..2 LOOP
        INSERT INTO MEDICO_ELABORADOR (CODIGO, CPF, CNPJ, CRM_NUMERO, CRM_ESTADO, NOME, ESPECIALIDADE, ENDERECO, TELEFONE, SALARIO, CARGA_HORARIA, DATA_ADMISSAO, DATA_DEMISSAO)
        VALUES (MEDICO_ELABORADOR_SEQ.NEXTVAL, '12345678901', '12345678901234', 'CRM12345', 'SP', 'Dr. João', 'Clínico Geral', 'Rua A', '1234567890', -5000.00, 40, TO_DATE('2024-04-14', 'YYYY-MM-DD'), NULL)
        RETURNING CODIGO INTO v_medico_id;

        FOR j IN 1..ROUND(DBMS_RANDOM.VALUE(0, 5)) LOOP
            INSERT INTO DEPENDENTE (CODIGO_DEPENDENTE, CODIGO_MEDICO_ELABORADOR, NOME, IDADE, SEXO)
            SELECT ROUND(DBMS_RANDOM.VALUE(1, 100)), v_medico_id, 'Dependente_' || j, ROUND(DBMS_RANDOM.VALUE(1, 10)), CASE ROUND(DBMS_RANDOM.VALUE(0, 1)) WHEN 0 THEN 'Masculino' ELSE 'Feminino' END
            FROM DUAL;
        END LOOP;
    END LOOP;
END;