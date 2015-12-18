module ZinCalendar

	def self.get_calendar(offset)
    inputTime=(DateTime.now+offset.months).beginning_of_day
    firstDayOfMonth=inputTime.beginning_of_month
    viewArray=[]

    unless firstDayOfMonth.strftime("%w")=="0" #if the month starts with a sunday
      tmpDay=firstDayOfMonth.beginning_of_week.yesterday #this is always be a sunday and is the first day in view
      tmpRow=[]
      while tmpDay <= firstDayOfMonth.yesterday
        tmpRow.push(tmpDay)
        tmpDay=tmpDay.tomorrow
      end
    end

    tmpDay=firstDayOfMonth
    isLastRow=false
    while !isLastRow || tmpDay.strftime("%w")!="0"
      if tmpDay.strftime("%w")=="6"
        tmpRow.push(tmpDay)
        viewArray.push(tmpRow)
        tmpRow=[]
        tmpDay=tmpDay.tomorrow
      else
        tmpRow.push(tmpDay)
        tmpDay=tmpDay.tomorrow
      end
      if !isLastRow && tmpDay.strftime("%-m")!=inputTime.strftime("%-m")
        isLastRow=true
        break if tmpDay.strftime("%w")=="0"
      end
    end
    return viewArray
	end

end