# fasta_renamer
Script to rename the headers of a multifasta file or files. A consecutive number will be added to each sequence header (>header_1, >header_2, etc.). Renamed files will be saved in a new subdirectory named renamed_files and the original files will not be modififed.

Although the coding needs some polishing, it works.

The script has tree options:

  1 Rename one file, the fasta header will be the same as the filename
  
  2 Rename one file and change the original header name with another
  
  3 Rename all fasta files in this directory, the fasta header will be the same as the filename

### Installation ###

Just download fasta_renamer.sh to any directory and make it executable: `chmod +x fasta_renamer.sh`

### Usage ###

`$ fasta_renamer.sh`
