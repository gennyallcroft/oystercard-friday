require 'oystercard'

describe Oystercard do

  let(:entry_station) { double :entry_station}
  let(:exit_station) { double :exit_station}
  let(:journey1) { double :journey, start: nil, finish: nil, entry_station: 'Victoria', exit_station: 'Aldgate East' }

  describe '#top_up' do

    it 'raises an error if maximum limit (£90) is reached' do
      subject.top_up Oystercard::MAXIMUM_BALANCE
      expect{ subject.top_up 10 }.to raise_error("Maximum limit of #{Oystercard::MAXIMUM_BALANCE} exceded")
    end

    it 'allows you to top up to the maxumum limit' do
      expect(subject.top_up Oystercard::MAXIMUM_BALANCE).to eq subject.balance
    end

    it 'raises an error if there are insufficient funds' do
      expect{ subject.touch_in(entry_station, journey1) }.to raise_error("Insufficient funds")
    end

  end

  describe '#touch_out' do

    it 'deduct_fares the minimum fare from the balance after a complete journey' do
      subject.top_up 10
      subject.touch_in(entry_station, journey1)
      expect{ subject.touch_out(exit_station) }.to change{ subject.balance }.by(-Oystercard::MINIMUM_FARE)
    end

    it 'stores journey in journeys variable' do
      subject.top_up 10
      subject.touch_in(entry_station, journey1)
      subject.touch_out(exit_station)
      expect(subject.journeys.length).to eq 1
    end

    it 'deducts the penalty fare if the user has not touched in' do
      subject.top_up(10)
      expect{ subject.touch_out(exit_station, journey1) }.to change{ subject.balance }.by(-Oystercard::PENALTY_FARE)
    end
  end

  describe '#touch_in' do

     it 'returns penalty fare of 6 if start journey twice' do
       subject.top_up 10
       subject.touch_in(entry_station, journey1)
       expect{ subject.touch_in(entry_station, journey1) }.to change{ subject.balance }.by(-Oystercard::PENALTY_FARE)
     end
     it 'starts new journey' do
       subject.top_up 10
       subject.touch_in(entry_station, journey1)
       expect(subject.journey).to eq(journey1)
     end

    end

end
