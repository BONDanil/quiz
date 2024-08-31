module AvatarHelper
  def player_avatar(user)
    image_object = if user.reload.profile_picture.present?
                     user.profile_picture
                   else
                     "default-avatar.webp"
                   end

    image_tag(image_object, class: "rounded-circle", style: "object-fit: scale-down; max-height: 50px")
  end
end
