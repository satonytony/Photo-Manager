module LoginHelper
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def login
      let(:user) { create(:user) }
      before { post "/login", params: { email: user.email, password: "password" } }
    end
  end
end
