include accounts.conf

all: \
	reports/monthly/change/$(expenses_account)_vs_$(income_account).json \
	reports/monthly/balance/$(assets_account).json \
	reports/daily/change/$(expenses_account).json \
	reports/monthly/balance/$(savings_account).json \
	reports/monthly/categories_with_other.json \
	.dashboard.yml

.dashboard.yml: ./dashboard.yml.template
	cat $< | \
		sed 's :expenses_account: $(expenses_account) g' | \
		sed 's :income_account: $(income_account) g' | \
		sed 's :assets_account: $(assets_account) g' | \
		sed 's :savings_account: $(savings_account) g' \
	> $@

reports/monthly/categories.json: expense_categories.conf $(ledgerfile)
	./scripts/categories.sh "$(ledgerfile)" "$<" "$(expenses_account)" $(currency) "$@"

reports/monthly/categories.total.txt.values: reports/monthly/categories.json
	cat $< | jq '.rows[1:][] | .[1:] | join(" + ")' -r | bc > $@

reports/monthly/categories.total.txt.dates: reports/monthly/categories.json
	cat $< | jq '.rows[1:][] | .[0]' -r > $@

reports/monthly/categories.total.txt: reports/monthly/categories.total.txt.dates reports/monthly/categories.total.txt.values 
	paste $^ > $@

reports/monthly/other_category.txt: reports/monthly/change/Expenses.txt reports/monthly/categories.total.txt
	bash -c "paste <(join -a1 -a2 -o auto -e \"0\" $^ | cut -f1 -d' ') <(join -a1 -a2 -o auto -e \"0\" $^ | cut -f2,3 -d' ' | tr ' ' '-' | bc)" > $@

reports/monthly/categories_with_other.txt: reports/monthly/categories.json reports/monthly/other_category.txt
	bash -c "cat reports/monthly/categories.json | jq '.rows[0] + [\"Other\"] | join(\" \")' -r" > $@
	bash -c "join -a1 -a2 -o auto -e \"0\" <(cat reports/monthly/categories.json | jq '.rows[1:][] | join(\"\t\")' -r) <(cat reports/monthly/other_category.txt)" >> $@


reports/monthly/categories_with_other.json: reports/monthly/categories_with_other.txt
	cat $< | jq -R '. | split(" ")' | jq --slurp '{"rows": ., "x": "Month", "xFormat": "%Y-%m-%d"}' > $@

reports/monthly/change/$(expenses_account)_vs_$(income_account).txt: reports/monthly/change/$(expenses_account).txt reports/monthly/inverted_change/$(income_account).txt
	join $^ -a1 -a2 -o auto -e "0" > $@

# Create monthly change report for account (json format)
reports/monthly/change/%.json: reports/monthly/change/%.txt
	./scripts/jsonify.sh "$<" "Month" "$*" > "$@"

# Create monthly change report for account (json format)
reports/daily/change/%.json: reports/daily/change/%.txt
	./scripts/jsonify.sh "$<" "Day" "$*" > "$@"


# Create monthly balance report for account (json format)
reports/monthly/balance/%.json: reports/monthly/balance/%.txt
	./scripts/jsonify.sh "$<" "Month" "$*" > "$@"

# Create monthly change report for account (dsv format)
reports/monthly/inverted_change/%.txt: reports/monthly/change/%.txt
	# Create parent directory
	mkdir -p $(shell dirname $@)
	cat $< | sed 's/ -/ /' > $@

# Create monthly change report for account (dsv format)
reports/monthly/change/%.txt: $(ledgerfile)
	# Create parent directory
	mkdir -p $(shell dirname $@)
	
	# Create report file
	./scripts/monthly_change.sh "$<" "$(shell echo "$*" | sed 's/^\///;s/\//:/g')" $(currency) > "$@"


# Create daily change report for account (dsv format)
reports/daily/change/%.txt: $(ledgerfile)
	# Create parent directory
	mkdir -p $(shell dirname $@)
	
	# Create report file
	./scripts/daily_change.sh "$<" "$(shell echo "$*" | sed 's/^\///;s/\//:/g')" $(currency) > "$@"



# Create monthly balance report for account (dsv format)
reports/monthly/balance/%.txt: $(ledgerfile)
	# Create parent directory
	mkdir -p $(shell dirname $@)
	
	# Create report file
	./scripts/monthly_balance.sh "$<" "$(shell echo "$*" | sed 's/^\///;s/\//:/g')" $(currency) > "$@"

