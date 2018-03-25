ledgerfile = book.txt

all: reports/monthly/change/Expenses_vs_Income.json reports/monthly/balance/Assets.json

reports/monthly/change/Expenses_vs_Income.txt: reports/monthly/change/Expenses.txt reports/monthly/change/Income.txt
	join $^ > $@

# Create monthly change report for account (json format)
reports/monthly/change/%.json: reports/monthly/change/%.txt
	./jsonify.sh "$<" "Month" "$*" > "$@"


# Create monthly balance report for account (json format)
reports/monthly/balance/%.json: reports/monthly/balance/%.txt
	./jsonify.sh "$<" "Month" "$*" > "$@"

# Create monthly change report for account (dsv format)
reports/monthly/change/%.txt: $(ledgerfile)
	# Create parent directory
	mkdir -p $(shell dirname $@)
	
	# Create report file
	./monthly_change.sh "$<" "$(shell echo "$*" | sed 's/^\///;s/\//:/g')" > "$@"

# Create monthly balance report for account (dsv format)
reports/monthly/balance/%.txt: $(ledgerfile)
	# Create parent directory
	mkdir -p $(shell dirname $@)
	
	# Create report file
	./monthly_balance.sh "$<" "$(shell echo "$*" | sed 's/^\///;s/\//:/g')" > "$@"

