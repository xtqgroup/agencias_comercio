-- Function: public.fnc_valida_ticket()

-- DROP FUNCTION public.fnc_valida_ticket();

CREATE OR REPLACE FUNCTION public.fnc_valida_ticket()
  RETURNS void AS
$BODY$
DECLARE
	ln_count int:=0;
BEGIN  
	SET datestyle = "ISO, DMY";
	TRUNCATE tmp_err_ticket;
	ln_count = 0;
	select count(*) into ln_count from ticket_input;
	if ln_count > 0 then		
		--Validar si codigo de agencia es correcto
		BEGIN
			INSERT INTO tmp_err_ticket (codigo,descripcion)
			SELECT -1,'No corresponde Agencia ' || tmp.co_agencia
			FROM ticket_input tmp 
			WHERE tmp.co_agencia NOT IN (SELECT sgc.co_agencia FROM res_partner sgc where sgc.co_agencia is not null) LIMIT 1;
		EXCEPTION
		WHEN OTHERS THEN 
			INSERT INTO tmp_err_ticket (codigo,descripcion)
			SELECT -1,'ERROR de Excepcion dato de  Agencia comuniquese con Soporte 1';
		END;
		--si fecha emision DUPLICADA  select distinct fe_emision from ticket_input order by 1 asc select distinct fe_emision from ticket_input order by 1 asc
		BEGIN
			INSERT INTO tmp_err_ticket (codigo,descripcion)
			SELECT -1,'Ya se cargo esta fecha de emision ' 	|| tmp.fe_emision
			FROM ticket_input tmp
			WHERE EXISTS (SELECT 1 FROM ticket_trans rc where fe_emision = tmp.fe_emision);
			EXCEPTION
		WHEN OTHERS THEN 
			INSERT INTO tmp_err_ticket (codigo,descripcion)
			SELECT -1,'ERROR de Excepcion duplicado fecha  comuniquese con Soporte 2';
		END;

		--si fecha emision no es consecutiva select max(fe_emision) from ticket_input  select min(fe_emision) from ticket_input 
		BEGIN
			INSERT INTO tmp_err_ticket (codigo,descripcion)
			SELECT -1,'La fecha de emision No es consecutiva ' || tmp.fe_emision
			FROM ticket_input tmp 
			where (select min(fe_emision::date) from ticket_input) <> 
			(select cast(max(sgc.fe_emision::date) + CAST('1 days' AS INTERVAL) as date) from ticket_trans sgc );
			EXCEPTION
		WHEN OTHERS THEN 
			INSERT INTO tmp_err_ticket (codigo,descripcion)
			SELECT -1,'ERROR de Excepcion feccha consecutiva comuniquese con Soporte 3';
		END;
		-- si el ticket ya ingreso a la base de datos ticket_trans
		BEGIN
			INSERT INTO tmp_err_ticket (codigo,descripcion)
			SELECT -1,'Ticket ya fue ingresado a la base de datos ' || tmp.nu_ticket
			FROM ticket_input tmp
			WHERE EXISTS (SELECT 1 FROM ticket_trans rc where nu_ticket = tmp.nu_ticket);
			EXCEPTION
		WHEN OTHERS THEN 
			INSERT INTO tmp_err_ticket (codigo,descripcion)
			SELECT -1,'ERROR de Excepcion ticket ingresado comuniquese con Soporte 4';
		END;
	else
			INSERT INTO tmp_err_ticket (codigo,descripcion)
			SELECT -1,'No hay datos para Procesar ' ;
	end if;
	ln_count = 0;
	select count(*) into ln_count from tmp_err_ticket;
	if ln_count = 0 then		
		BEGIN
		---    quitar  texto
			update ticket_input
			set de_producto = regexp_replace(de_producto, 'DIARIO ', '', 'g')
			where tipo_producto = 'EJEMPLARES';
		----- actualizar precios dias excepcion  DOMINGOS
			update ticket_input 
			set p_pauta =  p_pauta * 0.9286
			where co_producto in ('000000000000700067','000000000000700046','000000000000700006');
		--select * from ticket_input   select * from ticket_input
			update ticket_input
			set  co_estado  = 'importado' ;
			insert into ticket_trans
			(select * from ticket_input);
			truncate ticket_input;
		EXCEPTION
		WHEN OTHERS THEN 
			INSERT INTO tmp_err_ticket (codigo,descripcion)
			SELECT -1,'ERROR de Excepcion UPDATE TICKET_INPUT comuniquese con Soporte ';
		END;
	end if;
EXCEPTION WHEN others THEN
	INSERT INTO tmp_err_ticket (codigo,descripcion)
	SELECT -1, SQLERRM || ' ' || SQLSTATE;
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.fnc_valida_ticket()
  OWNER TO odoo;
