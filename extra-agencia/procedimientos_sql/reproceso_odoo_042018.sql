truncate ticket_trans;
truncate ticket_liquidacion;
truncate comprobante;
truncate comprobante_linea;
truncate ciclo_facturacion  cascade;
truncate tmp_ticket_llave;


truncate pos_session cascade;
truncate pos_order cascade;
truncate account_invoice cascade;
truncate account_move cascade;
truncate sale_order cascade;
truncate stock_inventory cascade;
truncate purchase_order cascade;



truncate folio_docu

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

select distinct fe_emision from ticket_trans order by 1
select distinct fe_emision, co_estado from ticket_trans order by 2
select substring(fe_emision from  4 for 2), fe_emision  from ticket_trans where substring(fe_emision from  4 for 2) = '04'  limit 10
where substring(fe_emision from 2 for 1)  limit 10


select sum(q_vendida) from ticket_trans where co_producto = '000000000000700062' 
and fe_emision::date between '01/04/2018'::date and '05/04/2018'::date
and co_estado = 'facturado' 

select sum(liq.q_vendida) , sum(liq.q_devolucion) from ticket_trans trans, ticket_liquidacion liq  
where 
trans.id = liq.id_pauta
and trans.co_producto = '000000000000700062' 
and trans.fe_emision::date between '01/04/2018'::date and '05/04/2018'::date
and trans.co_estado = 'facturado' 

select sum(linea.q_vendida_neto) from comprobante co, comprobante_linea linea
where 
co.id = linea.comprobante_id
and linea.co_producto = '000000000000700062' 
and co.fe_emision::date between '01/04/2018'::date and '05/04/2018'::date
and co.fe_emision >= '17/04/2018'::date

select ti_documento , nu_documento , name , co_canilla from res_partner where id <> 1 order by 1, name
select * from res_partner where co_canilla = '1300005297'
select * from res_partner where id=1
select distinct co_agencia from ticket_trans
SET datestyle = "ISO, DMY";
select sum(liq.q_vendida) , sum(liq.q_devolucion) from ticket_trans trans, ticket_liquidacion liq  
where 
trans.id = liq.id_pauta
and trans.co_producto = '000000000000700039' -- gestion
and trans.fe_emision::date between '20/04/2018'::date and '20/04/2018'::date
and trans.co_estado = 'facturado' 

select ti_documento , nu_documento , name , co_canilla from res_partner where id <> 1 order by 1, name

select * from res_partner where co_canilla = '1300004128'