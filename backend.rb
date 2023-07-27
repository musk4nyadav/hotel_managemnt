$rooms = {}
$users = {}
$bookings = {}
$payments = {}

class Room
    attr_accessor :id, :ac, :bedtype, :balcony
    attr_reader :price, :occupied
    def initialize(input)
        @id = input[:id]
        @ac = input[:ac]
        @bedtype = input[:bed]
        @balcony = input[:balcony]
        @occupied = false
        @price = 1000 + (input[:ac] && 1 || 0) *300 + input[:bed]*500 + (input[:balcony] && 1 || 0)*500
        $rooms[@id] = self
    end
    def occupied?
        return @occupied == true
    end
    protected 
        def update_occupied
            @occupied = !@occupied
        end    
end

class User < Room
    @@total = rand(1..100)
    attr_reader :id, :name, :contact, :aadhar
    def initialize(input)
        @id = input[:id]
        @name = input[:name]
        @contact = input[:contact]
        @aadhar = input[:aadhar]
        $users[@id] = self    
    end
    def checkin(room_id)
        $rooms[room_id].update_occupied
        puts " #@name you have checked in room number " + room_id.to_s + "!"
    end
    def checkout(room_id)
        $rooms[room_id].update_occupied
        puts " #@name you have checked out of room number " + room_id.to_s + "!"
    end
end


class Payment
  attr_reader :payment_id, :user_id, :room_id, :amount, :status, :payment_mode
  def initialize(input)
    @payment_id = input[:payment_id]
    @user_id = input[:user_id]
    @room_id = input[:room_id]
    @amount = input[:amount]
    @payment_mode = input[:payment_mode]
    @status = input[:status]
    $payments[@payment_id] = self
  end
  def process_payment
    @status = "processed"
  end
  def cancel_payment
    @status = "canceled"
  end
end


class Booking < User
    attr_reader :user_id, :room_id, :payment_id
    def initialize(input)
        @user_id = input[:user_id]
        @room_id = input[:room_id]
        @payment_id = input[:payment_id]
        $bookings[@user_id] = self
    end
    def book_room
        $users.fetch(@user_id).checkin(@room_id)
    end
end

def display_rooms(ac, bedtype, balcony)
  room_nos = []
  $rooms.each do |key, value|
      if (value.occupied == false) && !((ac == 1 ? true : false) ^ value.ac) && (bedtype == 1 && value.bedtype == 1|| bedtype == 2 && value.bedtype == 2) && !((balcony==1 ? true : false) ^ value.balcony)
          room_nos << value.id
          puts "Room ID " + key.to_s + " Corresponding Price : " + value.price.to_s
      end
  end
  room_nos

end

def find_user(contact)
  $users.each do |key, value|
      if value.contact == contact
          return value
      end
  end
  false
end

def generate_rooms(count)
  for room_no in 1..count do
      data = {:id => room_no, :ac => [true, false].sample, :bed => [1,2].sample, :balcony => [true, false].sample}
      puts data
      Room.new(data)
  end
  true
end

def valid?(contact, len)
  return false if contact.size != len
  contact.each_char do |digit|
      if digit.to_i.to_s != digit
          return false
      end
  end
  true
end
