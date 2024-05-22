class User < ApplicationRecord
  has_many :households, dependent: :destroy
  has_many :children, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # アカウント編集時に「現在のパスワード」の入力をしないため
  def update_without_current_password(params, *options)
    params.delete(:current_password)

    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    result = update_attributes(params, *options)
    clean_up_passwords
    result
  end

  def update_without_current_password(params, *options)
    params.delete(:current_password)

    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    result = update(params, *options)
    clean_up_passwords
    result
  end

  # 一般のゲストユーザーログイン用メソッド
  def self.general_guest
    find_or_create_by!(email: 'general_guest@example.com') do |user|
      user.name = "general_guest_user"
      user.admin = false
      user.age = 30
      user.marital_status = true
      user.spouse_age = 33
      user.children_number = 0
      user.password = "general_guest_user"
      user.password_confirmation = "general_guest_user"
    end
  end

    # 管理者のゲストユーザーログイン用メソッド
    def self.admin_guest
      find_or_create_by!(email: 'admin_guest@example.com') do |user|
        user.name = "admin_guest_user"
        user.admin = true
        user.age = 30
        user.marital_status = true
        user.spouse_age = 33
        user.children_number = 0
        user.password = "admin_guest_user"
        user.password_confirmation = "admin_guest_user"
      end
    end
  

  # （deviseに含まれない、独自で設定したデータに対する）バリデーションの設定
  validates :marital_status, inclusion:{in:[true,false]}
  validates :spouse_age, presence: true, if: :have_spose?

  # バリデーションの条件を定義したメソッド
  def have_spose?
    marital_status == true
  end

end
