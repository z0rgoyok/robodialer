require 'uuidtools'
require 'thread'

#Class that pulls from a database table to generate a dialing list, then dials
class Robodialer
  def self.fetch_customers
    customers = Customer.find(:all, :conditions => ["status = ?", "TODIAL"])
    return customers
  end
  
  def self.dial_customer(phone_number)
    #Currently set to dial via IAX2
    tracking_id = UUID.timestamp_create.to_s
    channel = $HELPERS["robodialer"]["channel"] + phone_number
    response = PBX.rami_client.originate({'Channel' => channel,
                                          'Context' =>  $HELPERS["robodialer"]["context"],
                                          'Exten' =>  $HELPERS["robodialer"]["extension"],
                                          'Priority' => $HELPERS["robodialer"]["priority"],
                                          'CallerID' => $HELPERS["robodialer"]["callerid"],
                                          'ActionID' => phone_number, #$HELPERS["robodialer"]["actionid"],
                                          'Timeout' => $HELPERS["robodialer"]["timeout"],
                                          'Variable' => "tracking_id=" + tracking_id,
					                                'Async' => $HELPERS["robodialer"]["async"]})
    return response
  end
  
  def self.update_customer
    log 'Update record'
  end
  
  Thread.new do
    customers = self.fetch_customers

    customers.each do |customer|
      log 'Dialing: ' + customer.inspect
      response = self.dial_customer customer.phone
      log 'The response: ' + response.inspect
    end
  
    while 1 > 0 do
      events = PBX.rami_client.get_events
      events.each do |event|
        log "Event: " + event.inspect
      end
    end
  end
  
end
