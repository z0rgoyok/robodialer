#Class that pulls from a database table to generate a dialing list, then dials
class Robodialer
  def self.fetch_customers
    customers = Customer.find(:all, :conditions => ["status = ?", "TODIAL"])
    return customers
  end
  
  def self.dial_customer(phone_number)
    #Need to figure out the correct value here
    channel = $HELPERS["robodialer"]["channel"] + phone_number
    response = PBX.rami_client.originate({'Channel' => channel,
                                          'Context' =>  $HELPERS["robodialer"]["context"],
                                          'Exten' =>  $HELPERS["robodialer"]["extension"],
                                          'Priority' => $HELPERS["robodialer"]["priority"],
                                          'CallerID' => $HELPERS["robodialer"]["callerid"],
                                          'ActionID' => $HELPERS["robodialer"]["actionid"],
                                          'Timeout' => $HELPERS["robodialer"]["timeout"],
					                                'Async' => $HELPERS["robodialer"]["async"]})
    return response
  end
  
  def self.update_customer
    log 'Update record'
  end
  
  customers = self.fetch_customers

  customers.each do |customer|
    log 'Dialing: ' + customer.inspect
    response = self.dial_customer customer.phone
    log 'The response: ' + response.inspect
  end
  
  log 'Exiting...'
end
