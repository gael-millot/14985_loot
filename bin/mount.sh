

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


# $1 in_path
# $2 out_path
output_file=$1
in_path="$2"
out_path="$3"

If
sudo mkdir /mnt/share
sudo mount -t drvfs '\\zeus.pasteur.fr\BioIT\gmillot' /mnt/share


echo -e "\nRESULT DIRECTORY CREATED:\n${out_path}\n" >> ${output_file}
echo -e "\nnextflow.config FILE USED FOR THIS RUN IS IN:\n${in_path}\nAND IS SAVED IN:\n${out_path}\n" >> ${output_file}




