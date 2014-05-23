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

  def self.send_new_event(tag, &block)
    BW::HTTP.post("http://www.colr.org/js/color/#{self.hex}/addtag/", payload: {tags: tag}) do |response|
      block.call
    end
  end

  
end



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