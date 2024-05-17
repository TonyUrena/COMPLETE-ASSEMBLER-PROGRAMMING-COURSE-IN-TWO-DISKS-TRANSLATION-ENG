; Lezione2a.s - This small program records in the byte named
; "counter" the number of times the right button is pressed, or rather
; how many times it has been pressed; in fact, when it is held down, it continues
; to be incremented; to exit, you must press the left button.

Start:
    btst #2, $dff016        ; POTINP - right mouse button pressed?
    beq.s add               ; if yes, go to "add"
    btst #6, $bfe001        ; left mouse button pressed?
    bne.s start             ; if no, go back to Start and repeat everything
    rts                     ; if yes, EXIT!

add:
    move.b counter, $dff180 ; put the value of COUNTER in COLOR0
    addq.b #1, counter      ; Add 1 to the value of counter
    bra.s start             ; go back to start and repeat

counter:
    dc.b 0                  ; this is the byte that will hold the count...

END     ; With END the end of the listing is determined, the words
        ; below END are not considered, it's as if they were all
        ; preceded by a ; (semicolon)

;NOTE: POTINP is the name of the register $dff016. The uppercase name after
; the semicolon always refers to the name of the register $dffxxx.
;In this listing, the use of labels can be seen both to represent instructions
;(bne.s start, bra.s start), and to represent a byte of data (addq.b #1, counter).
;There is no difference between the label Start: and the label counter:, both
;are labels, i.e., NAMES THAT IDENTIFY A SPECIFIC POINT IN THE PROGRAM, WHETHER
;IT'S A BYTE, A MOVE, OR ANYTHING ELSE, WHICH SERVES TO EXECUTE THE INSTRUCTIONS
;UNDER IT WHEN IT PRECEDES INSTRUCTIONS (FOR EXAMPLE, A BNE LABEL), OR TO READ/WRITE
;THE BYTE, WORD, OR LONGWORD THAT IT PRECEDES. I have noticed that many find it
;difficult to grasp this logic. Let's make some examples to clarify the role of LABELS:
;imagine having a rectangular garden enclosed by a fence, with a path running through the middle.
;After plowing it, you decide to plant strawberries, lettuce, basil, and parsley, so you divide it into 4
;rectangles of different sizes and plant. To know where the different crops will grow,
;those plastic labels with a point to insert into the ground are often used, remember them?
;Now let's plant them: the garden now has 4 labels sticking out of the ground, each with
;the name of the crop written on it: on one we will find STRAWBERRIES:, on another LETTUCE:, then BASIL:, and PARSLEY:.
;Note that we placed the labels at the point where a type of crop starts, and consequently where the previous one ends:
;
;
; STRAWBERRIES: LETTUCE: BASIL: PARSLEY:
; / / / /
; ................oooooooooooooooooo^^^^^^^^^^^^^^^^^^-----------
;
;
;If you consider the strawberries as the "......", the lettuce as the "ooooo", the
;basil as the "^^^^^^^" and the parsley as the "----", you will notice
;that when I write "BNE LETTUCE" I mean GO TO THE LABEL LETTUCE, not
;"throw yourself in the middle of the lettuce" or "go towards the lettuce", but
;precisely "GO TO THE LABEL INSERTED IN THE GROUND WHERE IT SAYS LETTUCE,
;AND EXECUTE THE INSTRUCTIONS AFTER IT, in this case, the "oooo" would be executed.
;In the case where you use the label in this way:
;
; addq.b #1, BASIL
;
;I am simply adding 1 seed in the first byte after THE LABEL, which
;has not changed its function! It does not indicate contents or other oddities!!! It always indicates
;a point in memory, i.e., of the listing, which is the beginning of the basil.
;Let's try doing a MOVE.B STRAWBERRIES, BASIL
;
; STRAWBERRIES: LETTUCE: BASIL: PARSLEY:
; / / / /
; ................oooooooooooooooooo.^^^^^^^^^^^^^^^^^-----------
;
; | |
; --> ----> ----> ----> ----> --->
;
;As you will notice, a ".", i.e., the byte after strawberries has been copied into the byte
;after BASIL:, now let's try a MOVE.W LETTUCE, STRAWBERRIES
;
; STRAWBERRIES: LETTUCE: BASIL: PARSLEY:
; / / / /
; oo..............oooooooooooooooooo.^^^^^^^^^^^^^^^^^-----------
;
; || ||
; <--- <--- <---/
;
;We have moved the first 2 "oo" that were after LETTUCE: into the first 2 bytes
;after STRAWBERRIES:
;
;If you want to read or write from an intermediate point between the LABELS, just
;add another one where you want it: to put 4 bytes of LETTUCE
;in the middle of the basil we will need to create a new LABEL named BAS2: at
;the predetermined point, then we will do a MOVE.L LETTUCE, BAS2
;
;Before:
;
; STRAWBERRIES: LETTUCE: BASIL: BAS2: PARSLEY:
; / / / / /
; oo..............oooooooooooooooooo.^^^^^^^^^^^^^^^^^-----------
;
;
;After:
;
; STRAWBERRIES: LETTUCE: BASIL: BAS2: PARSLEY:
; / / / / /
; oo..............oooooooooooooooooo.^^^^^^^oooo^^^^^^-----------
;
; |||| ||||
; \ ----> ----> ----> -----> /
;
;We have moved the first 4 bytes that were after LETTUCE: into the first 4
;bytes after BAS2:
;
;The operation works the same way as moving using real addresses, as already explained
;in LESSON1 (DOG CAT>NEW DOG), except that instead of working with addresses, where
;each seed has an address, labels are placed only at the addresses that are of interest:
;
;Using addresses:
;
; STRAWBERRIES: LETTUCE: BASIL: PARSLEY:
; / / / /
; ................oooooooooooooooooo^^^^^^^^^^^^^^^^^^-----------
; 123456789012345678901234567890123456789012345678901234567890123456789012345
; 11111111112222222222333333333344444444445555555555666666
;
;By moving with addresses, you can copy 4 bytes of lettuce from any
;position, for example from number 15, and put it in number 55: MOVE.L 15,55
;
;
; STRAWBERRIES: LETTUCE: BASIL: PARSLEY:
; / / / /
; ................oooooooooooooooooo^^^^^^^^^^^^^^^^^^------oooo_---_
; 123456789012345678901234567890123456789012345678901234567890123456789012345
; 11111111112222222222333333333344444444445555555555666666
; --> ---> ---> ---> ---> ---> ---> --->/
;
;The same operation can, however, be done by putting a label at position 15
;and another at position 55, then doing "move.l LABEL1, LABEL2"
;
; LABEL1: LABEL2:
; / /
; ................oooooooooooooooooo^^^^^^^^^^^^^^^^^^------oooo_---_
; ---> ---> ---> ---> ---> ---> ---> --->/
;

Why was it preferred to use LABELS rather than addresses?
SIMPLE! Because using addresses, if we had inserted things; between the lettuce and the basil, the destination would no longer be 55,
but another number, for example, 80, and we would have to change all the
numbers by shifting them forward to fit the new inserted piece.
Instead, with labels, if we insert something between one and the other it does not
require changes, because ASMONE calculates the label address each time.

Try running this program, the first time without pressing the right button, but only the left button to exit: the COUNTER byte in this case remains 0, as you can verify with the M command, which displays the actual values contained in memory addresses in hexadecimal byte format (indicated by the location number, for example, M $50000, or the name of a label): doing M counter will return a ZERO, followed by other numbers that correspond to the subsequent bytes in memory that we don't care about. (To advance in memory, press return multiple times, to finish press the ESC key - the bytes are obviously in HEXADECIMAL format). Reassemble with A and run it a second time, this time pressing the right button before exiting (with the left): doing "M counter" will return a number other than zero, corresponding to the number of cycles the right mouse button was pressed, in fact, the loop is executed very quickly by the processor and even pressing the right button for an instant results in numbers greater than 1.

It should be noted that the counter in question is one byte long, so it can reach a maximum value of 255, that is $FF, or %11111111 in binary, i.e., all eight bits that form the byte ON (1), after which the number will restart from zero (if you continue to add). ($ff+1 = 0, $ff+2 = 1...). The advance of this little program compared to the first one is that the structure of the conditional jumps is more complex (and I recommend not going further until you understand it!), in addition, a byte is used as a variable. This byte named COUNTER is not only written but also read to write its value in $dff180, that is COLOR0: from here you can see how many VARIABLES, i.e., bytes, words or longwords in which numbers useful to the program are written and read, can be managed, for example the number of lives of PLAYER 1, his energy, his points, etc.

The use of LABELS is useful to the programmer but the program once assembled becomes a series of bytes, which if read by the 68000 are interpreted as instructions referring to direct addresses: to verify this, assemble the program and do a D Start... The assembled program will thus be displayed in memory in its true form, where instead of labels the ACTUAL addresses appear: as you observe, the first column of numbers on the left are the memory addresses where we are reading, the second column of numbers are the commands in their REAL form in memory, that is, sequences of bytes (for example, the first line BTST #2,$dff016 in memory becomes 0839000200dff016, where $0839 means BTST, 0002 is the #2, 00dff016 is the address concerned)... the third column, the one on the right, shows the DISASSEMBLED, that is, it does the opposite of assembling: it transforms BYTES into INSTRUCTIONS (when you press A (assemble) it transforms instructions from the MOVE, ADD, BNE, BTST format... into BYTES). By reading, you will immediately notice that the labels are replaced by the real addresses where routines or variables are located.

As further proof that the instructions become precise numbers, replace the line:

    btst    #2,$dff016    ; POTINP - right mouse button pressed?

With the equivalent line:

    dc.l    $08390002,$00dff016

or:

    dc.w    $0839,$0002,$00df,$f016

or:

    dc.b    $08,$39,$00,$02,$00,$df,$f0,$16

In all cases, the result is 0839000200dff016 in memory, which the 68000 interprets as "btst #2,$dff016", i.e., "is bit 2 of $dff016 zero?".

If the variable had been a WORD instead of a BYTE, the listing should be modified as follows:

Start:
    btst #2,$dff016         ; POTINP - right mouse button pressed?
    beq.s add               ; if yes, go to "add"
    btst #6,$bfe001         ; left mouse button pressed?
    bne.s start             ; if no, return to Start and repeat everything
    rts                     ; if yes, EXIT!

add:
    move.w counter,$dff180  ; COLOR0 - Use .w instead of .b
    addq.W #1,counter       ; use ADDQ.W instead of ADDQ.B!!!
    bra.s start

counter:
dc.W 0                      ; dc.w instead of dc.b (the same as dc.b 0,0)

In this case, the maximum number containable by a word before starting over is $FFFF, or 65535, or %1111111111111111.

If you wanted to use a LONGWORD for COUNTER:, the maximum number before resetting would be $FFFFFFFF, or a few billion, but it must be considered that the high bit (i.e., the thirty-first in the case of the longword) is used for the sign of the number: try doing ?$0FFFFFFF and you will get about 268 million, and in binary, you will notice that the four highest bits of the number (i.e., the first four after the %) are zero. The maximum positive number that can be obtained is $7FFFFFFF or in binary:
;10987654321098765432109876543210 ; bit number from 0 to 31
%01111111111111111111111111111111
In fact, bit 31 (which would be the thirty-second, but it is thirty-one because it also counts zero) is ZERO, while the others are all 1.
If you do ?$7FFFFFFF+1 you get -2 billion and odd, and as the number increases, it approaches zero (-1 billion, -100 million, -10 etc.) in fact, if you do a ?-1 you get $FFFFFFFF, with ?-2 instead $FFFFFFFE.

This system of the high bit used as a sign can also be valid for bytes and words: for bytes, a move.b #-1,$50000 can also be written as move.b $FF,$50000 so the maximum positive number would become:
%01111111 , or $7f, 127. For words, the maximum positive number becomes
%0111111111111111, or $7FFF, or 32767. However, depending on how the program is made, the numbers can be used as positive and negative numbers or as absolute numbers.

Try changing the listing so that COUNTER: is a word, as described above: You can use ASMONE editor functions, the so-called CUT and PASTE: to "cut" a piece of text and copy it elsewhere, press the right Amiga key+b at the beginning of the part of the text you want to copy; in this case, select the source modified to WORD under the line "be modified as follows:" positioning yourself above the label Start: and pressing Amiga+b. Now you can select the block (which will appear in negative), moving down with the cursor. Once below the Dc.W 0 press Amiga+c, and the piece of text including the listing will go into memory. Now go to the top of the listing with CURSOR UP+SHIFT, and press Amiga+i ...
Magically a copy of the text you had selected before will appear.
At this point, just put an END (spaced from the beginning of the line with spaces, or better with a TAB) under the DC.W 0 to exclude the first source with COUNTER: one byte long. Assemble and Jump.

P.S.: Ignore, for now, that string of numbers, sometimes highlighted, that appear after each "J", their meaning will be explained later.

You will immediately notice the difference in screen flashing when you press the right button; try doing an M COUNTER now:
now it is a WORD, so the first 2 pairs of numbers will be valid,
i.e., the first 2 bytes... if, for example, 00 30 appears it means that
ADDQ.W #1, COUNTER has been executed $30 times, or 48 times; a value of 02 5e would mean $25e times, or 606 times.

If you are not experienced with text editors, do some CUT AND PASTE tests by copying and inserting parts of this text here and there, and consider that if once a block is selected with Amiga+b instead of copying it to memory with Amiga+c, you press Amiga+x the selected block will also be deleted, but pressing Amiga+i it can be reinserted elsewhere. I assure you that programming is all about CUT and PASTE, as this trick allows you to save time rewriting similar parts of the program, which can instead be copied and modified quickly.

You must be well-versed in binary numbering to work, in fact, many hardware registers are also BITMAPPED, meaning each bit corresponds to a function. Here is a table to make the difference clearer:

HEXADECIMAL BINARY DECIMAL
0 %0000 0
1 %0001 1
2 %0010 2
3 %0011 3
4 %0100 4
5 %0101 5
6 %0110 6
7 %0111 7
8 %1000 8
9 %1001 9
A %1010 10
B %1011 11
C %1100 12
D %1101 13
E %1110 14
F %1111 15

Thus, a nibble can be represented as a hexadecimal number
or a number from 0 to 15 or a binary number with four bits: the number
$2A or 42 corresponds to the binary number %00101010
where A is the low nibble (ten) and 2 is the high nibble. If you want to learn more about the subject, consult some specific books on the architecture and machine language of the 68000 processor, but for now, this little knowledge is enough to understand how things work