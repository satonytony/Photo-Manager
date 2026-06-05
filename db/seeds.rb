User.find_or_create_by!(email: "test@example.com") do |u|
  u.password = "password"
end
