-- Consulta 1: Liste o nome dos convênios que cobrem todos os exames.
SELECT C.NOME
FROM CONVENIO C
WHERE NOT EXISTS (
    SELECT E.CODIGO
    FROM EXAME E
    WHERE NOT EXISTS (
        SELECT 1
        FROM EXAME_PROVIDO EP
        WHERE EP.CODIGO_ANS = C.CODIGO_ANS
        AND EP.CODIGO_EXAME = E.CODIGO
    )
);

-- Consulta 2: 2. Liste o nome e preço dos Exame e o nome do Convênio que oferece, ordenado pelo nome do convênio e o preço do exame de forma crescente.
SELECT 
    C.NOME AS NOME_CONVENIO,
    E.NOME_EXAME,
    EP.PRECO
FROM 
    CONVENIO C
JOIN 
    EXAME_PROVIDO EP ON C.CODIGO_ANS = EP.CODIGO_ANS
JOIN 
    EXAME E ON EP.CODIGO_EXAME = E.CODIGO
ORDER BY 
    C.NOME ASC,
    EP.PRECO ASC;

-- Consulta 3: Liste o nome e o código dos médicos elaboradores e a quantidade de dependentes.
SELECT M.NOME, M.CODIGO, COUNT(D.CODIGO_DEPENDENTE) AS NUM_DEPENDENTES
FROM MEDICO_ELABORADOR M
LEFT JOIN DEPENDENTE D ON M.CODIGO = D.CODIGO_MEDICO_ELABORADOR
GROUP BY M.NOME, M.CODIGO

-- Consulta 4: Liste o nome dos convênios e quantidade de atendimentos, deve ser listado apenas aqueles com número de atendimentos maior que 5.
    SELECT C.NOME AS CONVENIO, COUNT(A.CODIGO) AS QUANTIDADE_ATENDIMENTOS
FROM CONVENIO C
INNER JOIN ATENDIMENTO A ON C.CODIGO_ANS = A.CODIGO_ANS
GROUP BY C.NOME
HAVING COUNT(A.CODIGO) > 5;

-- Consulta 5: Liste o código ans e o nome dos convênios que possuem atendimentos no mês 04/2024.

SELECT c.codigo_ans, c.nome
FROM atendimento atd
JOIN convenio c ON atd.codigo_ans = c.codigo_ans
WHERE EXTRACT(MONTH FROM atd.data_atendimento) = 4
  AND EXTRACT(YEAR FROM atd.data_atendimento) = 2024;

-- Consulta 6: Liste os médicos elaboradores com mais de 2 dependentes.
SELECT M.CODIGO, M.NOME, COUNT(D.CODIGO_DEPENDENTE) AS NUM_DEPENDENTES
FROM MEDICO_ELABORADOR M
LEFT JOIN DEPENDENTE D ON M.CODIGO = D.CODIGO_MEDICO_ELABORADOR
GROUP BY M.CODIGO, M.NOME
HAVING COUNT(D.CODIGO_DEPENDENTE) > 2;

-- Consulta 9: Mostre a quantidade de vezes que cada pagamento foi utilizado por mês.
SELECT 
    TO_CHAR(A.DATA_ATENDIMENTO, 'MM/YYYY') AS MES_ANO,
    FP.FORMA AS FORMA_PAGAMENTO,
    COUNT(FPA.CODIGO_FORMA_PAGAMENTO) AS QUANTIDADE_UTILIZADA
FROM 
    ATENDIMENTO A
JOIN 
    FORMAS_PAGAMENTO_ATENDIMENTO FPA ON A.CODIGO = FPA.CODIGO_ATENDIMENTO
JOIN 
    FORMAS_PAGAMENTO FP ON FPA.CODIGO_FORMA_PAGAMENTO = FP.ID
GROUP BY 
    TO_CHAR(A.DATA_ATENDIMENTO, 'MM/YYYY'),
    FP.FORMA
ORDER BY 
    TO_CHAR(A.DATA_ATENDIMENTO, 'MM/YYYY'),
    QUANTIDADE_UTILIZADA DESC;

