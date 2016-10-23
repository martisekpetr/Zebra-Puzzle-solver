% ZEBRA SOLVER
% Petr Martisek, II. rocnik
% letni semestr 2012/13
% Neproceduralni programovani NPRG005, cvicici RNDr. Rudolf Kryl
%
% Pouzite struktury:
% ==================
% podminka([(Vlastnost1, Hodnota1), (Vlastnost2, Hodnota2), ...])
%      - podminka mluvici o jednom objektu, napr.:
%      "Nor bydli v modrem dome." -> podminka([(narodnost, nor), (barva,modra)]).
%
% podminka([(Vlastnost1,Hodnota1),(Vlastnost2,Hodnota2),...],[Relace1, Relace2, ...])
%      - podminka mluvici o vztazich K objektu, kde K je delka seznamu
%      v prvnim argumentu
%      - vztahy jsou K-arni relace dane seznamem v druhem argumentu
%      - preddefinovane relace jsou: soused/2, vpravo/2, vlevo/2
%      - relace bere za argumenty objekty ve tvaru:
%        [Hodnota0,Hodnota1, Hodnota2, ... , HodnotaM]
%      kde M je pocet vlastnosti, Hodnota0 odpovida zabudovane
%      vlastnosti index a zbyle hodnoty odpovidaji vlastnostem v poradi,
%      v jakem jsou uvedeny v druhem argumentu predikatu zebra
% otazka((Vlastnost1,Hodnota1), Vlastnost2)
%      - chceme znat hodnotu vlastnosti Vlastnost2 u objektu, jehoz
%      Vlastnost1 nabyva hodnoty Hodnota1, napr.: "Jake zvire chova
%      Nor?" -> otazka((narodnost,nor), zvire).
%      ===================================================================
%
%
%


% zebra(+PocetObjektu, +SeznamVlastnosti, +SeznamPodminek,
% +SeznamOtazek, -SeznamOdpovedi)
zebra(N, Vlastnosti, Podminky, Otazky, Odpovedi):-

        %k zadanym vlastnostem pridame vlastnost 'index', udavajici poradi domu v rade
	pridejIndex(Vlastnosti, Vlastnosti2),

	%extrahujeme hodnoty vlastnosti, o nichz se mluvi v podminkach a v otazkach,
	%a vytvorime z nich 'castecne objekty', napr. [_,_,modra,_,pes,_]
	extrahujHodnotyZPodminek(Vlastnosti2, Podminky, CastecneObjekty, RedukovanePodminky),
	extrahujHodnotyZOtazek(Vlastnosti2, Otazky, CastecneObjekty2),

	%konkatenace
	conc(CastecneObjekty, CastecneObjekty2, CastecneObjekty3),!,

	%sloucime castecne objekty, ktere se shoduji v nejake hodnote (zrychleni programu)
	zahusti(CastecneObjekty3, CastecneObjekty4),

	%prazdna 'tabulka' (=seznam seznamu) velikosti N x M, kde M je pocet vlastnosti
	%sloupec index se automaticky vyplni pri konstrukci
	vytvorPrazdnouTabulku(N, Vlastnosti2, PrazdnaTabulka),!,

	%jadro algoritmu - snazime se naskladat vytvorene castecne objekty do prazdne tabulky,
	% pritom kontrolujeme platnost podminek mluvicich o vztazich nekolika objektu
	zaplnTabulku(Vlastnosti2, CastecneObjekty4, RedukovanePodminky, PrazdnaTabulka, VyslednaTabulka),
	%vyplneni seznamu odpovedi podle hodnot ve vysledne tabulce
	zodpovez(Vlastnosti2, VyslednaTabulka, Otazky, Odpovedi),

	%vypis
	vypisTabulku(VyslednaTabulka),nl,
	vypisOdpovedi(Otazky,Odpovedi)
	.

% ========================================================================

%pridejIndex(+PuvodniVlastnosti, -NoveVlastnosti)
pridejIndex(V, [index|V]).

%------------------------------------------------------------------------

%extrahujHodnotyZPodminek(+Vlastnosti, +SeznamPodminek, -SeznamCastecnychObjektu)
extrahujHodnotyZPodminek(_, [], [], []).
%unarni podminky rovnou mazeme ze seznamu podminek, jiz k nicemu nebudou
extrahujHodnotyZPodminek(V, [Podminka|Zbytek], Objekty, ZbylePodminky):- unarni(Podminka),!, extrahuj(V,Podminka, T), extrahujHodnotyZPodminek(V, Zbytek, S, ZbylePodminky), conc(T,S,Objekty).

%podminky mluvici o vztazich vice objektu v seznamu nechame
extrahujHodnotyZPodminek(V, [Podminka|Zbytek], Objekty, [Podminka|ZbylePodminky]):- extrahuj(V,Podminka, T), extrahujHodnotyZPodminek(V, Zbytek, S, ZbylePodminky), conc(T,S,Objekty).

unarni(podminka(_)).

%extrahuj(+Vlastnosti, +JedinaPodminka, -SeznamCastecnychObjektu)
 %unarni podminka (vznikne 1 objekt)
extrahuj(_, podminka([]), []).
extrahuj(V, podminka(T), [Objekt]):- vytvorObjekt(V,T,Objekt).

 %relacni podminka (vznikne nekolik objektu)
extrahuj(_, podminka([],_),[]).
extrahuj(V, podminka([(V1,H1)|Zbytek], _), [X|T]):-vytvorObjekt(V,[(V1,H1)],X), extrahuj(V, podminka(Zbytek,_), T).

%vytvorObjekt(+Vlastnosti, +SeznamDvojicVlastnost_Hodnota,-CastecnyObjekt)
vytvorObjekt(V, T, Objekt):- vytvorPrazdnyObjekt(V, Objekt), vObjekt(V, T, Objekt).

%vytvorPrazdnyObjekt(+Vlastnosti, -PrazdnyObjekt)
vytvorPrazdnyObjekt([],[]).
vytvorPrazdnyObjekt([_|T], [_|S]):- vytvorPrazdnyObjekt(T,S).

%vObjekt(+Vlastosti,+SeznamDvojicVlastnost_Hodnota,-CastecnyObjekt)
vObjekt(_, [], _).
vObjekt(V, [(V1,H1)|T], Objekt):- pridejHodnotu(V, V1, H1, Objekt), vObjekt(V,T,Objekt).

%pridejHodnotu(+Vlastnosti, +Vlastnost, +Hodnota, +CastecnyObjekt)
%pridejHodnotu([], _, _, []).
pridejHodnotu([V1|_], V1, H1, [H1|_]):-!.
pridejHodnotu([V2|T], V1, H1, [_|S]):-  V2 \= V1, pridejHodnotu(T,V1,H1,S).


%extrahujHodnotyZOtazek(+Vlastnosti, +SeznamOtazek,-SeznamCastecnychObjektu)
extrahujHodnotyZOtazek(_,[],[]).
extrahujHodnotyZOtazek(V, [otazka((V1,H1),_)|Zbytek], [Objekt| S]):- vytvorObjekt(V, [(V1,H1)], Objekt), extrahujHodnotyZOtazek(V,Zbytek, S).

% ------------------------------------------------------------------------
%zahusti(+SeznamCastecnychObjektu, -NovySeznamCastecnychObjektu)
 %postupne bereme kazdy castecny objekt a snazime se ho sloucit z nekterym ze zbylych
zahusti([],[]).
zahusti([Objekt|Zbytek], [ZpracovanyObjekt|Vysledek]):- zaclen(Objekt, Zbytek, RedukovanySeznam, ZpracovanyObjekt),!, zahusti(RedukovanySeznam, Vysledek).

%zaclen(+CastecnyObjekt,+SeznamCasecnychObjektu,-RedukovanySeznamCastecnychObjektu, -ZpracovanyObjekt)
 %zkusime najit v seznamu objekt, jenz by sel sloucit s nasim aktualnim objektem
 %uspejeme-li, objekty se slouci do promenne ZpracovanyObjekt a pouzity objekt ze seznamu odstranime

zaclen(Objekt, [], [], Objekt).

%pokud se objekty shoduji v nejake hodnote (predikat shodaVHodnote), pak musi jit sloucit (jinak je to chyba v zadani!)
 %napr.: [modra, _ , pes, _] a [modra, _, kocka, _] je zjevne chybne zadani (kazda vlastnost objektu nabyva)
 %prave jedne hodnoty) a zpusobi fail predikatu a celeho programu
zaclen(Objekt, [Radek|Zbytek], NovyZbytek, NovyRadek2):- shodaVHodnote(Objekt,Radek),!,Objekt = Radek, zaclen(Objekt, Zbytek, NovyZbytek, NovyRadek2).
zaclen(Objekt, [Radek|Zbytek], [Radek|NovyZbytek], NovyRadek):- zaclen(Objekt, Zbytek, NovyZbytek, NovyRadek).

% shodaVHodnote(+Radek1, +Radek2)
 %radky se shoduji v hodnote aspon jedne vlastnosti (shoduji, nikoli unifikuji)
shodaVHodnote([H1|_],[H2|_]):-nonvar(H1), nonvar(H2), H1 = H2.
shodaVHodnote([H|T1], [H|T2]):- shodaVHodnote(T1,T2).

%-----------------------------------------------------------------------
%vytvorPrazdnouTabulku(+PocetObjektu, +SeznamVlastnosti, -Tabulka)
vytvorPrazdnouTabulku(N,V,Tabulka):- vTabulku(N,V,1,Tabulka).

%vTabulku(+PocetObjektu, +SeznamVlastnosti, +Index, -Tabulka)
vTabulku(N,V,Index, [Radek|Tabulka]):- Index =< N, vytvorRadek(Index,V,Radek), Index1 is Index+1, vTabulku(N,V,Index1,Tabulka).
vTabulku(N,_, Index,[]):- Index > N.

%vytvorRadek(+Index, +SeznamVlastnosti, -PrazdnyRadek)
vytvorRadek(I, [_|V], [I|T]):- vRadek(V,T).

%vRadek(+SeznamVlastnosti, -PrazdnyRadek)
vRadek([],[]).
vRadek([_|T], [_|S]):- vRadek(T,S).

% ------------------------------------------------------------------------
%zaplnTabulku(+Vlastnosti, +SeznamCastecnychObjektu, +SeznamRelacnichPodminek,  +PuvodniTabulka,-ZaplnenaTabulka)
zaplnTabulku(_,[], _, T, T).
zaplnTabulku(V, [Objekt|Zbytek], Podminky, Tabulka, NovaTabulka):- vlozObjekt(Objekt, Tabulka, NovaTabulka2), zkontroluj(V, NovaTabulka2, Podminky), zaplnTabulku(V, Zbytek, Podminky, NovaTabulka2, NovaTabulka).

%vlozObjekt(+Objekt, +PuvodniTabulka, -NovaTabulka)
vlozObjekt(Objekt, [Radek|Zbytek], [Objekt|Zbytek]):- Objekt = Radek.
vlozObjekt(Objekt, [Radek|Zbytek], [Radek|NovaTabulka]):- vlozObjekt(Objekt, Zbytek, NovaTabulka).

%zkontroluj(+Vlastnosti, +Tabulka, +Podminky)
zkontroluj(_,_,[]).
zkontroluj(V, T, [podminka(Objekty, Relace)|Zbytek]):- najdiRadky(V,T,Objekty,Radky),!,
	plati(Radky, Relace), zkontroluj(V, T, Zbytek).

 %odpovidajici radky v tabulce jeste nejsou, neni co kontrolovat
zkontroluj(V,T,[_|Zbytek]):- zkontroluj(V,T,Zbytek).

% najdiRadky(+Vlastnosti, +Tabulka, +SeznamDvojicVlastnost_Hodnota,
% -OdpovidajiciRadky)
najdiRadky(_,_,[],[]).
najdiRadky(V, T, [(V1,H1)|Zbytek], [Radek|Zbytek2]):- najdiRadek(V, T, V1, H1, Radek), najdiRadky(V,T,Zbytek, Zbytek2).

%najdiRadek(+Vlastnosti, +Tabulka, +Vlastnost, +Hodnota, -Radek)
najdiRadek(V, [Radek|_], V1, H1, Radek):- najdiHodnotu(V,Radek,V1,H1).
najdiRadek(V, [_|T], V1,H1, Radek):- najdiRadek(V,T,V1,H1,Radek).

%najdiHodnotu(+Vlastnosti, +Radek, +Vlastnost, Hodnota)
najdiHodnotu([V1|_], [H1|_], V1, H2):- nonvar(H1), H1 = H2,!.
najdiHodnotu([V1|T1], [_|T2], V2, H1):- V1\=V2, najdiHodnotu(T1,T2,V2,H1).

%plati(+SeznamRadku, +SeznamRelaci)
 %zavolame postupne vsechny relace na vyextrahovane radky
plati(_,[]).
plati(Radky, [H|T]):- apply(H,Radky), plati(Radky, T).

% ------------------------------------------------------------------------
%zodpovez(+Vlastnosti, +Tabulka, +SeznamOtazek, -Odpovedi)
zodpovez(_,_,[],[]).
zodpovez(V, Tabulka, [Ot|Zb],[Odp|Zb2]):-zodp(V, Tabulka, Ot, Odp), zodpovez(V, Tabulka, Zb, Zb2).

%zodp(+Vlastnosti, +Tabulka, +Otazka, -Odpoved)
zodp(V, Tabulka, otazka((V1,H1),V2), H2):- najdiRadek(V, Tabulka, V1, H1, Radek), najdiHodnotu(V, Radek, V2, H2).


% ------------------------------------------------------------------------
% preddefinovane relace
% ------------------------------------------------------------------------

soused([X|_],[Y|_]):- 1 is X-Y.
soused([X|_],[Y|_]):- 1 is Y-X.

vpravo([X|_], [Y|_]):- X > Y.

vlevo([X|_],[Y|_]):- X < Y.

% -----------------------------------------------------------------------
%pomocne funkce
% -----------------------------------------------------------------------

conc([], T, T).
conc([H|T], S, [H|U]):-conc(T,S,U).


%-----------------------------------------------------------------------
%vypis na obrazovku
%-----------------------------------------------------------------------

vypisObjekty([]).
vypisObjekty([Objekt|T]):- write('['), vypisObjekt(Objekt), write(']'), nl, vypisObjekty(T).
vypisObjekt([]).
vypisObjekt([H|T]):- write(H), write(','), vypisObjekt(T).


%vypisTabulku(+Tabulka)
vypisTabulku([]).
vypisTabulku([Radek|Zbytek]):- write('[ '), vypisRadek(Radek), write(' ]'), nl, vypisTabulku(Zbytek).

%vypisRadek(+Radek)
vypisRadek([]).
vypisRadek([H|T]):- write(H), vRadek(T).

vRadek([]).
vRadek([H|T]):- var(H), write(', _'), vRadek(T).
vRadek([H|T]):- nonvar(H), write(', '), write(H), vRadek(T).

%vypisOdpovedi(+SeznamOtazek, +SeznamOdpovedi)
vypisOdpovedi([],[]).
vypisOdpovedi([Ot|Zb1], [Odp|Zb2]):-vypisOdpoved(Ot, Odp), nl , vypisOdpovedi(Zb1,Zb2).

%vypisOdpoved(+Otazka, +Odpoved)
vypisOdpoved(otazka((V1,H1),V2), H2):-
	write('Objekt, jehoz vlastnost '),
	write(V1),
	write(' nabyva hodnoty '),
	write(H1),
	write(' ma vlastnost '),
	write(V2),
	write(' rovnu hodnote '),
	write(H2),
	write('.').



% =======================================================================
% =======================================================================
% Varianta hlavniho predikatu, ktera vypisuje na obrazovku castecne
% objekty.
% =======================================================================
% =======================================================================


zebraSVypisem(N, Vlastnosti, Podminky, Otazky, Odpovedi):-

        %k zadanym vlastnostem pridame vlastnost 'index', udavajici poradi domu v rade
	pridejIndex(Vlastnosti, Vlastnosti2),

	%extrahujeme hodnoty vlastnosti, o nichz se mluvi v podminkach a v otazkach,
	%a vytvorime z nich 'castecne objekty', napr. [_,_,modra,_,pes,_]
	extrahujHodnotyZPodminek(Vlastnosti2, Podminky, CastecneObjekty, RedukovanePodminky),
	extrahujHodnotyZOtazek(Vlastnosti2, Otazky, CastecneObjekty2),

	%konkatenace
	conc(CastecneObjekty, CastecneObjekty2, CastecneObjekty3),!,

	write('Seznam castecnych objektu extrahovanych z podminek a otazek:'), nl, vypisObjekty(CastecneObjekty3),nl,
	%sloucime castecne objekty, ktere se shoduji v nejake hodnote (zrychleni programu)
	zahusti(CastecneObjekty3, CastecneObjekty4),
	write('Seznam objektu po slouceni radku shodujicich se v nejake hodnote:'),nl, vypisObjekty(CastecneObjekty4),nl,
	%prazdna 'tabulka' (=seznam seznamu) velikosti N x M, kde M je pocet vlastnosti
	%sloupec index se automaticky vyplni pri konstrukci
	vytvorPrazdnouTabulku(N, Vlastnosti2, PrazdnaTabulka),!,

	%jadro algoritmu - snazime se naskladat vytvorene castecne objekty do prazdne tabulky,
	% pritom kontrolujeme platnost podminek mluvicich o vztazich nekolika objektu
	zaplnTabulku(Vlastnosti2, CastecneObjekty4, RedukovanePodminky, PrazdnaTabulka, VyslednaTabulka),
	%vyplneni seznamu odpovedi podle hodnot ve vysledne tabulce
	zodpovez(Vlastnosti2, VyslednaTabulka, Otazky, Odpovedi),

	%vypis
	vypisTabulku(VyslednaTabulka),nl,
	vypisOdpovedi(Otazky,Odpovedi)
	.





























