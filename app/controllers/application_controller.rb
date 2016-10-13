class ApplicationController < ActionController::Base
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception

    def after_sign_in_path_for(resource)
        profile_path(resource)
    end

    def after_sign_out_path_for(_resource_or_scope)
        new_user_session_path
    end

    def authorize_user!
        # redirect_to profile_path(current_user) unless current_user.id.to_i == params[:id].to_i
    end

    def get_user
        @user = current_user
    end
end
