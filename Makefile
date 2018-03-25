include accounts.conf

all: \
	reports/monthly/change/$(expenses_account)_vs_$(income_account).json \
	reports/monthly/balance/$(assets_account).json \
	reports/monthly/balance/$(savings_account).json \
	.dashboard.yml

.dashboard.yml: ./dashboard.yml.template
	cat $< | \
		sed 's :expenses_account: $(expenses_account) g' | \
		sed 's :income_account: $(income_account) g' | \
		sed 's :assets_account: $(assets_account) g' | \
		sed 's :savings_account: $(savings_account) g' \
	> $@

reports/monthly/change/$(expenses_account)_vs_$(income_account).txt: reports/monthly/change/$(expenses_account).txt reports/monthly/change/$(income_account).txt
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
	./monthly_change.sh "$<" "$(shell echo "$*" | sed 's/^\///;s/\//:/g')" $(currency) > "$@"

# Create monthly balance report for account (dsv format)
reports/monthly/balance/%.txt: $(ledgerfile)
	# Create parent directory
	mkdir -p $(shell dirname $@)
	
	# Create report file
	./monthly_balance.sh "$<" "$(shell echo "$*" | sed 's/^\///;s/\//:/g')" $(currency) > "$@"

