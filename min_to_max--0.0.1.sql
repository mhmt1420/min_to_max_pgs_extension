CREATE OR REPLACE FUNCTION min_to_max_trans_numeric(agg numeric[], val numeric)
RETURNS numeric[]
LANGUAGE plpgsql
AS $$
BEGIN
    IF agg[1] IS NULL OR val < agg[1] THEN
        agg[1] = val;
    END IF;
    IF agg[2] IS NULL OR val > agg[2] THEN
        agg[2] = val;
    END IF;
    RETURN agg;
END;
$$;

CREATE OR REPLACE FUNCTION get_min_to_max_numeric_fin(cagg numeric[])
RETURNS text
LANGUAGE plpgsql
AS $$
DECLARE
    agg numeric[] = '{NULL,NULL}';
BEGIN
    IF cagg[1] IS NOT NULL THEN
        agg[1] = cagg[1];
        agg[2] = cagg[2];
    END IF;
    RETURN agg[1]::text || ' -> ' || agg[2]::text;
END;
$$;

CREATE AGGREGATE min_to_max(numeric) (
    SFUNC = min_to_max_trans_numeric,
    STYPE = numeric[],
    FINALFUNC = get_min_to_max_numeric_fin,
    INITCOND = '{NULL,NULL}'
);



CREATE OR REPLACE FUNCTION min_to_max_trans_text(agg text[], val text)
RETURNS text[]
LANGUAGE plpgsql
AS $$
BEGIN
    IF agg[1] IS NULL OR val < agg[1] THEN
        agg[1] = val;
    END IF;
    IF agg[2] IS NULL OR val > agg[2] THEN
        agg[2] = val;
    END IF;
    RETURN agg;
END;
$$;

CREATE OR REPLACE FUNCTION get_min_to_max_text_fin(cagg text[])
RETURNS text
LANGUAGE plpgsql
AS $$
DECLARE
    agg text[] = '{NULL,NULL}';
BEGIN
    IF cagg[1] IS NOT NULL THEN
        agg[1] = cagg[1];
        agg[2] = cagg[2];
    END IF;
    RETURN agg[1]::text || ' -> ' || agg[2]::text;
END;
$$;

CREATE AGGREGATE min_to_max(text) (
    SFUNC = min_to_max_trans_text,
    STYPE = text[],
    FINALFUNC = get_min_to_max_text_fin,
    INITCOND = '{NULL,NULL}'
);


CREATE OR REPLACE FUNCTION min_to_max_jsonb_trans(agg jsonb[], val jsonb)
RETURNS jsonb[]
LANGUAGE plpgsql
AS $$
BEGIN
    IF agg[1] IS NULL OR val < agg[1] THEN
        agg[1] = val;
    END IF;
    IF agg[2] IS NULL OR val > agg[2] THEN
        agg[2] = val;
    END IF;
    RETURN agg;
END;
$$;

CREATE OR REPLACE FUNCTION min_to_max_jsonb_final(cagg jsonb[])
RETURNS text
LANGUAGE plpgsql
AS $$
DECLARE
    agg jsonb[] = '{NULL,NULL}';
BEGIN
    IF cagg[1] IS NOT NULL THEN
        agg[1] = cagg[1];
        agg[2] = cagg[2];
    END IF;
    RETURN agg[1]::text || ' -> ' || agg[2]::text;
END;
$$;

CREATE AGGREGATE min_to_max(jsonb) (
    SFUNC = min_to_max_jsonb_trans,
    STYPE = jsonb[],
    FINALFUNC = min_to_max_jsonb_final,
    INITCOND = '{NULL,NULL}'
);