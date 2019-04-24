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

### Groups

The example file at the bottom of page https://developers.google.com/protocol-buffers/docs/reference/proto2-spec
has the field:

    optional group GroupMessage {
        optional a = 1;
      }

This is not valid syntax, according to the production rules given on the same page:

    group = label "group" groupName "=" fieldNumber messageBody

and

    field = label type fieldName "=" fieldNumber [ "[" fieldOptions "]" ] ";"


A group declaration must always supply a ```fieldNumber``` (missing in example).
And a field definition must always supply a ```type``` (missing in example).

Thus a corrected version of the example is as follows:

    optional group GroupMessage = 1 { // fixed
        optional Sometype a = 1;        // fixed
      }

Curiously though, the ```protoc``` compiler of ```libprotoc 3.0.0``` does not complain about the example file.

### Reserved

The example given in section ```reserved``` (https://developers.google.com/protocol-buffers/docs/reference/proto2-spec#reserved) is as follows:

    reserved 2, 15, 9 to 11;
    reserved "foo", "bar";

This is not valid syntax, according to the grammar productions given immediately above the example:

    reserved = "reserved" ( ranges | fieldNames ) ";"
    fieldNames = fieldName { "," fieldName }
where
    fieldName = ident

Reserved keywords cannot be quoted according to the grammar.
The parser implementation will be lenient wrt. reserved names,
as they are not used for compiling to PUML.

## Syntax differences between proto2 and proto3

Productions dropped from proto2 to proto3:

    capitalLetter = "A" ... "Z"
    streamName = ident
    groupName = capitalLetter { letter | decimalDigit | "_" }
    label = "required" | "optional" | "repeated"
    group = label "group" groupName "=" fieldNumber messageBody
    extensions = "extensions" ranges ";"
    extend = "extend" messageType "{" {field | group | emptyStatement} "}"
    stream = "stream" streamName "(" messageType "," messageType ")" (( "{" { option | emptyStatement } "}") | ";" )

Production ```syntax``` has changed, obviously:

    syntax = "syntax" "=" quote "proto2" quote ";"

    syntax = "syntax" "=" quote "proto3" quote ";"

Production ```field``` has changed:

  Reflecting the omission of ```label```, the declaration of ```repeatable``` moved into production ```field```.

    field = label type fieldName "=" fieldNumber [ "[" fieldOptions "]" ] ";"

    field = [ "repeated" ] type fieldName "=" fieldNumber [ "[" fieldOptions "]" ] ";"

Production ```messageBody``` has changed:

  Reflecting the omiision of ```extend```, ```extensions```, and ```group```, the production dropped some RHS's.

    messageBody = "{" { field | enum | message | extend | extensions | group |
    option | oneof | mapField | reserved | emptyStatement } "}"

    messageBody = "{" { field | enum | message | option | oneof | mapField |
    reserved | emptyStatement } "}"

Production ```service``` has changed:

  Stream services have been removed.
    
    service = "service" serviceName "{" { option | rpc | stream | emptyStatement } "}"

    service = "service" serviceName "{" { option | rpc | emptyStatement } "}"

  Curiously, rpc streams are retained in ```proto3```:
  
    rpc = "rpc" rpcName "(" [ "stream" ] messageType ")" "returns" "(" [ "stream" ]

Production ```topLevelDef``` has changed:

  Reflecting the omission of ```extend```.

    topLevelDef = message | enum | extend | service

    topLevelDef = message | enum | service

