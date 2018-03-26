# ledger-cli-dashboard
## Dependencies
- yarn
- npm

## Setup
```
./setup.sh
```

## Usage
### Customize account names
Edit `accounts.conf` to match your account names:

```
expenses_account=Expenses
income_account=Income
assets_account=Assets
savings_account=Assets/Savings
```


Edit `expense_categories.conf` to match your account names:

```
Food
Drinks
Rent
Services
Books
```

Note: Instead of ':' characters, you have to use '/' characters to access
sub-accounts.

### Display dashboard
```
./dashboard.sh book.txt USD
```


