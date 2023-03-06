APE=/sys/src/ape
<$APE/config

TARG=opusdec opusenc opusinfo
BIN=/$objtype/bin/audio

CFLAGS=$CFLAGS -c \
	-Iinclude \
	-I/sys/src/cmd/audio/libogg \
	-I/sys/include/ape/opus \
	-D_POSIX_SOURCE \
	-D__GNU_LIBRARY__ \
	-D_C99_SNPRINTF_EXTENSION \
	-DSPX_RESAMPLE_EXPORT= \
	-DRANDOM_PREFIX=opustools \
	-DOUTSIDE_SPEEX \
	-DRESAMPLE_FULL_SINC_TABLE \
	-DOPUSTOOLS \
	-DPACKAGE_NAME="opus-tools" \
	-DPACKAGE_VERSION="fuckoff"

LIB=\
	/$objtype/lib/ape/libopusfile.a \
	/$objtype/lib/ape/libopusenc.a \
	/$objtype/lib/ape/libopus.a \
	/sys/src/cmd/audio/libogg/libogg.a$O \

</sys/src/cmd/mkmany

%.$O:	src/%.c
	$CC $CFLAGS $prereq

%.$O:	share/%.c
	$CC $CFLAGS $prereq

%.$O:	/sys/src/cmd/audio/libogg/%.c
	$CC $CFLAGS $prereq

OGG=`{cd /sys/src/cmd/audio/libogg; echo *.c}
OGG=${OGG:%.c=%.$O}

/sys/src/cmd/audio/libogg/libogg.a$O:	$OGG
	ar vu $target $OGG

COMMON=opus_header.$O resample.$O getopt.$O getopt1.$O

$O.opusdec:	opusdec.$O wav_io.$O wave_out.$O diag_range.$O $COMMON
$O.opusenc:	opusenc.$O audio-in.$O diag_range.$O flac.$O picture.$O $COMMON
$O.opusinfo:	opusinfo.$O info_opus.$O picture.$O tagcompare.$O $COMMON

CLEANFILES=`{$CLEANFILES echo /sys/src/cmd/audio/libogg/libogg.a[$OS]}
