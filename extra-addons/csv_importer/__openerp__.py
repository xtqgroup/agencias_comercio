# -*- coding: utf-8 -*-
##############################################################################
#
#    OpenERP, Open Source Management Solution
#    Copyright (C) 2004-2010 Tiny SPRL (<http://tiny.be>).
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Affero General Public License as
#    published by the Free Software Foundation, either version 3 of the
#    License, or (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Affero General Public License for more details.
#
#    You should have received a copy of the GNU Affero General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
##############################################################################
{
    'name': "CSV Importer",
    'summary': """ Import your CSV in background """,
    'description': """
    This module enables to import any file into background. 
    You need not to wait till the completion of import for any file.
    """,

    # Author Details 
    'author': "Deepak Dixit",
    'website': "https://github.com/SpiritualDixit",

    # App Technical Details
    'category': 'Tools',
    'version': '1.0.0',
    
    # any module necessary for this one to work correctly
    'depends': ['base'],

    # always loaded
    'data': [
             'views/installer.xml',
             'views/csv_importer.xml',
#             'views/csv_importer_force.xml',
    ],
    
    # only loaded in demonstration mode
    'demo': [],
    'installable': True,
    'auto_install': False,
}

# vim:expandtab:smartindent:tabstop=4:softtabstop=4:shiftwidth=4:
