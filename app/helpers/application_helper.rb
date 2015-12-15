module ApplicationHelper
	def owns?(listing)
		current_user == listing.user
	end

end
