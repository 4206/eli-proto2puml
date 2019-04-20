ELI=/opt/eli/bin/eli
SRC_DIR=src
TRG_DIR=target
PUML=plantuml

exe:
	mkdir -p $(TRG_DIR)
	$(ELI) "$(SRC_DIR)/pro2pu.specs :exe > $(TRG_DIR)/pro2pu"

parsable:
	$(ELI) "$(SRC_DIR)/pro2pu.specs :parsable >"

mon:
	$(ELI) "$(SRC_DIR)/pro2pu.specs +monitor +arg='test/tutorial.proto' :mon"

test: tutorial.png

%.puml:
	$(TRG_DIR)/pro2pu test/$(*F).proto > $(TRG_DIR)/$(*F).puml
%.png:
	$(PUML) -tpng $(TRG_DIR)/$(*F).puml

.PHONY: test
