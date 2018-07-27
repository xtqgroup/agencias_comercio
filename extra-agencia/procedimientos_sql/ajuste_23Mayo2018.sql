-----------------alter
ALTER TABLE comprobante  ALTER COLUMN pbase TYPE  numeric(12,2);
ALTER TABLE comprobante  ALTER COLUMN exonerado TYPE  numeric(12,2);
ALTER TABLE comprobante  ALTER COLUMN igv TYPE  numeric(12,2);
ALTER TABLE comprobante  ALTER COLUMN total TYPE  numeric(12,2);

ALTER TABLE comprobante_linea  ALTER COLUMN p_pauta TYPE  numeric(12,2);
ALTER TABLE comprobante_linea  ALTER COLUMN pbase TYPE  numeric(12,2);
ALTER TABLE comprobante_linea  ALTER COLUMN exonerado TYPE  numeric(12,2);
ALTER TABLE comprobante_linea  ALTER COLUMN igv TYPE  numeric(12,2);
ALTER TABLE comprobante_linea  ALTER COLUMN total TYPE  numeric(12,2);

ALTER TABLE ticket_liquidacion  ALTER COLUMN pbase TYPE  numeric(12,2);
ALTER TABLE ticket_liquidacion  ALTER COLUMN exonerado TYPE  numeric(12,2);
ALTER TABLE ticket_liquidacion  ALTER COLUMN igv TYPE  numeric(12,2);
ALTER TABLE ticket_liquidacion  ALTER COLUMN total TYPE  numeric(12,2);
