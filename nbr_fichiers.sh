for i in *; do echo -n $i " " ; find $i |wc -l; done | sort -n -k2

