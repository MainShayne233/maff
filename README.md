# maff

A simple `haskell-servant` app that exposes the following two endpoints:

`/even-or-odd/:number` => Will return either `"even"` or `"odd"` depending on the number
`/arithmetic/:number/<add|subtract>/:number` => Will perform addition or subtraction on the two numbers

# Use

Assuming you have [`stack` installed](https://docs.haskellstack.org/en/stable/README/):

```sh
# clone the app
git clone https://github.com/MainShayne233/maff"

# enter app
cd maff

# start app
stack run

# hit the endpoints
curl http://localhost:8080/even-or-odd/2
# => "even"

curl http://localhost:8080/even-or-odd/3
# => "odd"

curl http://localhost:8080/arithmetic/1/add/2
# => 3

curl http://localhost:8080/arithmetic/1/subtract/2
# => -1
```
