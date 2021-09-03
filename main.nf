/*
#########################################################################
##                                                                     ##
##     main.nf                                                         ##
##                                                                     ##
##     Gael A. Millot                                                  ##
##     Bioinformatics and Biostatistics Hub                            ##
##     Computational Biology Department                                ##
##     Institut Pasteur Paris                                          ##
##                                                                     ##
#########################################################################
*/



//////// Processes

// create a file with the workflow version in out_path
process WorkflowVersion {
    publishDir "${out_path}/", mode: 'copy'

    cache 'false'
    executor 'local' // this is the default config

    output:
    file "Run_info.txt"

    script:
    """
echo "Project: " \$(git -C ${projectDir} remote -v | head -n 1) > Run_info.txt
echo "Git info: " \$(git -C ${projectDir} describe --abbrev=10 --dirty --always --tags) >> Run_info.txt
echo "Cmd line: ${workflow.commandLine}" >> Run_info.txt
echo "Manifest's pipeline version: ${workflow.manifest.version}" >> Run_info.txt
echo "Work directory: ${workDir}" >> Run_info.txt
    """
}
//${projectDir} nextflow variable
//${workflow.commandLine} nextflow variable
//${workflow.manifest.version} nextflow variable



process Nremove {
    input:
    val out_path

    output:
    file "log.txt"

    script:
    // as  insection 8.3 of C:\Users\gael\Documents\Hub projects\20200310 Loot 14985\labbook_gael_CL_14985.docx
    """
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
    """
    //warning: with no output dir for log.txt, the file is created in \\wsl$\Ubuntu-20.04\home\gael\work\35\b826898b7be994ff13b7bc73bc88d8\
}


//////// end Processes
