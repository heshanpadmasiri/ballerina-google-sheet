PYTHON=python3
BAL=bal
API_SPEC=openapi.yaml
NAME_LIST=name_list.txt
GENERATED_FILES=client.bal types.bal utils.bal
RENAME_STAMP=rename.stamp

all: $(RENAME_STAMP)

test: $(RENAME_STAMP) $(GENERATED_FILES)
	$(BAL) test

$(RENAME_STAMP): $(GENERATED_FILES)
	$(PYTHON) rename.py --inplace $(NAME_LIST)
	touch $(RENAME_STAMP)

$(GENERATED_FILES): $(API_SPEC)
	rm -rf $(GENERATED_FILES)
	$(BAL) openapi -i openapi.yaml --mode=client --client-methods=remote

clean:
	rm -f $(GENERATED_FILES)
	$(BAL) clean

.PHONY: clean all test