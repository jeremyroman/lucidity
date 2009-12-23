# Module which allows stubbing of all instances of a
# class (which does not appear to be supported by RSpec's
# built-in stubbing functionality). This is useful because
# stubbing ActiveRecord can be tricky.
module GlobalStub
  def self.hook(what, meth)
    what.class_eval do
      alias_method "#{meth}_noglobalstub".to_sym, meth
      define_method(meth) { |*a| GlobalStub[what, meth] }
    end
  end
  
  def self.unhook(what, meth)
    what.class_eval do
      alias_method meth, "#{meth}_noglobalstub".to_sym
      remove_method "#{meth}_noglobalstub"
    end
  end
  
  def self.[]=(what, meth, retval)
    @@stubs ||= {}
    @@stubs[what] ||= {}
    @@stubs[what][meth] = retval
  end
  
  def self.[](what, meth)
    @@stubs[what][meth]
  end
end