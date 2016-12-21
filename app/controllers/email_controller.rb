class EmailController < ApplicationController
	respond_to :json
	def inbox
		
	end

	def users
		@users = User.all
		render json: {users: @users}
	end

	def starred
		@starred = current_user.emails.where(is_active: true)
	end

	def sent_mail
		@sent_mail = Email.all
		render json: {emails: @sent_mail}
	end

	def trash
		
	end
end
