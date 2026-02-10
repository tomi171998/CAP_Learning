namespace com.sap.learning;

using {
    cuid,
    managed,
    sap.common.CodeList,
    Country,
    Currency
} from '@sap/cds/common';

entity Books : cuid, managed {
    title : localized String(255); //Creates a second table Books.texts where ID of Books entity is connecting this tables
    genre : Genre;
    publCountry : Country;
    stock : NoOfBooks;
    price : Price;
    isHardcover : Boolean;
    author: Association to Authors;
}

type Genre : Integer enum {
    fiction = 1;
    non_fiction = 2;
}

type NoOfBooks : Integer;

type Price {
    amount : Decimal;
    currency : Currency;
}

entity Authors : cuid, managed {
    name : String(100);
    dateOfBirth : Date;
    dateOfDeath : Date;
    books : Association to many Books
            on books.author = $self;
    epochs : Association to Epochs
}

extend Authors with ManagedObject;
extend Books with ManagedObject;

//Named aspect
aspect ManagedObject {
    createdAt : Timestamp;
    createdBy : String(255);
}



entity Orders {
    key ID : UUID;
    description : String(100);
    items : Composition of many OrderItems
            on items.order = $self;
}

entity OrderItems {
    key order : Association to Orders;
    key pos : Integer;
}

entity Epochs : CodeList {
    key ID : Integer;
}