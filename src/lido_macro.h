#ifndef LIDO_MACRO_H
#define LIDO_MACRO_H

/* warn that X is being dropped */
#define REPLACE(X,Y) ((X) ? (printf("Warning: value %s has been REPLACEd", StringTable(X)),(Y)) : (Y))


#endif // LIDO_MACRO_H
