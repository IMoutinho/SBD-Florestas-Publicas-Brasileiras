-- PROCEDIMENTOS E GATILHO
-- Verifica se uma unidade está em estágio crítico (criada após 2000, com mais de 100 mil hectares e paralisada em estudo inicial) e retorna um alerta.
CREATE OR REPLACE FUNCTION verificarEstagioCritico(unidade_id TEXT)
RETURNS TEXT AS $$
DECLARE
    v_nome TEXT;
    v_estagio TEXT;
    v_area NUMERIC;
    v_ano INT;
BEGIN
    SELECT n.nome, u.estagio, m.area_ha, EXTRACT(YEAR FROM d.data_criacao)
    INTO v_nome, v_estagio, v_area, v_ano
    FROM Unidade u, Nome_Unidade n, Metricas_Area m, Data_Criacao_Unidade d 
   WHERE  u.codigo = n.unidade_codigo AND u.area_ha = m.area_ha AND u.codigo = d.unidade_codigo AND u.codigo = unidade_id;
    IF v_ano > 2000 AND v_area > 100000 AND v_estagio IN ('Em estudo', 'Delimitada', 'Declarada') THEN
        RETURN 'ALERTA: A Unidade ' || v_nome || ' possui vasta extensão (' || v_area || ' ha) e permanece em estágio inicial de regularização.';
    ELSE
        RETURN 'Status Regular: A unidade não apresenta inconsistências de maturação territorial.';
    END IF;

END $$
LANGUAGE plpgsql;


-- Trigger
CREATE OR REPLACE FUNCTION florestas_publicas.func_valida_coordenadas_brasil()
RETURNS trigger AS $$
BEGIN
    IF NEW.latitude IS NOT NULL AND NEW.longitude IS NOT NULL THEN
        IF (NEW.latitude > 5.5 OR NEW.latitude < -33.8) OR 
           (NEW.longitude > -34.7 OR NEW.longitude < -74.0) THEN
            RAISE EXCEPTION 'Coordenadas inválidas. A unidade % possui latitude (%) e longitude (%) fora dos limites do Brasil.', NEW.codigo, NEW.latitude, NEW.longitude;
        END IF;
    END IF;
    RETURN NEW;
END $$ LANGUAGE plpgsql;


CREATE TRIGGER trg_valida_coordenadas
BEFORE INSERT OR UPDATE ON florestas_publicas.Unidade
FOR EACH ROW
EXECUTE PROCEDURE florestas_publicas.func_valida_coordenadas_brasil();