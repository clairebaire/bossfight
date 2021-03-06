class User < ActiveRecord::Base
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true
  has_secure_password

  def name
    "#{first_name} #{last_name}"
  end

  def email_style_name
    "#{first_name}#{last_name.first}"
  end

  def admin?
    access_level == Constants.get_access_id(:admin)
  end

  def self.all_for_select
    ret = Array.new

    User.all.each do |u|
      o = [ u.name, u.id ]
      ret.push o
    end

    ret
  end

  def projects
    Project.where('employee_id=? AND status>=?', id, Constants.get_status_id(:deleted)).order(:priority)
  end

  def recent_projects
    query = 'employee_id=? AND status>=? AND updated_at>=?'
    Project.where(query,
                  id,
                  Constants.get_status_id(:deleted),
                  2.months.ago
    ).order(:priority)
  end
end
