/**
 *  A Space Hulk adventure game written in prolog.
 *
 *  @author Will Stiles
 *  @author Drew Jaqua
 */

/* Inventory */
:- dynamic have/1.
help :-
    write( '\'n\', \'e\', \'w\', and \'s\' for North, East, South, & West.' ), 
    nl,
    write( '\'take(ITEM)\' to pick up an item.'),
    nl,
    write( '\'gun\' to use your gun' ),
    nl,
    write( '\'inventory\' to view your inventory' ),
    nl,
    write( '\'navigation\' to inspect navigation options' ), 
    nl.
     
inventory :-
    have(X),
    write('Inventory:'),
    nl,
    write(X),
    fail.

navigation :-
    location(you, LOCATION),
    next_to( LOCATION, n, N),
    write( 'The the North is '),
    write( N ),
    nl,
    fail;
    location(you, LOCATION),
    next_to( LOCATION, e, E),
    write( 'The the East is the '),
    write( E ),
    nl,
    fail;
    location(you, LOCATION),
    next_to( LOCATION, w, W),
    write( 'The the West is the '),
    write( W ),
    nl,
    fail;
    location(you, LOCATION),
    next_to( LOCATION, s, S),
    write( 'The the South is the '),
    write( S ),
    nl.

/* If the pilot is rescued */
:- dynamic rescued/1.    

/* What is dead */
:- dynamic dead/1.

/* Location of in game items */
:- dynamic location/2.
    location(you, cargobay).
    location(alienone, hangar).
    location(alientwo, medbay).
    location(pilot, shuttle).

/* Locations of items you can pick up */
:- dynamic item_at/2.
    item_at(gun, cargobay).
    item_at(medkit, medbay).
    item_at(keycard, bunks).

/* Buttons you can press */
:- dynamic press/2.
    press(button, elevator).
    press(button, medbay).

/* Items you can see */
:- dynamic can_see/1.
    can_see(gun).

/* Items you can pick up */
small(gun).
small(medkit).
small(keycard).

/* Drop the item specified if you are holding it */
drop(ITEM) :-
    have(ITEM),
    retract(have(ITEM)),
    write('You dropped the '),
    write(ITEM),
    nl, nl,
    begin.

/* You don't have the item to drop */
drop(ITEM) :-
    write('You don''t have a '),
    write(ITEM),
    nl, nl,
    begin.

/* Pick up an item if you are in the same room and the item is visible */
take(ITEM) :-
    item_at(ITEM, LOCATION),
    location(you, LOCATION),
    can_see(ITEM),
    write('You pick up the '),
    write(ITEM),
    nl, nl,
    assert(have(ITEM)),
    retract(can_see(ITEM)),
    retract(item_at(ITEM, LOCATION)),
    begin.

/* If you can't pick up an item */
take(ITEM) :-
    not(have(ITEM)),
    write('There is no '),
    write(ITEM),
    nl, nl,
    begin.

/* Use an item that you have */
use(ITEM) :-
    have(ITEM),
    ITEM,
    begin.

/* If you don't have the item to use */
use(ITEM) :-
    not(have(ITEM)),
    write('You do not have a '),
    write(ITEM),
    nl, nl,
    begin.

/* Using the gun on first alien */
gun :-
    location(you, hangar),
    location(alienone, hangar),
    assert(dead(alienone)),
    write('You shoot the genestealer and it dies with a ferocious screech.'),
    nl, nl,
    retract(location(alienone, hangar)).

/* Using the gun on second alien */
gun :-
    location(you, medbay),
    location(alientwo, medbay),
    assert(dead(alientwo)),
    write('You take a couple carefully aimed shots and decimate the Tyranid. '),
    write('The Tyranid falls in a terrifying rage.'),
    nl, nl, 
    retract(location(alientwo, medbay)).

/* Using the gun improperly */
gun :-
    assert(dead(you)),
    write('Upon firing your weapon, you hear loud shuffelling in the room '),
    nl,
    write('next to you. Suddenly, from around the corner you are rushed by '),
    nl,
    write('a number of Tyranid genestealers. You try your best to fend them '),
    nl,
    write('away, but to no avail. You are quickly torn apart and fade away '),
    nl,
    write('into death.'),
    nl, nl,
    lose.

/* Rooms you have access to */
:- dynamic access/1.
    access(elevator).
    access(bunks).
    access(cargobay).
    access(shuttle).
    access(hangar).
    access(messhall).

/* Where rooms are in respect to one another */
:- dynamic next_to/3.
    next_to(hangar, s, cargobay).
    next_to(cargobay, n, hangar).

    next_to(helm, s, hangar).
    next_to(hangar, n, helm).

    next_to(elevator, e, helm).
    next_to(helm, w, elevator).

    next_to(medbay, n, elevator).
    next_to(elevator, s, medbay).

    next_to(messhall, s, elevator).
    next_to(elevator, n, messhall).

    next_to(bunks, w, helm).
    next_to(helm, e, bunks).

    next_to(shuttle, w, hangar).
    next_to(hangar, e, shuttle).

/* Rooms and their descriptions */
cargobay :-
    write('You are in the cargo bay of the ship. Everything is dishevelled, '),
    nl,
    write('wrecked from the crash. '),
    nl, 
    write('You notice a loaded gun on the floor to your left.'),
    nl, nl,
    begin.

shuttle :-
    not(dead(alienone)),
    assert(dead(you)),
    write('You try to run, but the Tyranid creatues takes you to the ground '),
    nl,
    write('and tears you apart.'),
    nl, nl,
    lose.

shuttle :-
    have(medkit),
    assert(rescued(pilot)),
    write('You run into the shuttle, the ship is falling into orbit sirens'),
    nl,
    write('blaring. You quickly stitch up the pilot and seal the doors to the'),
    nl,
    write('shuttle. The pilot screams "I''LL SEE YOU IN HELL!" as he stomps'),
    nl, 
    write('the gas. The shuttle scrapes on the way out of the Space Hulk,'),
    nl,
    write('barely making it out. As the pilot picks up speed, the Hulk erupts'),
    nl,
    write('in flame. You made it out just in time.'),
    nl, nl,
    win.

shuttle :-
    write('You are inside the slightly damage shuttle. On the ground next to'),
    nl,
    write('you is a wounded pilot. He asks for your help, he needs medical'),
    nl,
    write('attention quickly. He reaches over, presses a button, and says '),
    nl, 
    write('"The door to the helm is unlocked. If you can get me a medkit '),
    nl,
    write('then I can fly us out of this hell hole.'),
    nl, nl,
    assert(access(helm)),
    begin.

medbay :-
    write('You enter the medical bay of the ship. Everthing is a mess from the'),
    nl,
    write('crash. You hear a shuffling and accross the room, you recognize a'),
    nl,
    write('genestealer making a feast out of the ship''s chief medical officer.'),
    nl, nl,
    assert(can_see(medkit)),
    begin.

medbay :-
    not(dead(alientwo)),
    write('You try to run, but the Tyranid creatues takes you to the ground '),
    nl,
    write('and tears you apart.'),
    nl, nl,
    begin.

helm :-
    write('You enter the helm of the ship. The room is full of gored corpses'),
    nl,
    write('of your fellow crewmates, your captain pinned to the wall by what'),
    nl,
    write('looks like the femur of his second in command, who is lying at his'),
    nl,
    write('feet.'),
    nl, nl,
    begin.

hangar :-
    dead(alienone),
    write('You enter the hangar. To the north is the helm of the ship. To the'),
    nl,
    write('east is the shuttle. To the south is the sealed off cargo bay.'),
    nl,
    write('In the floor is the dead Tyranid killed moments ago.'),
    nl, nl,
    begin.

hangar :-
    not(dead(alienone)),
    retract(access(cargobay)),
    write('You enter the hangar of the ship and seal the door to the cargo'),
    nl,
    write('bay behind you. The oxygen levels are low enough for you'),
    nl,
    write('to be constantly short of breath. You hear a loud screech'),
    nl,
    write('to your right, and you turn to see a genestealer on a direct path'),
    nl,
    write('to you from the shuttle to the east.'),
    nl, nl,
    begin.

bunks :-
    write('You are now in the bunks of the ship. All of the beds are unkempt,'),
    nl,
    write('and the chief engineering officer is dead at the foot of one of'),
    nl,
    write('the bunks with his keycard laying beside him.'),
    nl, nl,
    assert(can_see(keycard)),
    begin.

elevator :-
    not(have(keycard)),
    write('You enter the damaged elevator room, there isn''t a button that'),
    nl,
    write('looks like it works. To your north is the mess hall. To your south'),
    nl,
    write('is the medbay, you notice the door is locked and requires a key.'),
    nl, nl,
    begin.

elevator :-
    have(keycard),
    assert(access(medbay)),
    write('You enter the damaged elevator room, there isn''t a button that'),
    nl,
    write('looks like it works. To your north is the mess hall. To your south'),
    nl,
    write('is the medbay, and the key card looks like it will open the door.'),
    nl, nl,
    begin.

messhall :-
    write('You enter the mess hall. The burning smell of the chef''s chili'),
    nl,
    write('is in the air, most of the lights have been blown out by your'),
    nl,
    write('commerades bullets. Dead genestealers and marines alike are dead'),
    nl,
    write('accross the room'),
    nl, nl,
    begin.

/* How to travel */
n :-
    go(n).
e :-
    go(e).
s :-
    go(s).
w :-
    go(w).

/* Observe the room */
look :-
    location(you, CURRENT),
    call(CURRENT).

/* Check if you can go this direction */
go(DIRECTION) :-
    location(you, CURRENT),
    next_to(CURRENT, DIRECTION, PLACE),
    access(PLACE),
    retract( location(you, CURRENT) ),
    assert( location(you, PLACE) ),
    look,
    begin.

/* If you have no access */
go(DIRECTION) :-
    location(you, CURRENT),
    next_to(CURRENT, DIRECTION, PLACE),
    write('The door to '), write(PLACE, ' the is locked.'),
    nl,
    begin.

/* If you can't go that way */
go(_) :-
    writeln('You can''t go that way.').

/* The start of the game */
start :-
    write('You awaken to find yourself slowly being sucked towards'),
    nl,
    write('what appears to be a small breach in the hull of the Space Hulk you'),
    nl,
    write('remember being stationed on. Your head feels rough, as if there'),
    nl,
    write('was a crash and oxygen levels are dropping. You need to get out.'),
    nl, nl,
    look,
    nl,
    begin.

/*begin :- done.*/

/* Take input from the user and then attempt to call the user's input. */
begin :-
    read(INPUT),    /* Read from the keyboard */
    call(INPUT),    /* Call the function the user typed */
    begin.          /* See if the the goal has been met */

/* Check for death */
lose :-
    dead(you),
    write('You lose...'),
    nl,
    halt.

/* Check for victory */
win :-
    /* Finish terms */
    location(you, shuttle),
    rescued(pilot),
    write('You escape the fallen vessel and live to tell the tale.'),
    nl,
    halt.

