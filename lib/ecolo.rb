require 'forwardable'

module Ecolo

  def self.included(base)
    base.class == Module ? base.include(EnvWith) : base.extend(EnvWith)
    base.env_with
  end

  module EnvWith

    ACCESSOR = [:env, :env=].freeze
    DELEGATE = -> { ACCESSOR.each { |a| def_instance_delegator :@ecolo, a }; self }

    def self.extended(base)
      singleton_base = base.singleton_class.extend Forwardable
      singleton_base.class_exec &DELEGATE
    end

    def self.included(base)
      base.include(Forwardable).send :module_function, :def_instance_delegator
      base.class_exec(&DELEGATE).send :module_function, *ACCESSOR, :env_with
    end

    def env_with(options=self)
      @ecolo = Delegator.with options
    end

  end

  class Delegator

    def self.with(options)
      options.is_a?(Hash) ? options[:delegate] : new(options)
    end

    def initialize(name)
      @env_variable = name.is_a?(String) ? name : underscore(name).upcase << '_ENV'
    end

    def env
      @env ||= ENV[@env_variable] || 'development'
    end

    def env=(env)
      @env = env.to_s
    end

    def underscore(base)
      (base.respond_to?(:name) ? base.name : base.to_s).split('::').last
        .gsub(/.?[A-Z]/) { |c| (c.size == 1 ? c : [c[0], '_', c[-1]].join).downcase }
    end

  end

end
