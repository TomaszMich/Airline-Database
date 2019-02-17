--Wybierz imiona, nazwiska, telefon kontaktowy oraz miejscowosc pobytu, za³ogantów przebywaj¹cych w Niemczech

select Imie, Nazwisko, "Telefon kontaktowy", Miejscowosc from Zalogant Z join "Aktualne miejsce pobytu" M
ON Z.ID_miejsca = M.ID_miejsca where Kraj = 'Niemcy';


--Linia lotnicza chce wiedzieæ, którzy za³oganci nie byli w 2018 roku na urlopie

SELECT DISTINCT Imie, Nazwisko FROM Zalogant Z join Urlop U ON Z.ID_zaloganta = U.ID_zaloganta
WHERE NOT (year(U.[Od kiedy]) <= 2018 AND year(U.[Do kiedy]) >= 2018);


--Ktore samoloty lataj¹ w poniedzia³ki?

select Model, Wiek, "Data nastepnego przegladu" from Samolot S, [Typ samolotu] T
where ID_samolotu in (select ID_samolotu from "Lot rzeczywisty"
where ID_lotu_plan in (select ID_lotu_planowego from [Lot planowy] where "Dni odlotow" = 'Poniedzia³ek'))
and S.ID_typu = T.ID_typu;


--Z którego lotniska odbywa siê najwiêcej wylotów?

select Kod, Miejscowosc, Panstwo from Lotnisko where ID_lotniska
in (SELECT TOP 1 ID_lotniska_pocz FROM [Lot planowy] GROUP BY ID_lotniska_pocz ORDER BY count(ID_lotniska_pocz) DESC);


--Wyœwietl pilotów z nieaktualn¹ licencj¹
/*
create view [Niewazna licencja] as 
select Imie, Nazwisko, Nazwa, [Data waznosci]
from Zalogant Z, Licencja L
where ID_zaloganta in
(select ID_zaloganta from Pilot where ID_zaloganta in
(select ID_pilota from Licencja where [Data waznosci] <
(select convert(date, SYSDATETIME()))))
and L.ID_licencji in (select ID_licencji from Licencja where [Data waznosci] < (select
convert(date, SYSDATETIME())))
and Z.ID_zaloganta = L.ID_pilota;
*/
select * from [Niewazna licencja]


--Jaki procent urlopów by³ p³atny?

select sum(case when [Czy platny] = 1 then 1 else 0 end) * 100 / count(*) as [Procent p³atnych urlopów]
from Urlop


--Ilu zatrudnionych za³ogantów ma linia lotnicza, wed³ug ich funkcji?
select S.Stopien as Funkcja, count(*) as Iloœæ from Stewardessa S group by S.Stopien
union
select P.Stopien as Funkcja, count(*) as Iloœæ from Pilot P group by P.Stopien;

