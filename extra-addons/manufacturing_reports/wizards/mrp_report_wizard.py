    # -*- coding: utf-8 -*-
##############################################################################
#
#    Cybrosys Technologies Pvt. Ltd.
#    Copyright (C) 2012-TODAY Cybrosys Technologies(<http://www.cybrosys.com>).
#    Author: Cybrosys Technologies(<http://www.cybrosys.com>)
#    you can modify it under the terms of the GNU LESSER
#    GENERAL PUBLIC LICENSE (LGPL v3), Version 3.
#
#    It is forbidden to publish, distribute, sublicense, or sell copies
#    of the Software or modified copies of the Software.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU LESSER GENERAL PUBLIC LICENSE (LGPL v3) for more details.
#
#    You should have received a copy of the GNU LESSER GENERAL PUBLIC LICENSE
#    GENERAL PUBLIC LICENSE (LGPL v3) along with this program.
#    If not, see <http://www.gnu.org/licenses/>.
#
##############################################################################

from openerp import models, fields, api

class SaleReportWizard (models.Model):
    _name = "sales.report"
    
    filter = fields.Boolean("Filtrar por fecha")
    date_from = fields.Date("Dia Inicial")
    date_to = fields.Date("Dia Final")
    filter_user = fields.Boolean('Filter On Responsible')
    responsible = fields.Many2many('res.users', string='Responsible')
    product = fields.Many2many('product.product', string='Product')
    stage = fields.Selection([
        ('manual', 'Venta a Facturar'),
        ('draft', 'Borrador'),
        ('progress', 'In Progress'),
        ('done', 'Done'),
        ('cancel', 'Cancelled')], string="Filter State")
    codigo_estado  = fields.Char(compute='_get_ciclo', string='Codigo de Estado')
    fecha_inicio  = fields.Date(compute='_get_ciclo', string='Fecha de Inicio')
    fecha_termino  = fields.Date(compute='_get_ciclo', string='Fecha de Termino')
    ciclo_facturacion = fields.Many2one('ciclo_facturacion', string='Ciclo Facturacion')

    def check_report_sale(self, cr, uid, ids, context):
        data = self.read(cr, uid, ids, ['filter_user',
                                        'filter', 'fecha_inicio', 'responsible',
                                        'fecha_termino', 'product', 'stage'], context=context)[0]
        return {'type': 'ir.actions.report.xml',
                'report_name': 'mrp_reports_xls',
                'datas': data}
    
    @api.one
    @api.depends('ciclo_facturacion')
    def _get_ciclo(self): 
        for rec in self.ciclo_facturacion:
            self.fecha_inicio = rec.fe_inicio
            self.fecha_termino = rec.fe_termino
            self.codigo_estado = rec.co_estado 

    
