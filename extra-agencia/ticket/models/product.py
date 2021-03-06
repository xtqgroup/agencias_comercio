from openerp import api
from openerp.osv import fields, osv

class product_template(osv.osv): # puede ser product_template
    _inherit = "product.template"
    _columns = {
        'co_producto' : fields.char('Codigo de Producto SGC'),
        'tipo_producto': fields.selection([('EJEMPLARES', 'EJEMPLARES'),('OPTATIVOS','OPTATIVOS')], 'EJEMPLARES y OPTATIVOS',  help="Ejemplares"),        
        'afecto': fields.selection([('Afecto', 'Afecto'),('Inafecto','Inafecto')], 'Afecto e Inafecto', help="Afecto IGV"),        
        'alta_sgc' : fields.boolean('Flag Alta de registro desde SGC') ,
    }
    _defaults = {
        'alta_sgc' : False,
    }
    _sql_constraints = [('co_producto_uniq','unique(co_producto)', 'Codigo de Producto debe ser unico!')
    ]       

class tarifa_excepcion(osv.osv): # puede ser product_template
    _name = "tarifa_excepcion"
    _columns = {
        'fe_emision' : fields.date('Fecha Emision de Precio' , ),
        'product_id': fields.many2one('product.template', 'Product', store = True),
        'p_pauta' : fields.float('Precio', digits=(16,3),required = True),
        'afecto': fields.selection([('Afecto', 'Afecto'),('Inafecto','Inafecto')], 'Afecto e Inafecto', required = True, help="Afecto IGV"),        
    }
    _sql_constraints = [('co_producto_uniq2','unique(fe_emision,producto_id)', 'Codigo de Fecha + Producto debe ser unico!')
    ]       

