select distinct co_producto , de_producto from ticket_trans where de_producto like '%GESTION%'
select co_canilla, no_canilla, co_producto, de_producto, q_vendida from ticket_trans where co_producto = '000000000000700038' and fe_emision = '26/04/2018'  order by q_vendida desc

select sum(q_vendida) from ticket_trans where co_producto = '000000000000700038' and fe_emision = '26/04/2018'
select sum(q_devolucion) from ticket_trans where co_producto_devolver = '000000000000700038' and fe_emision = '27/04/2018'

update ticket_trans 
set q_vendida = 0
where co_producto = '000000000000700038' and fe_emision = '26/04/2018'

update ticket_trans
set q_devolucion = 0  
where co_producto_devolver = '000000000000700038' and fe_emision = '27/04/2018'