-- Function: public.fnc_insert_comprobante_odoo(integer)

-- DROP FUNCTION public.fnc_insert_comprobante_odoo(integer);

CREATE OR REPLACE FUNCTION public.fnc_insert_comprobante_odoo(idciclo integer)
  RETURNS integer AS
$BODY$
DECLARE
	ticket_row record;
	ln_count int:=0;
	tgrupo_producto varchar;
	tno_canilla varchar;
	tpbase numeric (12,2);
	texonerado numeric (12,2);
	tigv numeric (12,2);
	ttotal numeric (12,2);
	tpbase_line numeric (12,2);
	texonerado_line numeric (12,2);
	tigv_line numeric (12,2);
	ttotal_line numeric (12,2);
	tname varchar;
	fl_proceso int := 0;
	tid integer;
	tco_canilla varchar;
	id_cabecera	integer;
        tfe_emision date;
        tultimo bigint;
	tgrupo bigint;
	total_suma numeric (12,2);
	max_grupo bigint;
	flag_igual integer := 0;
	maxfecha date;
	minfecha date;
	tco_agencia varchar;
	strserie_boej varchar;
	strserie_bopr varchar;
	strserie_faej varchar;
	strserie_fapr varchar;
        intCicloFacturacion integer;
        flagProceso integer;
        tid_comprobante integer;
        comprobante_id integer;
BEGIN
	SET datestyle = "ISO, DMY";
	select serie into strserie_boej from folio_docu where ti_documento = 'DNI' and grupo_producto = '1' and activo = '1';
	select serie into strserie_bopr from folio_docu where ti_documento = 'DNI' and grupo_producto = '2'  and activo = '1';
	select serie into strserie_faej from folio_docu where ti_documento = 'RUC' and grupo_producto = '1'  and activo = '1';
	select serie into strserie_fapr from folio_docu where ti_documento = 'RUC' and grupo_producto = '2'  and activo = '1';
	-- select * from pos_order  select * from pos_order_line  select * from res_partner where id=1  select * from product_template
	tid_comprobante = 0;
	for ticket_row in select par.nu_documento as ruc,par.co_agencia as co_agencia, (select co_canilla from res_partner where id= ord.partner_id)
			,(select name from res_partner where id= ord.partner_id) as no_canilla
			,(select ti_documento from res_partner where id= ord.partner_id) 
			,(select nu_documento from res_partner where id= ord.partner_id) 
			,ord.id as id_comprobante,pt.tipo_producto, ord.date_order::date as fe_emision, line.qty as q_vendida, line.id as line_id 
			,pt.afecto as tipo_afecto
			,pt.co_producto
			,pt.name as no_producto
			,line.price_unit as p_pauta
			,line.price_subtotal as tpbase_line
			from  pos_order ord , pos_order_line line , product_product pp , product_template pt  ,res_partner par
			where  ord.id = line.order_id
			and line.product_id = pp.id
			and pp.product_tmpl_id = pt.id
			and ord.note is  null 
			and ord.company_id = par.id
			order by id_comprobante, line_id 
	LOOP

	if ticket_row.id_comprobante <> tid_comprobante then

---		raise notice '%', 'paso por aqui porq es mayor que cero';
		-- cambia tid graba comprobante, graba linea -- calcula precio base
		tid_comprobante = ticket_row.id_comprobante;
		if ticket_row.tipo_producto = 'EJEMPLARES' then
			tgrupo_producto = '1';
		else
			tgrupo_producto = '2';		
		end if;
		select coalesce(sum(price_subtotal),0)  --totales
		into tpbase 
		from pos_order_line where order_id = ticket_row.id_comprobante;
		if ticket_row.tipo_afecto = 'Afecto' then
			tpbase = tpbase ;
			texonerado = 0;
			tigv = tpbase * .18;
			ttotal = tpbase + tigv;
		else
			tpbase = tpbase ;
			texonerado = tpbase;
			tigv = 0 ;
			ttotal = tpbase ;
		end if;

		insert into comprobante
		(
		  id ,
		  fe_emision ,
		  ruc ,
		  co_agencia ,
		  co_canilla ,
		  no_canilla ,
		  ti_documento ,
		  nu_documento ,
		  grupo_producto ,
		  grupo ,
		  pbase ,
		  exonerado ,
		  igv ,
		  total ,
		  ciclo_facturacion ,
		  serie ,
		  folio ,
		  co_estado 				
		)	
		values
		(
		nextval('comprobante_id_seq')
		, ticket_row.fe_emision
		, ticket_row.ruc
		, ticket_row.co_agencia
		, ticket_row.co_canilla
		, ticket_row.no_canilla
		, ticket_row.ti_documento
		, ticket_row.nu_documento
		, tgrupo_producto
		, '5'
		, tpbase
		, texonerado
		, tigv
		, ttotal
		, idCiclo
		,  (case when ticket_row.ti_documento = 'DNI' and tgrupo_producto = '1' then strserie_boej 
			when ticket_row.ti_documento = 'DNI' and tgrupo_producto <> '1' then strserie_bopr 
			when ticket_row.ti_documento = 'RUC' and tgrupo_producto = '1' then strserie_faej 
			else strserie_fapr end) 	---as serie
		, 0 --as folio
		, 'facturado' ---as co_estado
		 ) returning id into comprobante_id;   

	-- graba  linea
		if ticket_row.tipo_afecto = 'Afecto' then
			texonerado_line = 0;
			tigv_line = ticket_row.tpbase_line * .18;
			ttotal_line = ticket_row.tpbase_line + tigv_line;
		else
			texonerado_line = ticket_row.tpbase_line;
			tigv_line = 0 ;
			ttotal_line = ticket_row.tpbase_line ;
		end if;

		insert into comprobante_linea
		(
		  id ,
		  comprobante_id ,
		  co_producto ,
		  de_producto ,
		  tipo_afecto ,
		  tipo_producto ,
		  p_pauta ,
		  q_vendida_neto ,
		  grupo_producto ,
		  pbase ,
		  exonerado ,
		  igv ,
		  total ,
		  grupo ,
		  ciclo_facturacion 		
		)
		values
		(
		   nextval('comprobante_linea_id_seq')
		  ,comprobante_id 
		  ,ticket_row.co_producto
		  ,ticket_row.no_producto
		  ,ticket_row.tipo_afecto 
		  ,ticket_row.tipo_producto 
		  ,ticket_row.p_pauta 
		  , ticket_row.q_vendida
		  ,tgrupo_producto 
		  , ticket_row.tpbase_line
		  , texonerado_line
		  , tigv_line
		  , ttotal_line
		  , '1' --t1.grupo
		  , idCiclo 
		  );
	else
	-- graba  linea
		if ticket_row.tipo_afecto = 'Afecto' then
			texonerado_line = 0;
			tigv_line = ticket_row.tpbase_line * .18;
			ttotal_line = ticket_row.tpbase_line + tigv_line;
		else
			texonerado_line = ticket_row.tpbase_line;
			tigv_line = 0 ;
			ttotal_line = ticket_row.tpbase_line ;
		end if;

		insert into comprobante_linea
		(
		  id ,
		  comprobante_id ,
		  co_producto ,
		  de_producto ,
		  tipo_afecto ,
		  tipo_producto ,
		  p_pauta ,
		  q_vendida_neto ,
		  grupo_producto ,
		  pbase ,
		  exonerado ,
		  igv ,
		  total ,
		  grupo ,
		  ciclo_facturacion 		
		)
		values
		(
		   nextval('comprobante_linea_id_seq')
		  ,comprobante_id 
		  ,ticket_row.co_producto
		  ,ticket_row.no_producto
		  ,ticket_row.tipo_afecto 
		  ,ticket_row.tipo_producto 
		  ,ticket_row.p_pauta 
		  , ticket_row.q_vendida
		  ,tgrupo_producto 
		  , ticket_row.tpbase_line
		  , texonerado_line
		  , tigv_line
		  , ttotal_line
		  , '1' --t1.grupo
		  , idCiclo 
		  );
	end if;
END LOOP;
	update pos_order  
	set note = idCiclo::text
	where note is null;
	return idCiclo;
EXCEPTION WHEN others THEN
	INSERT INTO tmp_err_ticket (codigo,descripcion)
	SELECT -1, SQLERRM || ' error facturando desde Punto de Venta' || SQLSTATE;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.fnc_insert_comprobante_odoo(integer)
  OWNER TO odoo;
