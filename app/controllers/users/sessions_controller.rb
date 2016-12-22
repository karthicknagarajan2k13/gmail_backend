class Users::SessionsController < Devise::SessionsController
# before_action :configure_sign_in_params, only: [:create]
  skip_before_filter :authenticate_user!, except: [:destroy]
  skip_before_filter :verify_authenticity_token
  skip_filter :verify_signed_out_user, only: :destroy
  respond_to :json

  def create
    resource = warden.authenticate!(scope: resource_name, recall: "#{controller_path}#failure")
    sign_in(resource_name, resource)
    render status: 200,
           json: { success: true,
                   info: 'Logged in',
                   data: { auth_token: current_user.token } }
  end

  def destroy
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    set_flash_message :notice, :signed_out if signed_out && is_flashing_format?
    yield if block_given?
    render json: { success: true, data: 'sign out success' }
  end

  def failure
    render status: 200,
           json: { success: false,
                   info: 'Login Failed',
                   data: {} }
  end
end
