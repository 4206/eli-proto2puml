## Prerequisites

Have ```eli``` installed.
Obtain it from https://eli-project.sf.net and compile.
In order for debugging with ```make mon``` to work, Tcl/Tk development libraries must be installed prior to building eli.

Adjust Makefile if path for eli is not ```/opt/eli/bin/eli```

## Building

Run ```make``` to build ```target/pro2pu``` executable.

## Error handling

Building fails with message ```Cannot connect to Odin server.```
Then run ```eli -r``` or ```make connect_to_odin```.

## Errors in the specs

The protobuffer specification for syntax level 2 ("proto2") is either incomplete or has wrong examples.

The example file at the bottom of page https://developers.google.com/protocol-buffers/docs/reference/proto2-spec
has the field:

```
optional group GroupMessage {
    optional a = 1;
  }
```

This is not valid syntax, according to the production rules given on the same page:
```
group = label "group" groupName "=" fieldNumber messageBody
```
and

```
field = label type fieldName "=" fieldNumber [ "[" fieldOptions "]" ] ";"
```

A group declaration must always supply a ```fieldNumber``` (missing in example).
And a field definition must always supply a ```type``` (missing in example).

Thus a corrected version of the example is as follows:
```
optional group GroupMessage = 1 { // fixed
    optional Sometype a = 1;        // fixed
  }
```

Curiously though, the ```protoc``` compiler of ```libprotoc 3.0.0``` does not complain about the example file.