class EmailController < ApplicationController
	respond_to :json

	def compose
		@compose = current_user.emails.create(email_params)
		if @compose.present?
		render json: {
			msg: 'Email Successfully created.', 
			edu_type: edu_type,
			inst: inst
			}, status: 'Success'
		else
			render_failed(msg: 'Email created failed')
		end
	end

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
	private

	def email_params
		params.require(:email).permit(:id, :user_id, :to, :subject, :message, :user_id, :is_active)
	end
end
