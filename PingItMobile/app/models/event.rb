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


  #the type of request must be a get (think why?)
  def self.send_new_event(new_event_data, &block)
    BW::HTTP.get("http://pure-garden-7269.herokuapp.com/phone", payload: {data: new_event_data}) do |response|
      puts "RESPONS FROM SEND EVENT REQUEST"
      p response
      block.call
    end
  end

  def selt.get_events
    BW::HTTP.get("http://pure-garden-7269.herokuapp.com/phone", payload: {data: new_event_data}) do |response|
      puts "RESPONSE FROM GET EVENTS REQUEST"
      p response
      block.call
    end
  end

# "http://www.pure-garden-7269.herokuapp.com/phone"
  # "http://www.colr.org/js/color/#{self.hex}/addtag/"

end

#QUESTIONS
#----------------------------------------------------
#how do I get ONLY the new events? so that we don't have to referesh every time



# title 
# description
#status             DO I NEED THIS??? (WHICH DO I NEED?)
# start_time
# end_time
# address
# latitude
# longitude
# creator_id
# created_at
# category_id

