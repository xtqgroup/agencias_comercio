-- Function: fnc_limpiar_ticket()

-- DROP FUNCTION fnc_limpiar_ticket();

CREATE OR REPLACE FUNCTION fnc_limpiar_ticket()
  RETURNS void AS
$BODY$
DECLARE
BEGIN
	truncate ticket_input;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION fnc_limpiar_ticket()
  OWNER TO odoo;
