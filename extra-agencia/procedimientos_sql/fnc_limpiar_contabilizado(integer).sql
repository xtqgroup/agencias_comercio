-- Function: public.fnc_limpiar_contabilizado(integer)

-- DROP FUNCTION public.fnc_limpiar_contabilizado(integer);

CREATE OR REPLACE FUNCTION public.fnc_limpiar_contabilizado(idciclo integer)
  RETURNS void AS
$BODY$
DECLARE
/*
 select * from ciclo_facturacion
 select fnc_limpiar_contabilizado(108)
*/
BEGIN
	SET datestyle = "ISO, DMY";
	    update ticket_trans tra
			set co_estado = 'importado'
	    from ticket_liquidacion liq
			where liq.id_pauta = tra.id
			and liq.ciclo_facturacion = idCiclo ;
		delete from ticket_liquidacion where ciclo_facturacion = idCiclo;
		delete from ticket_liquidacion where co_estado <> 'contabilizado';
		delete from comprobante_linea where ciclo_facturacion = idCiclo;
		delete from comprobante where ciclo_facturacion = idCiclo;
		delete  from ciclo_facturacion where id = idCiclo;
		truncate folio_docu;
		insert into folio_docu
		(
		select serie,max(folio) as folio, (select co_agencia from res_partner where id = 1) as co_agencia,ti_documento,1 as activo ,grupo_producto from comprobante
		where fe_emision = (select max(fe_emision::date) from comprobante)
		 group by serie, ti_documento ,grupo_producto order by 1,2 desc,3
		);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.fnc_limpiar_contabilizado(integer)
  OWNER TO odoo;
