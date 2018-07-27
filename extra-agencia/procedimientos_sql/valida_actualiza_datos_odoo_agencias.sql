select fnc_valida_ticket()
select fnc_ticket_liquidacion()
select fnc_insert_comprobante('2018-07-10')
select fnc_insert_comprobante_odoo(28)
select * from tmp_err_ticket
select fnc_limpiar_comprobante()

select * from res_partner order by 1 asc
select * from ticket_input
select p_pauta,co_estado,fe_emision,* from ticket_trans where co_estado = 'importado'
select * from ticket_liquidacion
select * from comprobante 
select * from comprobante_linea where total = 0
select * from ciclo_facturacion
select * from tarifa_excepcion
select * from product_taxes_rel where prod_id in (2551 ,2550)
select * from product_template;
select * from  account_invoice
select * from  account_invoice_line
select * from  product_product where id = 4172 order by 1 asc
select * from account_invoice order by 1 asc
select * from ticket_input where co_estado = 'preliminar'
select * from pos_order
select * from pos_order_line
select * from purchase_order
select * from purchase_order_line

truncate ticket_input;
truncate ticket_trans;
truncate ticket_liquidacion;
truncate comprobante;
truncate comprobante_linea;
truncate ciclo_facturacion  cascade;
truncate tmp_ticket_llave;
update ticket_trans 
set co_estado = 'importado'



truncate pos_session cascade;
truncate pos_order cascade;
truncate account_invoice cascade;
truncate account_move cascade;
truncate sale_order cascade;
truncate stock_inventory cascade;
truncate purchase_order cascade;

update res_partner
set co_agencia = '1200000071',no_agencia = 'AGENCIA MARZANO', ti_documento = 'RUC' , nu_documento = '20546720552'
where id = 1

update res_partner
set co_agencia = '1200000069',no_agencia = 'AGENCIA HIGUERETA', ti_documento = 'RUC' , nu_documento = '20546720552'
where id = 1

update res_partner
set co_agencia = '1200000068',no_agencia = 'AGENCIA DIBOS', ti_documento = 'RUC' , nu_documento = '20546720552'
where id = 1

update res_partner
set co_agencia = '1200000074',no_agencia = 'AGENCIA SBORJA', ti_documento = 'RUC' , nu_documento = '20546720552'
where id = 1

update res_partner
set co_agencia = '1200000009',no_agencia = 'AGENCIA CHORRILOS', ti_documento = 'RUC' , nu_documento = '20524498473'
where id = 1

update res_partner
set co_agencia = '1200000007',no_agencia = 'AGENCIA SANTAANITA', ti_documento = 'RUC' , nu_documento = '20601232104'
where id = 1

update res_partner
set co_agencia = '1200000006',no_agencia = 'AGENCIA VITARTE', ti_documento = 'RUC' , nu_documento = '20601232104'
where id = 1

update res_partner
set co_agencia = '1200000005',no_agencia = 'AGENCIA SANTACLARA', ti_documento = 'RUC' , nu_documento = '20601232104'
where id = 1

update res_partner
set co_agencia = '1200000008',no_agencia = 'AGENCIA CHOSICA', ti_documento = 'RUC' , nu_documento = '20601232104'
where id = 1

update res_partner
set co_agencia = '1200000004',no_agencia = 'AGENCIA HUAYCAN', ti_documento = 'RUC' , nu_documento = '20601232104'
where id = 1

update res_partner
set co_agencia = '1200000070',no_agencia = 'AGENCIA CHACARILLA', ti_documento = 'RUC' , nu_documento = '20603302487'
where id = 1

update res_partner
set co_agencia = '1200000042',no_agencia = 'AGENCIA LAMOLINA', ti_documento = 'RUC' , nu_documento = '20603302487'
where id = 1

update res_partner
set co_agencia = '1200000041',no_agencia = 'AGENCIA SANLUIS', ti_documento = 'RUC' , nu_documento = '20603302487'
where id = 1

update res_partner
set alta_sgc = True;

update product_template
set alta_sgc = True;

--update ticket_trans tra
set co_estado = 'importado'
---  para ejecutar en cada agencia en las tablas antiguas  ajuste de folio a partir de febrero  2018
update pos_order
set note = null

select * from ticket_trans limit 1
co_producto varchar
tipo_afecto varchar
fe_emision date
p_pauta  double precision --incluye igv

copy
(
select serie,max(folio) as folio, (select co_agencia from res_partner where id = 1) as co_agencia,ti_documento,1 as activo ,grupo_producto from ticket_cab_mov
where emision = '28-02-2018'
 group by serie, ti_documento ,grupo_producto order by 1,2 desc,3
)
to 'f:\temporales\folio_feb2018'
-- borrar antes  archivo truncate folio_docu
copy folio_docu
from 'f:\temporales\folio_feb2018'
select * from folio_docu
-----

CREATE TABLE ticket_trans
(
  id serial NOT NULL,
  co_producto character varying, -- Codigo del producto
  co_agencia character varying, -- Codigo de Agencia
  create_date timestamp without time zone, -- Created on
  de_producto character varying, -- Descripcion del producto
  nu_documento character varying, -- Nro de documento (DNI/RUC)
  tipo_afecto character varying, -- Afecto / Inafecto
  co_canilla character varying, -- Codigo de canilla
  write_uid integer, -- Last Updated by
  de_empresa character varying, -- Razon social del distribuidor
  qp_cancelo double precision, -- Cancelo
  create_uid integer, -- Created by
  p_importe_ticket double precision, -- Importe
  co_producto_devolver character varying, -- Codigo del producto a devolver
  p_total_dia double precision, -- Total del dia (del ticket)
  de_producto_devolver character varying, -- Descripcion del producto a devolver
  ti_documento character varying, -- Tipo de documento (DNI/RUC)
  ciclo_facturacion integer, -- Ciclo de Facturacion
  q_vendida integer, -- Cantidad Vendida de Pauta
  ruc character varying, -- Nro de RUC de distribuidor
  q_devolucion integer, -- Cantidad de Devolucion
  q_pauta integer, -- Cantidad de Pauta
  tipo_producto character varying, -- Tipo de Producto
  write_date timestamp without time zone, -- Last Updated on
  no_canilla character varying, -- Nombre del canilla
  p_devolucion double precision, -- Precio unitario de la devolucion
  co_estado character varying, -- Estado del documento
  fe_emision character varying, -- Fecha de emision dd/mm/aaaa
  p_pauta double precision, -- Precio unitario de la pauta
  nu_ticket character varying -- Nro de ticket
  )
WITH (
  OIDS=FALSE
);
ALTER TABLE ticket_trans
  OWNER TO odoo;


drop table comprobante
CREATE TABLE comprobante
(
  id  serial ,
  fe_emision date,
  ruc character varying,
  co_agencia character varying,
  co_canilla character varying,
  no_canilla  varchar,
  ti_documento varchar,
  nu_documento  varchar,
  grupo_producto character varying,
  grupo bigint,
  pbase numeric(12,3),
  exonerado numeric(12,2),
  igv numeric(12,2),
  total numeric(12,2),
  ciclo_facturacion integer,
  serie varchar,
  folio integer,
  co_estado varchar
)


-- DROP TRIGGER foliado_documento ON comprobante;

CREATE TRIGGER foliado_documento
  BEFORE INSERT
  ON comprobante
  FOR EACH ROW
  EXECUTE PROCEDURE foliado_documento();

-- drop table comprobante_linea
CREATE TABLE comprobante_linea
(
  id serial,
  comprobante_id integer,
  co_producto character varying,
  de_producto  varchar,
  tipo_afecto character varying,
  tipo_producto character varying,
  p_pauta numeric(12,3),
  q_vendida_neto numeric,
  grupo_producto text,
  pbase numeric(12,2),
  exonerado numeric(12,2),
  igv numeric(12,2),
  total numeric(12,2),
  grupo bigint,
  ciclo_facturacion integer
)


---drop table ticket_liquidacion
	CREATE TABLE IF NOT EXISTS ticket_liquidacion(
	id serial ,
	id_pauta bigint,
	id_devolucion bigint,
	fe_emision date, 
	q_vendida numeric,
	q_devolucion numeric,
	grupo_producto varchar ,
	co_estado varchar,
	ciclo_facturacion integer,
	pbase numeric(12,3),
	exonerado numeric(12,2),
	igv numeric(12,2),
	total numeric(12,2)
	);

		create  table  tmp_ticket_llave
		(
		id bigint
		, fe_emision date
		, grupo_producto varchar
		, co_canilla varchar
		, ti_documento varchar
		, total  numeric (12,2)
		, grupo bigint
		);



 -- Table: tmp_err_ticket

-- DROP TABLE tmp_err_ticket;

CREATE TABLE tmp_err_ticket
(
  codigo integer,
  descripcion character varying
)
WITH (
  OIDS=FALSE
);
ALTER TABLE tmp_err_ticket
  OWNER TO postgres;

		select
		nextval('comprobante_id_seq')
	--	, maxfecha as fe_emision
		, t2.ruc
		 ,t2.co_agencia
		,t2.co_canilla
--		, t4.name
--		, t4.ti_documento
--		, t4.nu_documento
		, t1.grupo_producto
		, t1.grupo
		,sum(t3.pbase)  
		, sum(t3.exonerado)  
		, sum(t3.igv) 
		, sum(t3.total) 
		    from tmp_ticket_llave t1 , ticket_input t2 , ticket_liquidacion t3  ---, res_partner t4
		    where 
		    t1.id = t2.id
		    and t1.id = t3.id_pauta
--		    and t1.co_canilla = t4.co_canilla
		    group by  2, t2.ruc, t2.co_agencia--, t4.ti_documento--, t4.nu_documento
		,t2.co_canilla
--		,t4.name
		, t1.grupo_producto
		, t1.grupo



-- Table: folio_docu

-- DROP TABLE folio_docu;


CREATE TABLE folio_docu
(
  serie character varying,
  folio integer,
  co_agencia character varying,
  ti_documento character varying,
  activo integer,
  grupo_producto character varying
)
WITH (
  OIDS=FALSE
);
ALTER TABLE folio_docu
  OWNER TO odoo;


  	CREATE TABLE IF NOT EXISTS tmp_ticket(
	ruc varchar,
	de_empresa varchar,
	co_agencia varchar,  --insert odoo   res_partner
	fe_emision date, 
	nu_ticket varchar,    
	co_canilla varchar,   -- insert odoo  res_partner
	no_canilla varchar,   -- insert odoo res_partner
	ti_documento varchar, -- insert odoo res_partner
	nu_documento varchar,  -- insert odoo res_partner
	co_producto varchar,     -- insert odoo producto
	de_producto varchar,   -- insert odoo producto
	co_producto_devolver varchar,	
	de_producto_devolver varchar,	
	q_pauta numeric,
	q_vendida numeric,
	p_pauta  numeric(12,3),
	q_devolucion numeric,
	p_devolucion  numeric(12,3),
	p_importe_ticket numeric(12,2),
	tipo_afecto  varchar,           -- ?????
	p_total_dia numeric(12,2),
	qp_cancelo numeric(12,2),
	tipo_producto varchar ,
	ciclo_facturacion integer
	);


select * from folio_docu
truncate folio_docu

insert into folio_docu
values 


--chosica
insert into folio_docu
values 
('007',3235,1200000008,'DNI',1,	1)
,('008',2142,1200000008,'DNI',1,2)

--huaycan
insert into folio_docu
values 
('003',1302,1200000004,'DNI',1,	1)
,('004',840,1200000004,'DNI',1,2)

--santa anita
insert into folio_docu
values 
('001',3863,1200000007,'DNI',1,	1)
,('002',2243,1200000007,'DNI',1,2)

--santa clara
insert into folio_docu
values 
('009',1385,1200000005,'DNI',1,	1)
,('010',805,1200000005,'DNI',1,2)


---vitarte
insert into folio_docu
values 
('005',5221,12000000006,'DNI',1,1)
,('006',3197,12000000006,'DNI',1,2)

select * from res_partner where char_length(nu_documento) > 8
select * from res_partner where ti_documento = 'RUC'

--SJM
('007',6401,1200000014,'DNI',1,1)
('008',2555,1200000014,'DNI',1,2)
--PACHAC
('009',4666,1200000010,'DNI',1,1)
('010',1716,1200000010,'DNI',1,2)
--CHORRILLOS
('009',6094,1200000009,'DNI',1,1)
('010',2607,1200000009,'DNI',1,2)
('002',215,1200000009,'RUC',1,1)
('004',0,1200000009,'RUC',1,2)
--CDD
('007',8116,1200000013,'DNI',1,1)
('008',3044,1200000013,'DNI',1,2)
--VES
('011',10250,1200000011,'DNI',1,1)
('012',3766,1200000011,'DNI',1,2)
('003',80,1200000011,'RUC',1,1)
('005',0,1200000011,'RUC',1,2)

---------------------------------- Actualizar Serie y Folio ------------------------------------------------------
--BARRANCO--
select * from folio_docu
truncate folio_docu

insert into folio_docu
values 
('015',3200,1200000012,'DNI',1,1)
,('015',151,1200000012,'RUC',1,1)
,('016',3153,1200000012,'DNI',1,2)
,('016',155,1200000012,'RUC',1,2)

--DIBOS--
select * from folio_docu
truncate folio_docu

insert into folio_docu
values 
('011',1295,1200000068,'DNI',1,1)
,('011',647,1200000068,'RUC',1,1)
,('012',1131,1200000068,'DNI',1,2)
,('012',628,1200000068,'RUC',1,2)

--HIGUERETA--
select * from folio_docu
truncate folio_docu

insert into folio_docu
values 
('009',1469,1200000069,'DNI',1,1)
,('009',1226,1200000069,'RUC',1,1)
,('010',1291,1200000069,'DNI',1,2)
,('010',1214,1200000069,'RUC',1,2)

--LURIN--
select * from folio_docu
truncate folio_docu

insert into folio_docu
values 
('011',1546,1200000072,'DNI',1,1)
,('012',1316,1200000072,'DNI',1,2)

--MARZANO--
select * from folio_docu
truncate folio_docu

insert into folio_docu
values 
('013',1430,1200000071,'DNI',1,1)
,('014',1146,1200000071,'DNI',1,2)


--SAN BORJA--
select * from folio_docu
truncate folio_docu

insert into folio_docu
values 
('013',1364,1200000074,'RUC',1,1)
,('013',1244,1200000074,'DNI',1,1)
,('014',1354,1200000074,'RUC',1,2)
,('014',1135,1200000074,'DNI',1,2)

--SURCO--
select * from folio_docu
truncate folio_docu

insert into folio_docu
values 
('009',1893,1200000506,'DNI',1,1)
,('009',1125,1200000506,'RUC',1,1)
,('010',1671,1200000506,'DNI',1,2)
,('010',1109,1200000506,'RUC',1,2)


--SJM
select * from folio_docu
truncate folio_docu

insert into folio_docu
values 
('007',6401,1200000014,'DNI',1,1)
,('008',2555,1200000014,'DNI',1,2)

--PACHAC
select * from folio_docu
truncate folio_docu

insert into folio_docu
values 
('009',4666,1200000010,'DNI',1,1)
,('010',1716,1200000010,'DNI',1,2)

--CHORRILLOS
select * from folio_docu
truncate folio_docu

insert into folio_docu
values 
('009',6094,1200000009,'DNI',1,1)
,('010',2607,1200000009,'DNI',1,2)
,('002',215,1200000009,'RUC',1,1)
,('004',0,1200000009,'RUC',1,2)

--CDD
select * from folio_docu
truncate folio_docu

insert into folio_docu
values 
('007',8116,1200000013,'DNI',1,1)
,('008',3044,1200000013,'DNI',1,2)

--VES
select * from folio_docu
truncate folio_docu

insert into folio_docu
values 
('011',10250,1200000011,'DNI',1,1)
,('012',3766,1200000011,'DNI',1,2)
,('003',80,1200000011,'RUC',1,1)
,('005',0,1200000011,'RUC',1,2)

-----------------alter
ALTER TABLE comprobante  ALTER COLUMN pbase TYPE  numeric(12,3);
ALTER TABLE comprobante  ALTER COLUMN exonerado TYPE  numeric(12,3);
ALTER TABLE comprobante  ALTER COLUMN igv TYPE  numeric(12,3);
ALTER TABLE comprobante  ALTER COLUMN total TYPE  numeric(12,3);

ALTER TABLE comprobante_linea  ALTER COLUMN p_pauta TYPE  numeric(12,3);
ALTER TABLE comprobante_linea  ALTER COLUMN pbase TYPE  numeric(12,3);
ALTER TABLE comprobante_linea  ALTER COLUMN exonerado TYPE  numeric(12,3);
ALTER TABLE comprobante_linea  ALTER COLUMN igv TYPE  numeric(12,3);
ALTER TABLE comprobante_linea  ALTER COLUMN total TYPE  numeric(12,3);

----  validaciones
select count(*) from ticket_trans where ruc is null
select co_producto,co_canilla, fe_emision, nu_ticket 
from ticket_trans group by 1,2,3,4
having count(co_canilla) > 1

select distinct fe_emision::date from ticket_trans order by 1
select distinct fe_emision, co_estado from ticket_trans order by 2
select substring(fe_emision from  4 for 2), fe_emision  from ticket_trans where substring(fe_emision from  4 for 2) = '04'  limit 10
where substring(fe_emision from 2 for 1)  limit 10


select sum(q_vendida) from ticket_trans where co_producto = '000000000000700062' 
and fe_emision::date between '10/04/2018'::date and '16/04/2018'::date
and co_estado = 'facturado' 

select sum(liq.q_vendida) , sum(liq.q_devolucion) from ticket_trans trans, ticket_liquidacion liq  
where 
trans.id = liq.id_pauta
and trans.co_producto = '000000000000700062' 
and trans.fe_emision::date between '10/04/2018'::date and '16/04/2018'::date
and trans.co_estado = 'facturado' 

select sum(linea.q_vendida_neto) from comprobante co, comprobante_linea linea
where 
co.id = linea.comprobante_id
and linea.co_producto = '000000000000700062' 
and co.fe_emision::date between '16/04/2018'::date and '16/04/2018'::date
and co.fe_emision >= '17-04-2018'::date

--select distinct fe_emision , tipo_producto from ticket_trans where
delete from ticket_trans  where 
tipo_producto = 'EJEMPLARES'
and substring(fe_emision from  1 for 2) in ( '20','21','22','23','24','25','26')

--select distinct fe_emision , tipo_producto, q_devolucion from ticket_trans 
update ticket_trans
set q_devolucion = 0
where tipo_producto = 'EJEMPLARES'
and fe_emision = '27/06/2018'

--CHACARILLA
select * from folio_docu
truncate folio_docu

insert into folio_docu
values 
('F001',0,1200000070,'RUC',1,1)
,('B001',1,1200000070,'DNI',1,1)
,('F002',0,1200000070,'RUC',1,2)
,('B002',0,1200000070,'DNI',1,2)

select * from comprobante where serie = 'F001'  and grupo = '2'
select * from comprobante_linea where comprobante_id = 9635
--LA MOLINA
select * from folio_docu
truncate folio_docu

insert into folio_docu
values 
('F003',0,1200000042,'RUC',1,1)
,('B003',0,1200000042,'DNI',1,1)
,('F004',0,1200000042,'RUC',1,2)
,('B004',0,1200000042,'DNI',1,2)

--SANLUIS
select * from folio_docu
truncate folio_docu

insert into folio_docu
values 
('F005',0,1200000041,'RUC',1,1)
,('B005',0,1200000041,'DNI',1,1)
,('F006',0,1200000041,'RUC',1,2)
,('B006',0,1200000041,'DNI',1,2)


	drop table cambio_res_partner;
  	CREATE TABLE IF NOT EXISTS cambio_res_partner(
	co_agencia varchar,
	co_canilla varchar,
	no_canilla varchar,
	no_empresa varchar,
	ruc varchar,
	tipo_docu varchar,
	direccion varchar
	);
	copy cambio_res_partner from 'G:\VilcaAgencias\cambios_nombre_ruc_vilca&cuadros_16072018.csv'   DELIMITER ',' CSV HEADER ;
	select nu_documento, * from res_partner where ti_documento  'DNI'
	select * from cambio_res_partner cares where cares.co_agencia = '1200000042' and cares.tiPO_docu  <> 'BOL'

	select cares.tipo_docu, ti_documento , res.name, cares.no_canilla ,res.nu_documento, cares.ruc from cambio_res_partner cares , res_partner  res
	where cares.co_canilla = res.co_canilla
	and cares.co_agencia = '1200000042'
	and cares.tiPO_docu  <> 'BOL'
	and res.nu_documento   <> cares.ruc

	update res_partner res
	set nu_documento = cares.ruc
	from cambio_res_partner cares
	where cares.co_canilla = res.co_canilla
	and cares.co_agencia = '1200000042'
	and cares.tipo_docu <> 'BOL'

---  ACTUALIZA DIRECCIONES 16072018
SELECT * FROM RES_PARTNER
	select cares.direccion, res.street from cambio_res_partner cares , res_partner  res
	where cares.co_canilla = res.co_canilla
	and cares.co_agencia = '1200000041'
	and cares.tiPO_docu  <> 'BOL'

	update res_partner res
	set street = cares.direccion
	from cambio_res_partner cares
	where cares.co_canilla = res.co_canilla
	and cares.co_agencia = '1200000042'
	and cares.tipo_docu <> 'BOL'

select * from comprobante
update comprobante
set fe_emision = '2018-07-13'::date

	update comprobante co
	set direccion_cliente = cares.direccion
	from cambio_res_partner cares
	where cares.co_canilla = co.co_canilla
	and cares.co_agencia = '1200000070'
	and cares.tipo_docu <> 'BOL'
	

select * from comprobante where serie = 'F001' and folio = 1
select * from comprobante_linea where comprobante_id = 9645
ALTER TABLE comprobante  add COLUMN hr_emision varchar;
update comprobante 
set hr_emision = to_char(current_timestamp, 'HH24:MI:SS')
 select 
tipo_iva_sunat
, nu_ticket_devolver
, exonerado
, * 
from comprobante_linea limit 1

select * from comprobante  limit 1
update comprobante_linea
set tipo_iva_sunat = nu_ticket_devolver 

update comprobante_linea
set nu_ticket_devolver = ' '

select * from res_partner where nu_documento = '20557226410'
select * from comprobante where nu_documento = '20557226410'
update comprobante 
set no_canilla = 'EMPRESA DE TRANSPORTES H&Z HNOS S.A.C'
where nu_documento = '20557226410'

update comprobante 
set no_canilla = 'CHAFFO AMAU, CESAR'
where nu_documento = '10094113071'
select * from comprobante limit 
update  comprobante
set fe_emision = 
