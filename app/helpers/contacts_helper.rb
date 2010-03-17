module ContactsHelper
  def formatted_address(contact)
    address = []
    if contact.address
      address << contact.address
    end
    if contact.city
      arr = [contact.city]
      arr << ', ' + contact.state if contact.state
      arr << ' ' + contact.postal_code if contact.postal_code
      address << arr.join('')
    end
    if contact.country
      address << contact.country
    end
    haml_concat(address.join('<br>').html_safe!)
  end
end
