#!/bin/tcsh

#Acest script transformă scrierea pre-92 în post-92
#Copyright I. M. Ciobîcă și E. Petrișor, GPL, 2005

#Întîi se verifică dacă argumentul există
if ( $# != 1 ) then
   echo "Usage: `basename $0` arg1"
   exit 1
endif

#Apoi se verifică dacă fișierul există
if !( -e $1 ) then
   echo "Usage: `basename $0` arg1"
   echo "with arg1 a (text) file."
   exit 2
endif

#Back-up?
cp -p $1 $1.bak

#Acum căutăm ce fel de codare avem, iso-8859-16 sau UTF-8?
#Comanda file nu este de încredere.
set abreve_iso8859=`grep -c ă $1`
set abreve_utf8=`grep -c Ä $1`
#echo "$abreve_iso8859 'a_breve' non-UTF-8 and $abreve_utf8 'a_breve' UTF-8."

if ( ( $abreve_utf8 > 0 ) && ( $abreve_iso8859 == 0 ) ) then
   #avem UTF-8
   echo "UTF-8 text."
   cat $1.bak | sed ':a;s/\([a-zA-Z]\)Ăź\([a-zA-Z]\)/\1Ăą\2/;ta' | \
              sed ':a;s/\([A-Za-z]\)Ă\([A-Za-z]\)/\1Ă\2/;ta' | \
              sed ':a;s/\(\(R\|r\)e\|\(N\|n\)e\|\(D\|d\)e\(s\|z\)\|\(P\|p\)re\|\(P\|p\)ost\)Ăą/\1Ăź/;ta' | \
              sed ':a;s/\(RE\|\NE\|DE\(S\|Z\)\|PRE\|POST\)Ă/\1Ă/;ta' | \
              sed ':a;s/\([Ss]\)Ăźnt/\1unt/;ta' | \
              sed ':a;s/\([Ss]\)Ăąnt/\1unt/;ta' | \
              sed 's/SĂNT/SUNT/g' | sed 's/SĂNT/SUNT/g' > $1
   exit 0
endif

if ( ( $abreve_iso8859 > 0 ) && ( $abreve_utf8 == 0 ) ) then
   #avem iso-8859-ceva, ceva=2,16
   echo "ISO-8858-x text."
   cat $1.bak | sed ':a;s/\([a-zA-Z]\)î\([a-zA-Z]\)/\1â\2/;ta' | \
                sed ':a;s/\([A-Za-z]\)Î\([A-Za-z]\)/\1Â\2/;ta' | \
                sed ':a;s/\(\(R\|r\)e\|\(N\|n\)e\|\(D\|d\)e\(s\|z\)\|\(P\|p\)re\|\(P\|p\)ost\)â/\1î/;ta' | \
                sed ':a;s/\(RE\|\NE\|DE\(S\|Z\)\|PRE\|POST\)Â/\1Î/;ta' |\
                sed ':a;s/\([Ss]\)[îâ]nt/\1unt/;ta' | \
                sed 's/S[ÎÂ]NT/SUNT/g' > $1
   exit 0
endif

#Asta a fost. "diff $1 $1.bak"?


#Aici se iese dacă "ă" nu a fost detectat nici într-o variantă.
echo "$1 file contains no diacritics. Or 'a with breve' exists in both variants UTF-8 and non-UTF-8. "
exit 10
