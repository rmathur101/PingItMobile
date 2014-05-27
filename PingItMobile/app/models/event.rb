class Event
  PROPERTIES = [:id, :end_time, :title, :description, :start_time, :address, :latitude, :longitude, :creator_id, :created_at, :updated_at, :category_id, :status]

  # {"id"=>1, "end_time"=>"2014-05-24T21:51:08.988Z", "title"=>"Sport town", "description"=>"Play the game", "start_time"=>"2014-05-24T22:07:48.988Z", "address"=>"630 N Kingsbury St Chicago, IL 60654", "latitude"=>41.8936415, "longitude"=>-87.6419372558594, "creator_id"=>1, "created_at"=>"2014-05-24T21:51:09.150Z", "updated_at"=>"2014-05-24T21:51:09.150Z", "category_id"=>2, "status"=>"pending"}

  PROPERTIES.each { |prop|
    attr_accessor prop
  }


  def return_array_of_events(events)
    self.this_thing = events
    # return events
  end


  def create_event_object(hash = {})
    hash.each { |key, value|
      if PROPERTIES.member? key.to_sym
        self.send((key.to_s + "=").to_s, value)
      end
    }
  end

#--------------------------------------------------------------------------------------------EVENT REQUESTS (note that the server is localhost)

# http://pingitt.herokuapp.com/phone/get_events
  def self.get_events(user_and_location, &block)
    BW::HTTP.get("http://localhost:3000/phone/get_events", payload: {data: user_and_location}) do |response|
      puts "RESPONSE FROM GET EVENTS REQUEST" 
      if response.ok?
        result_data = BW::JSON.parse(response.body.to_str)
        block.call(result_data)
      else
        block.call("no")
      end
    end
  end


  def self.create_event(new_event_data, &block)
    BW::HTTP.get("http://localhost:3000/phone/create_event", payload: {data: new_event_data}) do |response|
      puts "RESPONSE FROM CREATE EVENT REQUEST"
      if response.ok?   
        result_data = BW::JSON.parse(response.body.to_str)
        block.call(result_data)
      else
        block.call("no")
      end
    end
  end

  def self.send_rsvp_info(event_rsvp_info, &block)
    BW::HTTP.get("http://localhost:3000/phone/register_rsvp_info", payload: {data: event_rsvp_info}) do |response|
      if response.ok?
        result_data = BW::JSON.parse(response.body.to_str)
        block.call(result_data)
      else
        block.call("no")
      end
    end
  end




  #do we need to do stuff with plist ?

#------------------------------------------------------------------------------------------------------------------

   def initWithCoder(decoder)
    self.init
    PROPERTIES.each { |prop|
      value = decoder.decodeObjectForKey(prop.to_s)
      self.send((prop.to_s + "=").to_s, value) if value
    }
    self
  end

  # # called when saving an object to NSUserDefaults
  def encodeWithCoder(encoder)
    PROPERTIES.each { |prop|
      encoder.encodeObject(self.send(prop), forKey: prop.to_s)
    }
  end

end

