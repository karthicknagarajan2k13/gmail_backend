class Users::RegistrationsController < Devise::RegistrationsController
  skip_before_action :verify_authenticity_token, if: :json_request?
  before_filter :configure_permitted_parameters, if: :devise_controller?

  def create
    build_resource(sign_up_params)
    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        resource.create_user_profile! if resource.athlete?
        render :status => 200,
           :json => { :success => true,
                      :info => "Logged in" }
      else
        resource.create_user_profile! if resource.athlete?
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        render :status => 200,
          :json => {
            :success => false,
            :info => "Confirmation mail was sent your email. Please check your email.",
          }
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      # respond_with resource
      render :status => 200,
           :json => { :success => false,
                      :info => resource.errors.full_messages,
                      :data => { :message => "Email already exist" } }
    end
  end

  protected

  def json_request?
    request.format.json?
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :password, :password_confirmation])

    devise_parameter_sanitizer.sanitize(:sign_in) do |u|
      u.permit(:email, :password, :password_confirmation, :current_password)
    end
  end

  def sign_up_params
    devise_parameter_sanitizer.sanitize(:sign_up)
  end
end
