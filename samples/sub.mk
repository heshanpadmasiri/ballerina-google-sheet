BAL?=bal

test: expect.txt actual.txt
	diff $^

clean:
	rm -rf *.txt
	bal clean

expect.txt : main.bal
	../expect.sh $< > $@

actual.txt : main.bal
	$(BAL) run > $@

.PHONY: test clean
