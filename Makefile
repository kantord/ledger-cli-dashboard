ledgerfile = book.txt

all: monthly_reg/Expenses_vs_Income.json

monthly_reg/Expenses_vs_Income.txt: monthly_reg/Expenses.txt monthly_reg/Income.txt
	join $^ > $@

# Create monthly report for account (json format)
monthly_reg/%.json: monthly_reg/%.txt
	./jsonify.sh "$<" "Month" "$*" > "$@"

# Create monthly report for account (dsv format)
monthly_reg/%.txt: $(ledgerfile)
	# Create parent directory
	mkdir -p $(shell dirname $@)
	
	# Create report file
	./monthly_reg.sh "$<" "$(shell echo "$*" | sed 's/^\///;s/\//:/g')" > "$@"

