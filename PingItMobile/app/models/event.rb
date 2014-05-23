class Event
  PROPERTIES = [:title, :description, :location, :lat, :long, :timestamp, :id, :name]
  PROPERTIES.each { |prop|
    attr_accessor prop
  }

  def initialize(hash = {})
    hash.each { |key, value|
      if PROPERTIES.member? key.to_sym
        self.send((key.to_s + "=").to_s, value)
      end
    }
  end
end

# *we want the event_title
# *we want the the description
# *we want the the yes / no option
# *we want the google map w/location
# *we want the distance
# *we want the number of rsvps