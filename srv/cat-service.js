const cds = require('@sap/cds');
const { SELECT, UPDATE } = require('@sap/cds/lib/ql/cds-ql');

class CatalogService extends cds.ApplicationService {

    init(){
        const { Books } = this.entities;

        this.after('READ', Books, this.grantDiscount);
        this.on('submitOrder', this.reduceStock);

        return super.init();
    }

    grantDiscount(results){
        for (let b of results) {
            if (b.stock > 200) { b.title += ' -- 11% Discount!'; }
        }
    }

    async reduceStock(req){
        const { Books } = this.entities;
        const { book, quantity } = req.data;

        if (quantity < 1){
            return req.error('INVALID_QUANTITY');
        }

        // let query1 = SELECT.one.from(Books).where({ ID: book }).columns(b => { b.stock });
        // let query1 = SELECT.one.from(Books).where`ID=${book}`.columns`stock`; //tagged template
        // const b = await cds.db.run(query1);
        const b = await SELECT.one.from(Books).where({ ID: book }).columns(b => { b.stock });
        if (!b) {
            return req.error('BOOK_NOT_FOUND', [book]);
        }

        if (quantity > b.stock) {
            // return req.error(`${quantity} exceeds stock ${b.stock} for book with ID ${book}.`);
            return req.error('ORDER_EXCEEDS_STOCK', [quantity, b.stock, book]);
        }

        await UPDATE(Books).where({ ID: book }).with({ stock: { '-=': quantity } });
        // let query2 = UPDATE(Books).where`ID=${book}`.with`stock = stock - ${quantity}`; //tagged template

        return { stock: stock - quantity };
    }
}

module.exports = CatalogService;