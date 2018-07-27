--paso 1  mover del 04 al 11 pauta
drop table dia02;
create table dia02 as
(
select * from ticket_trans where tipo_producto = 'EJEMPLARES' and fe_emision = '26/05/2018'
);
--paso 2 cambiar fecha del temporal a 
update dia02  d2
set fe_emision = '02/06/2018',q_devolucion = 0
, q_vendida = 0, q_pauta = 0, co_estado = 'importado'
, nu_ticket = 'migrado 11-06-2018'
-- paso 3 insertar  temporal a ticket_trans
insert into ticket_trans
(
select 
nextval('ticket_trans_id_seq'::regclass),
  co_producto ,
  co_agencia ,
  create_date ,
  de_producto ,
  nu_documento ,
  tipo_afecto ,
  co_canilla ,
  write_uid ,
  de_empresa ,
  qp_cancelo ,
  create_uid ,
  p_importe_ticket ,
  co_producto_devolver ,
  p_total_dia ,
  de_producto_devolver ,
  ti_documento ,
  ciclo_facturacion ,
  q_vendida ,
  ruc ,
  q_devolucion ,
  q_pauta ,
  tipo_producto ,
  write_date ,
  no_canilla ,
  p_devolucion ,
  co_estado ,
  fe_emision ,
  nu_ticket ,
  p_pauta 
 from dia02
);
select max(id) from ticket_trans
select * from  ticket_trans where id = 9316