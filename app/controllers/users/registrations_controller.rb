# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  def update_resource(resource, params)
    if google_oauth?(resource)
      params.delete('current_password')

      resource.password = params['password']
      resource.update_without_password(params)
    else
      resource.update_with_password(params)
    end
  end

  private

  def google_oauth?(user)
    user.provider == User.providers[:google]
  end
end
