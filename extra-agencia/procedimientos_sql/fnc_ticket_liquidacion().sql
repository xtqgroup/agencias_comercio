-- Function: public.fnc_ticket_liquidacion()

-- DROP FUNCTION public.fnc_ticket_liquidacion();

CREATE OR REPLACE FUNCTION public.fnc_ticket_liquidacion()
  RETURNS void AS
$BODY$
DECLARE
	tco_estado varchar;
	t_id  bigint;
	tpbase numeric (12,3) = 0;
	tq_vendida numeric;
	tq_devolucion numeric ; 	
	tgrupo_producto varchar;
	ticket_row record;
	idCiclo integer;
	maxfecha date;
	minfecha date;
	tco_agencia varchar;
	flag_fe_emision integer;
	flag_grabar integer;
	tdif_dias integer;
	tid_devolucion integer;
	intervalodias  varchar;
BEGIN
	SET datestyle = "ISO, DMY";
	TRUNCATE tmp_err_ticket;
------- Liquidacion datos SGC
	select max(fe_emision::date), min(fe_emision::date) into maxfecha ,minfecha 
	           from ticket_trans where co_estado = 'importado' ;
	--   Actualizacion de Precios de Excepcion  select * from ticket_trans limit 1 select * from tarifa_excepcion
	update  ticket_trans trans
	set p_pauta = te.p_pauta, tipo_afecto = te.afecto
	from tarifa_excepcion te, product_template pt
	where 
	te.product_id = pt.id
	and pt.co_producto = trans.co_producto
	and te.fe_emision = trans.fe_emision::date
	and trans.fe_emision::date between minfecha and maxfecha;

	for ticket_row in select *  from  ticket_trans where co_estado = 'importado'  LOOP
		tq_devolucion = 0; flag_grabar = 0;  tid_devolucion = 0;
		if ticket_row.tipo_producto = 'EJEMPLARES' then
			tgrupo_producto = '1';
			tdif_dias = maxfecha - ticket_row.fe_emision::date;
			if ticket_row.co_producto = '000000000000700039' then
				intervalodias = '3 days';
			else
				intervalodias = '1 days';			
			end if;
			if (ticket_row.co_producto = '000000000000700039' and tdif_dias >= 3) or (ticket_row.co_producto <> '000000000000700039' and tdif_dias >= 1) then
				select coalesce(id,0), coalesce(ti.q_devolucion, 0) into tid_devolucion, tq_devolucion from ticket_trans ti
				where ti.co_canilla = ticket_row.co_canilla
				and ti.co_producto_devolver = ticket_row.co_producto
				and ti.fe_emision::date  = cast(ticket_row.fe_emision::date + CAST(intervalodias AS INTERVAL) as date);
				raise notice '%' , intervalodias;
				flag_grabar = 1;
				if tid_devolucion = 0 then
					tid_devolucion = ticket_row.id;
				end if;
			end if;
		end if;
		if ticket_row.tipo_producto <> 'EJEMPLARES' then
			flag_grabar = 1;
			tgrupo_producto = '2';		
			tq_devolucion = 0;
			tid_devolucion = ticket_row.id;
		end if;
		
		if flag_grabar = 1 then
			tco_estado = 'liquidado';
			insert into ticket_liquidacion
			(id, id_pauta,id_devolucion, fe_emision, q_vendida,q_devolucion,co_estado,grupo_producto)
			values
			( nextval('ticket_liquidacion_id_seq'), ticket_row.id,tid_devolucion,ticket_row.fe_emision::date,ticket_row.q_vendida,tq_devolucion,tco_estado,tgrupo_producto);
			update ticket_trans  
			set co_estado = 'liquidado'
			where id = ticket_row.id;    	
		end if;
    	END LOOP;
 
EXCEPTION WHEN others THEN
	INSERT INTO tmp_err_ticket (codigo,descripcion)
	SELECT -1, SQLERRM || ' liquidando ' || SQLSTATE;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.fnc_ticket_liquidacion()
  OWNER TO odoo;
