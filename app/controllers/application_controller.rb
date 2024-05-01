class ApplicationController < ActionController::Base
    before_action :configure_permitted_parameters, if: :devise_controller?
    
    protected

    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :admin, :age, :marital_status, :spouse_age, :children_number])
        devise_parameter_sanitizer.permit(:account_update, keys: [:name, :admin, :age, :marital_status, :spouse_age, :children_number])
    end
end
