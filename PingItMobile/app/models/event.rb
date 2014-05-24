class Event
  PROPERTIES = [:title, :description, :category, :start_time, :end_time, :address, :lat, :long]
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

#--------------------------------------------------------------------------------------------EVENT REQUESTS

#getting the event might not need a payload (unless the payload should be the events that are already on the phone)
  def self.get_events(&block)
    BW::HTTP.get("http://pure-garden-7269.herokuapp.com/phone/get_events") do |response|
      puts "RESPONSE FROM GET EVENTS REQUEST"
      p response.body.to_str
      block.call
    end
  end

  def self.create_event(new_event_data, &block)
    BW::HTTP.get("http://pure-garden-7269.herokuapp.com/phone/create_event", payload: {data: new_event_data}) do |response|
      puts "RESPONSE FROM CREATE EVENT REQUEST"
      result_data = BW::JSON.parse(response.body.to_str)
      p result_data
      # p response
      block.call(result_data)
    end
  end

#------------------------------------------------------------------------------------------------------------------

# "http://www.pure-garden-7269.herokuapp.com/phone"
  # "http://www.colr.org/js/color/#{self.hex}/addtag/"

end

#QUESTIONS
#----------------------------------------------------
#how do I get ONLY the new events? so that we don't have to referesh every time

