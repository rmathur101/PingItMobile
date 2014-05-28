class User



  def self.verify_or_create_user(fb_info)
    BW::HTTP.get("http://pingitt.herokuapp.com/phone/checkforuser", payload: {data: fb_info}) do |response|
      # p response
    end
  end

end


  # def self.send_rsvp_info(event_rsvp_info, &block)
  #   BW::HTTP.get("http://pure-garden-7269.herokuapp.com/phone/register_rsvp_info", payload: {data: event_rsvp_info}) do |response|
  #     block.call(response)
  #   end
  # end