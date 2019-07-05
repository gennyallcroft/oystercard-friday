require 'pry'
require 'journey'

class Oystercard

  DEFAULT_BALANCE = 0
  MAXIMUM_BALANCE = 90
  MINIMUM_FARE = 1
  PENALTY_FARE = 6

  attr_reader :balance, :journeys

  def initialize
    @journeys = []
    @balance = DEFAULT_BALANCE
  end

  def top_up(amount)
    raise("Maximum limit of #{MAXIMUM_BALANCE} exceded") if @balance + amount > MAXIMUM_BALANCE
    @balance += amount
    puts "Topped up £#{amount}. New balance: £#{@balance}"
    @balance
  end

  def touch_in
    raise("Insufficient funds") if @balance < MINIMUM_FARE
    deduct_penalty_fare
    @journey = Journey.new
    @journey.start(@journey.entry_station)
  end

  def touch_out
    if !@journey
      deduct_minimum_fare
    else
      @journey.finish(@journey.exit_station)
      @journeys << {entry_station: @journey.entry_station, exit_station: @journey.exit_station}
      @journey = nil
      deduct_minimum_fare
      puts "Journey complete. Minimum fare of £1 deducted. New balance #{balance}"
    end
  end

  def journey
    @journey
  end

  private

  def deduct_penalty_fare
    @balance -= Oystercard::PENALTY_FARE if @journey
  end

  def deduct_minimum_fare
    @balance -= Oystercard::MINIMUM_FARE if !@journey
  end
end

binding.pry
