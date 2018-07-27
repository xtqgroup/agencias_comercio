# -*- coding: utf-8 -*-
# See README.rst file on addon root folder for license details

from openerp import models, fields, api
from openerp.addons import decimal_precision as dp
from openerp.tools.float_utils import float_compare


class PosOrder(models.Model):
    _inherit = 'pos.order'