ELI=/opt/eli/bin/eli
SRC_DIR=src
TRG_DIR=target
#TEST_DIR=test-interfaces
TEST_DIR=test
PUML=plantuml

# build a compiler executable
exe:
	mkdir -p $(TRG_DIR)
	$(ELI) "$(SRC_DIR)/pro2pu.specs :exe > $(TRG_DIR)/pro2pu"

# generate C sources and zip them for export to other platforms
source:
	rm -rf $(TRG_DIR)/source
	mkdir -p $(TRG_DIR)/source/
	$(ELI) "$(SRC_DIR)/pro2pu.specs :source > $(TRG_DIR)/source/"	
	cd $(TRG_DIR); tar cfz pro2pu-$(shell date +%Y-%m%d-%H%M).tar.gz source

clean:
	rm -rf $(TRG_DIR)

# check if the concrete syntax (.con) is vali LALR(1)
parsable:
	$(ELI) "$(SRC_DIR)/pro2pu.specs :parsable >"

# debug the generated compiler with a graphical tool, call e.g. "make tutorial.mon"
%.mon:
	$(ELI) "$(SRC_DIR)/pro2pu.specs +monitor +arg='$(TEST_DIR)/$(*F).proto' :mon"

# restart the ELI-internal odin build server
connect_to_odin:
	$(ELI) -r


# targets for testing the compiler
.PHONY: test %.puml_show %.mon

# build .puml from .proto
%.puml: 
	cd $(TEST_DIR); ../$(TRG_DIR)/pro2pu $(*F).proto > ../$(TRG_DIR)/$(*F).puml
# build .puml from .proto an show on terminal
%.puml_show: $(TRG_DIR)/%.puml
	cat $(TRG_DIR)/$(*F).puml

# build .svg from .puml
%.svg: $(TRG_DIR)/%.puml
	$(PUML) -tsvg $(TRG_DIR)/$(*F).puml
# build .png frm .puml
%.png: $(TRG_DIR)/%.puml
	$(PUML) -tpng $(TRG_DIR)/$(*F).puml


svg: tutorial.svg example2.svg example3.svg import_package1.svg

test: tutorial.svg example2.svg example3.svg import_package1.svg
	# compare with reference outputs
	#for i in $?; do \
	#	diff -s $(TRG_DIR)/$$i test/$$i; \
	#done
test1: tutorial.puml_show tutorial.svg 

test2: example2.puml_show example2.svg

test3: example3.puml_show example3.svg

testimport: import_package1.puml_show import_package1.svg
	#cat $(TRG_DIR)/$?
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
test6: Bel.svg

test7: test7.svg

test8: test8.svg

test9: test9.puml

INDEX.proto:
	echo 'syntax = "proto3";' > $(TRG_DIR)/INDEX.proto
	find test-interfaces-sorted -name "*.proto" | sed 's/^\(.*\)/import "\1";/' >> $(TRG_DIR)/INDEX.proto


INDEX.puml: $(TRG_DIR)/INDEX.proto
	$(TRG_DIR)/pro2pu -Itest-interfaces-sorted  $(TRG_DIR)/INDEX.proto > $(TRG_DIR)/INDEX.puml
INDEX.svg: $(TRG_DIR)/INDEX.puml
	$(PUML) -tsvg $(TRG_DIR)/INDEX.puml

