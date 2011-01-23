Factory.define :catalogue do |c|
  c.name "Test Catalogue"
end

Factory.define :course do |c|
  c.name "Test Course"
  c.sequence(:code) { |n| "TEST #{100+n}" }
  c.offered "FWS"
  c.description "This is a test course."
  c.association :catalogue
end

Factory.define :plan do |p|
  p.name "Test Plan"
  p.association :user
end

Factory.define :term do |t|
  t.year Date.today.year
  t.sequence(:season) { |n| %w(winter spring fall)[n%3] }
  t.association :plan
end

Factory.define :user do |u|
  u.sequence(:username) { |n| "user#{n}" }
end

Factory.define :admin, :parent => :user do |u|
  u.username "admin"
end
