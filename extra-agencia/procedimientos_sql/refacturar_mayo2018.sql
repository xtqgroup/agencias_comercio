truncate ticket_input;
delete from ticket_trans where fe_emision in ('17/05/2018','18/05/2018','19/05/2018','20/05/2018','21/05/2018','22/05/2018','23/05/2018','24/05/2018');
select distinct fe_emision, co_estado from ticket_trans order by 2, 1;

select * from ciclo_facturacion
update ciclo_facturacion
set co_estado = 'facturado'
where id = 111

update ticket_trans
set co_estado = 'importado'
where co_estado = 'liquidado';

delete from ticket_liquidacion
where EXTRACT(MONTH from fe_emision) = '05';

update ticket_trans
set co_estado = 'importado'
where substring(fe_emision from 4 for 2) = '05';


select distinct fe_emision, co_estado from ticket_liquidacion where substring(fe_emision::text from 6 for 2) = '05' order by 1
select distinct fe_emision, co_estado from comprobante where substring(fe_emision::text from 6 for 2) = '05' order by 1
select distinct fe_emision from ticket_trans where fe_emision in ('18/05/2018','19/05/2018','20/05/2018','21/05/2018','22/05/2018','23/05/2018')

select ciclo_facturacion ,fe_emision, co_producto,sum(q_vendida) from ticket_trans where co_producto = '000000000000700065'  
group by 
1,2,3


select ciclo_facturacion ,fe_emision, co_producto_devolver,sum(q_devolucion) from ticket_trans where co_producto_devolver = '000000000000700065'  
group by 
1,2,3
order by 2


select co.ciclo_facturacion, co.fe_emision , sum(linea.q_vendida_neto) from comprobante co, comprobante_linea  linea
where 
co.id = linea.comprobante_id
and linea.co_producto = '000000000000700065' 
 group by 1, 2

