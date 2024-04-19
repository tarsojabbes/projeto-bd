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

