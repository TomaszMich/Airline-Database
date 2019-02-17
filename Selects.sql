--Wybierz imiona, nazwiska, telefon kontaktowy oraz miejscowosc pobytu, za�ogant�w przebywaj�cych w Niemczech

select Imie, Nazwisko, "Telefon kontaktowy", Miejscowosc from Zalogant Z join "Aktualne miejsce pobytu" M
ON Z.ID_miejsca = M.ID_miejsca where Kraj = 'Niemcy';


--Linia lotnicza chce wiedzie�, kt�rzy za�oganci nie byli w 2018 roku na urlopie

SELECT DISTINCT Imie, Nazwisko FROM Zalogant Z join Urlop U ON Z.ID_zaloganta = U.ID_zaloganta
WHERE NOT (year(U.[Od kiedy]) <= 2018 AND year(U.[Do kiedy]) >= 2018);


--Ktore samoloty lataj� w poniedzia�ki?

select Model, Wiek, "Data nastepnego przegladu" from Samolot S, [Typ samolotu] T
where ID_samolotu in (select ID_samolotu from "Lot rzeczywisty"
where ID_lotu_plan in (select ID_lotu_planowego from [Lot planowy] where "Dni odlotow" = 'Poniedzia�ek'))
and S.ID_typu = T.ID_typu;


--Z kt�rego lotniska odbywa si� najwi�cej wylot�w?

select Kod, Miejscowosc, Panstwo from Lotnisko where ID_lotniska
in (SELECT TOP 1 ID_lotniska_pocz FROM [Lot planowy] GROUP BY ID_lotniska_pocz ORDER BY count(ID_lotniska_pocz) DESC);


--Wy�wietl pilot�w z nieaktualn� licencj�
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


--Jaki procent urlop�w by� p�atny?

select sum(case when [Czy platny] = 1 then 1 else 0 end) * 100 / count(*) as [Procent p�atnych urlop�w]
from Urlop


--Ilu zatrudnionych za�ogant�w ma linia lotnicza, wed�ug ich funkcji?
select S.Stopien as Funkcja, count(*) as Ilo�� from Stewardessa S group by S.Stopien
union
select P.Stopien as Funkcja, count(*) as Ilo�� from Pilot P group by P.Stopien;

