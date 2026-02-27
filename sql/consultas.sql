-- Arquivo para consultas SQL
-- Comandos SELECT


-- Relatório de unidades que já possuem ato legal e ano de criação listando nome, ato legal e ano de criação em ordem decrescente de ano.

SELECT n.nome AS unidade, r.ato_legal, r.ano_criacao
FROM Unidade u
JOIN Nome_Unidade n ON u.codigo = n.unidade_codigo
JOIN Ato_Legal_Unidade a ON u.codigo = a.unidade_codigo
JOIN Regulamentacao r ON a.ato_legal = r.ato_legal
ORDER BY r.ano_criacao DESC;

-- Quantas florestas não foram regulamentadas na última década?
SELECT n.nome AS unidade, r.ano_criacao
FROM Unidade u
JOIN Nome_Unidade n ON u.codigo = n.unidade_codigo
JOIN Ato_Legal_Unidade a ON u.codigo = a.unidade_codigo
JOIN Regulamentacao r ON a.ato_legal = r.ato_legal
WHERE r.ano_criacao < 2016
ORDER BY r.ano_criacao ASC;

-- Quantas unidades estão em estágio crítico (paradas em estudo há pelo menos 10 anos), agrupadas por ano?
SELECT r.ano_criacao, COUNT(u.codigo) AS qtd_unidades_paradas
FROM Unidade u
JOIN Ato_Legal_Unidade a ON u.codigo = a.unidade_codigo
JOIN Regulamentacao r ON a.ato_legal = r.ato_legal
WHERE u.estagio LIKE '%ESTUDO%' AND r.ano_criacao < 2015
GROUP BY r.ano_criacao
ORDER BY r.ano_criacao ASC;

-- Quantas Unidades de Conservação existem por Bioma em ordem decrescente por total de unidades?
SELECT t.bioma, COUNT(u.codigo) AS total_unidades
FROM Unidade u
JOIN Territorio t ON u.geo_codigo = t.geo_codigo
GROUP BY t.bioma
ORDER BY total_unidades DESC;

-- Contagem de unidades agrupadas por ano de criação.
SELECT r.ano_criacao, COUNT(*) AS qtd_criada
FROM Ato_Legal_Unidade a
JOIN Regulamentacao r ON a.ato_legal = r.ato_legal
GROUP BY r.ano_criacao
ORDER BY r.ano_criacao;

-- Quantidade de unidades e área total florestal (soma de hectares) por Estado (UF) em ordem decrescente por area.
SELECT t.uf, COUNT(u.codigo) AS qtd_unidades, SUM(m.area_ha) AS area_total_ha
FROM Unidade u
JOIN Territorio t ON u.geo_codigo = t.geo_codigo
JOIN Metricas_Area m ON u.area_ha = m.area_ha
GROUP BY t.uf
ORDER BY area_total_ha DESC;

-- Quantas florestas cada bioma tem, separado por tipo de proteção.

SELECT t.bioma, cp.protecao, COUNT(*) AS qtd
FROM Unidade u
JOIN Territorio t ON u.geo_codigo = t.geo_codigo
JOIN Categoria_Unidade cuni ON u.codigo = cuni.unidade_codigo
JOIN Categoria_Protecao cp ON cuni.categoria = cp.categoria
GROUP BY t.bioma, cp.protecao
ORDER BY t.bioma;

-- Total de áreas geridas por órgão governamental (agrupado por nome do órgão e estado).
SELECT og.orgao, t.uf, SUM(m.area_ha) AS area_total
FROM Unidade u
JOIN Orgao_Unidade ou ON u.codigo = ou.unidade_codigo
JOIN Orgao_Governamental og ON ou.orgao = og.orgao
JOIN Territorio t ON u.geo_codigo = t.geo_codigo
JOIN Metricas_Area m ON u.area_ha = m.area_ha
GROUP BY og.orgao, t.uf;

-- Quais Biomas possuem a maior média de área por unidade em ordem decrescente?
SELECT t.bioma, AVG(m.area_ha) AS media_area_ha
FROM Unidade u
JOIN Territorio t ON u.geo_codigo = t.geo_codigo
JOIN Metricas_Area m ON u.area_ha = m.area_ha
GROUP BY t.bioma
ORDER BY media_area_ha DESC;

-- Qual tipo de proteção ocupa mais território em ordem decrescente? 
SELECT cp.protecao, COUNT(u.codigo) AS qtd_unidades, SUM(u.area_ha) AS area_total_ha
FROM Unidade u
JOIN Categoria_Unidade cu ON u.codigo = cu.unidade_codigo
JOIN Categoria_Protecao cp ON cu.categoria = cp.categoria
GROUP BY cp.protecao
ORDER BY area_total_ha DESC;

-- Qual é a unidade com a maior área registrada no banco de dados?

SELECT n.nome, t.bioma, m.area_ha
FROM Unidade u
JOIN Nome_Unidade n ON u.codigo = n.unidade_codigo
JOIN Territorio t ON u.geo_codigo = t.geo_codigo
JOIN Metricas_Area m ON u.area_ha = m.area_ha
ORDER BY m.area_ha DESC
LIMIT 1;

-- Listar unidades que são maiores que a média nacional em ordem decrescente de área.
SELECT n.nome, t.bioma, u.area_ha
FROM Unidade u
JOIN Nome_Unidade n ON u.codigo = n.unidade_codigo
JOIN Territorio t ON u.geo_codigo = t.geo_codigo
WHERE u.area_ha > (SELECT AVG(area_ha) FROM Unidade) 
ORDER BY u.area_ha DESC;

SELECT verificarEstagioCritico('FPA-4117602-036-HL-275');

SELECT verificarEstagioCritico('FPA-1300904-034-CS-118');
