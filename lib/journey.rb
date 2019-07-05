# require 'oystercard'

class Journey

attr_reader :entry_station, :exit_station

  def initialize
    @complete = false
    @entry_station = nil
    @exit_station = nil
    @penalty_fare = true
  end

  def start(entry_station)
    @entry_station = entry_station
  end

  def finish(exit_station)
    @exit_station = exit_station
    @complete = true if @entry_station
  end

  def complete?
    @complete
  end
end
