-- Function: public.fnc_contabilizar()

-- DROP FUNCTION public.fnc_contabilizar();

CREATE OR REPLACE FUNCTION public.fnc_contabilizar()
  RETURNS void AS
$BODY$
DECLARE
	idCiclo integer;
BEGIN
	SET datestyle = "ISO, DMY";
	TRUNCATE  tmp_err_ticket; 
	select id into idCiclo 	
	from ciclo_facturacion where co_estado = 'facturado';
	if idciClo > 0 then	
		update ticket_liquidacion 
			set co_estado = 'contabilizado'
			where ciclo_facturacion = idCiclo;
		update comprobante 
			set co_estado = 'contabilizado'
			where ciclo_facturacion = idCiclo;
		update ciclo_facturacion 
		set co_estado = 'contabilizado'
		where id = idCiclo;
--  revisar 5-4-2018
	    update ticket_trans tra
			set co_estado = 'contabilizado'
	    from ticket_liquidacion liq
			where liq.co_estado = 'contabilizado'
			and liq.id_pauta = tra.id
			and liq.ciclo_facturacion = idciClo ;
--
		
	else
		INSERT INTO tmp_err_ticket (codigo,descripcion)
		SELECT -1, 'NO SE ELIMINO FACTURACION,,,No existe ciclo de facturacion en estado facturado';
	end if;
EXCEPTION WHEN others THEN
	INSERT INTO tmp_err_ticket (codigo,descripcion)
	SELECT -1, SQLERRM || ' Error al eliminar factuacion..consulte a soporte ' || SQLSTATE;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.fnc_contabilizar()
  OWNER TO odoo;
