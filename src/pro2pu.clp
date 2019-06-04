FileName input "File to be processed";
usage "--help";

/* workaround from 2012: https://sourceforge.net/p/eli-project/mailman/message/30261880/ */
ShowVersion "--version" boolean "Display version and exit";

/* definition moved to ImportDefer.clp */
/* IncludeDir "-I" "--include=" joinedto strings "Include directory imports"; */

ShowUsageRelation "-u" "--usage=" joinedto int "Hide (-u0) or show (-u1) usage relation [default: 1]";
ShowInnerRelation "-i" "--inner=" joinedto int "Hide (-i0) or show (-i1) inner message relation [default: 1]";