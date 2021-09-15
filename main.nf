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


//////// Variables from config.file that need to be modified

config2 = file("${config2}")

//////// Variables from config.file that need to be modified





//////// Channels


//////// end Channels





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
    """
}
//${projectDir} nextflow variable
//${workflow.commandLine} nextflow variable
//${workflow.manifest.version} nextflow variable
//Note that variables like ${out_path} are interpreted in the script block

process configBackup {
    label 'bash' // see the withLabel: bash in the nextflow config file 
    publishDir "${out_path}", mode: 'copy', overwrite: false // since I am in mode copy, all the output files will be copied into the publishDir. See \\wsl$\Ubuntu-20.04\home\gael\work\aa\a0e9a739acae026fb205bc3fc21f9b
    cache 'false'

    input:
    file config2

    output:
    file "${config2}" // warning message if we use file config2

    script:
    """
    """
}



//////// end Processes
