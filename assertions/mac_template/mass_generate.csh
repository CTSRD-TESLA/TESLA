#!/bin/csh

#
# Convert extracted ".vars" files into a set of C assertions
#
set FILES=~/freebsd/svncommit/base/head/sys/kern/*.c.vars
cat ${FILES} | split -p ^ASSERTION_EVENT: - extracted_assertion_spec.
foreach spec (extracted_assertion_spec.*)
	set NAME=`cat $spec | head -1 | awk -F':' '{print $2}' | \
	    awk -F'(' '{print $1}'`
	set TEMPLATE=${NAME}.c.template
	cp mac_assertion.c.template ${TEMPLATE}
	sh generate.sh ${spec} ${TEMPLATE}
end

#
# Generate a unified specfile
#
set SPECFILE=mass_instrumentation.spec
echo function,syscallenter > ${SPECFILE}
echo function,syscallret >> ${SPECFILE}
grep MACCHECK extracted_assertion_spec.* | awk -F':' '{print "function,"$3}' \
    > ${SPECFILE}
