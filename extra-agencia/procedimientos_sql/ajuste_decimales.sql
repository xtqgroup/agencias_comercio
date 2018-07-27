SET datestyle = "ISO, DMY";
---ubicar  los errores
select distinct ruc from comprobante
update comprobante
set ruc = '20600767721'

select * from ciclo_facturacion 
drop table compara;
create table compara as
select co.id,co.serie , co.folio,co.co_canilla,no_canilla,co.ti_documento,co.fe_emision,co.grupo_producto,co.total 
,(select coalesce(sum(linea.total),0) from comprobante_linea linea where linea.comprobante_id = co.id) as totallinea
from comprobante co
where ciclo_facturacion = 101  
order by co.folio ;

select * from  compara where trunc(total,0) - trunc(totallinea,0) <> 0 order by fe_emision, co_canilla , grupo_producto, total asc
select * from  compara where trunc(totallinea,0) = 0 and trunc(total,0) <> 0 order by fe_emision, co_canilla , grupo_producto

--1. limpiar comprobante_id de comprobante_linea  ciclo = 88 
alter table comprobante_linea add trans_id integer;
delete from comprobante_linea where ciclo_facturacion = 101
--2. crear tabla de registros del 24/04/2018  y 30/04

drop table co1;
create table co1 as
select trans.co_canilla, trans.co_producto, trans.de_producto, trans.tipo_afecto,liq.grupo_producto,liq.pbase,liq.igv,liq.exonerado,liq.total
,trans.tipo_producto, liq.ciclo_facturacion 
, '24/04/2018' as fe_emision ------, (select max(fe_emision) from comprobante where ciclo_facturacion = 101)  as fe_emision 
, trans.p_pauta,(liq.q_vendida - coalesce(liq.q_devolucion,0)) as q_vendida_neto
,  (liq.q_vendida - coalesce(liq.q_devolucion,0)) * trans.p_pauta as total2
, trans.id as trans_id
from ticket_liquidacion liq , ticket_trans trans 
where liq.id_pauta  = trans.id 
and  liq.ciclo_facturacion = 101
and liq.q_vendida > 0
and trans.fe_emision IN ( '21/04/2018','22/04/2018','23/04/2018','24/04/2018')
union
select trans.co_canilla, trans.co_producto, trans.de_producto, trans.tipo_afecto,liq.grupo_producto,liq.pbase,liq.igv,liq.exonerado,liq.total
,trans.tipo_producto, liq.ciclo_facturacion 
, (select max(fe_emision) from comprobante where ciclo_facturacion = 101)  as fe_emision 
, trans.p_pauta,(liq.q_vendida - coalesce(liq.q_devolucion,0)) as q_vendida_neto
,  (liq.q_vendida - coalesce(liq.q_devolucion,0)) * trans.p_pauta as total2
, trans.id as trans_id
from ticket_liquidacion liq , ticket_trans trans 
where liq.id_pauta  = trans.id 
and  liq.ciclo_facturacion = 101
and liq.q_vendida > 0
and trans.fe_emision = '25/04/2018'


drop table co2;
create table co2 as
select t1.*, (select sum(t2.total) from co1 t2 
		where t2.co_canilla = t1.co_canilla 
		and t2.grupo_producto = t1.grupo_producto 
		and t2.fe_emision = t1.fe_emision
		group by t2.fe_emision, t2.co_canilla,t2.grupo_producto) as suma2
from co1 t1;

--3. asignar comprobante_id a comprobante_linea a partir tabla co2404 por montos = actual

insert into comprobante_linea
(
select 
nextval('comprobante_linea_id_seq')
,co.id as comprobante_id,co2.co_producto, de_producto, tipo_afecto, co2.tipo_producto, co2.p_pauta, co2.q_vendida_neto, co2.grupo_producto
, co2.pbase, co2.exonerado,co2.igv,co2.total, grupo,co2.ciclo_facturacion
, co2.trans_id
from co2 co2 , comprobante co
where co.co_canilla = co2.co_canilla 
and co.grupo_producto = co2.grupo_producto
and co.ciclo_facturacion = co2.ciclo_facturacion
and round(co.total::decimal,0) - round(co2.suma2::decimal,0) between -5 and 5
and co.ciclo_facturacion = 101
)

------------
----
select * from comprobante where ciclo_facturacion = 101

select fe_emision, co_canilla,grupo_producto , co_producto ,de_producto,total ,suma2 from co2 
where co_canilla = '1300011371'
and grupo_producto = '1'
and ciclo_facturacion = 101
order by 1 , 2
select * from comprobante  where ciclo_facturacion = 101 and co_canilla = '1300011371'



select sum(pbase), sum(exonerado), sum(igv),sum(total)  from comprobante_linea where comprobante_id = 8640

---  calculos
copy
(
select id ,serie,folio, pbase, exonerado, igv,total 
, round(pbase,2) as pbase2
, round(exonerado,2)  as exonerado2
, round((round(pbase,2) - round(exonerado,2) ) * .18,2) as  igv2
, round(pbase,2) +  round((round(pbase,2) - round(exonerado,2) ) * .18,2) as total2

from comprobante 
where folio = 3260
)
to 'd:\barrancoajuste.csv'

update comprobante
set pbase =  round(pbase,2) 
, exonerado = round(exonerado,2)  
, igv = round((round(pbase,2) - round(exonerado,2) ) * .18,2) 
, total = round(pbase,2) +  round((round(pbase,2) - round(exonerado,2) ) * .18,2) 
where fe_emision between '2018-05-01'::date and '2018-05-14'::date


select distinct fe_emision from comprobante
where fe_emision between '2018-05-01'::date and '2018-05-14'::date

select * from  ciclo_facturacion



select * from comprobante_linea where comprobante_id in (7757,7683)
delete from comprobante_linea where id in (159066,158130)
