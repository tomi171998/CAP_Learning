namespace com.sap.learning;

entity Books {
    key ID : UUID;
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

entity Authors {
    key ID : UUID;
    name : String(100);
    dateOfBirth : Date;
    dateOfDeath : Date;
    books : Association to many Books
            on books.author = $self;
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