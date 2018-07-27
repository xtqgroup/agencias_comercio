from openerp import api
from openerp.osv import fields, osv

class res_partner(osv.osv):
    _inherit = 'res.partner'
    _columns = {
        'co_agencia' : fields.char('Codigo de Agencia'),
        'no_agencia' : fields.char('Nombre de Agencia'),
        'co_establecimiento' : fields.char('Codigo de Establecimiento'),
        'direccion_agencia' : fields.char('Direccion de la Agencia'),
        'numero_autorizacion_sunat' : fields.char('Numero de Autorizacion de SUNAT'),
        'no_impresora' : fields.char('Nombre de Impresora'),  
        'serie_impresora' : fields.char('Numero de Serie de Impresora'),  
        'co_canilla' : fields.char('codigo de canilla'),  
        'ti_documento': fields.selection([('DNI', 'DNI'),('RUC','RUC')], 'DNI y RUC', required=True, help="RUC / DNI"),        
        'nu_documento' : fields.char('Numero de Documento'),
        'alta_sgc' : fields.boolean('Flag Alta de registro desde SGC')  ,
    }
    _defaults =  {
        'alta_sgc' : False,
    }
class account_invoice(osv.osv):
    _inherit = 'account.invoice'
    _columns = {
        'comprobante_id' : fields.integer('Codigo Comprobante'),
    }