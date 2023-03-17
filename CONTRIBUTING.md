# Contributing

Contributing to this could be anything and doesn't have to be tree-sitter queries or lua. It could also be spell checking :)

## Making a pull request

* Fork the repo
* Create your feature branch (git checkout -b my-new-feature)
* Commit your changes (git commit -am 'Added some feature')
* Push to the branch (git push origin my-new-feature)
* Create new Pull Request

## Adding tree-sitter query for xyz

* Make sure that its a query others can use and don't match on specific keywords
* Queries are located in `queries/<filetype>/agrolens.<query>.scm`
* Every query should have a test located in `tests/<filetype>` and tested via [Plenary's test framework](https://github.com/nvim-lua/plenary.nvim)
* Variables in the query are arbitrary but one is mandatory and that is the `agrolens.scope` which covers the full match of a scope.

## Oh and ..

Thank you! :)
