# Treely

A gem for generating tree-like format

## Installation

Install globally ⤵️

```bash
gem install treely
```

Or add to your `Gemfile` ⤵️

```ruby
gem 'treely', '>= 1.0.8'
```

> Be sure to run `bundle install`

## Usage

```bash
treely [options] [PATH]
```

```bash
treely lib --dirs-first
treely lib --only-dirs -s unicode_rounded
```

> Run `treely --help` for more details

Render a nested array

```ruby
require 'treely'

Treely.tree([1, [2, 3], 4])
```

Render a directory

```ruby
require 'treely'
require 'treely/directory'

Treely.dir('lib').to_tree
```

## License

Treely is released under the [1-clause BSD License](https://opensource.org/license/bsd-1-clause)
