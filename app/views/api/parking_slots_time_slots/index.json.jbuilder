json.array! @psts do |timeSlot|
    json.id timeSlot.id
    json.title "unavailable"
    json.start timeSlot.start_time
    json.end timeSlot.end
    json.color "red"
    json.allDay false

end
