-- Function: public.fnc_insert_comprobante(text)

-- DROP FUNCTION public.fnc_insert_comprobante(text);

CREATE OR REPLACE FUNCTION public.fnc_insert_comprobante(fechafactura text)
  RETURNS void AS
$BODY$
DECLARE
	ticket_row record;
	liq_row record;
	ln_count int:=0;
	tgrupo_producto varchar;
	tno_canilla varchar;
	tpbase numeric (12,2);
	texonerado numeric (12,2);
	tigv numeric (12,2);
	ttotal numeric (12,2);
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
	truc varchar;
        intCicloFacturacion integer;
        flagProceso integer;
        flg_proceso_odoo integer;
        idCiclo integer;
        retorno integer;
        tq_vendida_neto integer;
        tsumacabecera numeric (12,2);
        tsumadetalle numeric (12,2);
BEGIN
	SET datestyle = "ISO, DMY";
	TRUNCATE tmp_err_ticket;
	select co_agencia, nu_documento into tco_agencia, truc from res_partner where id= 1;	
	idCiclo := 0;
	select coalesce(id,0) into idCiclo from ciclo_facturacion where co_estado = 'facturado';
	if idCiclo > 0 then
		INSERT INTO tmp_err_ticket (codigo,descripcion)
		SELECT -1, 'Ya Existe un ciclo de Facturacion en estado Facturado, debe eliminar o pasar a Contabilizado ' ;
	else
		flagProceso := 0;
		select max(fe_emision), min(fe_emision), count(*) into maxfecha ,minfecha ,flagProceso
			   from ticket_liquidacion where co_estado = 'liquidado' and  fe_emision::date <= fechafactura::date ;
		if flagProceso > 0 then
			insert into ciclo_facturacion
			(id,co_estado,co_agencia,fe_inicio, fe_termino,fe_cambio)
			values
			(nextval('ciclo_facturacion_id_seq'),'facturado',tco_agencia,minfecha,maxfecha,current_date) returning id into idCiclo;
			select serie into strserie_boej from folio_docu where ti_documento = 'DNI' and grupo_producto = '1' and activo = '1';
			select serie into strserie_bopr from folio_docu where ti_documento = 'DNI' and grupo_producto = '2'  and activo = '1';
			select serie into strserie_faej from folio_docu where ti_documento = 'RUC' and grupo_producto = '1'  and activo = '1';
			select serie into strserie_fapr from folio_docu where ti_documento = 'RUC' and grupo_producto = '2'  and activo = '1';

			for liq_row in select liq.id_pauta ,trans.tipo_afecto,trans.p_pauta, liq.q_vendida ,liq.q_devolucion  
				from ticket_trans trans, ticket_liquidacion liq 
					where liq.co_estado = 'liquidado'
					and liq.id_pauta = trans.id
					and  liq.fe_emision::date <= fechafactura::date 
			loop
					tpbase := 0; texonerado := 0 ; tigv := 0; ttotal := 0; tq_vendida_neto := 0;
					tq_vendida_neto := liq_row.q_vendida - coalesce(liq_row.q_devolucion,0);
					ttotal = ROUND((liq_row.p_pauta::decimal  * tq_vendida_neto ),2) ;
				
					tpbase = (case liq_row.tipo_afecto when 'Afecto' 
								then ROUND(((liq_row.p_pauta::decimal / 1.18)  * tq_vendida_neto) ,2)
								else
								     0
								end);
					texonerado = (case liq_row.tipo_afecto when 'Afecto' 
								then 0 
								else
								     ROUND(liq_row.p_pauta::decimal * tq_vendida_neto,2)
								end);
					tigv =  (case liq_row.tipo_afecto when 'Afecto' 
								then ROUND(ttotal - tpbase,2)
								else
								     0
								end);

					update ticket_liquidacion
					set pbase = tpbase, exonerado = texonerado , igv = tigv , total = ttotal
					, co_estado = 'facturado', ciclo_facturacion = idCiclo
					where id_pauta = liq_row.id_pauta;

			end loop;
			truncate tmp_ticket_llave;
			insert into tmp_ticket_llave
			(
			SELECT
			 tit.id 
			, tit.fe_emision::date
			, tlq.grupo_producto 
			, tit.co_canilla
			, tit.ti_documento
			, tlq.total
			, dense_rank() over(w)  AS grupo
				from ticket_trans tit, ticket_liquidacion tlq
				where
				tit.id = tlq.id_pauta
				and tlq.co_estado = 'facturado'
				and tlq.q_vendida  > 0
				and tlq.fe_emision::date <= fechafactura::date
			WINDOW w AS (order by tit.co_canilla asc , tit.ti_documento , tlq.grupo_producto)
			);
			
			select grupo  into tgrupo  from  tmp_ticket_llave limit 1;
			select max(grupo)  into max_grupo from  tmp_ticket_llave;
			total_suma := 0;
			for 
				 ticket_row in select * from tmp_ticket_llave
			LOOP
				if tgrupo <> ticket_row.grupo then
					tgrupo := ticket_row.grupo;
					total_suma := 0;
					total_suma = total_suma + ticket_row.total;
					flag_igual := 0;
				else
					total_suma = total_suma + ticket_row.total;
					if total_suma >= 3500  then
						max_grupo := max_grupo + 1;		
						update tmp_ticket_llave
						set grupo = max_grupo
						where grupo = ticket_row.grupo and id = ticket_row.id;
						total_suma := 0;
						total_suma = total_suma + ticket_row.total;
						flag_igual := 1;
					end if;
					if flag_igual = 1 then
						update tmp_ticket_llave
						set grupo = max_grupo
						where grupo = ticket_row.grupo and id = ticket_row.id;
					end if;
				end if;		
			END LOOP;
		    update ticket_trans tra
					set co_estado = 'facturado'
			    from ticket_liquidacion liq
					where liq.co_estado = 'facturado'
					and liq.id_pauta = tra.id
					and liq.ciclo_facturacion = idciClo ;
			
				insert into comprobante
				(	
				select
				nextval('comprobante_id_seq')
				, maxfecha as fe_emision
				, truc
				 ,tco_agencia
				,t2.co_canilla
				, t4.name
				, t4.ti_documento
				, t4.nu_documento
				, t1.grupo_producto
				, t1.grupo
				, sum(t3.pbase)
				, sum(t3.exonerado)
				, sum(t3.igv)
				, sum(t3.total) 
				, idCiclo
				,  (case when t4.ti_documento = 'DNI' and t1.grupo_producto = '1' then strserie_boej 
					when t4.ti_documento = 'DNI' and t1.grupo_producto = '2' then strserie_bopr 
					when t4.ti_documento = 'RUC' and t1.grupo_producto = '1' then strserie_faej 
					when t4.ti_documento = 'RUC' and t1.grupo_producto = '2' then strserie_fapr
					else '0000' end) as serie
				, 0 as folio
				, 'facturado' as co_estado
				    from tmp_ticket_llave t1 , ticket_trans t2 , ticket_liquidacion t3 , res_partner t4
				    where 
				    t1.id = t2.id
				    and t1.id = t3.id_pauta
				    and t2.id = t3.id_pauta
				    and t1.co_canilla = t4.co_canilla
				    group by  
				    2
				    , truc
				    , tco_agencia
				    , t2.co_canilla
				    , t4.name
				    , t4.ti_documento
				    , t4.nu_documento
				    , t1.grupo_producto
				    , t1.grupo
				 );   
			
				insert into comprobante_linea
				(
				select
				nextval('comprobante_linea_id_seq')
				  ,(select id from comprobante where grupo = t1.grupo and ciclo_facturacion = idCiclo limit 1 ) as comprobante_id 
				  ,t2.co_producto
				  ,pt.name
				  ,pt.afecto 
				  ,pt.tipo_producto 
				  ,t2.p_pauta 
				  , (t3.q_vendida - coalesce(t3.q_devolucion,0) ) as q_vendida_neto
				  ,t3.grupo_producto 
				, t3.pbase
				, t3.exonerado
				, t3.igv
				, t3.total
				  ,t1.grupo
				  ,idCiclo
				  ,t2.id 
				    from tmp_ticket_llave t1 , ticket_trans t2 , ticket_liquidacion t3 , product_template pt
				    where 
				    t1.id = t2.id
				    and t1.id = t3.id_pauta
				    and t2.id = t3.id_pauta
				    and t2.co_producto = pt.co_producto	    
				    and t3.ciclo_facturacion = idCiclo
				    );
				    tsumacabecera = 0; tsumadetalle = 0;				    
				    select sum(total) into tsumacabecera from comprobante where ciclo_facturacion = idCiclo;
				    select sum(total) into tsumadetalle from comprobante_linea where ciclo_facturacion = idCiclo;
				   if  tsumacabecera <> tsumadetalle then
					INSERT INTO tmp_err_ticket (codigo,descripcion)
					SELECT -1, 'Error de facturacion.LOS VALORES CABECERA Y DETALLE NO CUADRAN.  comuniquese con Soporte Sistemas XTQ GROUP ' ;
				   end if;
		end if;
	end if;
	
EXCEPTION WHEN others THEN
	INSERT INTO tmp_err_ticket (codigo,descripcion)
	SELECT -1, SQLERRM || ' error facturando ' || SQLSTATE;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.fnc_insert_comprobante(text)
  OWNER TO odoo;
