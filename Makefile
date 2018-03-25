ledgerfile = book.txt

all: monthly_change/Expenses_vs_Income.json monthly_balance/Assets.json

monthly_change/Expenses_vs_Income.txt: monthly_change/Expenses.txt monthly_change/Income.txt
	join $^ > $@

# Create monthly change report for account (json format)
monthly_change/%.json: monthly_change/%.txt
	./jsonify.sh "$<" "Month" "$*" > "$@"


# Create monthly balance report for account (json format)
monthly_balance/%.json: monthly_balance/%.txt
	./jsonify.sh "$<" "Month" "$*" > "$@"

# Create monthly change report for account (dsv format)
monthly_change/%.txt: $(ledgerfile)
	# Create parent directory
	mkdir -p $(shell dirname $@)
	
	# Create report file
	./monthly_change.sh "$<" "$(shell echo "$*" | sed 's/^\///;s/\//:/g')" > "$@"

# Create monthly balance report for account (dsv format)
monthly_balance/%.txt: $(ledgerfile)
	# Create parent directory
	mkdir -p $(shell dirname $@)
	
	# Create report file
	./monthly_balance.sh "$<" "$(shell echo "$*" | sed 's/^\///;s/\//:/g')" > "$@"

