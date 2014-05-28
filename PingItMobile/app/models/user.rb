class User

  # http://pingitt.herokuapp.com/phone/checkforuser
  def self.verify_or_create_user(fb_info)
    BW::HTTP.get("http://localhost:3000/phone/checkforuser", payload: {data: fb_info}) do |response|
      # p response
    end
  end

  def self.set_radius(user_info) 
    BW::HTTP.get("http://localhost:3000/phone/set_radius", payload: {data: user_info}) do |response|  
      if response.ok?
        result_data = BW::JSON.parse(response.body.to_str)
        block.call(result_data)
      else
        block.call("no")
      end
    end
  end

end


  # def self.send_rsvp_info(event_rsvp_info, &block)
  #   BW::HTTP.get("http://pure-garden-7269.herokuapp.com/phone/register_rsvp_info", payload: {data: event_rsvp_info}) do |response|
  #     block.call(response)
  #   end
  # end