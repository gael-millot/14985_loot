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


//////// Variables

config_file = file("${projectDir}/nextflow.config")
log_file = file("${launchDir}/.nextflow.log")

//////// end Variables


//////// Variables from config.file that need to be modified

in_path_test = file("${in_path}/${fastq_file}") // to test if exist below

//////// end Variables from config.file that need to be modified


//////// Channels

fastq_ch = Channel.fromPath("${in_path}/${fastq_file}", checkIfExists: false) // I could use true, but I prefer to perform the check below, in order to have a more explicit error message

//////// end Channels



//////// Checks

if(system_exec == 'local' || system_exec == 'slurm'){
    if(system_exec == 'local'){
        def file_exists = in_path_test.exists()
        if( ! file_exists){
            error "\n\n========\n\nERROR IN NEXTFLOW EXECUTION\n\nINVALID in_path PARAMETER IN nextflow.config FILE: ${in_path}\nIF POINTING TO A DISTANT SERVER, CHECK THAT IT IS MOUNTED\n\n========\n\n"
        }
    }
}else{
    error "\n\n========\n\nERROR IN NEXTFLOW EXECUTION\n\nINVALID system_exec PARAMETER IN nextflow.config FILE: ${system_exec}\n\n========\n\n"
}

//////// end Checks



//////// Processes

// create a file with the workflow version in out_path
process WorkflowVersion {
    publishDir "${out_path}", mode: 'copy'
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
echo "result path: ${out_path}" >> Run_info.txt
echo "nextflow version: ${nextflow.version}" >> Run_info.txt
echo -e "\\n\\nIMPLICIT VARIABLES:\\n\\nlaunchDir (directory where the workflow is run): ${launchDir}\\nprojectDir (directory where the main script is located): ${projectDir}\\nworkDir (directory where tasks temporary files are created): ${workDir}" >> Run_info.txt
echo -e "\\n\\nUSER VARIABLES:\\n\\nout_path: ${out_path}\\nin_path: ${in_path}" >> Run_info.txt
    """
}
//${projectDir} nextflow variable
//${workflow.commandLine} nextflow variable
//${workflow.manifest.version} nextflow variable
//Note that variables like ${out_path} are interpreted in the script block



process Nremove {
    label 'bash' // see the withLabel: bash in the nextflow config file 
    publishDir "${out_path}", mode: 'copy', overwrite: false
    cache 'true'

    input:
    file gz from fastq_ch

    output:
    file "${gz.baseName}_Nremove.gz" into fastq_Nremove_ch
    file "Nremove_log.txt"

    script:
    """
    Nremove.sh ${gz} "${gz.baseName}_Nremove.gz" "Nremove_log.txt"
    """
}






process Backup {
    label 'bash' // see the withLabel: bash in the nextflow config file 
    publishDir "${out_path}", mode: 'copy', overwrite: false // since I am in mode copy, all the output files will be copied into the publishDir. See \\wsl$\Ubuntu-20.04\home\gael\work\aa\a0e9a739acae026fb205bc3fc21f9b
    cache 'false'

    input:
    file config_file
    file log_file

    output:
    file "${config_file}" // warning message if we use file config_file
    file "${log_file}" // warning message if we use file log_file
    file "Log_info.txt"

    script:
    """
    echo "nextflow log (full version, the one in the result folder is not complete): ${launchDir}" > Log_info.txt
    """
}


//////// end Processes
