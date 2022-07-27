require "bench"
require_relative "../lib/ohm"

Ohm.redis = Redis.new(host: "127.0.0.1", port: 6379, db: 15)
Ohm.flush

class Event < Ohm::Model
  attribute :name
  attribute :location

  index :name
  index :location
end

class Sequence
  def initialize
    @value = 0
  end

  def succ!
    Thread.exclusive { @value += 1 }
  end

  def self.[](name)
    @@sequences ||= Hash.new { |hash, key| hash[key] = Sequence.new }
    @@sequences[name]
  end
end
