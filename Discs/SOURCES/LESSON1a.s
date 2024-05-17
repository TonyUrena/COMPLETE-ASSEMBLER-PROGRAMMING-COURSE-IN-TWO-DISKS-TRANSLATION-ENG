; by Fabio Ciucci - Assemble with "A", execute with "J"

Waitmouse:			; This LABEL serves as a reference for the bne.
	move.w	$dff006,$dff180	; Put the value of $dff006 into $dff180
				; VHPOSR into COLOR00
	btst	#6,$bfe001	; Left mouse button pressed?
	bne.s	Waitmouse	; If not, return to Waitmouse and repeat
	rts			; Exit

	END

; NOTE: The MOVE command means MOVE, or better yet, COPY the number contained
; in the first operand into the second, in this case, "READ WHAT NUMBER IS IN
; $DFF006, AND PUT IT INTO $DFF180". The .w means it moves a word, i.e.,
; 2 bytes, or 16 bits (1 byte=8 bits, 1 word=16 bits, 1 longword=32 bits).
; NOTE2: BTST followed by BNE is used to make a program jump in
; case a condition has occurred: it can be translated as follows:
; BTST = CHECK IF PIERO HAS EATEN THE APPLE, AND WRITE IT ON A PIECE OF PAPER
; BNE = BNE GOES TO READ ON THE PIECE OF PAPER IF PIERO HAS EATEN THE APPLE,
; SOMETHING HE CANNOT VERIFY, BUT WHICH HAS BEEN VERIFIED BY HIS FRIEND BTST...
; IN CASE THE NOTE SAYS THAT HE HAS NOT EATEN IT, THEN
; JUMP TO THE INDICATED LABEL (IN THIS CASE BNE.S Waitmouse, SO IF PIERO
; hasn't eaten the apple, the processor will jump to Waitmouse and repeat the
; whole process; if he has eaten it, then it won't jump to Waitmouse, but will
; continue executing the instruction below the BNE... in this case, it finds an RTS and
; consequently, the program ends. The piece of paper where BTST writes the sentence
; for the BNE is the STATUS REGISTER, or SR. For example, if instead of BNE
; there had been a BEQ, then the loop would occur only when the mouse
; is pressed, and it would end when it's released (THE OPPOSITE: IN FACT, BNE means:
; BRANCH IF NOT EQUAL, i.e., JUMP IF IT'S NOT EQUAL (false), while BEQ:
; BRANCH IF EQUAL, i.e., jump if it's EQUAL (true).
; In the first line, it reads the value present in $dff006, which is the line
; reached by the electronic pen that continuously redraws the screen,
; therefore, a constantly changing number, and puts it into $dff180, which is the
; register that controls color 0, consequently obtaining a flashing or streaked screen,
; where the color is continuously changed.
; Verify that $dff006 is VHPOSR by typing "=c 006", and that $dff180 is the
; COLOR 0, by typing "=C 180". You can ask ASMONE for help with
; each $dffxxx register.
; The color format is as follows: $0RGB, i.e., the word of the register
; is divided into RED, GREEN, and BLUE, in 16 shades per color; by mixing them as
; from the PALETTE or TAVOLOZZA of deluxe paint, one can select one of the
; 4096 possible colors (16*16*16=4096), each value of RED, GREEN, and BLUE,
; i.e., RED, GREEN, and BLUE, ranging from 0 to F (hexadecimal number, i.e.,
; it can be 0,1,2,3,4,5,6,7,8,9,a,b,c,d,e,f), for example, try changing the
; first line with MOVE.W #$000,$dff180: you'll get black color
; changing it with MOVE.W #$00e,$dff180 you'll get BLUE,
; with MOVE.W #$cd0,$dff180 you'll get YELLOW, i.e., red+green...
; try changing the color to see if you've understood
; #$444 = gray, #$900 = dark red, #$e00 = bright red, #$0a0 = green...
; finally, if you change $dff180 to $dff182, the text will flash instead of
; the background, i.e., the one colored with color 1. If you put both
; instructions one after the other, both the background and the text will flash.
; The BTST command checks if a BIT at a given address is 0...
; remember that the bit number is read from right to left and
; starting from 0, for example, in a byte like %01000000 , the bit at 1 is the 6th:
; 76543210 		 5432109876543210
; 01000000    one word:  0001000000000000 <= here the bit 12 is set to 1!!!
;
; P.S:	The first bit is called bit 0 and not bit 1, so you should never
;	get confused about this, i.e., for example, the seventh bit
;	is called bit 6. To avoid mistakes, always put the numbering
;	; 5432109876543210 above the binary number.

; the bit 6 of $bfe001 is indeed the left mouse button.
; The name of the register $bfe001 is CIAAPRA, but no one remembers it.
; the right button instead is bit 2 of $dff016. try replacing the
; line BTST #6,$bfe001 with BTST #2,$dff016, and the right button will be used
; to exit the loop. Make all the suggested variations to verify!
; NOTE: if you want to save the program so that it can be followed from the CLI
; just type "WO" after assembling with A (and before doing the J!),
; and a window will appear to decide where to save it
; (Remember! save it on another disk! Keep the course disk write-protected
; and beware if you write on it!!!).
; If you instead want to save the listing, use the "W" command. (on another
; disk!!!).

; PSPS: You may have noticed the BNE.S, which has a suffix that is neither .B nor .W
;   nor .L!!!! Well, in instructions like BNE, BEQ, BSR, only two dimensions are allowed:
;   .B and .W, which, however, do not influence the result,
;   indeed, a bne.w will do the same thing as a bne.b. In these instructions
;   it is allowed to call .B as .S, which stands for SHORT, and
;   it can only be used if the label it refers to is not too
;   "far away," otherwise, ASMONE will automatically change it to
;   .W during assembly. Since .S (which I repeat stands for .B)
;   can only be used with such instructions, I think it's better to use it,
;   now that you know, it shouldn't cause any problems.
;   PSPSPS: If you specify .L size (BNE.L), ASMONE does not give an error
;   and assembles it as .W, other assemblers give an error. If you forget
;   to put the suffix (BNE Start), ASMONE will always assemble it as
;   BNE.W, the same goes for other instructions! Writing MOVE $10,$20,
;   doesn't give an error because it is assembled as MOVE.W $10,$20, BUT IT IS NOT
;   SAID THAT ALL ASSEMBLERS BEHAVE LIKE THIS, SO ALWAYS PUT
;   THE SUFFIX, which is also aesthetically more pleasing.
