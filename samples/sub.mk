BAL?=bal
PACK=../../build/pack/bala/heshan-ballerina_google_sheet-java11-0.1.0.bala

test: expect.txt actual.txt
	diff $^

clean:
	rm -rf *.txt
	bal clean

expect.txt : main.bal
	../expect.sh $< > $@

actual.txt : main.bal $(PACK)
	$(BAL) run > $@

$(PACK):
	$(MAKE) -C ../.. target=pack client.d

.PHONY: test clean
