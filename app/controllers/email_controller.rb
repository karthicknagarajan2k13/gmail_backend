class EmailController < ApplicationController
	respond_to :json
	before_filter :authenticate_token!

	def compose
		@compose = current_user.emails.create(email_params)
		if @compose.present?
		render json: {
			success: true,
      info: 'Email Successfully created.'
		}
		else
			render_failed(info: 'Email created failed')
		end
	end

	def inbox
		@user_mail = @user.email
		@inbox = Email.where(to: @user_mail)
		render json: {emails: @inbox}
	end

	def users
		@users = User.all
		render json: {users: @users}
	end

	def starred
		@starred = @user.emails.where(is_active: true)
		render json: {emails: @starred}
	end

	def sent_mail
		@sent_mail = @user.emails
		render json: {emails: @sent_mail}
	end

	def trash
		
	end
	
	private

	def authenticate_token!
		params[:token]
		@user = User.find_by(token: params[:token])
		p @user.token
		unless @user.present?
			render json: {emails: []}
		end
	end

	def email_params
		params.require(:email).permit(:id, :user_id, :to, :subject, :message, :user_id, :is_active)
	end
end
