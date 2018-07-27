# -*- coding: utf-8 -*-
# See README.rst file on addon root folder for license details

from openerp import models, fields
from openerp.addons import decimal_precision as dp


class PosConfig(models.Model):
    _inherit = 'pos.config'
    co_agencia = fields.Char(string='Codigo de Agencia')