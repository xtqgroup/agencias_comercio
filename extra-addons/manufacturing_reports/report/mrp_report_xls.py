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

import xlwt
import datetime
from openerp.addons.report_xls.report_xls import report_xls


def get_xls(row):
       
    #getvals = {
        #'product': obj[int('de_producto')],
        #'user_id': obj["no_canilla"],
        #'date_planned': obj['fe_emision'],
    #}
    templist1 = [
                 (1, 1, 0, 'text', str(row[13])), 
                 (2, 1, 0, 'text', str(row[1])),
                 (3,1,0, 'text', str(row[1])),
                 (4,1,0, 'text', str(row[11])), 
                 (5,1,0, 'text', str(row[12])), 
                 (6,1,0, 'text', row[2]),
                 (7,1,0, 'text', row[3]),
                 (8,1,0, 'text', row[4]),
                 (9,1,0, 'text', row[5]),
                 (10,1,0, 'text', str(row[6])),
                 (11,1,0, 'text', str(row[7])),
                 (12,1,0, 'text', str(row[8])),
                 (13,1,0, 'text', str(row[9])),
                 (14,1,0, 'text', row[10]),
                 ]
    return templist1

def get_xls2(row2):
       
    #getvals = {
        #'product': obj[int('de_producto')],
        #'user_id': obj["no_canilla"],
        #'date_planned': obj['fe_emision'],
    #}
    templist3 = [
                 (1, 1, 0, 'text', str(row2[0])),
                 (2, 1, 0, 'text', row2[1]),
                 (3,1,0, 'text', str(row2[2])),
                 (4,1,0, 'text', str(row2[3])),
                 (5,1,0, 'text', row2[4]),
                 (6,1,0, 'text', str(row2[5])),
                 (7,1,0, 'text', str(row2[6])),
                 (8,1,0, 'text', row2[7]),
                 (9,1,0, 'text', str(row2[8])),
                 (10,1,0, 'text', str(row2[9])),
                 (11,1,0, 'text', str(row2[10])),
                 ]
    return templist3

def get_xls3(row3):
       
    #getvals = {
        #'product': obj[int('de_producto')],
        #'user_id': obj["no_canilla"],
        #'date_planned': obj['fe_emision'],
    #}
    templist5 = [
                 (1, 1, 0, 'text', str(row3[0])),
                 (2, 1, 0, 'text', row3[1]),
                 (3,1,0, 'text', str(row3[2])),
                 (4,1,0, 'text', row3[3]),
                 (5,1,0, 'text', str(row3[4])),
                 (6,1,0, 'text', str(row3[5])),
                 (7,1,0, 'text', str(row3[6])),
                 (8,1,0, 'text', str(row3[7])),
                 (9,1,0, 'text', str(row3[8])),
                 (10,1,0, 'text', str(row3[9])),
                 ]
    return templist5

def get_xls4(row4):
       
    #getvals = {
        #'product': obj[int('de_producto')],
        #'user_id': obj["no_canilla"],
        #'date_planned': obj['fe_emision'],
    #}
    templist7 = [
                 (1, 1, 0, 'text', str(row4[0])),
                 (2,1,0, 'text', row4[1]),
                 (3,1,0, 'text', row4[2]),
                 (4,1,0, 'text', row4[3]),
                 (5,1,0, 'text', row4[4]),
                 (6,1,0, 'text', row4[5]),
                 ]
    return templist7

class MrpXlsReport(report_xls):

    def generate_xls_report(self, _p, _xs, data, objects, wb): #wb = workbook
            report_name = "REGISTRO DE VENTAS"
            report_name2= "CONSOLIDADO DE EJEMPLARES"
            report_name3= "CONSOLIDADO DE PRODUCTOS"
            report_name4= "COMPARATIVO VENTASvsCOMPRAS"
            ws = wb.add_sheet(report_name[:31], cell_overwrite_ok=False)
            ws2 = wb.add_sheet('CONSOLIDADO DE EJEMPLARES')
            ws3 = wb.add_sheet('CONSOLIDADO DE PRODUCTOS')
            ws4 = wb.add_sheet('COMPARATIVO VENTASvsCOMPRAS')
                
            ws.panes_frozen = True
            ws.split_panes = True
            ws2.panes_frozen = True
            ws2.split_panes = True
            ws3.panes_frozen = True
            ws3.split_panes = True
            ws4.panes_frozen = True
            ws4.split_panes = True
            
            """wW1"""
            ws.portrait = 1
            ws.fit_width_to_pages = 1
            row_pos = 0
            ws.set_horz_split_pos(row_pos)
            ws.header_str = self.xls_headers['standard']
            ws.footer_str = self.xls_footers['standard']
            """WS2"""
            ws2.portrait = 1
            ws2.fit_width_to_pages = 1
            row_pos2 = 0
            ws2.set_horz_split_pos(row_pos2)
            ws2.header_str = self.xls_headers['standard']
            ws2.footer_str = self.xls_footers['standard']
            """W3"""
            ws3.portrait = 1
            ws3.fit_width_to_pages = 1
            row_pos3 = 0
            ws3.set_horz_split_pos(row_pos3)
            ws3.header_str = self.xls_headers['standard']
            ws3.footer_str = self.xls_footers['standard']
            """W4"""
            ws4.portrait = 1
            ws4.fit_width_to_pages = 1
            row_pos4 = 0
            ws4.set_horz_split_pos(row_pos4)
            ws4.header_str = self.xls_headers['standard']
            ws4.footer_str = self.xls_footers['standard']
            
            _xs.update({
                'xls_title': 'font: bold true, height 350;'
            })
            _xs.update({
                'xls_sub_title': 'font: bold false, height 250;'
            })
            cell_style = xlwt.easyxf(_xs['xls_title'] + _xs['left'])
            cell_center = xlwt.easyxf(_xs['left'])
            cell_center_bold_no = xlwt.easyxf(_xs['left'] + _xs['bold'])
            cell_left_b = xlwt.easyxf(_xs['left'] + _xs['bold'])
            
            c_specs = [('report_name', 8, 0, 'text', report_name)]
            row_pos += 1
            row_data = self.xls_row_template(c_specs, ['report_name'])
            row_pos = self.xls_write_row(ws, row_pos, row_data, row_style=cell_style)
            ws.row(row_pos - 1).height_mismatch = True
            ws.row(row_pos - 1).height = 220 * 2
            row_pos += 1
            date_report = "Reporte elaborado el día:" + str(datetime.datetime.now().strftime("%Y-%m-%d"))
            top2 = [('entry1', 3, 0, 'text', date_report)]
            row_data = self.xls_row_template(top2, [x[0] for x in top2])
            row_pos = self.xls_write_row(ws, row_pos, row_data, cell_left_b)
            row_pos += 1

            templist = [(1,1,0, 'text', 'Correlativo'), 
                        (2,1,0, 'text', 'Fecha de emision'),
                        (3,1,0, 'text', 'Fecha de vencimiento'), 
                        (4,1,0, 'text', 'Serie'),
                        (5,1,0, 'text', 'Folio'),
                        (6,1,0, 'text', 'Tipo de Documento'),
                        (7,1,0, 'text', 'Numero'),
                        (8,1,0, 'text', 'Descripcion'),
                        (9,1,0, 'text', 'Exporta'),
                        (10,1,0, 'text', 'Precio Base'),
                        (11,1,0, 'text', 'Exonerado'),
                        (12,1,0, 'text', 'IGV'),
                        (13,1,0, 'text', 'Total'),
                        (14,1,0, 'text', 'Tipo de Producto'),]
            row_pos += 1
            row_data = self.xls_row_template(templist, [x[0] for x in templist])
            row_pos = self.xls_write_row(ws, row_pos, row_data, cell_center_bold_no)

            if data['filter'] is False:
                if data['filter_user'] is False:
                    ## Trabajar con esta opcion:
                    if len(data['product']) == 0 and data['stage'] is False and data['fecha_inicio'] and data['fecha_termino']:
# reporte de ventas                         
                        self.cr.execute("""
                        SELECT ' ',fe_emision,
                        (case when ti_documento='DNI' then '1' else '6' end),
                        nu_documento, no_canilla, '0', 
                        pbase,
                        exonerado,igv,total,
                        (case grupo_producto when '1' then 'EDI' else 'OPT' end), 
                        serie, folio, serie || lpad(cast(folio as char),8,'0') as correlativo
                        FROM comprobante WHERE fe_emision >= %s AND fe_emision <= %s
                        order by ti_documento desc, grupo_producto, folio, correlativo, no_canilla
                        """,(data['fecha_inicio'],data['fecha_termino'],)) 
                        #for i in self.pool.get('ticket_input').search(self.cr, self.uid, []):
                        #   obj = self.pool.get('ticket_input').browse(self.cr, self.uid, i)
                        obj= self.cr.fetchall()
                        for row in obj:
                            self.templist1 = get_xls(row)
                            row_data = self.xls_row_template(self.templist1, [x[0] for x in self.templist1])
                            row_pos = self.xls_write_row(ws, row_pos, row_data, cell_center)
                            
                            
            c_specs2 = [('report_name2', 8, 0, 'text', report_name2)]
            row_pos2 += 1
            row_data2 = self.xls_row_template(c_specs2, ['report_name2'])
            row_pos2 = self.xls_write_row(ws2, row_pos2, row_data2, row_style=cell_style)
            ws2.row(row_pos2 - 1).height_mismatch = True
            ws2.row(row_pos2 - 1).height = 220 * 2
            row_pos2 += 1
            date_report = "Reporte elaborado el día:" + str(datetime.datetime.now().strftime("%Y-%m-%d %H:%M %p"))
            top2 = [('entry1', 3, 0, 'text', date_report)]
            row_data2 = self.xls_row_template(top2, [x[0] for x in top2])
            row_pos2 = self.xls_write_row(ws2, row_pos2, row_data2, cell_left_b)
            row_pos2 += 1   
            
            templist2 = [(1,1,0, 'text', 'Fecha de Emision'), 
                        (2,1,0, 'text', 'Tipo'),
                        (3,1,0, 'text', 'Codigo'), 
                        (4,1,0, 'text', 'Precio'), 
                        (5,1,0, 'text', 'Descripcion'),
                        (6,1,0, 'text', 'Cantidad'),
                        (7,1,0, 'text', 'Afecto'),
                        (8,1,0, 'text', 'Inafecto'),
                        (9,1,0, 'text', 'IGV'),
                        (10,1,0, 'text', 'Total'),
                        (11,1,0, 'text', 'Promedio'),]
            row_pos2 += 1
            row_data2 = self.xls_row_template(templist2, [x[0] for x in templist2])
            row_pos2 = self.xls_write_row(ws2, row_pos2, row_data2, cell_center_bold_no)
            
            if data['filter'] is False:
                if data['filter_user'] is False:
                    ## Trabajar con esta opcion:  EJEMPLARES
                    if len(data['product']) == 0 and data['stage'] is False and data['fecha_inicio'] and data['fecha_termino']:
                         
                        self.cr.execute("""
                        SELECT 
                        co.fe_emision, 
                        (case coli.tipo_producto when 'EJEMPLARES' then 'EDI' else 'OPT' end),
                        coli.co_producto, 
                        coli.p_pauta, 
                        coli.de_producto, 
                        sum(coli.q_vendida_neto), 
                        sum(coli.pbase), 
                        '0', 
                        sum(coli.igv), 
                        sum(coli.total), 
                        sum(coli.total) / sum(coli.q_vendida_neto)
                        FROM 
                        comprobante co, comprobante_linea coli 
                        WHERE 
                        co.id = coli.comprobante_id 
                        AND coli.tipo_producto = 'EJEMPLARES'
                        AND co.fe_emision >= %s 
                        AND co.fe_emision <= %s 
                        GROUP BY 
                        co.fe_emision,coli.tipo_producto,coli.co_producto,coli.de_producto,coli.p_pauta
                        """,(data['fecha_inicio'],data['fecha_termino'],)) 

                        #for i in self.pool.get('ticket_input').search(self.cr, self.uid, []):
                        #   obj = self.pool.get('ticket_input').browse(self.cr, self.uid, i)
                        obj2= self.cr.fetchall()
                        for row2 in obj2:
                            self.templist3 = get_xls2(row2)
                            row_data2 = self.xls_row_template(self.templist3, [x[0] for x in self.templist3])
                            row_pos2 = self.xls_write_row(ws2, row_pos2, row_data2, cell_center)
            
            c_specs3 = [('report_name3', 8, 0, 'text', report_name3)]
            row_pos3 += 1
            row_data3 = self.xls_row_template(c_specs3, ['report_name3'])
            row_pos3 = self.xls_write_row(ws3, row_pos3, row_data3, row_style=cell_style)
            ws3.row(row_pos3 - 1).height_mismatch = True
            ws3.row(row_pos3 - 1).height = 220 * 2
            row_pos3 += 1
            date_report = "Reporte elaborado el día:" + str(datetime.datetime.now().strftime("%Y-%m-%d %H:%M %p"))
            top3 = [('entry1', 3, 0, 'text', date_report)]
            row_data3 = self.xls_row_template(top3, [x[0] for x in top3])
            row_pos3 = self.xls_write_row(ws3, row_pos3, row_data3, cell_left_b)
            row_pos3 += 1   
            
            templist4 = [(1,1,0, 'text', 'Fecha de Emision'), 
                        (2,1,0, 'text', 'Grupo'),
                        (3,1,0, 'text', 'Codigo'), 
                        (4,1,0, 'text', 'Descripcion'),
                        (5,1,0, 'text', 'Cantidad'),
                        (6,1,0, 'text', 'Afecto'),
                        (7,1,0, 'text', 'Inafecto'),
                        (8,1,0, 'text', 'IGV'),
                        (9,1,0, 'text', 'Total'),
                        (10,1,0, 'text', 'Promedio'),]
            row_pos3 += 1
            row_data3 = self.xls_row_template(templist4, [x[0] for x in templist4])
            row_pos3 = self.xls_write_row(ws3, row_pos3, row_data3, cell_center_bold_no)
            
            if data['filter'] is False:
                if data['filter_user'] is False:
                    ## Trabajar con esta opcion:  PRODUCTOS
                    if len(data['product']) == 0 and data['stage'] is False and data['fecha_inicio'] and data['fecha_termino']:
                         
                        self.cr.execute("""
                        SELECT 
                        co.fe_emision, 
                        (case co.grupo_producto when '1' then 'EDI' else 'OPT' end), 
                        coli.co_producto, 
                        coli.de_producto, 
                        sum(coli.q_vendida_neto) as Cantidad, 
                        sum(coli.pbase) as Afecto,
                        sum(coli.exonerado) as Inafecto,
                        sum(coli.igv),
                        sum(coli.total),
                        sum(coli.total)  / sum(coli.q_vendida_neto) 
                        FROM 
                        comprobante co, comprobante_linea coli WHERE co.id = coli.comprobante_id
                        AND coli.tipo_producto <> 'EJEMPLARES' 
                        AND co.fe_emision >= %s AND co.fe_emision <= %s 
                        GROUP BY 
                        co.fe_emision,co.grupo_producto, co.fe_emision, coli.co_producto,coli.de_producto,coli.tipo_afecto 
                        HAVING sum(coli.q_vendida_neto) > 0
                        """,(data['fecha_inicio'],data['fecha_termino'],)) 

                        #for i in self.pool.get('ticket_input').search(self.cr, self.uid, []):
                        #   obj = self.pool.get('ticket_input').browse(self.cr, self.uid, i)
                        obj3= self.cr.fetchall()
                        for row3 in obj3:
                            self.templist5 = get_xls3(row3)
                            row_data3 = self.xls_row_template(self.templist5, [x[0] for x in self.templist5])
                            row_pos3 = self.xls_write_row(ws3, row_pos3, row_data3, cell_center)
            
            c_specs4 = [('report_name4', 8, 0, 'text', report_name4)]
            row_pos4 += 1
            row_data4 = self.xls_row_template(c_specs4, ['report_name4'])
            row_pos4 = self.xls_write_row(ws4, row_pos4, row_data4, row_style=cell_style)
            ws4.row(row_pos4 - 1).height_mismatch = True
            ws4.row(row_pos4 - 1).height = 220 * 2
            row_pos4 += 1
            date_report = "Reporte elaborado el día:" + str(datetime.datetime.now().strftime("%Y-%m-%d %H:%M %p"))
            top4 = [('entry1', 3, 0, 'text', date_report)]
            row_data4 = self.xls_row_template(top4, [x[0] for x in top4])
            row_pos4 = self.xls_write_row(ws4, row_pos4, row_data4, cell_left_b)
            row_pos4 += 1   
            
            templist4 = [(1,1,0, 'text', 'Fecha de Corte'), 
                        (2,1,0, 'text', 'Codigo Producto'), 
                        (3,1,0, 'text', 'Nombre Producto'),
                        (4,1,0, 'text', 'Suma Compra'),
                        (5,1,0, 'text', 'Suma Venta'),
                        (6,1,0, 'text', 'Diferencia'),]
            row_pos4 += 1
            row_data4 = self.xls_row_template(templist4, [x[0] for x in templist4])
            row_pos4 = self.xls_write_row(ws4, row_pos4, row_data4, cell_center_bold_no)
            
            if data['filter'] is False:
                if data['filter_user'] is False:
                    ## Trabajar con esta opcion:
                    if len(data['product']) == 0 and data['stage'] is False and data['fecha_inicio'] and data['fecha_termino']:
                         
                        self.cr.execute("""
                            SELECT 
                            (Case When suma_vendida_neto is not  null Then sub_venta.fe_emision Else sub_compra.date_planned End),
                            (Case When suma_vendida_neto is not null Then sub_venta.co_producto Else substring(sub_compra.name,2,18) End),
                            (Case When suma_vendida_neto is not null Then sub_venta.de_producto Else substring(sub_compra.name,21) End),
                            (suma_comprada_neto)::varchar(20), 
                            (suma_vendida_neto)::varchar(20),
                            ((suma_comprada_neto - suma_vendida_neto))::varchar(20) as diferencia
                            FROM 
                            (
                            select max(pol.date_planned) as date_planned, pol.name, substring(pol.name,2,18), sum(pol.product_qty) as suma_comprada_neto
                            from product_template pt, product_product pp, purchase_order po, purchase_order_line pol
                            where 
                            pt.id = pp.product_tmpl_id 
                            and pol.product_id = pp.id 
                            and po.id = pol.order_id
                            and date_planned >= %s 
                            and date_planned <= %s
                            group by pol.name, substring(pol.name,2,18), pol.product_id
                            ) as sub_compra
                            FULL OUTER JOIN
                            (
                            select co.fe_emision, coli.de_producto, coli.co_producto, sum(coli.q_vendida_neto) as suma_vendida_neto
                            from product_template pt, product_product pp, comprobante co, comprobante_linea coli
                            where 
                            pt.id = pp.product_tmpl_id 
                            and coli.co_producto = pt.co_producto 
                            and co.id = coli.comprobante_id 
                            and fe_emision >= %s 
                            and fe_emision <= %s
                            group by co.fe_emision, coli.de_producto, coli.co_producto
                            ) as sub_venta
                            ON 
                            substring(sub_compra.name,2,18) = sub_venta.co_producto
                            """,(data['fecha_inicio'],data['fecha_termino'],data['fecha_inicio'],data['fecha_termino'])) 

                        #for i in self.pool.get('ticket_input').search(self.cr, self.uid, []):
                        #   obj = self.pool.get('ticket_input').browse(self.cr, self.uid, i)
                        obj4= self.cr.fetchall()
                        for row4 in obj4:
                            self.templist7 = get_xls4(row4)
                            row_data4 = self.xls_row_template(self.templist7, [x[0] for x in self.templist7])
                            row_pos4 = self.xls_write_row(ws4, row_pos4, row_data4, cell_center)
        
MrpXlsReport('report.mrp_reports_xls', 'sale.order')
