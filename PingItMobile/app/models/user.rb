class User

  def self.verify_or_create_user(fb_info, &block)
    BW::HTTP.get("http://localhost:3000/phone/checkforuser", payload: {data: fb_info}) do |response|
      p response
      result = BW::JSON.parse(response.body.to_str)
      block.call(result)
    end
  end

end


  # def self.send_rsvp_info(event_rsvp_info, &block)
  #   BW::HTTP.get("http://pure-garden-7269.herokuapp.com/phone/register_rsvp_info", payload: {data: event_rsvp_info}) do |response|
  #     block.call(response)
  #   end
  # end