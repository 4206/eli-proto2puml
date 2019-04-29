ELI=/opt/eli/bin/eli
SRC_DIR=src
TRG_DIR=target
PUML=plantuml

exe:
	mkdir -p $(TRG_DIR)
	$(ELI) "$(SRC_DIR)/pro2pu.specs :exe > $(TRG_DIR)/pro2pu"

source:
	mkdir -p $(TRG_DIR)/source/
	$(ELI) "$(SRC_DIR)/pro2pu.specs :source > $(TRG_DIR)/source/"	

clean:
	rm -rf $(TRG_DIR)

parsable:
	$(ELI) "$(SRC_DIR)/pro2pu.specs :parsable >"

mon:
	$(ELI) "$(SRC_DIR)/pro2pu.specs +monitor +arg='test/example2.proto' :mon"

svg: tutorial.svg example2.svg example3.svg import_package1.svg

test: tutorial.svg example2.svg example3.svg import_package1.svg
	# compare with reference outputs
	#for i in $?; do \
	#	diff -s $(TRG_DIR)/$$i test/$$i; \
	#done
test1: tutorial.puml
	cat $(TRG_DIR)/$?
test2: example2.puml
	cat $(TRG_DIR)/$?
test3: example3.puml
	cat $(TRG_DIR)/$?
testimport: import_package1.puml
	cat $(TRG_DIR)/$?
testimport2:
	$(TRG_DIR)/pro2pu -Itest test/import_package1.proto
test4a:
	$(TRG_DIR)/pro2pu -Itest -Itest/test4-module1 -Itest/test4-module2 test/test4a.proto
test4b:
	$(TRG_DIR)/pro2pu -Itest test/test4b.proto
test5:
	$(TRG_DIR)/pro2pu -Itest test/wolken/Wolken.proto > $(TRG_DIR)/Wolken.puml
	cat $(TRG_DIR)/Wolken.puml
	plantuml -tsvg $(TRG_DIR)/Wolken.puml

%.puml: 
	cd test; ../$(TRG_DIR)/pro2pu $(*F).proto > ../$(TRG_DIR)/$(*F).puml
%.png: $(TRG_DIR)/%.puml
	$(PUML) -tpng $(TRG_DIR)/$(*F).puml
%.svg: $(TRG_DIR)/%.puml
	$(PUML) -tsvg $(TRG_DIR)/$(*F).puml

.PHONY: test

connect_to_odin:
	$(ELI) -r
