PYTHON=python3
BAL=bal
API_SPEC=openapi.yaml
NAME_LIST=name_list.txt
CLIENT=client.bal
TYPES=types.bal
LIB=lib.bal
INCLUSION=inclusion.py
RENAME=rename.py
GENERATED_FILES=$(CLIENT) $(TYPES) utils.bal
RENAME_STAMP=rename.stamp
INCLUSION_STAMP=inclusion.stamp
PACK=../build/pack/bala/heshan-ballerina_google_sheet-java11-0.1.0.bala
JAR=../build/gsheet/bin/ballerina_google_sheet.jar

all: $(RENAME_STAMP) $(INCLUSION_STAMP)
	$(BAL) build --target-dir ../build/gsheet

pack: $(PACK)
	$(BAL) push $(PACK) --repository=local

$(PACK): $(INCLUSION_STAMP) $(RENAME_STAMP)
	$(BAL) pack --target-dir ../build/pack

test: $(RENAME_STAMP) $(GENERATED_FILES) $(INCLUSION_STAMP)
	$(BAL) test

$(INCLUSION_STAMP): $(GENERATED_FILES) $(INCLUSION)
	$(PYTHON) $(INCLUSION) $(CLIENT) $(LIB)
	touch $@

$(RENAME_STAMP): $(GENERATED_FILES) $(RENAME)
	$(PYTHON) $(RENAME) --inplace $(CLIENT) $(TYPES) $(NAME_LIST)
	touch $@

$(GENERATED_FILES): $(API_SPEC)
	rm -rf $(GENERATED_FILES)
	$(BAL) openapi -i openapi.yaml --mode=client --client-methods=remote

clean:
	$(PYTHON) $(INCLUSION) --clean $(CLIENT) $(LIB)
	rm -f $(GENERATED_FILES)
	rm -rf ./build
	$(BAL) clean

.PHONY: clean all test pack
