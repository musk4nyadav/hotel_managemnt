require '/Users/muskan.yadav/Desktop/project/hotel_management/backend.rb'

def checkout_flow
  puts "Enter Your Contact Number :"
  user_contact = gets.chomp
  ob = find_user(user_contact)
  if ob == false
      puts "You do not have any room booked with us. "
      exit(456)
  else 
      room_number = $bookings[ob.id].room_id
      ob.checkout(room_number)
  end
  true
end


def user_information
  puts "Enter your name : "
  user_name = gets.chomp
  puts "Enter yout contact number : "
  user_contact = gets.chomp
  puts "Enter Aadhar Number : "
  user_aadhar = gets.chomp
  if valid?(user_contact, 10) == false
      puts "INVALID CONTACT"
      user_information
  end
  if valid?(user_aadhar, 12) == false
      puts "INVALID AADHAR"
      user_information
  end
  {:name=> user_name, :contact => user_contact, :aadhar => user_aadhar}
end

def price4room(room_id)
  $rooms.each do |ob|
      if ob.id? == room_id
          return ob.price?
      end
  end
end

def checkin_flow

  puts "Choose Room Preference"
  puts "AC (1) / non-AC (0)"
  ac_option = gets.chomp
  ac_option = ac_option.to_i
  puts "Single or Double Occupency (1/2)"
  bedtype_option = gets.chomp
  bedtype_option = bedtype_option.to_i
  puts "Balcony facing or not (1/0)"
  balcony_option = gets.chomp
  balcony_option = balcony_option.to_i

  room_availibality = display_rooms(ac_option, bedtype_option, balcony_option)

  if room_availibality.size == 0
      puts "No Room Available with your Requirements. Want to continue to choose another room (1) or exit (2) ? "
      controller1 = gets.chomp
      if controller1 == "1"
          checkin_flow
      else
          exit(432)
      end
  
  else
      puts "Choose a Room among the given options!"
      room_id = gets.chomp
      room_id = room_id.to_i
      if room_availibality.include?(room_id)
        user_object = User.new(user_information)
        puts "Enter how you would like to pay (Gpay, UPI, Card)"
        payment_mode = gets.chomp
        data = { :payment_id => rand(1...1000), :payment_mode => payment_mode, :amount => $rooms[room_id].price, :room_id => room_id, :user_id => user_object.id}
        payment_object = Payment.new(data)
        data = {:user_id => user_object.id, :room_id => room_id, :payment_id => payment_object.payment_id}
        Booking.new(data).book_room
      else 
        puts "You Chose a Wrong Room Number. Enter Your Room Requiremnts Again : "
        checkin_flow
      end
  end
  true
end 

generate_rooms(15)
# display_rooms(1,1,1)
flag = true

while flag
  puts "Checkin (0)/ Checkout (1) / exit(2)"
  inorout = gets.chomp
  if inorout == "0"
      flag = checkin_flow
  elsif inorout == "1"
      flag = checkout_flow
  elsif inorout == "2"
      exit(432) 
  else
      puts "Invalid Input! Enter 0/1/2"
  end
  
end
