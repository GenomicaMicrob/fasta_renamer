#!/bin/bash
# AUTHOR: Bruno Gomez-Gil, Lab. Genomica Microbiana, CIAD. https://github.com/GenomicaMicrob
# LAST REVISED: 24 Oct. 2016
# USAGE: fasta_renamer.sh
echo ___________________________________________________________________________
echo
echo "Script to rename the headers of a multifasta file or files."
echo "A consecutive number will be added to each sequence header (>header_1, >header_2, etc.)"
echo "New files will be created with the extension fna."
echo
fasta=$(ls -l *.{fna,fasta,fa,fsa,fas} 2>/dev/null | wc -l) # variable to count the number of fasta files in this directory, if false, sends no error message (2>/dev/null) to stdout
#OPTIONS-----
echo -n -e "Please select an option:\n   1 Rename one file, the fasta header will be the same as the filename\n   2 Rename one file and change the original header name with another\n   3 Rename all $fasta files in this directory, the fasta header will be the same as the filename\n   x exit "
echo
read character
case $character in
    1 ) echo
		read -e -p "Name of the fasta file: " FILE
		mkdir -p renamed_files
		BASENAME=$(echo $FILE | rev | cut -f 2- -d '.' | rev) # variable to extract the name of file without the extension.
		awk '/^>/{print ">'$BASENAME'_"++i; next}{print}' $FILE > renamed_files/$BASENAME.fna # adds a _ and a consecutive number to the new sequence header.
		SEQS=$(grep -c ">" renamed_files/$BASENAME.fna | sed -r ':L;s=\b([0-9]+)([0-9]{3})\b=\1,\2=g;t L') # counts number of sequences and displays them with thousand comma separators
		echo "File $FILE was processed and saved as $BASENAME.fna with $SEQS sequences in renamed_files/"
	;;
		
    2 ) echo 
		read -e -p "Name of the fasta file: " FILE
		mkdir -p renamed_files
		read -p "Type a new header name: " SAMPLE
		awk '/^>/{print ">'$SAMPLE'_"++i; next}{print}' $FILE > renamed_files/$SAMPLE.fna
		SEQS=$(grep -c ">" renamed_files/$SAMPLE.fna | sed -r ':L;s=\b([0-9]+)([0-9]{3})\b=\1,\2=g;t L') # counts number of sequences and displays them with thousand comma separators
		echo "File $FILE was processed and saved as $SAMPLE.fna with $SEQS sequences in renamed_files/"
	;;
	
    3 ) echo
		mkdir -p tmp renamed_files # make a temporary folder to backup all fasta files
		cp *.{fna,fasta,fa,fsa,fas} tmp/ 2>/dev/null || : # copy all fasta files to a backup folder
		# rename all .extension to to .fasta
		rename 's/\.fna$/\.fasta/' *.fna 2>/dev/null || :
		rename 's/\.fa$/\.fasta/' *.fa 2>/dev/null || :
		rename 's/\.fas$/\.fasta/' *.fas 2>/dev/null || :
		rename 's/\.fsa$/\.fasta/' *.fsa 2>/dev/null || :
		
		# RENAME HEADERS OF FASTA FILES
		FILES=*.fasta
		for f in $FILES
			do
				SAMPLE=$(basename $f .fasta) # obtains only the name of the file without the .fasta extension and saves it as the variable $SAMPLE
				awk '/^>/{print ">'$SAMPLE'_"++i; next}{print}' $f > renamed_files/$SAMPLE.fna
				SEQS=$(grep -c ">" renamed_files/$SAMPLE.fna | sed -r ':L;s=\b([0-9]+)([0-9]{3})\b=\1,\2=g;t L') # counts number of sequences and displays them with thousand comma separators
				echo "File $f was processed and saved as $SAMPLE.fna with $SEQS sequences in renamed_files/"
			done
			# Cleanup
			rm -f *.fasta
			mv tmp/* .
			rm -fr tmp
	;;
			
	* ) echo
		echo "Adios"
esac
echo "Done"
echo
# This is the end.