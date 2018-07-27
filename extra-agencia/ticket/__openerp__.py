# -*- coding: utf-8 -*-
# © <2016> <Luis Felipe Mileo>
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl).
{
    "name": "Ticket El Comercio NEW",
    "summary": "Modulo de Importacion de  datos y facturacion del Comercio",
    "version": "8.0.1.0",
    "category": "custom",
    "website": "www.xtqgroup.com/",
    "author": "XTQ GROUP SAC",
    "license": "AGPL-3",
    "application": False,
    "installable": True,
    "depends": [
        "base",
        "point_of_sale",        
        "account",
        "security_stock",        
    ],
    "data": [
        'views/ticket.xml',
        'views/res_partner_view.xml',
        'views/product_view.xml',
        'wizard/pos_down_ticket.xml',        
    ],
}
