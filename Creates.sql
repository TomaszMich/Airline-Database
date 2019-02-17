create table "Typ samolotu"
(ID_typu int identity primary key,
"Liczba stewardess" int not null,
"Liczba pilotow" int not null,
"Pojemnosc pasazerow" int,
"Model" varchar(12) not null,
constraint minPilotow check ("Liczba pilotow" > 0)
);

create table "Lotnisko"
(ID_lotniska int identity primary key,
Panstwo varchar(20) not null,
Miejscowosc varchar(20) not null,
Kod char(3) unique not null
);

create table "Lot planowy"
(ID_lotu_planowego int identity primary key,
"Dni odlotow" varchar(20) not null,
"Godzina odlotow" varchar(5) not null,
ID_lotniska_pocz int references Lotnisko not null,
ID_lotniska_kon int references Lotnisko not null,
ID_typu int references "Typ samolotu" not null,
);

create table "Samolot"
(ID_samolotu int identity primary key,
Wiek int not null,
"Data nastepnego przegladu" date not null,
ID_typu int references "Typ samolotu" not null,
constraint wiekSamolotu check (Wiek >= 0)
);

create table "Lot rzeczywisty"
(ID_lotu_rzecz int identity primary key,
"Data lotu" date not null,
"Godzina zamkniecia bramki" char(5) not null,
"Godzina odlotu" char(5) not null,
ID_samolotu int references Samolot not null,
ID_lotu_plan int references "Lot planowy" not null,
constraint godziny check ("Godzina zamkniecia bramki" < "Godzina odlotu")
);

create table "Aktualne miejsce pobytu"
(ID_miejsca int identity primary key,
Kraj varchar(20) not null,
Miejscowosc varchar(20) not null,
"Data" date not null
);

create nonclustered index miejscowoscPobytu
on "Aktualne miejsce pobytu"(Miejscowosc);

create table Zalogant
(ID_zaloganta int identity primary key,
Imie varchar(10) not null,
Nazwisko varchar(20) not null,
"Forma zatrudnienia" varchar(20),
Wynagrodzenie int,
Narodowosc varchar(30),
"Telefon kontaktowy" int not null,
"Data urodzenia" date not null,
Adres varchar(100) not null,
ID_miejsca int references "Aktualne miejsce pobytu" not null
);

create table Pilot
(ID_zaloganta int primary key not null,
Stopien varchar(16) not null,
"Przelatane godziny" int not null,
foreign key (ID_zaloganta) references Zalogant(ID_zaloganta)
on delete cascade on update cascade
);

create table Stewardessa
(ID_zaloganta int primary key not null,
"Znane jêzyki obce" varchar(20),
Kursy varchar(50),
Stopien varchar(30) not null,
foreign key (ID_zaloganta) references Zalogant(ID_zaloganta)
on delete cascade on update cascade
);

create table "Przypisanie do lotu"
(ID_przypisania int identity primary key, 
"Data przypisania" date not null,
"Czy zalogant dostêpny" bit not null,
Funkcja varchar(16) not null,
ID_lotu_rzecz int references "Lot rzeczywisty" not null,
ID_stewardessy int references Stewardessa,
ID_pilota int references Pilot
);

create table Urlop
(ID_urlopu int identity primary key,
"Od kiedy" date not null,
"Do kiedy" date not null,
"Czy platny" bit not null,
ID_zaloganta int references Zalogant not null,
constraint datyUrlopu check ("Od kiedy" < "Do kiedy")
);

create table Licencja
(ID_licencji int identity primary key,
Nazwa varchar(100) not null,
"Organ wydajacy" varchar(30) not null,
"Data otrzymania" date not null,
"Data waznosci" date,
ID_pilota int references Pilot not null,
ID_typu int references "Typ samolotu" not null
);

create table "Badanie lekarskie"
(ID_badania int identity primary key,
"Data badania" date not null,
"Wazne do" date,
"Lekarz przeprowadzajacy" varchar(40) not null,
ID_zaloganta int references Zalogant not null
);
