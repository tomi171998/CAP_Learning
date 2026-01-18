namespace com.sap.learning;

using {
    cuid,
    managed
} from '@sap/cds/common';

entity Books : cuid, managed {
    title : String(255);
    genre : Genre;
    publCountry : String(3);
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
    currency : String(3);
}

entity Authors : cuid, managed {
    name : String(100);
    dateOfBirth : Date;
    dateOfDeath : Date;
    books : Association to many Books
            on books.author = $self;
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