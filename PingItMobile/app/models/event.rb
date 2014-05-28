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
def self.category_from_id(id)
  case id
  when 1
    return "deals"
  when 2 
    return "sports"
  when 3
    return "social" 
  when 4
    return "ent"
  when 5
    return "food"
  else
    return "other"
  end
end

def self.clocktime_from_datetime(datetime)

end

def  self.draw_on_map(mapView)
timer = EM.add_periodic_timer 10.0 do
"THESE ARE THE EVENTS THAT ARE LOADED FROM THE SERVER!!!!!!"
        p events = App::Persistence['events']
        if events
          mapView.clear
          puts "ACTIVE EVENTS"
          p active_events = events[:pingas_active_in_radius]
          puts "PENDING EVENTS"
          p pending_events = events[:pingas_pending_in_radius]
          puts "OUTSIDE EVENTS"
          p outside_events = events[:pingas_outside_radius]


          # some_array = [8,9,10]
          # App::Persistence["already_marked"] = {}

          active_events.each do |event|
            # this_hash = App::Persistence["already_marked"]
            # if this_hash.has_key?(event[:id]) == false
              puts "placing an active event"
              ping_marker = GMSMarker.alloc.init
              ping_marker.title = event[:title]
              ping_marker.snippet = "#{event[:start_time]} -- #{event[:description]}"
              ping_marker.position = CLLocationCoordinate2DMake(event[:latitude], event[:longitude])
              ping_marker.icon = GMSMarker.markerImageWithColor(UIColor.greenColor)
              ping_marker.icon = UIImage.imageNamed("markers/#{Event.category_from_id(event[:category_id])}_active.png")
              # ping_marker.icon = UIImage.imageNamed('')
              ping_marker.map = mapView

              # another_array = App::Persistence["already_marked"]
              # another_array.push(event[:id])
              # App::Persistence["already_marked"][event[:id]] = "yes"
            # end

          end

          pending_events.each do |event|
            # this_array = App::Persistence["already_marked"]
            # if this_array.include?(event[:id]) == false
              ping_marker = GMSMarker.alloc.init
              ping_marker.title = event[:title]
              ping_marker.snippet = "#{event[:start_time]} -- #{event[:description]}"
              ping_marker.position = CLLocationCoordinate2DMake(event[:latitude], event[:longitude])
              ping_marker.icon = UIImage.imageNamed("markers/#{Event.category_from_id(event[:category_id])}_pending.png")
              ping_marker.map = mapView
              # another_array = App::Persistence["already_marked"]
              # another_array.push(event[:id])
              # App::Persistence["already_marked"] = another_array 
            # end
          end

          outside_events.each do |event|
            # this_array = App::Persistence["already_marked"]
            # if this_array.include?(event[:id]) == false
              p "GETTING AN OUTSIDE EVENT"
              ping_marker = GMSMarker.alloc.init
              ping_marker.title = event[:title]
              ping_marker.snippet = "#{event[:start_time]} -- #{event[:description]}"
              ping_marker.position = CLLocationCoordinate2DMake(event[:latitude], event[:longitude])
              # ping_marker.icon = GMSMarker.markerImageWithColor(UIColor.whiteColor)
              ping_marker.icon = UIImage.imageNamed("markers/#{Event.category_from_id(event[:category_id])}_outside.png")

              ping_marker.map = mapView
              # another_array = App::Persistence["already_marked"]
              # another_array.push(event[:id])
              # App::Persistence["already_marked"] = another_array 
            # end
            # puts "ALREADY MARKED ARRAY"
            # p App::Persistence["already_marked"]
          end
        end
      end
end
# http://pinggit.herokuapp.com/phone/get_events
# http://localhost:3000
  def self.get_events(user_and_location, &block)
    BW::HTTP.get("http://pinggit.herokuapp.com/phone/get_events", payload: {data: user_and_location}) do |response|
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
    BW::HTTP.get("http://pinggit.herokuapp.com/phone/create_event", payload: {data: new_event_data}) do |response|
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
    BW::HTTP.get("http://pinggit.herokuapp.com/phone/register_rsvp_info", payload: {data: event_rsvp_info}) do |response|
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

