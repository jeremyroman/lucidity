class Ability
  include CanCan::Ability
  
  def initialize(user)
    if user.admin?
      can :manage, :all
    elsif !user.nil?
      can :manage, Plan, :user_id => user.id
      can :read, Catalogue
      can :read, Course
      can :search, Course
      can :manage, Term, :plan => { :user_id => user.id }
    end
  end
end
