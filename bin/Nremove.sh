

#########################################################################
##                                                                     ##
##     Nremove.sh                                                      ##
##                                                                     ##
##     Gael A. Millot                                                  ##
##     Bioinformatics and Biostatistics Hub                            ##
##     Computational Biology Department                                ##
##     Institut Pasteur Paris                                          ##
##                                                                     ##
#########################################################################



# $1 in_path
# $2 out_path
gz=$1
Nremove_gz=$2
log=$3

zcat ${gz} | awk '{lineKind=(NR-1)%4;}lineKind==0{record=$0; next}lineKind==1{toGet=!($0~/^N*$/); if(toGet) print record}toGet' | gzip -c > ${Nremove_gz}
# see protocol 44
zcat ${Nremove_gz} | wc -l > ${log}
# warning: with no output dir for log.txt, the file is created in \\wsl$\Ubuntu-20.04\home\gael\work\35\b826898b7be994ff13b7bc73bc88d8\
# get the bad sequences + 3 other lines of the fastq #see https://stackoverflow.com/questions/11793942/delete-lines-before-and-after-a-match-in-bash-with-sed-or-awk
# BEWARE: !/^(N*)$/ does not work to take the good seq, because the + line will be a good one and will print the 4 corresponding lines



