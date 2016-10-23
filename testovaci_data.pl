testuj(original):-zebra(
		     5,
		     [color, pet, beverage, nationality, cigarets],
		    [
		     podminka([(nationality, englishman),(color,red)]),
		     podminka([(nationality,spaniard), (pet,dog)]),
		     podminka([(color, green),(beverage, coffee)]),
		     podminka([(nationality,ukrainian),(beverage, tea)]),
		     podminka([(color, green),(color,ivory)], [soused,vpravo]),
		     podminka([(cigarets,old_gold),(pet, snails)]),
		     podminka([(color,yellow),(cigarets, kools)]),
		     podminka([(beverage, milk),(index, 3)]),
		     podminka([(nationality, norwegian),(index,1)]),
		     podminka([(cigarets,chesterfield),(pet,fox)], [soused]),
		     podminka([(cigarets,kools),(pet,horse)],[soused]),
		     podminka([(cigarets,lucky_strike),(beverage, orange_juice)]),
		     podminka([(nationality,japanese),(cigarets, parliaments)]),
		     podminka([(nationality,norwegian),(color,blue)],[soused])
		    ],
		    [
		     otazka((pet,zebra), color),
		     otazka((beverage, water), cigarets)
		    ],
		    [_,_]
		     ).
testuj(books):-zebra(
		     8,
		     [surname, he, she, employment, car, color, brought, borrowed],
		    [
		     podminka([(she, pamela),(surname, zajac)],[borrow]),
		     podminka([(surname,black),(she,daniella),(employment,shop-assistant)]),
		     podminka([(brought, the_seadog),(car, fiat),(color,red)]),
		     podminka([(he, owen),(she, victoria),(color, brown)]),
		     podminka([(he, stan), (surname,horricks), (she, hannah), (color, white)]),
		     podminka([(she, jenny),(surname, smith),(employment,warehouse_managers),(car, wartburg)]),
		     podminka([(she, monica),(he, alexander),(borrowed, grandfather_joseph)]),
		     podminka([(he, matthew),(color,pink),(brought,mulatka_gabriela)]),
		     podminka([(she,irene),(he, oto),(employment,accountants)]),
		     podminka([(car, trabant), (borrowed, we_were_five)]),
		     podminka([(surname, cermaks),(employment, ticket-collectors), (brought,shed_stoat)]),
		     podminka([(surname, kuril),(employment, doctors),(borrowed,slovacko_judge)]),
		     podminka([(he, paul),(color, green)]),
		     podminka([(she, veronica),(surname, dvorak),(color, blue)]),
		     podminka([(he, rick),(car, ziguli),(brought, slovacko_judge)]),
		     podminka([(brought, dame_commissar),(borrowed, mulatka_gabriela)]),
		     podminka([(car, dacia),(color, violet)]),
		     podminka([(employment, teachers),(borrowed, dame_commissar)]),
		     podminka([(employment, agriculturalists), (car, moskvic)]),
		     podminka([(she, pamela), (car, renault),(brought,grandfather_joseph)]),
		     podminka([(he, robert),(color, yellow),(borrowed, modern_comedy)]),
		     podminka([(surname, swain),(employment, shoppers)]),
		     podminka([(brought, modern_comedy), (car, skoda)]),
		     podminka([(brought,the_seadog)]),
		     podminka([(brought,grandfather_joseph)]),
		     podminka([(brought,mulatka_gabriela)]),
		     podminka([(brought,we_were_five)]),
		     podminka([(brought,shed_stoat)]),
		     podminka([(brought,slovacko_judge)]),
		     podminka([(brought,dame_commissar)]),
		     podminka([(brought,modern_comedy)]),
		     podminka([(borrowed,the_seadog)]),
		     podminka([(borrowed,grandfather_joseph)]),
		     podminka([(borrowed,mulatka_gabriela)]),
		     podminka([(borrowed,we_were_five)]),
		     podminka([(borrowed,shed_stoat)]),
		     podminka([(borrowed,slovacko_judge)]),
		     podminka([(borrowed,dame_commissar)]),
		     podminka([(borrowed,modern_comedy)])
		    ],
		    [otazka((surname, swain), borrowed)],
		    [_]
		     ).

borrow([_,_,_,_,_,_,_,_,X],[_,_,_,_,_,_,_,X,_]).

testuj(heroes):-zebra(
		     5,
		     [hero, armor, sigil, height, weapon],
		    [
		     podminka([(hero, lion),(index,3)]),
		     podminka([(sigil,white)],[notTallest,notShortest]),
		     podminka([(sigil,green),(sigil,black)], [soused, vlevo]),
		     podminka([(height,3), (weapon,club)]),
		     podminka([(index,4),(weapon,spear)]),
		     podminka([(weapon,sword),(weapon,club)],[soused]),
		     podminka([(hero,snake)],[notLance]),
		     podminka([(armor, pink),(weapon, dagger)]),
		     podminka([(hero, bear),(height,7)]),
		     podminka([(hero, wolf),(weapon,sword)],[soused]),
		     podminka([(armor,white),(armor,black)],[soused,vlevo]),
		     podminka([(hero, wolf),(weapon, club)]),
		     podminka([(sigil, white),(sigil, red)],[soused]),
		     podminka([(armor,purple),(weapon,spear)]),
		     podminka([(armor,black),(height,3)]),
		     podminka([(hero,owl)],[okraj]),
		     podminka([(hero,bear)],[okraj]),
		     podminka([(sigil,red)],[notTallest]),
		     podminka([(hero,wolf)],[notWhiteSigil,notWhiteArmor]),
		     podminka([(height,6),(armor,red)]),
		     podminka([(height,4),(index,1)]),
		     podminka([(height,4)],[notSword]),
		     podminka([(height,3),(weapon,club)]),
		     podminka([(hero, snake),(sigil,black)],[soused]),
		     podminka([(hero,lion)],[notBlackSigil])
		    ],
		    [
		     otazka((sigil,golden), hero)
		    ],
		    [_]
		     ).
notTallest([_,_,_,_,3,_]).
notTallest([_,_,_,_,4,_]).
notTallest([_,_,_,_,5,_]).
notTallest([_,_,_,_,6,_]).

notShortest([_,_,_,_,4,_]).
notShortest([_,_,_,_,5,_]).
notShortest([_,_,_,_,6,_]).
notShortest([_,_,_,_,7,_]).

notWhiteSigil([_,_,_,X,_,_]):- var(X).
notWhiteSigil([_,_,_,X,_,_]):- nonvar(X), X \= white.

notWhiteArmor([_,X|_]):- var(X).
notWhiteArmor([_,X|_]):- nonvar(X), X \= white.

okraj([1|_]).
okraj([5|_]).

notSword([_,_,_,_,_,X]):- var(X).
notSword([_,_,_,_,_,X]):- nonvar(X), X \= sword.

notLance([_,_,_,_,_,X]):- var(X).
notLance([_,_,_,_,_,X]):- nonvar(X), X \= lance.

notBlackSigil([_,_,_,X,_,_]):-  var(X).
notBlackSigil([_,_,_,X,_,_]):- nonvar(X), X \= black.



testuj(priklad):-zebraSVypisem(
		     5,
		     [barva, zvire, napoj, narodnost, cigarety],
		    [
		     podminka([(barva,modra),(cigarety,chesterfield)]),
		     podminka([(barva,modra),(zvire,kun)]),
		     podminka([(barva,modra),(napoj,caj)]),
		     podminka([(barva,modra),(narodnost,anglican)]),
		     podminka([(cigarety,kools)]),
		     podminka([(barva,cervena)])
		    ],
		    [
		     otazka((zvire,zebra), barva),
		     otazka((napoj,voda), cigarety)
		    ],
		    [_,_]
		     ).
testuj(priklad2):-zebra(
		     5,
		     [color, pet, beverage, nationality, cigarets],
		    [
		     podminka([(color, green),(color, red),(pet, dog),(pet,snails),(beverage, tea),(beverage,milk),(cigarets,lucky_strike),(cigarets,parliaments),(cigarets,old_gold),(color, ivory),(nationality,englishman),(nationality,japanese)],[notFirst]),
		     podminka([(nationality, englishman),(color,red)]),
		     podminka([(nationality,spaniard), (pet,dog)]),
		     podminka([(color, green),(beverage, coffee)]),
		     podminka([(nationality,ukrainian),(beverage, tea)]),
		     podminka([(color, green),(color,ivory)], [soused,vpravo]),
		     podminka([(cigarets,old_gold),(pet, snails)]),
		     podminka([(color,yellow),(cigarets, kools)]),
		     podminka([(beverage, milk),(index, 3)]),
		     podminka([(nationality, norwegian),(index,1)]),
		     podminka([(cigarets,chesterfield),(pet,fox)], [soused]),
		     podminka([(cigarets,kools),(pet,horse)],[soused]),
		     podminka([(cigarets,lucky_strike),(beverage, orange_juice)]),
		     podminka([(nationality,japanese),(cigarets, parliaments)]),
		     podminka([(nationality,norwegian),(color,blue)],[soused])
		    ],
		    [
		     otazka((pet,zebra), color),
		     otazka((beverage, water), cigarets)
		    ],
		    [_,_]
		     ).
notFirst([A|_],[B|_],[C|_],[D|_],[E|_],[F|_],[G|_],[H|_],[I|_],[J|_],[K|_],[L|_]):- A \= 1, B\=1, C\=1, D\=1, E\=1,F\=1,G\=1,H\=1,I\=1,J\=1,K\=1,L\=1.

testuj(chyba2):-zebra(
		     5,
		     [barva, zvire, napoj, narodnost, cigarety],
		    [
		     podminka([(cigarety,winston),(zvire, sneci),(cigarety,kools), (cigarety,lucky_strike),(zvire,had)])
		    ],
		    [],
		    []
		     ).
testuj(chyba1):-zebra(
		     5,
		     [barva, zvire, napoj, narodnost, cigarety],
		    [
		     podminka([(barfa,zluta),(cigarety, kools)]),
		     podminka([(barva,zluta),(cigarety, winston)])
		    ],
		    [],
		    []
		     ).

