#!/usr/bin/env bash

### Converts your fullsize logo into specified smaller versions
### v0.1 it works
### px <px@ns1.net>
### 2013.01.18

DEBUG=

if [[ ! -z "${DEBUG}" ]]; then
  set -x 
 # DEBUG=`which echo`
fi


images='public/images'
logo='/logo.xcf'

# two width sizes
sizes=( 200  132 ) 

# define the dimensions of the above sizes
resize[200]='200x61'
resize[132]='132x40'


function xcf2png () {

### convert -alpha on -background none -layers merge 
CMD='convert '
CMD+="-verbose "
CMD+="-alpha transparent "
CMD+="-resize ${size} "
CMD+="-layers merge"

outfile="${images}/logo-${size}.png"
EXEC="${CMD} -resize ${resize[${size}]} ${images}${logo} ${outfile}"

if [[ ${DEBUG} -gt 0 ]];
then
# echo out ${EXEC}
echo ${EXEC}

else
  
  ## just run the ${EXEC}
  ${EXEC}
fi 

}

## Loop through our sizes array
for size in ${sizes[@]}
do
  ## run our conversion function using the ${size}
  xcf2png
done

exit 0

