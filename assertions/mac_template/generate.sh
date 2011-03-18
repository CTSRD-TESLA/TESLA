#!/bin/sh

VARS=$1

TEMPLATE=$2
if [ "$TEMPLATE" == "" ]; then
	echo "usage: generate.sh <vars> <template file>"
	exit 1
fi

OUTPUT=`echo $TEMPLATE | sed 's/.template$//'`

if [ "$OUTPUT" == "$TEMPLATE" ]; then
	echo "Error: input filename does not end in .template"
	exit 1
fi

echo "$TEMPLATE => $OUTPUT"

SED_BACKUP=$OUTPUT.backup
cp $TEMPLATE $OUTPUT

cat $VARS | while read line
do
	case $line in
		\#*)	continue ;;
	esac

	name=`echo "$line" | awk -F: '{print $1}'`
	value=`echo "$line" | awk -F: '{print $2}'`

	if [ "" == "`grep %$name% $OUTPUT`" ]; then
		echo Pattern %$name% not present in $OUTPUT
	else
		echo $name
	fi

	sed -i.backup -e "s/%$name%/$value/" $OUTPUT || exit 1
done

cat $OUTPUT | tr '$' '\n' > $SED_BACKUP
mv $SED_BACKUP $OUTPUT

