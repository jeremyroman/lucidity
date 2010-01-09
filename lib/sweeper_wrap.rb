# allows cache sweepers to call each other
# by passing the @controller instance variable
# around.
module SweeperWrap
  def wrap(controller)
    backup = what.instance_variable_get(:@controller)
    instance_variable_set(:@controller, controller)
    yield
    instance_variable_set(:@controller, backup)
  end
end

ActionController::Caching::Sweeper.send(:include, SweeperWrap)