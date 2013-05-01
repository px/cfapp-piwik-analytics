#!/usr/bin/env bash

### Converts your fullsize logo into specified smaller versions
### v0.1 it works
### px <px@ns1.net>
### 2013.05.01

DEBUG=true

if [[ ! -z "${DEBUG}" ]]; then
  set -x 
 # DEBUG=`which echo`
fi


images='public/images'
logoURL='http://piwik.org/download/Piwik-logo-high-res.png'
logo='/Piwik-logo-high-res.png'

# two width sizes
sizes=( 200  132 ) 

# define the dimensions of the above sizes
resize[200]='200x61'
resize[132]='132x40'

function fetch_high_res() {
  OPTS="--continue "
  OPTS+="--timestamping "

  wget ${OPTS} "${logoURL}" --output-document="${images}${logo}"
}

function resize () {

### convert -alpha on -background none -layers merge 
CMD='convert '
CMD+="-verbose "
#CMD+="-alpha transparent "
CMD+="-resize ${size} "
#CMD+="-layers merge"

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

fetch_high_res

## Loop through our sizes array
for size in ${sizes[@]}
do
  ## run our conversion function using the ${size}
  resize
  #  xcf2png
done

exit 0

