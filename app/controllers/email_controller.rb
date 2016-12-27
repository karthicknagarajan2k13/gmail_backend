class EmailController < ApplicationController
	respond_to :json
	before_filter :authenticate_token!

	def compose
		@compose = @user.emails.create(to: params[:email][:to], subject: params[:email][:subject], message: params[:email][:message], user_name: @user.name)
		render json: {
			success: true
		}
	end

	def inbox
		@user_mail = @user.email
		@inbox = Email.where(to: @user_mail)
		render json: {emails: @inbox}
	end

	def mail_detail
		@email_id = params[:id]
		@email = Email.find_by(id: @email_id)
		render json: {email: @email}
	end

	def users
		@users = User.all
		render json: {users: @users}
	end

	def starred
		@user_mail = @user.email
		@user_active = @user.emails.where(is_active: true)
		@inbox_active = Email.where(to: @user_mail, is_active: true)
		@mail = []
		@mail = @user_active + @inbox_active
		@starred = @mail
		render json: {emails: @starred}
	end

	def sent_mail
		@sent_mail = @user.emails
		render json: {emails: @sent_mail}
	end

	def starred_mail
		@starred_mail = Email.find_by(id: params[:email_id])
		if @starred_mail.is_active == false
			@starred_mail.is_active = true
			@starred_mail.save
		else
			@starred_mail.is_active = false
			@starred_mail.save
		end
		render json: {email: @starred_mail,
			success: true,
			info: 'Email successfully created'}
	end

	def trash
		@trash = @user.emails.where(trash: true)
		render json: {emails: @trash}
	end

	def recover_mail
		@recover_mail = Email.find_by(id: params[:email_id])
		if @recover_mail.trash == true
			@recover_mail.trash = false
			@recover_mail.save
		end
		render json: {email: @recover_mail,
			success: true,
			info: 'Email successfully recovered'}
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
