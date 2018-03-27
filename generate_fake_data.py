import random
import itertools

assets_account = "Assets"
accounts = {
    "Income": ((-2200, -2000), 1, (10, 15)),
    "Expenses:Rent": ((1000, 1000), 1, (10, 15)),
    "Expenses:Services": ((10, 100), 3, (10, 25)),
    "Expenses:Food": ((200, 800), 15, (1, 28)),
    "Expenses:Travel": ((0, 500), 1, (1, 28)),
    "Expenses:Drinks": ((0, 100), 15, (1, 28)),
    "Expenses:Books": ((0, 200), 2, (1, 28)),
    "Assets:Savings": ((-200, 500), 1, (1, 28)),
}


for year, month in itertools.product(range(2014, 2017), range(1, 13)):
    for account_name, config in accounts.items():
        total_amount_range, number_of_transactions, day_range = config
        amount_range = (int(total_amount_range[0] / number_of_transactions),
                        int(total_amount_range[1] / number_of_transactions))
        for i in range(number_of_transactions):
            day = random.randint(*day_range)
            amount = random.randint(*amount_range)
            if not amount:
                continue
            print("{}-{}-{}".format(year, month, day))
            print("    {}".format(assets_account))
            print("    {}       {} USD".format(
                account_name, amount))
            print()
