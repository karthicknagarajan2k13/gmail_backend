class EmailController < ApplicationController
	def inbox
		
	end

	def starred
		@starred = current_user.emails.where(is_active: true)
	end

	def sent_mail
		@sent_mail = current_user.emails
	end

	def trash
		
	end
end
