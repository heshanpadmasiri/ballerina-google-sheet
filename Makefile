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

all: $(RENAME_STAMP) $(INCLUSION_STAMP)
	$(BAL) build

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
	$(BAL) clean

.PHONY: clean all test
