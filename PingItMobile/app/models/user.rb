class User

  def self.already_exists?(fb_info, &block)
    BW::HTTP.get("http://pure-garden-7269.herokuapp.com/phone/register_rsvp_info", payload: {data: event_rsvp_info}) do |response|
      block.call(response)
    end
  end

end


  # def self.send_rsvp_info(event_rsvp_info, &block)
  #   BW::HTTP.get("http://pure-garden-7269.herokuapp.com/phone/register_rsvp_info", payload: {data: event_rsvp_info}) do |response|
  #     block.call(response)
  #   end
  # end