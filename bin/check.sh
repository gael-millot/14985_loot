#!/usr/bin/env bash

#########################################################################
##                                                                     ##
##     check.sh                                                         ##
##                                                                     ##
##     Gael A. Millot                                                  ##
##     Bioinformatics and Biostatistics Hub                            ##
##     Computational Biology Department                                ##
##     Institut Pasteur Paris                                          ##
##                                                                     ##
#########################################################################





if [[ -d $out_path ]]; then
    echo -e \"\nDIRECTORY ALREADY EXISTS:\n\"
    echo -e ${out_path}
    exit 1
else
    mkdir ${out_path}
fi
zcat ${fastq_file} | awk \'{lineKind=(NR-1)%4;}lineKind==0{record=\$0; next}lineKind==1{toGet=!(\$0~/^N*\$/); if(toGet) print record}toGet\' | gzip > ${out_path}/good_file_CL14985.gz
# see protocol 44
zcat ${out_path}/good_file_CL14985.gz | wc -l > ${out_path}/log.txt

# warning: with no output dir for log.txt, the file is created in \\wsl$\Ubuntu-20.04\home\gael\work\35\b826898b7be994ff13b7bc73bc88d8\




