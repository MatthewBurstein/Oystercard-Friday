class JourneyLog

  attr_reader :journeys, :current_journey

  def initialize(journey_class = Journey)
    @journeys = []
    @journey_class = journey_class
  end

  def start(station)
    @current_journey = @journey_class.new(station)
  end

  def finish(station)
    @current_journey.finish(station)
    @journeys << @current_journey
  end

end
