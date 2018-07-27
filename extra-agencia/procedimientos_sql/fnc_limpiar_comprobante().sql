-- Function: public.fnc_limpiar_comprobante()

-- DROP FUNCTION public.fnc_limpiar_comprobante();

CREATE OR REPLACE FUNCTION public.fnc_limpiar_comprobante()
  RETURNS void AS
$BODY$
DECLARE
	idCiclo integer;
BEGIN
	SET datestyle = "ISO, DMY";
	TRUNCATE  tmp_err_ticket; 
	select id into idCiclo 	from ciclo_facturacion where co_estado = 'facturado';
	if idciClo > 0 then	
	    update ticket_trans tra
			set co_estado = 'importado'
	    where co_estado <> 'contabilizado';
		delete from ticket_liquidacion 
			where co_estado <> 'contabilizado';

		update pos_order
			set note = null
			where note = idCiclo::text;
		delete from comprobante_linea where ciclo_facturacion = idCiclo;
		delete from comprobante where ciclo_facturacion = idCiclo;
		delete  from ciclo_facturacion where id = idCiclo and co_estado = 'facturado';
		truncate folio_docu;
		insert into folio_docu
		(
		select serie,max(folio) as folio, (select co_agencia from res_partner where id = 1) as co_agencia,ti_documento,1 as activo ,grupo_producto from comprobante
		where fe_emision = (select max(fe_emision::date) from comprobante)
		 group by serie, ti_documento ,grupo_producto order by 1,2 desc,3
		);
		
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
ALTER FUNCTION public.fnc_limpiar_comprobante()
  OWNER TO odoo;
