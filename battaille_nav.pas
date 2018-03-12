PROGRAM bataille_naval;
//But: recréer le jeu de la baitaille navale en pascal
//Entrées: Coordonée de bateau/tir
//Sorties: affichage de la grille, annonce du perdant, annonce de bateau coulé/touché,

USES crt;

//Constantes globales
CONST
    dimmax=12;
    batmax=4;

//Déclaration des types
type pos=RECORD
    x,y: INTEGER;
end;

type boat=RECORD;
    cases: ARRAY[1..5] of pos;
    taille: INTEGER;
end;

type flotte=RECORD
    bat: ARRAY[1..batmax] of boat;
    player, reste: INTEGER;
end;

type cell= ARRAY[1..2] of flotte;

//Sous-programmes
function fc_boatlimit(boat1: boat): BOOLEAN;
var
    test: INTEGER;
begin
    fc_boatlimit:= FALSE;
    for test:= 1 to boat.taille do
    begin
        if (boat1.cases[test].x<1) or (boat1.cases[test].y<1) or (boat1.cases[test].x>dimmax) or (boat1.cases[test].y>dimmax) then                                                                                       // programme de qualité par Brayan <3 c'est à moi, pas touche <3                                                                          // programme de qualité par Brayan <3 c'est à moi, pas touche <3
            fc_boatlimit:=TRUE
    end;
end;

function fc_compare (pos1, pos2: pos): BOOLEAN;
begin
    fc_compare:= FALSE;
    if (pos1.x= pos2.x) and (pos2.y= pos1.y) then
        fc_compare:= TRUE;
end;

function fc_boat (boat1:boat, pos1:pos): BOOLEAN;
var
    test:INTEGER;
begin
    fc_boat:= FALSE;
    for test:=1 to boat1.taille do
    begin
        if fc_compare(boat1.cases[test],pos1) then
            fc_boat:= TRUE;
    end;
end;

function fc_flotte (flotte1: flotte; pos1: pos);
var
    test: INTEGER;
begin
    fc_flotte:= FALSE;
    for test:=1 to batmax do
    begin
        if fc_boat(flotte1.bat[test], pos1) then
            fc_flotte:= TRUE;
    end;
end;

function fc_boatflotte (flotte1: flotte; boat1: boat): BOOLEAN;
var
    a, b: INTEGER;
begin
    fc_boatflotte:= FALSE;
    for a:=1 to batmax do
    begin
        for b:=1 to boat1.taille do
        begin
            if fc_boat(flotte1.bat[a], boat1.cases[b]) then
              fc_boatflotte:= TRUE;
        end;
    end;
end;

procedure pr_creepos (x, y: INTEGER; var pos1:pos);
begin
    pos1.x:= x;
    pos1.y:= y;
end;

function fc_creeboat (taille: INTEGER): boat;
var
    test: INTEGER;
    x, y: 1..batmax;
    sens: STRING;
    temppos: pos;
    test2: BOOLEAN;
    boat1: boat;
begin
    repeat
        test2:= FALSE;
        writeln('Votre bateau de longueur ' , taille, ' va être placer');
        writeln('Saissisez son absisse (comprises entre 1 et ', max , ')');
        readln(x);
        writeln('Saissisez son ordonnée (comprises entre 1 et ', max , ')');                                                                          // programme de qualité par Brayan <3 c'est à moi, pas touche <3
        readln(y);
        pr_creepos(x, y, temppos);
        boat1.taille:= taille;
        repeat
            writeln('Saisissez à présent son orientation');
            writeln('NORD (N) ; EST (E) ; SUD (S) ; OUEST (O)');
            readln(sens);
        until (sens='N') OR (sens='E') OR (sens='S') OR  (sens='O');
        for test:=1 to boat1.taille do
        begin
            case sens of
                'N'
                begin
                    boat1.cases[test].x:= temppos.x;
                    boat1.cases[test].y:= temppos.y+test+1;
                end;
                'S'
                begin
                    boat1.cases[test].x:= temppos.x;
                    boat1.cases[test].y:= temppos.y+test-1;
                end;
                'E'
                begin
                    boat1.cases[test].y:= temppos.y;
                    boat1.cases[test].x:= temppos.x+test-1;
                end;
                'O'
                begin
                    boat1.cases[test].y:= temppos.y;
                    boat1.cases[test].x:= temppos.x+test+1;
                end;
            end;
        end;
        if fc_boatlimit(boat1) then
        begin
            test2:= TRUE;
            writeln('le bateau est hors limite, recommencez');                                                                                                      // programme de qualité par Brayan <3 c'est à moi, pas touche <3
        end;
    until (test=boat1.taille) and (test2:= FALSE);
    fc_creeboat:= boat1;
end;

procedure pr_showtab (flotte1: flotte);
var
    a, b: INTEGER;
    temppos: pos;
begin
    for a:=0 to dimmax do
    begin
        for b:=0 to dimmax do
        begin
            temppos.x:=b;
            temppos.y:=a;
            if a=0 then
            begin
                if b>9 then
                    write(' ',b);
                else
                    write('  ',b);
            end
            else if b=0 then
            begin
                if a>9 then
                    write(' ',a,' ');
                else
                    write('  ',a,' ');
            end
            else if fc_flotte(flotte1, temppos) then
                write(' ',+,' ');
            else
                write(' . ');
        end;
        writeln;
    end;
end;

procedure pr_assiflotte (var flotte1:flotte);
var
    test: INTEGER;
    boat1: boat;
begin
    for test:= 1 to batmax do
    begin
        case test of
            1: flotte1.bat[test].taille:= 2;
            2: flotte1.bat[test].taille:= 3;
        else
            flotte1..bat[test].taille:= test;
        end;
        repeat
            boat1:=fc_creeboat(test,flotte1.bat[test].taille);
            if fc_boatflotte(flotte1, boat1) then
                writeln('Superposition non possible, recommencez');
        until fc_boatflotte(flotte1, boat1)=FALSE;
        flotte1.boat[test]:= boat1;
        pr_showtab(flotte1);
    end;
end;

function fc_coule (boat1: boat): INTEGER;
var
    test: INTEGER;
begin
    fc_coule:= 0;
    for test:= 1 to boat1.taille do
    begin
        if (boat1.cases[test].x=0) and (boat1.cases[test].y=0) then
            fc_coule:= fc_coule+1;
    end;
end;

function fc_lose (flotte1: flotte): BOOLEAN;
var
    a, b, temp: INTEGER;
begin
    temp:= 0;
    for a:= 1 to batmax do
    begin
        for b:= 1 to flotte1.bat[a].taille do
        begin
            if (flotte1.bat[a].cases[b].x=-1) and (flotte1.bat[a].cases[b].y=-1) then
            temp:= 1+temp;
        end;
    end;
    if temp= batmax then
    begin
        fc_lose:= TRUE;
        writeln('le joueur', flotte1.player, ' a perdu')
    end
    else
        fc_lose:= FALSE;
end;

procedure pr_play(flotte1: flotte; var flotte2: flotte);
var
    a, b: INTEGER;
    temppos: pos;
    x, y:1..dimmax;
begin
    writeln('Voici votre flotte:');
    pr_showtab(flotte1);
    writeln('Joueur ', flotte1. player, ', preparez votre tir');                                                                                                                                       // programme de qualité par Brayan <3 c'est à moi, pas touche <3
    writeln('Abscisse de votre tir');
    readln(x);
    writeln('Ordonée de votre tir');
    readln(y);
    pr_creepos(x, y, temppos);
    clrscr;
    if fc_flotte(flotte2, temppos) then
    begin
        writeln ('Touché!')
        for a:=1 to batmax do
        begin
            for b:= 1 to flotte2.boat[a].taille do
            begin
                if fc_compare(flotte2.bat[a].cases[b], temppos) then
                begin
                    fc_compare(flotte2.bat[a].cases[b].x:= 0;
                    fc_compare(flotte2.bat[a].cases[b].y:= 0;
                end;
                if (fc_coule(flotte2.bat[a])=flotte2.bat[a].taille) then                                                                                                                                           // programme de qualité par Brayan <3 c'est à moi, pas touche <3
                begin
                    writeln('Coulé!');
                    flotte2.reste:= flotte2.reste-1;
                    flotte2.bat[a].cases[b].x:= -1;
                    flotte2.bat[a].cases[b].y:= -1;
                end;
            end;
        end;
    end
    else
    begin
        writeln('Manqué')
    end;
    for a:= 0 to dimmax do
    begin
        for b:= 0 to dimmax do
        begin
            if a=0 then
            begin
                if b>9 then
                    write(' ', b);
                else
                    write('  ', b);
            end
            else if b=0 then
            begin
                if a>9 then
                    write(' ',a,' ');
                else
                    write('  ',i,' ');
            end
            else if (temppos.x=b) and (temppos.y=a) then
                write(' ','-',' ');
            else
                write(' . ');
        end;
        writeln;
    end;
    writeln('Votre adversaire a encore ',flotte2.reste,' bateau(x). Entrez pour continuer');
    readln;
end;

//Corps principal

var
    grille: cell;
    a: INTEGER;
    valid: STRING;
begin
    clrscr;
    writeln('Bataille Navale par Brayan');
    write('Entrer pour lancer la partie');
    readln;
    clrscr;
    for a:= 1 to 2 do
    begin
        repeat
            writeln('Joueur', a);
            pr_assiflotte(grille[a]);
            grille[a].player:= a;
            grille[a].reste:= batmax;
            writeln('Saisisez "OK" pour confirmer');
            readln(valid);
        until (valid:='OK');
        clrscr;
    end;
    repeat
        pr_play(grille[1], grille[2]);
        clrscr;
        if fc_lose(grille[1])=FALSE then
        begin
            pr_play(grille[2], grille[1]);
            clrscr;
        end;
    until ((fc_lose(grille[1])) or fc_lose(grille[2]));
    readln;
end.