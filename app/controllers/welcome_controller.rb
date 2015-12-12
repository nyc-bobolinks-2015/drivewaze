class WelcomeController < ApplicationController
	def index
		render :'users/stripe-signup'
	end
end
