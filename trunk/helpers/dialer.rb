#Class that pulls from a database table to generate a dialing list, then dials
class Dialer
  def self.fetch_customers
    customers = Customer.find(:all, :conditions => ["status = ?", "TODIAL"])
    return customers
  end
  
  def self.dial_customer(phone_number)
    #Need to figure out the correct value here
    channel = $HELPERS["dialer"]["channel"] + phone_number
    response = PBX.rami_client.originate({'Channel' => channel,
                                          'Context' =>  $HELPERS["dialer"]["context"],
                                          'Exten' =>  $HELPERS["dialer"]["extension"],
                                          'Priority' => $HELPERS["dialer"]["priority"],
                                          'CallerID' => $HELPERS["dialer"]["callerid"],
                                          'ActionID' => $HELPERS["dialer"]["actionid"],
                                          'Timeout' => $HELPERS["dialer"]["timeout"],
					                                'Async' => $HELPERS["dialer"]["async"]})
    return response
  end
  
  def self.update_customer
    log 'Update record'
  end
  
  customers = self.fetch_customers

  customers.each do |customer|
    log 'Dialing: ' + customer.inspect
    response = self.dial_record customer.phone
    log 'The response: ' + response.inspect
  end
  
  log 'Exiting...'
end
