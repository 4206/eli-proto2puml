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
	$(ELI) "$(SRC_DIR)/pro2pu.specs +monitor +arg='test/example2.proto' :mon"

test: tutorial.svg example2.svg
	# compare with reference outputs
	for i in $?; do \
		diff -s $(TRG_DIR)/$$i test/$$i; \
	done
test1: tutorial.puml
	cat $(TRG_DIR)/$?
test2: example2.puml
	cat $(TRG_DIR)/$?
testimport: import_package1.puml
	cat $(TRG_DIR)/$?

%.puml: 
	# $(TRG_DIR)/pro2pu test/$(*F).proto > $(TRG_DIR)/$(*F).puml
	cd test; ../$(TRG_DIR)/pro2pu $(*F).proto > ../$(TRG_DIR)/$(*F).puml
%.png: $(TRG_DIR)/%.puml
	$(PUML) -tpng $(TRG_DIR)/$(*F).puml
%.svg: $(TRG_DIR)/%.puml
	$(PUML) -tsvg $(TRG_DIR)/$(*F).puml

.PHONY: test

connect_to_odin:
	$(ELI) -r
