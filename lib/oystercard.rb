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

  def touch_in(station, journey = Journey.new)
    raise("Insufficient funds") if @balance < MINIMUM_FARE
    @journey = journey
    @journey.start(station)
  end

  def touch_out(station, journey = Journey.new)
    if !@journey
      @journey = journey
      deduct
    else
      @journey.finish(station)
      @journeys << {entry_station: @journey.entry_station, exit_station: @journey.exit_station}
      deduct
      @journey = nil
      puts "Journey complete. Minimum fare of £1 deducted. New balance #{balance}"
    end
  end

  def journey
    @journey
  end

  private

  def deduct
    @balance -= @journey.fare
  end

  def check_complete
    @journey.complete?
  end
end
#
# binding.pry
