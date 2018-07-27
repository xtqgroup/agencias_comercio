from openerp.osv import fields, osv
import openerp.addons.decimal_precision as dp
from openerp.tools.translate import _
import time
class pos_down_ticket(osv.osv_memory):
    _name = 'pos_down_ticket'
    _columns = {
        'name' : fields.char('Reason', readonly=True),
        # Attention, we don't set a domain, because there is a journal_type key 
        # in the context of the action
        'amount' : fields.float('Amount',
                                digits_compute = dp.get_precision('Account'),
                                readonly=True),
    }

    def run(self, cr, uid, ids, context=None):
        # cop
        if not context:
            context = dict()

        active_model = context.get('active_model', False) or False
        active_ids = context.get('active_ids', []) or []

        records = self.pool[active_model].browse(cr, uid, active_ids, context=context)

        return self._run(cr, uid, ids, records, context=context)

    def _run(self, cr, uid, ids, records, context=None):

        for box in self.browse(cr, uid, ids, context=context):
            for record in records:
                if not record.journal_id:
                    raise osv.except_osv(_('Error!'),
                                         _("Please check that the field 'Journal' is set on the Bank Statement"))
                    
                if not record.journal_id.internal_account_id:
                    raise osv.except_osv(_('Error!'),
                                         _("Please check that the field 'Internal Transfers Account' is set on the payment method '%s'.") % (record.journal_id.name,))

                self._create_bank_statement_line(cr, uid, box, record, context=context)

        return {}

    def _create_bank_statement_line(self, cr, uid, box, record, context=None):
        values = self._compute_values_for_statement_line(cr, uid, box, record, context=context)
        return self.pool.get('account.bank.statement.line').create(cr, uid, values, context=context)

    def _compute_values_for_statement_line(self, cr, uid, box, record, context=None):
        fecha_hoy = context.get('date', time.strftime('%d/%m/%Y'))
        cr.execute('select distinct co_canilla,fe_emision,qp_cancelo from ticket_trans where fe_emision::date = %s', (fecha_hoy,))
        res = cr.fetchall()
        sum=0
        for i in res:
            sum=sum+i[2]
        if sum==0:
            raise osv.except_osv(_('Suma de pagos = 0'), _("Usted debe de importar los datos del dia a partir de Sistema SGC"))
        if not record.journal_id.internal_account_id.id:
            raise osv.except_osv(_('Configuration Error'), _("You should have defined an 'Internal Transfer Account' in your cash register's journal!"))
        return {
            'statement_id': record.id,
            'journal_id': record.journal_id.id,
            'amount': sum or 0.0,
            'account_id': record.journal_id.internal_account_id.id,
            'ref': '%s' % ('SGC-ElComercio' or ''),
            'name': 'Pagos de Canillas',
        }
