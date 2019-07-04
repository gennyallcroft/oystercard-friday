require 'pry'
require 'journey'

class Oystercard

  DEFAULT_BALANCE = 0
  MAXIMUM_BALANCE = 90
  MINUMUM_BALANCE = 1
  MINUMUM_CHARGE = 1

  attr_reader :balance, :entry_station, :journeys, :exit_station

  def initialize
    @journeys = []
    @balance = DEFAULT_BALANCE
  end

  def top_up(amount)
    raise("Maximum limit of #{MAXIMUM_BALANCE} exceded") if @balance + amount > MAXIMUM_BALANCE
    @balance += amount
    puts "Topped up £#{amount}. New balance: £#{@balance}"
    return @balance
  end

  def touch_in
    @journey = Journey.new
    @journey.start(@journey.entry_station)
    raise("Insufficient funds") if @balance < MINUMUM_BALANCE
  end

  def touch_out
    @journey.finish(@journey.exit_station)
    @journeys << {entry_station: @journey.entry_station, exit_station: @journey.exit_station}
    deduct

  end

  def journey
    @journey
  end

  private

  def deduct
    @balance -= MINUMUM_CHARGE
  end

end

# binding.pry
