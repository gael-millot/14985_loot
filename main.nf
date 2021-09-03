
out_path="/pasteur/zeus/projets/p01/BioIT/gmillot/14985_loot/results/20210720_res_CL14985_newtrim_align"
fastq_file="/pasteur/zeus/projets/p01/BioIT/gmillot/14985_loot/B2699/00_Rawdata/Pool-B2699_S1_L001_R1_001.fastq.gz"

out_path="/mnt/c/Users/Gael/Desktop/20210720_res_CL14985_newtrim_align"
fastq_file="/mnt/y/14985_loot/B2699/00_Rawdata/Pool-B2699_S1_L001_R1_001.fastq.gz"

// get the bad sequences + 3 other lines of the fastq #see https://stackoverflow.com/questions/11793942/delete-lines-before-and-after-a-match-in-bash-with-sed-or-awk
// zcat /pasteur/homes/gmillot/14985_loot/B2699/00_Rawdata/Pool-B2699_S1_L001_R1_001.fastq.gz | awk '/^(N*)$/{for(x=NR-1;x<=NR+2;x++)d[x];}{a[NR]=$0}END{for(i=1;i<=NR;i++)if(i in d)print a[i]}' | gzip > bad.txt &
// BEWARE: !/^(N*)$/ does not work to take the good seq, because the + line will be a good one and will print the 4 corresponding lines

// get the good sequences # code given by Amaury

// We create a file with the workflow version in the Results folder
process WorkflowVersion {
    publishDir "${out_path}/", mode: 'copy'

    cache 'false'
    executor 'local'

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


