# Ecolo

`ENV`ironmental concerns expert.

This gem implements to use of `.env` and `.env=` methods on your modules or classes.

## Installation

Ruby 2.* is required (though i don't figure any line of code where 1.9.3 would'nt do).

Install it with rubygems:

    gem install ecolo

With bundler, add it to your `Gemfile`:

```ruby
gem "ecolo"

```

## Use

### Basic use

```ruby
require 'ecolo'

module MyProject

  include Ecolo

end

MyProject.env          # will output whatever your system or Ruby have in ENV['MY_PROJECT_ENV']

MyProject.env = 'test' # will make your system ready to launch your Rspec suite
```

### `env_with`

As a module function or public class method, `env_with`, allows the lookup for
`env` in other environment variables, constants or delegates.

#### String argument

```ruby

MyProject.env_with 'ALTERNATE_VARIABLE_FOR_ENV'
```

Will use the given exact same string (no alteration) as key to ENV to determnine
enironment.

#### Constant argument

```ruby

MyProject.env_with SomeOtherProject # environment variable will be guessed as SOME_OTHER_PROJECT_ENV
```

will fetch its environment name in ENV['SOME_OTHER_PROJECT_ENV']. But `MyProject`
and `SomeOtherProject` environments won't be linked, as shown below.

```ruby

ENV['SOME_OTHER_PROJECT_ENV'] = 'some_other_project_env'

MyProject.env_with SomeOtherProject
SomeOtherProject.env # will output 'some_other_project_env'
MyProject.env        # will output 'some_other_project_env'

SomeOtherProject.env = 'new_env'

SomeOtherProject.env # will output 'new_env'
MyProject.env        # will output 'some_other_project_env', still
```

#### Delegate

```ruby

MySupervisorProject.env = 'my_supervisor_env'

MyProject.env_with delegate: MySupervisorProject
MyProject.env           # will output 'my_supervisor_env'

MySupervisorProject.env = 'new_env'

MySupervisorProject.env # will output 'new_env'
MyProject.env           # will output 'new_env', as well
```

`.env` and `.env=` methods will be delegated to another class/module, so that
environments will all be gotten at the same place, and evolve accordingly.

## Thanks

Eager and sincere thanks to all the Ruby guys and chicks for making all this so
easy to devise.

## Copyright

I was tempted by the WTFPL, but i have to take time to read it.
So far see LICENSE.
